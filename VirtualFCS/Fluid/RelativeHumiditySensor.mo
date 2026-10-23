within VirtualFCS.Fluid;

model RelativeHumiditySensor
  extends Modelica.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor(redeclare package Medium = Media.MoistAir);
  extends Modelica.Icons.RoundSensor;

  Modelica.Blocks.Interfaces.RealOutput phi(final quantity="MoleFraction", final unit="1") annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  phi = Medium.relativeHumidity(Medium.setState_phX(port.p, inStream(port.h_outflow), inStream(port.Xi_outflow)));
annotation(
    Icon(graphics = {Text(origin = {70, -142}, extent = {{60, 136}, {0, 102}}, textString = "φ"), Text(extent={{-150,80},{150,120}}, textString="%name", textColor={0,0,255}), Line(rotation = 90,points = {{-100, 0}, {-70, 0}}, color = {0, 127, 255}, thickness = 1), Line( rotation = 180, points = {{-100, 0}, {-70, 0}}, color = {0, 0, 127}, thickness = 0.5), Ellipse(origin = {0, -38}, lineColor = {0, 127, 255}, fillColor = {0, 127, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-10, 10}, {10, -10}}, startAngle = -30, endAngle = 210, closure = EllipseClosure.Chord), Polygon(origin = {0, -22}, fillColor = {0, 127, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-8.66, -11}, {8.66, -11}, {0, 0}, {-8.66, -11}})}),
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>
This sensor indicates the relative humidity (as mole fraction) of the component it is connected to.
</p><p>The medium must provide a Medium.relativeHumidity function taking the medium state as argument.</p>
<h2>Governing Equations</h2>
<pre>phi = Medium.relativeHumidity(Medium.setState_phX(port.p, inStream(port.h_outflow), inStream(port.Xi_outflow)));</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>phi</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>1</td><td>Hydration factor in the ohmic-loss correlation</td></tr>
<tr><td><code>port</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
</table>
</body>
</html>"),
  Diagram(graphics));
end RelativeHumiditySensor;
