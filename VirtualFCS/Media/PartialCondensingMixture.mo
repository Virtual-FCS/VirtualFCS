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
      annotation( Documentation(info = "<html><head></head><body><div>To keep things simple, we assume that pTX is a sufficient representation of the thermodynamic state.</div><div>Strictly speaking, it isn't, since there are corner cases like water at 0 or 100 C.</div><div>If we were to handle these cases correctly we should use h instead of T, but then we need to invert h(T), which is an onerous operation since Shomate equations are polynomials of T and would need to be solved iteratively:</div><div>this it possible but numerically onerous.</div><div>It would also be possible to calculate new direct correlations T(h), but this becomes rapidly a larger job.</div><div>Since pure freezing or boiling water is an extremely rare case in the systems we study, we use the more convenient option.</div></body></html>"));
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
  
  function antoine "Vapour pressure according to the Antoine equation"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T;
    input Real A;
    input Modelica.Units.SI.TemperatureDifference B, C;
    output Modelica.Units.SI.AbsolutePressure p;
  algorithm
    p := 10^(A - B/(T + C));
    annotation(smoothOrder(normallyConstant = A, normallyConstant = B, normallyConstant = C) = 100);
  end antoine;
  
  function clausiusClapeyron "Vapour pressure according to the Clausius Clapeyron equation"
    extends Modelica.Icons.Function;
    import Modelica.Constants.R;
    input Modelica.Units.SI.Temperature T, T_boil;
    input Modelica.Units.SI.MolarEnergy L;
    output Modelica.Units.SI.AbsolutePressure p;
  algorithm
    p := reference_p * exp(-L/R * (1/T - 1/T_boil));
    annotation(smoothOrder(normallyConstant = T_boil, normallyConstant = L) = 100);
  end clausiusClapeyron;

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
    annotation(derivative = flashVaporisation_der);
  end flashVaporisation;
  
  replaceable function flashVaporisation_der
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MoleFraction Xmol[nX];
    input Real iK[nX];
    input Real dXmol[nX];
    input Real diK[nX];
    output Real dbeta_mol = flashVaporisation(Xmol, iK);
  protected
    Real beta_mol = flashVaporisation(Xmol, iK);
    Real D[nX] = {iK[i] + beta_mol*(1-iK[i]) for i in 1:nX} "Convenience variable";
    Real S = sum(Xmol[i]*(1-iK[i])^2/D[i]^2 for i in 1:nX) "Convenience variable";
  algorithm
    dbeta_mol := (sum((1-iK[i])/D[i]*dXmol[i] - Xmol[i]/D[i]^2*diK[i] for i in 1:nX)) / S;
  annotation(
      Documentation(info = "<html><head></head><body>Differential of the Rachford-Rice relation for flash equilibria:<div>h(β) = Σ<sub>i</sub> z<sub>i</sub>/(iK<sub>i</sub>+β(1-iK<sub>i</sub>) = 0</div><div><br></div><div>Having defined the convenience variables:</div><div>D<sub>i</sub>=iK<sub>i</sub>+β(1-iK<sub>i</sub>)</div><div>S = Σ<sub>i</sub> (1-iK<sub>i</sub>)<sup>2</sup>z<sub>i</sub>/D<sub>i</sub></div><div><sub><br></sub></div><div>The differential is then dβ = Σ<sub>i</sub>(1-iK<sub>i</sub>)/(S*D<sub>i</sub>) dz<sub>i</sub> - z<sub>i</sub>/(S*D<sub>i</sub><sup>2</sup>) diK<sub>i</sub></div><div><sub><br></sub></div><div>If you need to verify this, either find pen and paper, or use Maxima and enter <pre>diff( z*(1-iK)/(iK+b*(1-iK)));</pre></div></body></html>"));
end flashVaporisation_der;

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
    output Real iK[nX](each min=0.0);
  end invertedKs;


  function gasMolarFractions
    extends Modelica.Icons.Function;
    import Modelica.Constants.eps;
    input Real beta_mol "Generalised vaporisation ratio";
    input Modelica.Units.SI.MoleFraction[nX] Xmol "Overall molar compositions";
    input Real[nX] iK "Inverted equilibrium constants";
    output Modelica.Units.SI.MoleFraction[nX] Xmol_gas "Gas molar compositions";
  algorithm
    if beta_mol >= 1 then
      Xmol_gas := Xmol;
    elseif abs(beta_mol) < eps then
      // If both iK and beta_mol = 0, I get a division by zero with the general formula
      // beta = 0 means only liquid, so Xmol=0 for all non-condensables
      Xmol_gas := {if iK[i] > eps then Xmol[i]/(iK[i] + beta_mol*(1.0.-iK[i])) else 0.0 for i in 1:nX};
    else
      Xmol_gas := Xmol ./ (iK + beta_mol*(1.0.-iK));
    end if;
  annotation(
      Documentation(info = "<html><head></head><body>Given a generalised molar vaporisation ratio β, molar fractions X<sub>mol</sub>&nbsp;and inverted equilibrium constants iK, the function returns the corresponding molar fractions in the gas phase.<div>Note that, if β≥1 (i.e. only gas), the gas concentrations are simply the overall ones.</div><div><br></div><div>The case of β≤0 is a bit more thorny since no gas phase exist, and the gas fractions do not have a physical meaning, but must be defined nevertheless to ensure continuity of variables.</div><div>The main problem occurs when β=0, since the denominator of the main formula would collapse to zero for all incondensables, which already have iK=0 by definition of incondensables. Of course there cannot be incondensables present if β=0, but 0/0 would still produce an error.</div></body></html>"));
end gasMolarFractions;
  
  function liquidMolarFractions
    extends Modelica.Icons.Function;
    import Modelica.Constants.eps;
    input Real beta_mol "Generalised vaporisation ratio";
    input Modelica.Units.SI.MoleFraction[nX] Xmol "Overall molar compositions";
    input Real[nX] iK "Inverted equilibrium constants";
    output Modelica.Units.SI.MoleFraction[nX] Xmol_liq "Liquid molar compositions";
  algorithm
    if beta_mol >= 1 then
      Xmol_liq := iK.*Xmol;
      if max(Xmol_liq) < eps then
        Xmol_liq := iK / sum(iK) "Handle corner case with no condensables in mixture";
      else
        Xmol_liq := Xmol_liq / sum(Xmol_liq) "Normalise if we know it is nonzero";
      end if;
    elseif beta_mol <= 0 then
      Xmol_liq := Xmol;
    else
      Xmol_liq := (iK.*Xmol) ./ (iK + beta_mol*(1.0.-iK));
    end if;
  annotation(
      Documentation(info = "<html><head></head><body>Given a generalised molar vaporisation ratio β, molar fractions X<sub>mol</sub> and inverted equilibrium constants iK, the function returns the corresponding molar fractions in the liquid phase.<div>Note that, if β≤0 (i.e. only liquid), the liquid concentrations are simply the overall ones.</div><div><br></div><div>The case of β≥1 is a bit more thorny since no liquid phase exist, and the liquid fractions do not have a physical meaning, but must be defined nevertheless to ensure continuity of variables.</div><div>The algorithm first attempts to use iK*X<sub>mol</sub>&nbsp;as the composition of the first droplet to form, but before normalising by dividing by Σ iK*X<sub>mol</sub>, it checks whether the array is zero: this happens in corner cases such as dry air. In that case, it assumes a liquid composition of iK/Σ iK, which is the limit for the overall fractions of all condensable species tending to zero at the same rate.</div></body></html>"));
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
    beta := max(0.0, min(1.0, beta_mol * MM_gas/molarMass(state)));
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
    Modelica.Units.SI.SpecificEntropy s_ref = specificEntropy(refState);
    Modelica.Units.SI.SpecificEnthalpy h_min = specificEnthalpy(setState_pTX(refState.p, 200, refState.Xi));
    Modelica.Units.SI.SpecificEnthalpy h_max = specificEnthalpy(setState_pTX(refState.p, 1000, refState.Xi));

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
    h_is := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function s_offset(s_in=s_ref, p_out=p_downstream, Xi=refState.Xi), u_min = h_min, u_max = h_max);
  end isentropicEnthalpy;


  redeclare function extends setSmoothState "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(
          p=Modelica.Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
          T=Modelica.Media.Common.smoothStep(x, state_a.T, state_b.T, x_small),
          Xi=Modelica.Media.Common.smoothStep(x, state_a.Xi, state_b.Xi, x_small));
  end setSmoothState;

end PartialCondensingMixture;
