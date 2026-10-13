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
      annotation( Documentation(info = "<html><head></head><body><div>To keep things simple, we assume that pTX is a sufficient representation of the thermodynamic state.</div><div>Strictly speaking, it isn't, since there are corner cases like water at 0 or 100 C.</div><div>If we were to handle these cases correctly we should use h instead of T, but then we need to invert h(T), which is an onerous operation since Shomate equations are polynomials of T and would need to be solved iteratively: this it possible but numerically onerous.</div><div>It would also be possible to calculate new direct correlations T(h), but this becomes rapidly a larger job.</div><div>Since pure freezing or boiling water is an extremely rare case in the systems we study, we use the more convenient option.</div></body></html>"));
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
    
    Modelica.Units.SI.Temperature T_min = 273;
    Modelica.Units.SI.Temperature T_max = 500;
    Integer counter = 0 "Keep track of how many times we widened the window";
  algorithm
    state.p := p;
    state.Xi := X[1:nXi];
// Debugging code,
/*if h_offset(T_min, p, h, X)*h_offset(T_max, p, h, X) >= 0 then
      Modelica.Utilities.Streams.print("Same-sign error in setState_phX");
      Modelica.Utilities.Streams.print("p="+String(p)+", h="+String(h));
      for i in 1:nXi loop
        Modelica.Utilities.Streams.print("X["+String(i)+"]="+String(X[i]));
      end for;
    end if;*/
    while h_offset(T_min, p, h, X)*h_offset(T_max, p, h, X) >= 0 and counter < 20 loop
      T_min := T_min/1.1;
      T_max := T_max*1.1;
      counter := counter + 1;
    end while;
    state.T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function h_offset(p=p, h=h, X=X), u_min = T_min, u_max = T_max);
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
    output Real dbeta_mol;
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
  protected
    Modelica.Units.SI.MoleFraction beta_real = min(max(beta_mol, 0.0), 1.0) "Physically true vaporisation ratio";
  algorithm
    Xmol_gas := {Xmol[i] / max(iK[i] + beta_real*(1.0 - iK[i]), eps) for i in 1:nX};
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
  protected
    Modelica.Units.SI.MoleFraction beta_real = min(max(beta_mol, 0.0), 1.0) "Physically true vaporisation ratio";
  algorithm
    Xmol_liq :=  {iK[i]*(Xmol[i] + eps) / max(iK[i] + beta_real*(1.0 - iK[i]), eps) for i in 1:nX};
    Xmol_liq := Xmol_liq / sum(Xmol_liq);
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

    function s_offset "Find offset from isentropic conditions, u is T_out"
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input Modelica.Units.SI.SpecificEntropy s_in;
      input Modelica.Units.SI.Pressure p_out;
      input Modelica.Units.SI.MassFraction[nXi] Xi;
    algorithm
      y := specificEntropy(setState_pTX(p_out, u, Xi)) - s_in;
    end s_offset;

    Modelica.Units.SI.Temperature T_is "Temperature after isentropic change of pressure";
  algorithm
    T_is := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function s_offset(s_in=s_ref, p_out=p_downstream, Xi=refState.Xi), u_min = 200, u_max = 1000);
    h_is := specificEnthalpy(setState_pTX(p_downstream, T_is, refState.Xi));
  end isentropicEnthalpy;


  redeclare function extends setSmoothState "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(
          p=Modelica.Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
          T=Modelica.Media.Common.smoothStep(x, state_a.T, state_b.T, x_small),
          Xi=Modelica.Media.Common.smoothStep(x, state_a.Xi, state_b.Xi, x_small));
  end setSmoothState;annotation(
    Documentation(info = "<html><head></head><body>This extension of <tt>PartialMedium</tt> models a mixture of multiple components, several of which may or may not condense into liquid phase.<div>This can be used to model e.g. condensing air in a fuel cell's cathode, the anodic loop of a PEM electrolyser and ammonia-air systems.</div><div>Note that condensation is inherently an extra calculation, and gas mixtures or pure liquids should be preferred when possible.</div><h2>Derived classes</h2><div>To implement your medium, you need to provide implementations for the following:</div><div><ul><li>Molar masses <tt>MMX</tt>, reference composition <tt>reference_X</tt>&nbsp;(note: <i>mass</i> fractions, not molar!), and component names <tt>substanceNames</tt>;</li><li><tt>invertedKs</tt>, a function providing the inverse of equilibrium constants K<sub>i</sub>, i.e. the ratios of <u><i>molar</i></u> fraction in gas vs. in liquid. The reason why the function provides K<sub>i</sub><sup>-1</sup> instead of K<sub>i</sub>&nbsp;directly is that we want to allow modelling of incondensable gases, for which K<sub>i</sub>=
<!--StartFragment--><span id=\"symbol\" class=\"symbol large\">∞; providing</span> K<sub>i</sub><sup>-1</sup>=0 allows to avoid dealing with infinity in calculations and the headaches that come with it.</li><li><tt>(gas|liquid)SpecificHeatCapacityCp</tt>, <tt>(gas|liquid)SpecificEnthalpy</tt>, <tt>(gas|liquid)SpecificEntropy</tt>, <tt>(gas|liquid)Density</tt>: these thermodynamic functions provide the indicated quantities for either phase. Note that their argument is a <tt>ThermodynamicState</tt> <i>already</i>&nbsp;referring to the relevant phase, to reduce the times the equilibrium calculations are run.</li></ul></div><div><h2>Implementation</h2><div>The model uses a <a href=\"https://en.wikipedia.org/wiki/Flash_evaporation#Equilibrium_flash_of_a_multi-component_liquid\">Rachford-Rice equation</a>&nbsp;to calculate the equilibrium compositions for both phases (and whether there is one or both phases).</div><div>Rachford-Rice is an implicit equation and as such it is inherently <b>computationally onerous</b>; if your mixture has only one condensable component (e.g. water), it may be worth it to replace the implementation of <tt>flashVaporisation</tt> with a direct approach to achieve better computational performance.</div><h2>Utilities</h2></div><div>The model provides some useful functions:</div><div><ul><li><tt>massToMoleFractions</tt> and <tt>moleToMassFractions</tt>, to convert composition arrays between the two systems; Modelica uses mostly mass internally, but data is typically available on a mole basis.</li><li><tt>antoine</tt> and <tt>clausiusClapeyron</tt>, to calculate vapour pressure with the respective equation.</li></ul><h2>Reference</h2></div><!--StartFragment--><!--EndFragment--><div>Whitson, Curtis H., and Michael L. Michelsen. <a href=\"https://www.researchgate.net/publication/223072443_The_Negative_Flash\">\"The negative flash.\" </a><i>Fluid phase equilibria</i> 53 (1989): 51-71.</div><div><br></div></body></html>"));

end PartialCondensingMixture;
