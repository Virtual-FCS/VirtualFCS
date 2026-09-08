within VirtualFCS.Media.Examples;

model CrackedAmmoniaTest
  extends Modelica.Icons.Example;
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.CrackedAmmonia, T_start=298, fixedMassFlowRate(X_ambient = {0.9, 0.1, 0}));

end CrackedAmmoniaTest;
