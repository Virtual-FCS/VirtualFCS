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
    d = 1/(beta/d_gas + (1-beta)/d_liq),
    h = beta*h_gas + (1-beta)*h_liq,
    u = h - p*(beta/d_gas+(1-beta)/d_liq),
    MM = molarMass(state),
    R_s = Modelica.Constants.R / MM_gas,
    state.p = p,
    state.T = T,
    state.Xi = Xi
    ) "Base properties of medium"
    Modelica.Units.SI.MassFraction beta = max( min(beta_mol * MM_gas/MM, 1.0), 0.0) "Mass vaporisation rate";
    Modelica.Units.SI.MassFraction X_liq[nX] = moleToMassFractions(Xmol_liq) "Liquid mass fractions";
    Modelica.Units.SI.MassFraction X_gas[nX] = moleToMassFractions(Xmol_gas) "Gas mass fractions";
    Modelica.Units.SI.MolarMass MM_liq = MMX*Xmol_liq "Molar mass of liquid phase";
    Modelica.Units.SI.MolarMass MM_gas = MMX*Xmol_gas "Molar mass of gas phase";

    // The following functions are specific to the fluid and need to be specified in child classes
    Modelica.Units.SI.Density d_liq = liquidDensity(state_liq) "Density of liquid phase";
    Modelica.Units.SI.Density d_gas = gasDensity(state_gas) "Density of gas phase";
    Modelica.Units.SI.SpecificEnthalpy h_liq = liquidSpecificEnthalpy(state_liq) "Specific enthalpy of liquid phase";
    Modelica.Units.SI.SpecificEnthalpy h_gas = gasSpecificEnthalpy(state_gas) "Specific enthalpy of gas phase";
  
  protected // These helper variables are hidden to avoid cluttering the model
    Real iK[nX] = invertedKs(state) "Inverted equilibrium constants";
    Real beta_mol = flashVaporisation(Xmol, iK) "Generalised vaporisation ratio";
    Modelica.Units.SI.MoleFraction Xmol[nX] = massToMoleFractions(X);
    Modelica.Units.SI.MoleFraction Xmol_liq[nX] = liquidMolarFractions(beta_mol, Xmol, iK);
    Modelica.Units.SI.MoleFraction Xmol_gas[nX] = gasMolarFractions(beta_mol, Xmol, iK);
    ThermodynamicState state_gas = ThermodynamicState(p, T, X_gas[1:nXi]);
    ThermodynamicState state_liq = ThermodynamicState(p, T, X_liq[1:nXi]);
  end BaseProperties;


  function moleToMassFractions "Return mass fractions X from mole fractions"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MoleFraction Xmol[nX] "Mole fractions of mixture";
    output Modelica.Units.SI.MassFraction X[nX] "Mass fractions of mixture";
  algorithm
    X := Xmol.*MMX/(Xmol*MMX);
    annotation (smoothOrder=5);
  end moleToMassFractions;

  function massToMoleFractions "Return mole fractions from mass fractions X"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MassFraction X[nX] "Mass fractions of mixture";
    output Modelica.Units.SI.MoleFraction Xmol[nX] "Mole fractions of mixture";
  algorithm
    Xmol := (X./MMX)/(X*(1.0./MMX));
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
      input MassFraction X[:] "Mass fractions of composition";
    algorithm
      y := specificEnthalpy_pTX(p, u, X) - h;
    end h_offset;
  algorithm
    state.p := p;
    state.Xi := X[1:nXi];
    state.T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function h_offset(p=p, h=h, X=X), u_min = 200, u_max = 1000);
  end setState_phX;


  replaceable function flashVaporisation
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MoleFraction Xmol[nX] "Mole Fractions";
    input Real iK[nX] "Inverted equilibrium constants, XL[i] = iK[i]*XG[i]";
    output Real beta_mol "Generalised gas fraction";
  protected
    Real beta_max "Upper bound for Rachford-Rice";
    Real beta_min "Lower bound for Rachford-Rice";
    Real beta_eps "Numerical assistance";

    function rachford_rice
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input Modelica.Units.SI.MoleFraction Xmol[nX] "Mole Fractions";
      input Real iK[nX] "Inverted equilibrium constants";
    algorithm
      y := sum({Xmol[i]*(1-iK[i])/(iK[i] + u*(1-iK[i])) for i in 1:nX});
    end rachford_rice;
  
  algorithm
    beta_max := max(iK)/(max(iK)-1);
    beta_min := min(iK)/(min(iK)-1);
    beta_eps := 1E-9*(beta_max - beta_min);
    beta_mol := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function rachford_rice(Xmol=Xmol, iK=iK), u_min = beta_min+beta_eps, u_max = beta_max-beta_eps);
  end flashVaporisation;

  function vaporisationRatio
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MassFraction beta_mass;
  protected
    Modelica.Units.SI.MoleFraction[nX] Xmol = massToMoleFractions(cat(1, state.Xi, {1-sum(state.Xi)}));
    Real iK[nX] = invertedKs(state);
    Real beta_mol = flashVaporisation(Xmol, iK);
    Modelica.Units.SI.MoleFraction[nX] Xmol_gas;
    Modelica.Units.SI.MolarMass MM_gas "Molar mass for gas phase";
  algorithm
    if beta_mol <= 0 then
      beta_mass := 0;
    elseif beta_mol >= 1 then
      beta_mass := 1;
    else
      Xmol_gas := gasMolarFractions(beta_mol, Xmol, iK);
      MM_gas := Xmol_gas*MMX;
      beta_mass := beta_mol * MM_gas/molarMass(state);
    end if;
  end vaporisationRatio;


  partial function invertedKs "Inverted equilibrium constants"
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Real iK[nX];
  end invertedKs;


  function gasMolarFractions
    extends Modelica.Icons.Function;
    import Modelica.Constants.eps;
    input Real beta_mol "Generalised vaporisation ratio";
    input Modelica.Units.SI.MoleFraction[nX] Xmol "Overall molar compositions";
    input Real[nX] iK "Inverted equilibrium constants";
    output Modelica.Units.SI.MoleFraction[nX] Xmol_gas "Gas molar compositions";
  protected
    // Watch out for division by zero
    Real iK_safe[nX] = {max(iK[i], eps) for i in 1:nX};
  algorithm
    if beta_mol >= 1 then
      Xmol_gas := Xmol;
    else
      Xmol_gas := Xmol ./ (iK_safe + beta_mol*(1.0.-iK));
    end if;
  end gasMolarFractions;
  
  function liquidMolarFractions
    extends Modelica.Icons.Function;
    input Real beta_mol "Generalised vaporisation ratio";
    input Modelica.Units.SI.MoleFraction[nX] Xmol "Overall molar compositions";
    input Real[nX] iK "Inverted equilibrium constants";
    output Modelica.Units.SI.MoleFraction[nX] Xmol_liq "Liquid molar compositions";
  algorithm
    if beta_mol <= 0 then
      Xmol_liq := Xmol;
    else
      Xmol_liq := (iK.*Xmol) ./ (iK + beta_mol*(1.0.-iK));
    end if;
  end liquidMolarFractions;


  function gasConstant "Gas constant for the gas phase"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.SpecificHeatCapacity R_s "Gas constant of the gas phase";
  protected
    import Modelica.Constants.R;
    Real iK[nX] = invertedKs(state) "Inverted equilibrium constants";
    Modelica.Units.SI.MoleFraction Xmol[nX] = massToMoleFractions(cat(1, state.Xi, {1-sum(state.Xi)})) "Molar fractions";
    Real beta_mol = flashVaporisation(Xmol, iK) "Generalised vaporisation ratio";
    Modelica.Units.SI.MoleFraction[nX] Xmol_gas = gasMolarFractions(beta_mol, Xmol, iK) "Molar fractions in gas phase";
    Modelica.Units.SI.MolarMass MM_gas = MMX*Xmol_gas "Average molar mass of gas phase";
  algorithm
    R_s := R / MM_gas;
  end gasConstant;

  
  function flashEquilibrium
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MassFraction beta;
    output ThermodynamicState state_gas;
    output ThermodynamicState state_liq;
  protected
    Real iK[nX] = invertedKs(state);
    Modelica.Units.SI.MoleFraction Xmol[nX] = massToMoleFractions(cat(1, state.Xi, {1 - sum(state.Xi)}));
    Real beta_mol = flashVaporisation(Xmol, iK);
    Modelica.Units.SI.MoleFraction Xmol_gas[nX] = gasMolarFractions(beta_mol, Xmol, iK);
    Modelica.Units.SI.MoleFraction Xmol_liq[nX] = liquidMolarFractions(beta_mol, Xmol, iK);
    Modelica.Units.SI.MolarMass MM_gas = MMX*Xmol_gas;
    Modelica.Units.SI.MassFraction X_gas[nX] = moleToMassFractions(Xmol_gas);
    Modelica.Units.SI.MassFraction X_liq[nX] = moleToMassFractions(Xmol_liq);
  algorithm
    beta := beta_mol * MM_gas/molarMass(state);
    state_gas := ThermodynamicState(state.p, state.T, X_gas[1:nXi]);
    state_liq := ThermodynamicState(state.p, state.T, X_liq[1:nXi]);
  end flashEquilibrium;


  partial function gasSpecificHeatCapacityCp
    extends Modelica.Icons.Function;
    input ThermodynamicState state_gas "State of the gas phase, with gas compositions";
    output Modelica.Units.SI.SpecificHeatCapacity cp_gas;
  end gasSpecificHeatCapacityCp;
  
  partial function liquidSpecificHeatCapacityCp
    extends Modelica.Icons.Function;
    input ThermodynamicState state_liq "State of the liquid phase, with liquid compositions";
    output Modelica.Units.SI.SpecificHeatCapacity cp_liq;
  end liquidSpecificHeatCapacityCp;
  
  redeclare function extends specificHeatCapacityCp
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    cp := beta*gasSpecificHeatCapacityCp(state_gas) + (1-beta)*liquidSpecificHeatCapacityCp(state_liq);
  end specificHeatCapacityCp;
  
  redeclare function extends specificHeatCapacityCv
    import Modelica.Constants.R;
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
    Modelica.Units.SI.MolarMass MM_gas;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    MM_gas := MMX*massToMoleFractions(cat(1, state_gas.Xi, {1-sum(state_gas.Xi)}));
    cv := beta*(gasSpecificHeatCapacityCp(state_gas)-R/MM_gas) + (1-beta)*liquidSpecificHeatCapacityCp(state_liq);
  end specificHeatCapacityCv;


  partial function gasSpecificEnthalpy
    extends Modelica.Icons.Function;
    input ThermodynamicState state_gas "State of the gas phase, with gas compositions";
    output Modelica.Units.SI.SpecificEnthalpy h_gas;
  end gasSpecificEnthalpy;

  partial function liquidSpecificEnthalpy
    extends Modelica.Icons.Function;
    input ThermodynamicState state_liq "State of the liquid phase, with liquid compositions";
    output Modelica.Units.SI.SpecificEnthalpy h_liq;
  end liquidSpecificEnthalpy;
  
  redeclare function extends specificEnthalpy
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    h := beta*gasSpecificEnthalpy(state_gas) + (1-beta)*liquidSpecificEnthalpy(state_liq);
  end specificEnthalpy;


  partial function gasSpecificEntropy
    extends Modelica.Icons.Function;
    input ThermodynamicState state_gas "State of the gas phase, with gas compositions";
    output Modelica.Units.SI.SpecificEntropy s_gas;
  end gasSpecificEntropy;

  partial function liquidSpecificEntropy
    extends Modelica.Icons.Function;
    input ThermodynamicState state_liq "State of the liquid phase, with liquid compositions";
    output Modelica.Units.SI.SpecificEntropy s_liq;
  end liquidSpecificEntropy;
  
  redeclare function extends specificEntropy
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    s := beta*gasSpecificEntropy(state_gas) + (1-beta)*liquidSpecificEntropy(state_liq);
  end specificEntropy;


  partial function gasDensity
    extends Modelica.Icons.Function;
    input ThermodynamicState state_gas "State of the gas phase, with gas compositions";
    output Modelica.Units.SI.Density d_gas;
  end gasDensity;

  partial function liquidDensity
    extends Modelica.Icons.Function;
    input ThermodynamicState state_liq "State of the liquid phase, with liquid compositions";
    output Modelica.Units.SI.Density d_liq;
  end liquidDensity;

  redeclare function extends density
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    d := 1/(beta/gasDensity(state_gas) + (1-beta)/liquidDensity(state_liq));
  end density;


  redeclare function extends specificInternalEnergy
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    u := specificEnthalpy(state) - state.p*(beta/gasDensity(state_gas) + (1-beta)/liquidDensity(state_liq));
  end specificInternalEnergy;


  redeclare function extends isentropicEnthalpy
  protected
    Modelica.Units.SI.SpecificEntropy s_ref;
    Modelica.Units.SI.SpecificEnthalpy h_min, h_max;

    function s_offset "Find offset from isoentropic conditions, u is h_out"
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input Modelica.Units.SI.SpecificEntropy s_in;
      input Modelica.Units.SI.Pressure p_out;
      input Modelica.Units.SI.MassFraction[nXi] Xi;
    protected
      Modelica.Units.SI.SpecificEntropy s_out;
    algorithm
      s_out := specificEntropy(setState_phX(p_out, u, Xi));
      y := s_out - s_in;
    end s_offset;
  algorithm
    h_min := specificEnthalpy(setState_pTX(refState.p, 273.15, refState.Xi));
    h_max := specificEnthalpy(setState_pTX(refState.p, 1000, refState.Xi));
    s_ref := specificEntropy(refState);
    h_is := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function s_offset(s_in=s_ref, p_out=p_downstream, Xi=refState.Xi), u_min = h_min, u_max = h_max);
  end isentropicEnthalpy;


  redeclare function extends setSmoothState "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(
          p=Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
          T=Media.Common.smoothStep(x, state_a.T, state_b.T, x_small),
          Xi=Media.Common.smoothStep(x, state_a.Xi, state_b.Xi, x_small));
  end setSmoothState;

end PartialCondensingMixture;
