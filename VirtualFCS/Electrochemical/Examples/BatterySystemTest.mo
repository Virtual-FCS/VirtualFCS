within VirtualFCS.Electrochemical.Examples;

model BatterySystemTest
  extends Modelica.Icons.Example;
  Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.99)  annotation(
    Placement(transformation(origin = {5, -15}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Blocks.Sources.Step P_values(height = -52000, offset = 25800, startTime = 10000) annotation(
    Placement(transformation(origin = {56, 86}, extent = {{10, -10}, {-10, 10}})));
  Electrical.PowerSource powerSource annotation(
    Placement(transformation(origin = {4, 30}, extent = {{10, 10}, {-10, -10}}, rotation = -0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-32, -6}, extent = {{-4, -4}, {4, 4}})));
equation
  connect(powerSource.n, batterySystem.pin_n) annotation(
    Line(points = {{-6, 30}, {-10, 30}, {-10, 16}, {-4, 16}, {-4, 4}}, color = {0, 0, 255}));
  connect(powerSource.p, batterySystem.pin_p) annotation(
    Line(points = {{14, 30}, {24, 30}, {24, 16}, {14, 16}, {14, 4}}, color = {0, 0, 255}));
  connect(P_values.y, powerSource.P) annotation(
    Line(points = {{46, 86}, {4, 86}, {4, 36}}, color = {0, 0, 127}));
  connect(batterySystem.pin_n, ground.p) annotation(
    Line(points = {{-4, 4}, {-32, 4}, {-32, -2}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 20000, Tolerance = 1e-06, Interval = 0.5),
    Diagram,
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>This test applies a battery power demand of 25.8 kW from 0 to 10000 s, then steps it to -26.2 kW at 10000 s. The battery starts at SOC = 0.99. </p><p>The electrical source is connected directly to the battery system; battery electrical and thermal parameters otherwise use their model defaults.</p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end BatterySystemTest;
