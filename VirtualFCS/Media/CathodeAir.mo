within VirtualFCS.Media;

package CathodeAir "Template for media models"
  extends Modelica.Media.Interfaces.PartialMedium(
    final mediumName = "Moist_air",
    final substanceNames = {"oxygen", "nitrogen", "water"}, 
    final reference_X = {0.23, 0.76, 0.01},  // NB! These are MASS fractions, not molar. Oxygen is heavier, water is lighter.
    final singleState = false,
    final reducedX = true,
    final fixedX = false,
    Temperature(min = 298, max = 500, start = 333),
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
      // I should add: X_l, Y, RH
      Modelica.Units.SI.MoleFraction RH = relativeHumidity(state) "Relative humidity of gas phase";
      Modelica.Units.SI.MassFraction X_l = liquidMassFraction(state) "Mass fraction in liquid phase";
      Modelica.Units.SI.MassFraction Y[nX] = cat(1, Yi, {1-sum(Yi)}) "Full gas-phase compositions";
      Modelica.Units.SI.AbsolutePressure p_sat = saturationPressure(state.T);
      Modelica.Units.SI.AbsolutePressure y_sat = (MMs[Water]/MM)*(p_sat/state.p);
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
    Modelica.Units.SI.MassFraction[nXi] Y "Independent mass fractions in gas phase";
    Modelica.Units.SI.MolarMass MM_gas "Average molar mass of gas phase";
  algorithm
    Y := gasMassFraction(state);
    MM_gas := 1/(sum(Y./MMs[Oxygen:Nitrogen]) + (1-sum(Y))/MMs[Water]);
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
    Y := cat(1, Yi, {1-sum(Yi)});
    h := X_l*enthalpyOfWater(state.T) + (1-X_l)*enthalpyOfGas(state.T, Y);
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
    u := X_l*(enthalpyOfWater(state.T) - state.p/densityOfWater(state.p, state.T)) +
        (1-X_l)*(enthalpyOfGas(state.T, Y) - state.p/densityOfGas(state));
  end specificInternalEnergy;
  
  function enthalpyOfWater
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.SpecificEnthalpy h_liq;
  protected
    Modelica.Units.SI.MolarEnthalpy h_mol;
    Real t; // T/1000 K;
    constant Real A = -203.6060;
    constant Real B = 1523.290;
    constant Real C = -3196.413;
    constant Real D = 2474.455;
    constant Real E = 3.855326;
    constant Real F = -256.5478;
  algorithm
    t := T/1000;
    h_mol := 1000 * (A*t + (B/2)*t^2 + (C/3)*t^3 + (D/4)*t^4 - E/t + F);
    h_liq := h_mol / Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;
  annotation(
      Documentation(info = "<html><head></head><body>Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div></body></html>"));
end enthalpyOfWater;
  
  function enthalpyOfGas
    extends Modelica.Icons.Function;
    import h_T = Modelica.Media.IdealGases.Common.Functions.h_Tlow; // "Low" is anything below 1000 K
    import fluids = Modelica.Media.IdealGases.Common.SingleGasesData;
    import Modelica.Media.Interfaces.Choices.ReferenceEnthalpy;
    
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    input Modelica.Units.SI.MassFraction Y[nX] "Full vapour composition";
    output Modelica.Units.SI.SpecificEnthalpy h_gas;
  algorithm
    h_gas := h_T(fluids.O2,  T, false, ReferenceEnthalpy.ZeroAt25C)*Y[Oxygen] + 
             h_T(fluids.N2,  T, false, ReferenceEnthalpy.ZeroAt25C)*Y[Nitrogen] + 
             h_T(fluids.H2O, T, false, ReferenceEnthalpy.ZeroAt25C)*Y[Water];
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
  protected
    Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
  algorithm
    X_l := liquidMassFraction(state);
    d := 1 / (X_l/densityOfWater(state.p, state.T) + (1-X_l)/densityOfGas(state)); // NOTE non-linear combination
  end density;

  function relativeHumidity
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MoleFraction RH;
  algorithm
    RH := (state.X[Water]-liquidMassFraction(state)) * (molarMass(state)/MMs[Water]) * (state.p/saturationPressure(state.T));
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
