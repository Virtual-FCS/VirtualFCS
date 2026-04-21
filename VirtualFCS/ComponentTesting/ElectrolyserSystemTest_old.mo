within VirtualFCS.ComponentTesting;

model ElectrolyserSystemTest_old

  extends Modelica.Icons.Example;
  VirtualFCS.Electrochemical.Hydrogen.Electrolysers_dev.ElectrolyserSystem_old electrolyserSystem_dev "Switched to dev"
    annotation (Placement(transformation(extent={{-22,-22},{22,22}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Electrical.Analog.Sources.StepCurrent stepCurrent(I = 600, offset = 100, startTime = 10)  annotation(
    Placement(transformation(origin = {0, 70}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(stepCurrent.n, electrolyserSystem_dev.pin_n) annotation(
    Line(points = {{-10, 70}, {-10, 20}}, color = {0, 0, 255}));
  connect(stepCurrent.p, electrolyserSystem_dev.pin_p) annotation(
    Line(points = {{10, 70}, {10, 45}, {12, 45}, {12, 20}}, color = {0, 0, 255}));
  annotation (experiment(StopTime = 20, Interval = 0.5, __Dymola_Algorithm = "Dassl"),
    Icon(graphics = {Text(origin = {-1, 1}, extent = {{19, 13}, {-19, -13}}, textString = "DEV")}));

end ElectrolyserSystemTest_old;
