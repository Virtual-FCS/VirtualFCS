within VirtualFCS.Media;

partial model PartialCondensingMixture
  extends Modelica.Media.Interfaces.PartialMixtureMedium;
  
  constant Modelica.Units.SI.MolarMass MMX[nS] = "Molar masses of substances";
  
  // TODO Rachford-Rice K_i, z_i
  // Extend base properties with beta, liquid and gas-phase compositions, gas and liquid enthalpies
  // Equilibrium constants, use inverse value for numerical convenience (invK)
  // Several set-state convenience functions, also phX
  // setSmoothState
  
  // NOT humidity - to be specificied in child classes
  
  
  
end PartialCondensingMixture;
