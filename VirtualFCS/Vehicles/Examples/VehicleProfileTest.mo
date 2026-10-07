within VirtualFCS.Vehicles.Examples;

model VehicleProfileTest
  extends Modelica.Icons.Example;
  VehicleProfile vehicleProfile(VN = "UserDefined", m_user_defined = 1200)  annotation(
    Placement(transformation(extent = {{-21, -21}, {21, 21}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(amplitude = 100, rising = 20, width = 20, falling = 20, period = 80, startTime = 20)  annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-14, -14}, {14, 14}})));
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {60, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 90)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {43, -27}, extent = {{-3, -3}, {3, 3}})));
equation
  connect(trapezoid.y, vehicleProfile.vehicleVelocity) annotation(
    Line(points = {{-64, 0}, {-26, 0}}, color = {0, 0, 127}));
  connect(vehicleProfile.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{18, -10}, {34, -10}, {34, -6}, {46, -6}}, color = {0, 0, 255}));
  connect(vehicleProfile.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{18, 10}, {34, 10}, {34, 6}, {46, 6}}, color = {0, 0, 255}));
  connect(batterySystem.pin_n, ground.p) annotation(
    Line(points = {{46, -6}, {46, -15}, {43, -15}, {43, -24}}, color = {0, 0, 255}));

annotation(
    experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-06, Interval = 1));
end VehicleProfileTest;
