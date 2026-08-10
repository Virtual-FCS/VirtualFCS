within VirtualFCS.Media;

partial model PartialCondensingMixture
  extends Modelica.Media.Interfaces.PartialMedium(
    final singleState=false,
    final ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pTX,
    reducedX = true,
    fixedX = false
  );
  
  constant Modelica.Units.SI.MolarMass MMX[nS] "Molar masses of substances";
  
  redeclare replaceable record extends ThermodynamicState "Thermodynamic state variables"
    Modelica.Units.SI.AbsolutePressure p "Absolute pressure of medium";
    Modelica.Units.SI.Temperature T "Temperature of medium";
    Modelica.Units.SI.MassFraction[nXi] Xi(start=reference_X[1:nXi]) "Mass fractions (= (component mass)/total mass  m_i/m)";
  end ThermodynamicState;
  
  redeclare model extends BaseProperties(final standardOrderComponents = true,
    d = density(state),
    h = specificEnthalpy(state),
    u = specificInternalEnergy(state),
    MM = molarMass(state),
    R_s = gasConstant(state),
    state.p = p,
    state.T = T,
    state.Xi = Xi
    ) "Base properties of medium"
    Modelica.Units.SI.MassFraction beta = vaporisationRatio(state) "Mass vaporisation rate";
    Modelica.Units.SI.MassFraction X_liq[nX] = liquidMassFractions(state) "Liquid mass fractions";
    Modelica.Units.SI.MassFraction X_gas[nX] = gasMassFractions(state) "Gas mass fractions";
    // TODO place molar properties in protected section to reduce overhead? Too much back & forth mass-molar going on...
  end BaseProperties;
  
  function moleToMassFractions "Return mass fractions X from mole fractions"
    extends Modelica.Icons.Function;
    input SI.MoleFraction Xmol[nX] "Mole fractions of mixture";
    output SI.MassFraction X[nX] "Mass fractions of mixture";
  algorithm
    X := Xmol.*MMX/(Xmol*MMX);
    annotation (smoothOrder=5);
  end moleToMassFractions;

  function massToMoleFractions "Return mole fractions from mass fractions X"
    extends Modelica.Icons.Function;
    input SI.MassFraction X[nX] "Mass fractions of mixture";
    output SI.MoleFraction Xmol[nX] "Mole fractions of mixture";
  algorithm
    Xmol := (X./MMX)/(X*(1./MMX));
    annotation (smoothOrder=5);
  end massToMoleFractions;
  
  redeclare function extends temperature
  algorithm
    T := state.T;
  end temperature;
  
  redeclare function extends pressure
  algorithm
    p := state.p;
  end pressure;
  
  redeclare function extends massFraction
  algorithm
    Xi := state.Xi;
  end massFraction;

  redeclare function extends molarMass
  protected
    Modelica.Units.SI.MassFraction X[nX];
  algorithm
    X  := cat(1, state.Xi, {1-sum(state.Xi)});
    MM := 1 / sum(X ./ MMX);
  end molarMass;
  
  redeclare function extends setState_pTX "Set state with pressure, temperature, composition"
  algorithm
    state.p := p;
    state.T := T;
    state.Xi := X[1:nXi];
  end setState_pTX;

  redeclare function extends setState_phX "Set state with pressure, enthalpy, composition"
  protected
    function h_offset "Solve h = specificEnthalpy_pTX(p, T, X) for T with given h"
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input AbsolutePressure p "Pressure";
      input SpecificEnthalpy h "Specific enthalpy";
      input MassFraction[:] X "Mass fractions of composition";
    algorithm
      y := specificEnthalpy_pTX(p, u, X) - h;
    end h_offset;
  algorithm
    state.p := p;
    state.Xi := X[1:nXi];
    state.T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function h_offset(p=p, h=h, X=X), u_min = 200, u_max = 1000);
  end setState_phX;
  
  function flashBeta
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MoleFraction X[nX] "Mole Fractions";
    input Real iK[nX] "Inverted equilibrium constants, XL[i] = iK[i]*XG[i]";
    output Real beta "Generalised gas fraction";
  protected
    Real beta_max "Upper bound for Rachford-Rice";
    Real beta_min "Lower bound for Rachford-Rice";
    Real beta_eps "Numerical assistance";

    function rachford_rice
      extends Modelica.Icons.Function;
      input Real beta "Generalised gas fraction";
      input Modelica.Units.SI.MoleFraction X[nX] "Mole Fractions";
      input Real iK[nX] "Inverted equilibrium constants, XL[i] = iK[i]*XG[i]";
      output Real offset;
    algorithm
      offset := sum({X[i]*(1-iK[i])/(iK[i] + beta*(1-iK[i])) for i in 1:nX});
    end rachford_rice;
  
  algorithm
    beta_max := max(iK)/(max(iK)-1);
    beta_min := min(iK)/(min(iK)-1);
    beta_eps := 1E-9*(beta_max - beta_min);
    beta := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function rachford_rice(X=X, iK=iK), u_min = beta_min+beta_eps, u_max = beta_max-beta_eps);
  end flashBeta;

  partial function invEquilibria "Inverted equilibrium constants"
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Real iK[nX];
  end invEquilibria;
  
  function gasMolarFractions
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MoleFraction beta "Vaporisation ratio";
    input Modelica.Units.SI.MoleFraction[nX] Xmol "Overall molar compositions";
    input Real[nX] iK "Inverted equilibrium constants";
    output Modelica.Units.SI.MoleFraction[nX] Xmol_G "Gas molar compositions";
  algorithm
    if beta < 0 then
      Xmol_G := Xmol./iK /sum(Xmol./iK);
    elseif beta > 1 then
      Xmol_G := Xmol;
    else
      Xmol_G := Xmol ./ (iK + beta*(-iK.+1));
    end if;
  end gasMolarFractions;
  
  function gasMassFractions
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MassFraction[nX] X_gas;
  protected
    Real iK = invEquilibria(state);
    Modelica.Units.SI.MassFraction X = cat(1, state.Xi, {1-sum(state.Xi)});
    Modelica.Units.SI.MoleFraction Xmol = massToMoleFractions(X);
    Modelica.Units.SI.MoleFraction beta = flashBeta(Xmol, iK);
    Modelica.Units.SI.MoleFraction Xmol_gas = gasMolarFractions(beta, Xmol, iK);
  algorithm
    X_gas := moleToMassFractions(Xmol_gas);
  end gasMassFractions;
  
  function liquidMolarFractions
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MoleFraction beta "Vaporisation ratio";
    input Modelica.Units.SI.MoleFraction[nX] Xmol "Overall molar compositions";
    input Real[nX] iK "Inverted equilibrium constants";
    output Modelica.Units.SI.MoleFraction[nX] Xmol_L "Liquid molar compositions";
  algorithm
    if beta < 0 then
      Xmol_G := Xmol;
    elseif beta > 1 then
      Xmol_G := Xmol*iK /(Xmol*iK);
    else
      Xmol_G := (iK.*Xmol) ./ (iK + beta*(-iK.+1));
    end if;
  end liquidMolarFractions;
  
  function liquidMassFractions
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MassFraction[nX] X_liq;
  protected
    Real iK = invEquilibria(state);
    Modelica.Units.SI.MassFraction X = cat(1, state.Xi, {1-sum(state.Xi)});
    Modelica.Units.SI.MoleFraction Xmol = massToMoleFractions(X);
    Modelica.Units.SI.MoleFraction beta = flashBeta(Xmol, iK);
    Modelica.Units.SI.MoleFraction Xmol_liq = liquidMolarFractions(beta, Xmol, iK);
  algorithm
    X_liq := moleToMassFractions(Xmol_liq);
  end liquidMassFractions;

  function vaporisationRatio
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MassFraction beta_mass;
  protected
    Modelica.Units.SI.MassFraction[nX] X = cat(1, state.Xi, {1-sum(state.Xi)});
    Modelica.Units.SI.MoleFraction[nX] Xmol = massToMoleFractions(X);
    Real iK[nX] = invEquilibria(state);
    Modelica.Units.SI.MoleFraction beta_mol = flashBeta(Xmol, iK);
    Modelica.Units.SI.MoleFraction[nX] Xmol_G;
    Modelica.Units.SI.MolarMass MMG "Molar mass for gas phase";
  algorithm
    if beta_mol <= 0 then
      beta_mass := 0;
    elseif beta_mol >= 1 then
      beta_mass := 1;
    else
      Xmol_G := gasMolarFractions(beta_mol, Xmol, iK);
      MMG := Xmol_G*MMX;
      beta_mass := beta_mol * MMG/molarMass(state);
    end if;
  end vaporisationRatio;
  
  partial function specificHeatCapacityCpofGas
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    output Modelica.Units.SI.SpecificHeatCapacity cp;
  end specificHeatCapacityCpofGas;
  
  partial function specificHeatCapacityCpofLiquid
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    output Modelica.Units.SI.SpecificHeatCapacity cp;
  end specificHeatCapacityCpofLiquid;
  
  partial function specificEnthalpyofGas
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    output Modelica.Units.SI.SpecificEnthalpy h;
  end specificEnthalpyofGas;

  partial function specificEnthalpyofLiquid
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    output Modelica.Units.SI.SpecificEnthalpy h;
  end specificEnthalpyofLiquid;

  partial function specificEntropyofGas
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    input Modelica.Units.SI.Pressure p "Gas pressure";
    output Modelica.Units.SI.SpecificEntropy s;
  end specificEntropyofGas;

  partial function specificEntropyofLiquid
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    input Modelica.Units.SI.Pressure p "Gas pressure";
    output Modelica.Units.SI.SpecificEntropy s;
  end specificEntropyofLiquid;


  // TODO calculate thermodynamic properties; leave implementation to child classes (Shomate and the like)
  // Have {enthalpy|entropy}of{Gas|Liquid} & combine in main functions, e.g. SpecificEnthalpy & C.
  // Also need heatcapacity (p&c), isentropicEnthalpy

  redeclare function extends setSmoothState "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(
          p=Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
          T=Media.Common.smoothStep(x, state_a.T, state_b.T, x_small),
          Xi=Media.Common.smoothStep(x, state_a.Xi, state_b.Xi, x_small));
  end setSmoothState;

end PartialCondensingMixture;
