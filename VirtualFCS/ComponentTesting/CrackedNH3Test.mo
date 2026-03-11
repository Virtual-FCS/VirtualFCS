within VirtualFCS.ComponentTesting;

model CrackedNH3Test
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.CrackedNH3_Shomate, fixedMassFlowRate(X_ambient = X_start+ {-x_NH3_conversion, x_NH3_conversion*0.5, x_NH3_conversion*3}, T_ambient = T_source));
  extends Modelica.Icons.Example;
  
  parameter Modelica.Units.SI.MassFraction x_NH3_conversion = 0.1;
  parameter Modelica.Units.SI.Temperature T_source = 293;
equation

end CrackedNH3Test;
