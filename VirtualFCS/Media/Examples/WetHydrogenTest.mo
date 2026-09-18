within VirtualFCS.Media.Examples;

model WetHydrogenTest
  extends Modelica.Icons.Example;
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.WetHydrogen);

end WetHydrogenTest;
