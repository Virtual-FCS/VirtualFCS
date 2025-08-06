within VirtualFCS.Media;

package CathodeAir "Medium model for cathodic air"
  extends Modelica.Media.Interfaces.PartialMedium(
    final ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pTX,
    final mediumName = "Cathode_air",
    final substanceNames = {"oxygen", "nitrogen", "water"}, 
    final reference_X = {0.23, 0.76, 0.01},  // NB! These are MASS fractions, not molar. Oxygen is heavier, water is lighter.
    final singleState = false,
    final reducedX = true,
    final fixedX = false,
    Temperature(min = 273.15, max = 500, start = 333),
    AbsolutePressure(min = 3E4, max = 3E5, start = 1E5));

  // Convenience variables to index arrays within class
  constant Integer Oxygen = 1 "Index of oxygen (in substanceNames, massFractions X, etc.)";
  constant Integer Nitrogen = 2 "Index of nitrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Water = 3 "Index of water (in substanceNames, massFractions X, etc.)";
  constant Modelica.Units.SI.MolarMass MMs[nX] = {
    Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM, 
    Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, 
    Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM} "Molar weights of the medium species";

  redeclare record extends ThermodynamicState "Thermodynamic state variables"
    extends Modelica.Icons.Record;
    /* To keep things simple, we assume that pTX is a sufficient representation of the thermodynamic state.
     * Strictly speaking, it isn't, since there are corner cases like water at 0 or 100 C.
     * If we were to handle these cases correctly we should use h instead of T, but then we need to invert h(T).
     * Since pure boiling water is an extremely rare case in fuel cells, we use the more convenient.
     */
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
    MassFraction[nX] X(start = reference_X) "Mass fractions (= (component mass)/total mass  m_i/m)";
  end ThermodynamicState;

  redeclare model extends BaseProperties(final standardOrderComponents = true) "Base properties of medium"
      Modelica.Units.SI.MoleFraction phi = relativeHumidity(state) "Relative humidity of gas phase";
      Modelica.Units.SI.MassFraction X_l = liquidMassFraction(state) "Mass fraction in liquid phase";
      Modelica.Units.SI.MassFraction Y[nX] = cat(1, Yi, {1-sum(Yi)}) "Full gas-phase compositions";
      Modelica.Units.SI.AbsolutePressure p_sat = saturationPressure(state.T);
      Modelica.Units.SI.SpecificEnthalpy h_gas = enthalpyOfGas(T, Yi[Oxygen], Yi[Nitrogen]);
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
      state.X = X;
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
    state.X := X;
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
    state.X := X;
    state.T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function h_offset(p=p, h=h, X=X), u_min = 273.15, u_max = 500);
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
    Xi := state.X[1:nXi];
  end massFraction;
  
  redeclare function extends molarMass
  algorithm
    MM := 1 / sum(state.X ./ MMs);
  end molarMass;
  
  function liquidMassFraction "Fraction of mass in liquid phase, assumed only water."
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.MassFraction X_l "Mass fraction in liquid phase";
  algorithm
    X_l := max(0.0, state.X[Water] - MMs[Water]/molarMass(state)*saturationPressure(state.T)/state.p);
  end liquidMassFraction;

  function gasMassFraction "Independent mass fractions in gas phase"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.MassFraction[nXi] Yi "Mass fractions in gas phase";
  algorithm
    Yi := state.X[Oxygen:Nitrogen] / (1-liquidMassFraction(state));
  end gasMassFraction;

  function gasConstant "Gas constant for the gas phase"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.SpecificHeatCapacity R_s "Gas constant of the gas phase";
  protected
    import Modelica.Constants.R;
    Modelica.Units.SI.MassFraction[nXi] Yi "Independent mass fractions in gas phase";
    Modelica.Units.SI.MolarMass MM_gas "Average molar mass of gas phase";
  algorithm
    Yi := gasMassFraction(state);
    MM_gas := 1/(sum(Yi./MMs[Oxygen:Nitrogen]) + (1-sum(Yi))/MMs[Water]);
    R_s := R / MM_gas;
  end gasConstant;

  redeclare function extends specificEnthalpy
  protected
    Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
    Modelica.Units.SI.MassFraction Yi[nXi] "Independent gas-phase compositions";
    Modelica.Units.SI.MassFraction Y[nX] "Full gas-phase compositions";
  algorithm
    X_l := liquidMassFraction(state);
    Yi := gasMassFraction(state);
    h := X_l*enthalpyOfWater(state.T) + (1-X_l)*enthalpyOfGas(state.T, Yi[Oxygen], Yi[Nitrogen]);
  end specificEnthalpy;
  
  redeclare function extends specificInternalEnergy
  protected
    Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
    Modelica.Units.SI.MassFraction Yi[nXi] "Independent gas-phase compositions";
    Modelica.Units.SI.MassFraction Y[nX] "Full gas-phase compositions";
  algorithm
    X_l := liquidMassFraction(state);
    Yi := gasMassFraction(state);
    Y := cat(1, Yi, {1-sum(Yi)});
    u := specificEnthalpy(state) - state.p*(X_l/densityOfWater(state.p, state.T) + (1-X_l)/densityOfGas(state));
  end specificInternalEnergy;
  
  function enthalpyOfWater "Helper function for enthalpy of liquid water"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.SpecificEnthalpy h_liq;
  algorithm
    h_liq := Shomate.enthalpy(T, Shomate.H2O_L) / Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;
  annotation(
      Documentation(info = "<html><head></head><body>Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div></body></html>"));
end enthalpyOfWater;
  
  impure function enthalpyOfGas
    extends Modelica.Icons.Function;    
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    input Modelica.Units.SI.MassFraction y_O2 "Oxygen fraction in gas";
    input Modelica.Units.SI.MassFraction y_N2 "Nitrogen fraction in gas";
    output Modelica.Units.SI.SpecificEnthalpy h_gas;
  protected
    constant Shomate.Parameters[nX] parameters = {Shomate.O2, Shomate.N2, Shomate.H2O_G};
    Modelica.Units.SI.SpecificEnthalpy[nX] h_species;
  algorithm
    h_species := {Shomate.enthalpy(T, parameters[i]) / MMs[i] for i in 1:nX};
    h_gas := y_O2 * Shomate.enthalpy(T, Shomate.O2) / MMs[Oxygen] +
             y_N2 * Shomate.enthalpy(T, Shomate.N2) / MMs[Nitrogen] +
             (1-y_O2-y_N2) * Shomate.enthalpy(T, Shomate.H2O_G) / MMs[Water];
  annotation(
      Documentation(info = "<html><head></head><body><b><u>Important note!</u></b> To avoid confusing the compiler, we provide 2 scalars instead of an array Yi as it would seem simpler.<div>This nonsense does not always appear and is devilishly difficult to track back to this point. Noticed first in ManifoldTest.</div><div>It might not happen at all in Dymola or future OpenModelica compilers.</div><div><i>Modify at your peril!</i></div></body></html>"));
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
  
  function densityOfGas
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
  algorithm
    X_l := liquidMassFraction(state);
    d := 1 / (X_l/densityOfWater(state.p, state.T) + (1-X_l)/densityOfGas(state)); // NOTE non-linear combination
  end density;

  function relativeHumidity
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MoleFraction phi;
  algorithm
    phi := (state.X[Water]-liquidMassFraction(state)) * (molarMass(state)/MMs[Water]) * (state.p/saturationPressure(state.T));
  end relativeHumidity;
  
  redeclare function extends setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(
          p=Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
          T=Media.Common.smoothStep(x, state_a.T, state_b.T, x_small),
          X=Media.Common.smoothStep(x, state_a.X, state_b.X, x_small));
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
end CathodeAir;
