within VirtualFCS.Media;

/* What do we want here?
 * 1) Enthalpy from p, T which will usually be available; in general, have to sum phases
 * 1b) Enthalpy for liquid and gas phases
 * 2) Compositions in both phases
 * 3) Calculate mass fraction in liquid phase (needed to sum enthalpies)
 * 4) If liquid phase is present (boolean function), compare p with p_vap
 * 5) Presence of dissolved gases in liquid (Henry's law)
 */ 
  

package MoistAir "Template for media models"
  extends Modelica.Media.Interfaces.PartialMedium(
    final mediumName="Moist_air",
    final substanceNames={"oxygen", "nitrogen", "water"},
    final reference_X={0.23, 0.76, 0.01}, // NB! These are MASS fractions, not molar. Oxygen is heavier, water is lighter.
    final singleState=false,
    final reducedX=true,
    final fixedX=false,
    Temperature(min=298, max=500, start=333),
    AbsolutePressure(min=3E4, max=3E5, start=1E5)
  );

  constant Integer Oxygen=1 "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Nitrogen=2 "Index of air (in substanceNames, massFractions X, etc.)";
  constant Integer Water=3 "Index of air (in substanceNames, massFractions X, etc.)";

  redeclare record extends ThermodynamicState "Thermodynamic state variables"
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
    MassFraction[nX] X(start=reference_X) "Mass fractions (= (component mass)/total mass  m_i/m)";
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

  redeclare model extends BaseProperties(final standardOrderComponents=true)
    "Base properties of medium"
  
    // TODO
    // Relative humidity in gas (0..1), if 1 there is a liquid phase
    // Add gas/liquid fractions? Liquid will be fixed at {0,0,1}.
    // Gas/liquid density, enthalpy and internal energy split by phase? I might have separators and such...
    // I need to provide MM, R_s, and set the state
    
    // Future work:
    // Add hydrogen to obtain multi-purpose mixture
    // Henry's law for dissolved gases (ignore in mass balance?)
    
    Modelica.Units.SI.SpecificEnthalpy h_liq "Specific Enthalpy of liquid phase";
    Modelica.Units.SI.SpecificEnthalpy h_gas "Specific Enthalpy of gas phase";
    Modelica.Units.SI.MoleFraction Xmol[nX] = (X ./ MMs) / sum(X ./ MMs) "Overall molar composition";
    Modelica.Units.SI.MassFraction Y[nX] "Gas-phase composition";
    Modelica.Units.SI.MassFraction Ymol[nX] = (Y ./ MMs) / sum(Y ./ MMs) "Molar gas-phase composition";
    
    Real RH(min=0.0, max=1.0) "Relative humidity of gas phase";
    
    // What about water vapour pressure?

  protected
    Modelica.Units.SI.AbsolutePressure p_sat = SaturationPressure(T) "Water vapour pressure at current temperature";
    constant Modelica.Units.SI.MolarMass MMs[nX] = {
      Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM,
      Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM,
      Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM} "Molar weights of the medium species";

  equation // TODO comment on inverting Shomate to use h and p for state to handle corner cases

    // FIXME can I fully remove mol components? Should I?
    if p_sat > X_mol[Water] * p then // We are in gas phase, and there is not enough water to sustain a liquid phase
      Y = X;
    else // Part of the water will be in liquid phase; fraction in gas phase is set by saturation limit
      Ymol[Water] = p_sat/p;
      Y[Oxygen]*X[Nitrogen] = X[Oxygen]*Y[Nitrogen]; // O2/N2 ratio is identical since they are only in gas phase. Use * instead of / to avoid division by zero issues.
      sum(Y) = 1.0;
    end if;

    MM = 1 / sum(X ./ MMs); // Weighed average for all species, both phases
    //R_s = TODO // Makes sense only for gas phase
    //phi = min(TODO, 1.0);

    //TODO d = 1; // We have two phases here (but maybe only one!)
    // Note: there are functions from NASA for ideal gas enthalpy/Cp/entropy. Could use that instead of my own Shomate implementation.
    // See Modelica.Media.IdealGases.Common.Functions.
    // Anything similar for liquid water? YES, Modelica.Media.Water.IF97_Utilities.h_pT
    h = cp_const*T; // Add up contributions from fractions
    u = h - p/d; // OK as-is?

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

  annotation (Documentation(info="<html>
<p>
This package is a <strong>template</strong> for <strong>new medium</strong> models. For a new
medium model just make a copy of this package, remove the
\"partial\" keyword from the package and provide
the information that is requested in the comments of the
Modelica source.
</p>
</html>"));

  function SaturationPressure "Vapour pressure of water as function of temperature"
    extends Modelica.Icons.Function;
    
    import Modelica.Math.log;
    
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.AbsolutePressure p;
     
    annotation(derivative=SaturationPressure_der);
  
  protected
    constant Real A = 4.6543;
    constant Real B = 1435.264;
    constant Real C = -64.848;
  
  algorithm
    p := 10^5 * 10^(A - B/(T+C));
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
    p := 10^5 * 10^(A - B/(T+C));
    dp := p*log(10)*B/(T+C)^2;
  
  end SaturationPressure_der;

end MoistAir;

