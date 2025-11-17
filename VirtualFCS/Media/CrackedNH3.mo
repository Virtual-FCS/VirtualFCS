within VirtualFCS.Media;

package CrackedNH3
  extends Modelica.Media.Interfaces.PartialMixtureMedium;
  // Define the number of components
  constant Integer nS = 3;
  constant String compositionNames[nS] = {"NH3", "H2", "N2"};

  // Initial composition (mass fractions)
  parameter Real X0[nS] = {0.33, 0.33, 0.34};

end CrackedNH3;
