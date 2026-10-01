within VirtualFCS.Media.Examples;

model MoistAirTest
  extends Modelica.Icons.Example;
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.MoistAir);

end MoistAirTest;
