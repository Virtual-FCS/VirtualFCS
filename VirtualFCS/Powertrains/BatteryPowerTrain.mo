within VirtualFCS.Powertrains;
model BatteryPowertrain
  extends VirtualFCS.Powertrains.PowertrainInterface;
  replaceable Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(batterySystem.pin_n, pin_n) annotation(
    Line(points = {{-34, -20}, {-34, 40}, {-40, 40}, {-40, 96}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, pin_p) annotation(
    Line(points = {{-26, -20}, {-26, 40}, {42, 40}, {42, 96}}, color = {0, 0, 255}));
  annotation (
    Icon(coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Battery-electric powertrain connecting a DC converter, battery system, and external electrical bus.</p>
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
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
</tbody></table>

</body></html>"));
end BatteryPowertrain;
