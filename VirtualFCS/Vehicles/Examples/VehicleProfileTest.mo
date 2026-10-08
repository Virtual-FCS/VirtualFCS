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
    experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-06, Interval = 1),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Simulation harness for VehicleProfile. The instantiated sources, boundaries, and loads define the test conditions; sensors expose the connected component response.</p><h3>Assembly</h3><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Component</th><th>Model</th><th>Description</th></tr>
<tr><td><code>trapezoid</code></td><td><code>Modelica.Blocks.Sources.Trapezoid</code></td><td>-</td></tr>
<tr><td><code>batterySystem</code></td><td><code>Electrochemical.Battery.BatterySystem</code></td><td>-</td></tr>
<tr><td><code>ground</code></td><td><code>Modelica.Electrical.Analog.Basic.Ground</code></td><td>-</td></tr>
</tbody></table>
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
end VehicleProfileTest;
