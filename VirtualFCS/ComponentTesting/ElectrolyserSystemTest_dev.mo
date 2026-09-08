within VirtualFCS.ComponentTesting;

model ElectrolyserSystemTest_dev

  extends Modelica.Icons.Example;
  VirtualFCS.Electrochemical.Hydrogen.Electrolysers_dev.ElectrolyserSystem_dev electrolyserSystem_dev "Switched to dev"
    annotation (Placement(transformation(extent={{-22,-22},{22,22}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Electrical.Analog.Sources.StepVoltage stepVoltage(V = 10, offset = 80, startTime = 10)  annotation(
    Placement(transformation(origin = {0, 64}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(stepVoltage.n, electrolyserSystem_dev.pin_n) annotation(
    Line(points = {{-10, 64}, {-10, 20}}, color = {0, 0, 255}));
  connect(stepVoltage.p, electrolyserSystem_dev.pin_p) annotation(
    Line(points = {{10, 64}, {12, 64}, {12, 20}}, color = {0, 0, 255}));
  annotation (experiment(StopTime = 20, Interval = 0.5, __Dymola_Algorithm = "Dassl"),
    Icon(graphics = {Text(origin = {-1, 1}, extent = {{19, 13}, {-19, -13}}, textString = "DEV")}));

annotation(Documentation(info = "<html><p>Development test model for the electrolyser system.</p></html>"));
end ElectrolyserSystemTest_dev;
