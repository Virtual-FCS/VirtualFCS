within VirtualFCS.Powertrains.Examples;

model BatteryPowertrainTest
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}})));
  replaceable BatteryPowerTrain powerTrain(SOC_init = 0.7)  annotation(
    Placement(transformation(origin = {40, 0}, extent = {{-20, -20}, {20, 20}})));
  Electrical.PowerSource powerSource annotation(
    Placement(transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Trapezoid trapezoid(amplitude = 50000, rising = 20, width = 20, falling = 20, period = 80, offset = -20000, startTime = 40)  annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}})));  
equation
  connect(powerSource.p, powerTrain.pin_p) annotation(
    Line(points = {{-30, 10}, {22, 10}}, color = {0, 0, 255}));
  connect(powerSource.n, powerTrain.pin_n) annotation(
    Line(points = {{-30, -10}, {22, -10}}, color = {0, 0, 255}));
  connect(trapezoid.y, powerSource.P) annotation(
    Line(points = {{-68, 0}, {-36, 0}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 400, Tolerance = 1e-06, Interval = 0.1));
end BatteryPowertrainTest;
