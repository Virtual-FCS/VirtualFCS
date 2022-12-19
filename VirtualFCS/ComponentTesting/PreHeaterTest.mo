within VirtualFCS.ComponentTesting;

model PreHeaterTest
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Thermal.PreHeater preHeater(L_pipe = 100)  annotation(
    Placement(visible = true, transformation(origin = {1.77636e-15, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(replaceable package Medium = Medium, nPorts = 1, p = 101325*5)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(replaceable package Medium = Medium, nPorts = 1, p = 101325*4.7) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {0, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature1(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {30, -30}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
equation
  connect(boundary.ports[1], preHeater.port_a) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(preHeater.port_b, fixedBoundary.ports[1]) annotation(
    Line(points = {{20, 0}, {60, 0}}, color = {0, 127, 255}));
  connect(batterySystem.pin_p, preHeater.pin_p) annotation(
    Line(points = {{-4, 52}, {-4, 30}, {-10, 30}, {-10, 20}}, color = {0, 0, 255}));
  connect(batterySystem.pin_n, preHeater.pin_n) annotation(
    Line(points = {{4, 52}, {4, 30}, {10, 30}, {10, 20}}, color = {0, 0, 255}));
  connect(temperature.port, preHeater.port_a) annotation(
    Line(points = {{-30, -20}, {-20, -20}, {-20, 0}}, color = {0, 127, 255}));
  connect(temperature1.port, preHeater.port_b) annotation(
    Line(points = {{30, -20}, {20, -20}, {20, 0}}, color = {0, 127, 255}));

annotation(experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end PreHeaterTest;
