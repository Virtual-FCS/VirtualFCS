within VirtualFCS.Electrochemical.Examples;

model BatterySystemTest
  extends Modelica.Icons.Example;
  Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.99)  annotation(
    Placement(transformation(origin = {5, -15}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Blocks.Sources.Step P_values(height = -52000, offset = 25800, startTime = 10000) annotation(
    Placement(transformation(origin = {56, 86}, extent = {{10, -10}, {-10, 10}})));
  Electrical.PowerSource powerSource annotation(
    Placement(transformation(origin = {4, 30}, extent = {{10, 10}, {-10, -10}}, rotation = -0)));
equation
  connect(powerSource.n, batterySystem.pin_n) annotation(
    Line(points = {{-6, 30}, {-10, 30}, {-10, 16}, {-4, 16}, {-4, 4}}, color = {0, 0, 255}));
  connect(powerSource.p, batterySystem.pin_p) annotation(
    Line(points = {{14, 30}, {24, 30}, {24, 16}, {14, 16}, {14, 4}}, color = {0, 0, 255}));
  connect(P_values.y, powerSource.P) annotation(
    Line(points = {{46, 86}, {4, 86}, {4, 36}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 20000, Tolerance = 1e-06, Interval = 0.5),
  Diagram);
annotation(Documentation(info = "<html><p>This test applies a battery power demand of 25.8 kW from 0 to 10000 s, then steps it to -26.2 kW at 10000 s. The battery starts at SOC = 0.99. </p><p>The electrical source is connected directly to the battery system; battery electrical and thermal parameters otherwise use their model defaults.</p></html>"));
end BatterySystemTest;
