within VirtualFCS.Media;

package MoistAir "Template for media models"
  /* What do we want here?
   * 1) Enthalpy from p, T which will usually be available; in general, have to sum phases
   * 1b) Enthalpy for liquid and gas phases
   * 2) Compositions in both phases
   * 3) Calculate mass fraction in liquid phase (needed to sum enthalpies)
   * 4) If liquid phase is present (boolean function), compare p with p_vap
   * 5) Presence of dissolved gases in liquid (Henry's law)
   */
  extends Modelica.Media.Interfaces.PartialMedium(
    final mediumName = "Moist_air",
    final substanceNames = {"oxygen", "nitrogen", "water"}, 
    final reference_X = {0.23, 0.76, 0.01},  // NB! These are MASS fractions, not molar. Oxygen is heavier, water is lighter.
    final singleState = false,
    final reducedX = true,
    final fixedX = false,
    Temperature(min = 298, max = 500, start = 333),
    AbsolutePressure(min = 3E4, max = 3E5, start = 1E5));

  import Modelica.Constants.R;

  // Convenience variables to index arrays within class
  constant Integer Oxygen = 1 "Index of oxygen (in substanceNames, massFractions X, etc.)";
  constant Integer Nitrogen = 2 "Index of nitrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Water = 3 "Index of water (in substanceNames, massFractions X, etc.)";

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

  /* Provide an implementation of model BaseProperties,
     that is defined in PartialMedium. Select two independent
     variables from p, T, d, u, h. The other independent
     variables are the mass fractions "Xi", if there is more
     than one substance. Provide 3 equations to obtain the remaining
     variables as functions of the independent variables.
     It is also necessary to provide two additional equations to set
     the gas constant R_s and the molar mass MM of the medium.
     Finally, the thermodynamic state vector, defined in the base class
     Interfaces.PartialMedium.BaseProperties, should be set, according to
     its definition (see ThermodynamicState below).
     The computation of vector X[nX] from Xi[nXi] is already included in
     the base class Interfaces.PartialMedium.BaseProperties, so it should not
     be repeated here.
     The code fragment below is for a single-substance medium with
     p,T as independent variables.
  */

  redeclare model extends BaseProperties(final standardOrderComponents = true) "Base properties of medium"
      // Future work:
      // * Add hydrogen to obtain multi-purpose mixture
      // * Henry's law for dissolved gases (ignore in mass balance?)
      Modelica.Units.SI.SpecificEnthalpy h_liq "Specific Enthalpy of liquid phase";
      Modelica.Units.SI.SpecificEnthalpy h_gas "Specific Enthalpy of gas phase";
      Modelica.Units.SI.SpecificInternalEnergy u_liq "Internal Energy of liquid phase";
      Modelica.Units.SI.SpecificInternalEnergy u_gas "Internal Energy of gas phase";
      Modelica.Units.SI.MassFraction X_liq "Mass fraction in liquid phase, assumed only water";
      Modelica.Units.SI.MassFraction Y[nX] "Gas-phase composition";
      Modelica.Units.SI.MolarMass MM_gas = 1/sum(Y./MMs) "Average molar mass of gas phase";
      Modelica.Units.SI.MoleFraction RH(min = 0.0, max = 1.0) "Relative humidity of gas phase";

    protected
      Modelica.Units.SI.AbsolutePressure p_sat = SaturationPressure(T) "Water vapour pressure at current temperature";
      constant Modelica.Units.SI.MolarMass MMs[nX] = {
        Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM, 
        Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, 
        Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM} "Molar weights of the medium species";
      import fluids = Modelica.Media.IdealGases.Common.SingleGasesData;
      import h_T = Modelica.Media.IdealGases.Common.Functions.h_Tlow; // "Low" is anything below 1000 K
      import Modelica.Media.Water.IF97_Utilities.rho_pT;
      import Modelica.Media.Water.IF97_Utilities.h_pT;

    equation
      MM = 1/sum(X./MMs); // Weighed average for all species, both phases
      X_liq = max(X[Water] - (MMs[Water]/MM)*(p_sat/p), 0.0); // Note MM correction for mass instead of mole fraction
      Y = X / (1-X_liq); // Y == X if no liquid phase
      
      RH = (X[Water] - X_liq) * (M/MMs[Water]) * (p/p_sat); // Humidity in gas phase
      R_s = R / MM_gas; // Gas constant valid only for gas phase
      
      d_liq = rho_pT(p, T, 1); // Last input: region 1, or liquid water
      d_gas = p/(R_s*T); // Assumed ideal gas law; OK for O2 & N2, maybe not perfect for H2O
      d = 1 / (X_liq/d_liq + (1-X_liq)/d_gas); // NOTE non-linear combination

      h_gas = h_T(fluids.O2, T, false) *Y[Oxygen] + 
              h_T(fluids.N2, T, false) *Y[Nitrogen] + 
              h_T(fluids.H2O, T, false)*Y[Water];
      // Anything similar for liquid water? YES, Modelica.Media.Water.IF97_Utilities.h_pT
      h_liq = h_pT(p, T, 1); // Last input: region 1, or liquid water
      h = h_liq*X_liq + h_gas*(1 - X_liq);

      u_liq = h_liq - p/d_liq;
      u_gas = h_gas - p/d_gas;
      u = X_liq*u_liq + (1-X_liq)*u_gas;
      
      state.p = p;
      state.T = T;
  end BaseProperties;

  /* Provide implementations of the following optional properties.
     If not available, delete the corresponding function.
     The record "ThermodynamicState" contains the input arguments
     of all the function and is defined together with the used
     type definitions in PartialMedium. The record most often contains two of the
     variables "p, T, d, h" (e.g., medium.T)
  */

  function SaturationPressure "Vapour pressure of water as function of temperature"
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
      derivative = SaturationPressure_der);
  end SaturationPressure;

  function SaturationPressure_der
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
  end SaturationPressure_der;

  function MassToMoleFractions
    extends Modelica.Icons.Function;
    input MassFraction X[:] "Mass fractions";
    input MolarMass MM[:] "Molar masses";
    output MoleFraction X_mol[:] "Molar fractions";
  algorithm
    X_mol := (X ./ MM) / sum(X ./ MM);

  end MassToMoleFractions;

  function MoleToMassFractions
    extends Modelica.Icons.Function;
    input MoleFraction X_mol[:] "Molar fractions";
    input MolarMass MM[:] "Molar masses";
    output MassFraction X[:] "Mass fractions";
  algorithm
    X := (X .* MM) / sum(X .* MM);
  algorithm

  end MoleToMassFractions;
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
end MoistAir;
