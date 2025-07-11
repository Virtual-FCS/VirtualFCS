within VirtualFCS.ComponentTesting;

model CathodeAirTest
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.CathodeAir, fixedMassFlowRate(X_ambient = X_start+ {-x_H2O_increase*0.2, -x_H2O_increase*0.8, x_H2O_increase}, T_ambient = T_source));
  extends Modelica.Icons.Example;
  
  parameter Modelica.Units.SI.MassFraction x_H2O_increase = 0.05;
  parameter Modelica.Units.SI.Temperature T_source = 293;
equation

end CathodeAirTest;
