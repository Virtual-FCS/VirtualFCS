within VirtualFCS.Media;

package NH3Cracked

extends BaseShoMix(

  mediumName = "cracked_NH3",
  substanceNames = {"hydrogen", "nitrogen", "ammonia"}, 
  reference_X = {0.01, 0.01, 0.98},  // NB! These are MASS fractions, not molar.
  sh_params= {Shomate.H2, Shomate.N2, Shomate.NH3_G, Shomate.H2O_L},
  MMX = {
      Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM, 
      Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, 
      Modelica.Media.IdealGases.Common.SingleGasesData.NH3.MM} "Molar weights of the medium species",
      T_boil = 239.8 "Boiling temperature at atmospheric pressure of the condensing phase (ammonia)",
      L = 23400 "Latent heat of condensing phase (ammonia)"
);

 redeclare function densityOfLiquid
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.AbsolutePressure p;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.Density d_liq "Water density";
  algorithm
    d_liq := 682;
// Last "1" specifies liquid phase explicitly
  end densityOfLiquid;
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

redeclare function enthalpyOfLiquid "Helper function for enthalpy of liquid water"
  extends Modelica.Icons.Function;
  input ThermodynamicState state "Thermodynamic state record";
  output Modelica.Units.SI.SpecificEnthalpy h_liq;
algorithm
  h_liq := -16e6; // J/kg
end enthalpyOfLiquid;

redeclare function specificHeatCapacityCpOfLiquid "Helper function for heat capacity of liquid ammonia"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.SpecificHeatCapacity cp_liq;
  algorithm
    cp_liq := 4700; // J/(kg*K)

end specificHeatCapacityCpOfLiquid;

//redeclare function extends dynamicViscosity
//      "Return dynamic viscosity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
//  algorithm
//    eta := 3e-5;
//  end dynamicViscosity;

redeclare function extends thermalConductivity
      "Return thermal conductivity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
  algorithm
    lambda :=0.09;
  
  end thermalConductivity;


end NH3Cracked;
