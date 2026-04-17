within VirtualFCS.Media;

package NH3Cracked

extends BaseShoMix(

  mediumName = "cracked_NH3",
  substanceNames = {"hydrogen", "nitrogen", "ammonia"}, 
  reference_X = {0.01, 0.01, 0.98},  // NB! These are MASS fractions, not molar.
  sh_params= {Shomate.H2, Shomate.N2, Shomate.NH3_G, Shomate.H2O_L},
  MMs = {
      Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM, 
      Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, 
      Modelica.Media.IdealGases.Common.SingleGasesData.NH3.MM} "Molar weights of the medium species",
      T_boil = 239.8 "Boiling temperature at atmospheric pressure of the condensing phase (ammonia)",
      L = 23400 "Latent heat of condensing phase (ammonia)"
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


end NH3Cracked;
