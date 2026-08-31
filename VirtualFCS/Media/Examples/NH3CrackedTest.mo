within VirtualFCS.Media.Examples;

model NH3CrackedTest
  //X_ambient = X_start + {-x_NH3_conversion, x_NH3_conversion*0.5, x_NH3_conversion*3}
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.NH3Cracked, fixedMassFlowRate(T_ambient = T_source, redeclare package Medium = VirtualFCS.Media.NH3Cracked));
  extends Modelica.Icons.Example;
  
  parameter Modelica.Units.SI.MassFraction x_NH3_conversion = 0.1;
  parameter Modelica.Units.SI.Temperature T_source = 193;
equation

end NH3CrackedTest;
