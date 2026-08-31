within VirtualFCS.Media.Examples;

model PEMELfluidTest
  extends Modelica.Icons.Example;
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.PEMELfluid);

end PEMELfluidTest;
