within VirtualFCS.ComponentTesting;

model PumpElectricDCTest "Simple model to test the PumpElectricDC model"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, nPorts = 1, p = system.p_start)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.9, V_max_bat_pack = 27, V_min_bat_pack = 23, V_nom_bat_pack = 25, m_bat_pack = 1) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 0.14, f = 0.01, offset = 0.15, startTime = 10)  annotation(
    Placement(visible = true, transformation(origin = {-46, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine1(amplitude = 0.15, f = 1, offset = 0.005, startTime = 350) annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Abs abs1 annotation(
    Placement(visible = true, transformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(sine1.y, abs1.u) annotation(
    Line(points = {{-58, -70}, {-42, -70}}, color = {0, 0, 127}));
  connect(boundary.ports[1], pumpElectricDC.Input) annotation(
    Line(points = {{-60, 0}, {-18, 0}}, color = {0, 0, 255}, thickness = 1.5));
  connect(pumpElectricDC.Output, fixedBoundary.ports[1]) annotation(
    Line(points = {{18, 0}, {60, 0}}, color = {0, 0, 255}, thickness = 1.5));
  connect(batterySystem.pin_n, pumpElectricDC.pin_n) annotation(
    Line(points = {{-4, 50}, {-6, 50}, {-6, 16}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, pumpElectricDC.pin_p) annotation(
    Line(points = {{4, 50}, {6, 50}, {6, 16}}, color = {0, 0, 255}));
  connect(sine.y, pumpElectricDC.contol_input) annotation(
    Line(points = {{-34, -38}, {-6, -38}, {-6, -16}}, color = {0, 0, 127}));
annotation (
  experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end PumpElectricDCTest;
