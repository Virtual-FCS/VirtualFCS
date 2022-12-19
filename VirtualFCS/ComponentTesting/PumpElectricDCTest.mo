within VirtualFCS.ComponentTesting;

model PumpElectricDCTest
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC annotation(
    Placement(visible = true, transformation(origin = {1.77636e-15, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 0.14, f = 0.01, offset = 0.15, startTime = 10)  annotation(
    Placement(visible = true, transformation(origin = {-46, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(batterySystem.pin_n, pumpElectricDC.pin_n) annotation(
    Line(points = {{-4, 50}, {-4, 32}, {-6, 32}, {-6, 16}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, pumpElectricDC.pin_p) annotation(
    Line(points = {{4, 50}, {4, 32}, {6, 32}, {6, 16}}, color = {0, 0, 255}));
  connect(boundary.ports[1], pumpElectricDC.Input) annotation(
    Line(points = {{-60, 0}, {-18, 0}}, color = {0, 127, 255}));
  connect(pumpElectricDC.Output, fixedBoundary.ports[1]) annotation(
    Line(points = {{18, 0}, {60, 0}}, color = {0, 127, 255}));
  connect(sine.y, pumpElectricDC.contol_input) annotation(
    Line(points = {{-34, -38}, {-6, -38}, {-6, -16}}, color = {0, 0, 127}));

annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end PumpElectricDCTest;
