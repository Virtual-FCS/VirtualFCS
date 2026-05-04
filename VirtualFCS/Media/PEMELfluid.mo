within VirtualFCS.Media;

model PEMELfluid "Generic fluid on anode and cathode of a PEM electrolyser"
  // derived from CathodeAir
  // TODO: rewrite considering we can have hydrogen/water mixtures w/o oxygen/nitrogen. Different indices, include H2 Shomate &c.
  // TODO: Check that only-liquid phase cases work (e.g. anode feed)
  // TODO: Possible to express CathodeAir as specialisation of PEMELfluid? Should we?
  // TODO: later extension: presence of trace gases in water w/ Henry's law.
  // TODO: nice to have: function to determine if gas mixture is explosive (>4% H2 and > 5% O2 for starters; maybe more complex models?)
  extends Modelica.Media.Interfaces.PartialMedium(final ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pTX, final mediumName = "PEMEL_fluid", final substanceNames = {"hydrogen", "oxygen", "nitrogen", "water"}, final reference_X = {0.0, 0.23, 0.76, 0.01},  // NB! These are MASS fractions, not molar. Oxygen is heavier, water is lighter.
  final singleState = false, final reducedX = true,  // Water is the "filler", since it can be anywhere
  final fixedX = false, Temperature(min = 273.15, max = 500, start = 333), AbsolutePressure(min = 3E4, max = 1E6, start = 1E5));
  // Convenience variables to index arrays within class
  constant Integer Hydrogen = 1 "Index of hydrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Oxygen = 2 "Index of oxygen (in substanceNames, massFractions X, etc.)";
  constant Integer Nitrogen = 3 "Index of nitrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Water = 4 "Index of water (in substanceNames, massFractions X, etc.)";
  constant Modelica.Units.SI.MolarMass MMs[nX] = {Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM, Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM, Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM} "Molar weights of the medium species";

  redeclare record extends ThermodynamicState "Thermodynamic state variables"
      extends Modelica.Icons.Record;
      /* To keep things simple, we assume that pTX is a sufficient representation of the thermodynamic state.
       * Strictly speaking, it is not: there are corner cases like water at 0 or 100 C.
       * If we were to handle these cases correctly we should use h instead of T, but then we would need to invert h(T).
       * Inverting h(T) at every step would be far more computationally onerous than using the direct Shomate formulas.
       * Since pure freezing or boiling water is an extremely rare case, we use the more convenient and faster option.
       */
      AbsolutePressure p "Absolute pressure of medium";
      Temperature T "Temperature of medium";
      MassFraction[nXi] Xi(start = reference_X[1:nXi]) "Independent mass fractions";
  end ThermodynamicState;

  redeclare model extends BaseProperties(final standardOrderComponents = true) "Base properties of medium"
      Modelica.Units.SI.MoleFraction phi = relativeHumidity(state) "Relative humidity of gas phase";
      Modelica.Units.SI.MassFraction X_l = liquidMassFraction(state) "Mass fraction in liquid phase";
      Modelica.Units.SI.MassFraction Y[nX] = cat(1, Yi, {1 - sum(Yi)}) "Full gas-phase compositions";
      Modelica.Units.SI.AbsolutePressure p_sat = saturationPressure(state.T);
      Modelica.Units.SI.SpecificEnthalpy h_gas = enthalpyOfGas(T, Yi[Hydrogen], Yi[Oxygen], Yi[Nitrogen]);
      Modelica.Units.SI.SpecificEnthalpy h_liq = enthalpyOfWater(T);

    protected
      Modelica.Units.SI.MassFraction Yi[nXi] = gasMassFraction(state) "Independent gas-phase compositions";

    equation
      d = density(state);
      h = specificEnthalpy(state);
      u = specificInternalEnergy(state);
      MM = molarMass(state); // Weighed average for all species, both phases
      R_s = gasConstant(state); // Gas constant valid only for gas phase
      state.p = p;
      state.T = T;
      state.Xi = Xi;
  end BaseProperties;

  function saturationPressure "Vapour pressure of water as function of temperature"
    extends Modelica.Icons.Function;
    import Modelica.Math.log;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.AbsolutePressure p;
  protected
    constant Real A = 4.6543;
    constant Real B = 1435.264;
    constant Real C = -64.848;
  algorithm
    p := 10^5*10^(A - B/(T + C));
    annotation(
      derivative = saturationPressure_der);
  end saturationPressure;

  function saturationPressure_der
    extends Modelica.Icons.Function;
    import Modelica.Math.log;
    input Modelica.Units.SI.Temperature T;
    input Modelica.Units.SI.TemperatureSlope dT;
    output Modelica.Units.SI.PressureSlope dp;
  protected
    constant Real A = 4.6543;
    constant Real B = 1435.264;
    constant Real C = -64.848;
    Modelica.Units.SI.Pressure p;
  algorithm
    p := 10^5*10^(A - B/(T + C));
    dp := p*log(10)*B/(T + C)^2;
  end saturationPressure_der;

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
      state.T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function h_offset(p = p, h = h, X = X), u_min = 273.15, u_max = 1000);
  end setState_phX;

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
      Modelica.Units.SI.MolarMass X[nX];

    algorithm
      X := cat(1, state.Xi, {1 - sum(state.Xi)});
      MM := 1/sum(X./MMs);
  end molarMass;

  function liquidMassFraction "Fraction of mass in liquid phase, assumed only water."
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.MassFraction X_l "Mass fraction in liquid phase";
  algorithm
    X_l := max(0.0, (1 - sum(state.Xi)) - MMs[Water]/molarMass(state)*saturationPressure(state.T)/state.p);
  end liquidMassFraction;

  function gasMassFraction "Independent mass fractions in gas phase"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.MassFraction[nXi] Yi "Mass fractions in gas phase";
  algorithm
    Yi := state.Xi[Hydrogen:Nitrogen]/(1 - liquidMassFraction(state));
  end gasMassFraction;

  function gasConstant "Gas constant for the gas phase"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.SpecificHeatCapacity R_s "Gas constant of the gas phase";
  protected
    import Modelica.Constants.R;
    Modelica.Units.SI.MassFraction[nXi] Yi "Independent mass fractions in gas phase";
    Modelica.Units.SI.MassFraction[nX] Y "Full mass fractions in gas phase";
    Modelica.Units.SI.MolarMass MM_gas "Average molar mass of gas phase";
  algorithm
    Yi := gasMassFraction(state);
    Y := cat(1, Yi, {1 - sum(Yi)});
    MM_gas := 1/sum(Y./MMs);
    R_s := R/MM_gas;
  end gasConstant;

  redeclare function extends specificEnthalpy
    protected
      Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
      Modelica.Units.SI.MassFraction Yi[nXi] "Independent gas-phase compositions";

    algorithm
      X_l := liquidMassFraction(state);
      Yi := gasMassFraction(state);
      h := X_l*enthalpyOfWater(state.T) + (1 - X_l)*enthalpyOfGas(state.T, Yi[Hydrogen], Yi[Oxygen], Yi[Nitrogen]);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
    protected
      Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";

    algorithm
      X_l := liquidMassFraction(state);
      u := specificEnthalpy(state) - state.p*(X_l/densityOfWater(state.p, state.T) + (1 - X_l)/densityOfGas(state));
    annotation(
      Documentation(info = "<html><head></head><body>Obtained by inverting the well-known formula H = U+pV.<div><br>In this case, u = h - pv, where all extensive units (h, u, v) are on a per-kg basis; this means that v = 1/&rho;.</div></body></html>"));
  end specificInternalEnergy;

  function enthalpyOfWater "Helper function for enthalpy of liquid water"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.SpecificEnthalpy h_liq;
  algorithm
    h_liq := Shomate.enthalpy(T, Shomate.H2O_L)/MMs[Water];
    annotation(
      Documentation(info = "<html><head></head><body>Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div></body></html>"));
  end enthalpyOfWater;

  function enthalpyOfGas
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    input Modelica.Units.SI.MassFraction y_H2 "Hydrogen fraction in gas";
    input Modelica.Units.SI.MassFraction y_O2 "Oxygen fraction in gas";
    input Modelica.Units.SI.MassFraction y_N2 "Nitrogen fraction in gas";
    output Modelica.Units.SI.SpecificEnthalpy h_gas;
  protected
    constant Shomate.Parameters[nX] parameters = {Shomate.H2, Shomate.O2, Shomate.N2, Shomate.H2O_G};
    Modelica.Units.SI.MassFraction[nX] Y = {y_H2, y_O2, y_N2, 1-y_H2-y_O2-y_N2};
  algorithm
    h_gas := Y * {Shomate.enthalpy(T, parameters[i]) / MMs[i] for i in 1:nX};
    annotation(
      Documentation(info = "<html><head></head><body><b><u>Important note!</u></b> To avoid confusing the compiler, we provide 3 separate composition scalars instead of an array Yi, which would seem simpler.<div><br></div><div>The OM compiler currently would accept the code with input scalar for temperature and vector for compositions, but will generate, compile and link C code that will however fail at runtime due to dimensional mismatch.</div><div>As the error occurs at runtime, there is no indication that the problem is actually in this part of the code; tracking the issue back to this point is nontrivial.</div><div><br><div>This issue may not happen in Dymola or future OpenModelica compilers; until then,&nbsp;<i><font color=\"#ff0000\">modify at your peril!</font></i></div></div></body></html>"));
  end enthalpyOfGas;

  function densityOfWater
    extends Modelica.Icons.Function;
    import Modelica.Media.Water.IF97_Utilities.rho_pT;
    input Modelica.Units.SI.AbsolutePressure p;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.Density d_liq "Water density";
  algorithm
    d_liq := rho_pT(p, T, 1); // Last "1" specifies liquid phase explicitly
  end densityOfWater;

  function densityOfGas "Density of gas, assuming ideality"
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.Density d_gas "Gas density";
  algorithm
    d_gas := state.p/(gasConstant(state)*state.T);
  end densityOfGas;

  redeclare function extends density
      extends Modelica.Icons.Function;

    protected
      Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";

    algorithm // NOTE non-linear combination
      X_l := liquidMassFraction(state);
      d := 1/(X_l/densityOfWater(state.p, state.T) + (1 - X_l)/densityOfGas(state));
  end density;

  function relativeHumidity
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MoleFraction phi;
  algorithm
    phi := ((1-sum(state.Xi))-liquidMassFraction(state)) * (molarMass(state)/MMs[Water]) * (state.p/saturationPressure(state.T));
  annotation(
      Documentation(info = "<html><head></head><body>Relative humidity φ is calculated as the ratio of actual water content in the gas phase compared to the saturation limit.<div><br></div><div>(1 - Σ X<sub>i</sub>) - X<sub>L</sub>&nbsp;is the <i>mass</i> fraction of water in gas phase (works as long as only water is in liquid phase). Multiplied by the average molar mass across phases and divided by M<sub>H2O</sub>, it becomes the <i>molar</i> ratio.</div><div>This is then divided by the saturation limit p<sup>sat</sup>(T)/p to calculate φ.</div><div><br></div><div>Note that φ&gt;1 is impossible by construction of liquidMassFraction().</div></body></html>"));
  end relativeHumidity;


  function specificHeatCapacityCpOfWater "Helper function for heat capacity of liquid water"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.SpecificHeatCapacity cp_liq;
  algorithm
    cp_liq := Shomate.heat_capacity(T, Shomate.H2O_L)/MMs[Water];
    annotation(
      Documentation(info = "<html><head></head><body>Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div></body></html>"));
  end specificHeatCapacityCpOfWater;

  function specificHeatCapacityCpOfGas
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    input Modelica.Units.SI.MassFraction y_H2 "Hydrogen fraction in gas";
    input Modelica.Units.SI.MassFraction y_O2 "Oxygen fraction in gas";
    input Modelica.Units.SI.MassFraction y_N2 "Nitrogen fraction in gas";
    output Modelica.Units.SI.SpecificHeatCapacity cp_gas;
  protected
    constant Shomate.Parameters[nX] parameters = {Shomate.H2, Shomate.O2, Shomate.N2, Shomate.H2O_G};
    Modelica.Units.SI.MassFraction[nX] Y = {y_H2, y_O2, y_N2, 1-y_H2-y_O2-y_N2};
  algorithm
    cp_gas := Y * {Shomate.heat_capacity(T, parameters[i]) / MMs[i] for i in 1:nX};
    annotation(
      Documentation(info = "<html><head></head><body><b><u>Important note!</u></b>&nbsp;To avoid confusing the compiler, we provide 3 separate composition scalars instead of an array Yi, which would seem simpler.<div><br></div><div>The OM compiler currently would accept the code with input scalar for temperature and vector for compositions, but will generate, compile and link C code that will however fail at runtime due to dimensional mismatch.</div><div>As the error occurs at runtime, there is no indication that the problem is actually in this part of the code; tracking the issue back to this point is nontrivial.</div><div><br><div>This issue may not happen in Dymola or future OpenModelica compilers; until then,&nbsp;<i><font color=\"#ff0000\">modify at your peril!</font></i></div></div></body></html>"));
  end specificHeatCapacityCpOfGas;

  redeclare function extends specificHeatCapacityCp
    protected
      Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
      Modelica.Units.SI.MassFraction Yi[nXi] "Independent gas-phase compositions";

    algorithm
      X_l := liquidMassFraction(state);
      Yi := gasMassFraction(state);
      cp := specificHeatCapacityCpOfGas(state.T, Yi[Hydrogen], Yi[Oxygen], Yi[Nitrogen])*(1 - X_l) + specificHeatCapacityCpOfWater(state.T)*X_l;
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
    protected
      Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
      Modelica.Units.SI.MassFraction Yi[nXi] "Independent gas-phase compositions";

    algorithm
      X_l := liquidMassFraction(state);
      Yi := gasMassFraction(state);
      cv := (specificHeatCapacityCpOfGas(state.T, Yi[Oxygen], Yi[Nitrogen]) - gasConstant(state))*(1 - X_l) + specificHeatCapacityCpOfWater(state.T)*X_l;
  end specificHeatCapacityCv;

  redeclare function extends setSmoothState "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
    algorithm
      state := ThermodynamicState(p = Media.Common.smoothStep(x,  state_a.p,  state_b.p, x_small),
                                  T = Media.Common.smoothStep(x,  state_a.T,  state_b.T, x_small), 
                                  Xi= Media.Common.smoothStep(x, state_a.Xi, state_b.Xi, x_small));
  end setSmoothState;
  annotation(
    Documentation(info = "<html>
<p>
This package is a <strong>template</strong> for <strong>new medium</strong> models. For a new
medium model just make a copy of this package, remove the
\"partial\" keyword from the package and provide
the information that is requested in the comments of the
Modelica source.
</p>
</html>"));
end PEMELfluid;
