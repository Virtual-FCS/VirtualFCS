within VirtualFCS.ComponentTesting;

model HeatSinkTest
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC annotation(
    Placement(visible = true, transformation(origin = {-36, -8.88178e-16}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial)  annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, T = Medium.T_default + 100, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {-36, 40}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 0.14, f = 0.01, offset = 0.15, startTime = 10)  annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Thermal.HeatSink heatSink annotation(
    Placement(visible = true, transformation(origin = {20, 14}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-60, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-12, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {62, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(batterySystem.pin_n, pumpElectricDC.pin_n) annotation(
    Line(points = {{-40, 30}, {-40, 11}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, pumpElectricDC.pin_p) annotation(
    Line(points = {{-32, 30}, {-32, 11}}, color = {0, 0, 255}));
  connect(boundary.ports[1], pumpElectricDC.Input) annotation(
    Line(points = {{-80, 0}, {-49, 0}}, color = {0, 127, 255}));
  connect(sine.y, pumpElectricDC.contol_input) annotation(
    Line(points = {{-79, -50}, {-40, -50}, {-40, -11}}, color = {0, 0, 127}));
  connect(pumpElectricDC.Output, heatSink.port_a) annotation(
    Line(points = {{-24, 0}, {0, 0}}, color = {0, 127, 255}));
  connect(heatSink.port_b, fixedBoundary.ports[1]) annotation(
    Line(points = {{40, 0}, {80, 0}}, color = {0, 127, 255}));
  connect(temperature.port, pumpElectricDC.Input) annotation(
    Line(points = {{-60, -14}, {-60, 0}, {-48, 0}}, color = {0, 127, 255}));
  connect(temperature1.port, heatSink.port_a) annotation(
    Line(points = {{-12, -14}, {-12, 0}, {0, 0}}, color = {0, 127, 255}));
  connect(temperature2.port, heatSink.port_b) annotation(
    Line(points = {{62, -14}, {62, 0}, {40, 0}}, color = {0, 127, 255}));

annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end HeatSinkTest;
