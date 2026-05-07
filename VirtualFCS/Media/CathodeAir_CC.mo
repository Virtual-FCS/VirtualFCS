within VirtualFCS.Media;

package CathodeAir_CC

extends BaseShoMix(

  mediumName = "Cathode_air",
  substanceNames = {"oxygen", "nitrogen", "water"}, 
  reference_X = {0.23, 0.76, 0.01},  // NB! These are MASS fractions, not molar. Oxygen is heavier, water is lighter.
  sh_params= {Shomate.O2, Shomate.N2, Shomate.H2O_G, Shomate.H2O_L},
  MMs = {
      Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM, 
      Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, 
      Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM} "Molar weights of the medium species",
      T_boil = 373.15 "Boiling temperature at atmospheric pressure of the condensing phase (water)",
      L = 40700 "Latent heat of condensing phase (water)"
);
  
    
    
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

end CathodeAir_CC;
