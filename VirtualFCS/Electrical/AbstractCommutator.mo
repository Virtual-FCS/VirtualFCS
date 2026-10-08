within VirtualFCS.Electrical;

partial model AbstractCommutator
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort annotation(
    IconMap(extent = {{-73.75, -47.5}, {126.25, 152.5}}),
    DiagramMap(extent = {{-47.5, -47.5}, {152.5, 152.5}}));
  Modelica.Electrical.Analog.Interfaces.PositivePin p1 annotation(
    Placement(transformation(origin = {-100, 100}, extent = {{10, 10}, {-10, -10}}), iconTransformation(origin = {-100, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin p2 annotation(
    Placement(transformation(origin = {100, 100}, extent = {{-10, 10}, {10, -10}}, rotation = -0), iconTransformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n annotation(
    Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
equation
  annotation(
    Icon(graphics = {Line(origin = {0, -100}, rotation = -90, points = {{-98, -34}, {-80, -20}, {-60, -20}, {-60, 0}, {0, 0}}, color = {0, 0, 255}, thickness = 1), Line(origin = {0, 100}, points = {{-100, 0}, {0, 0}, {0, -80}, {-20, -80}, {-20, -100}}, color = {0, 0, 255}, thickness = 1), Line(origin = {22, 80}, points = {{-22, 20}, {78, 20}}, color = {0, 0, 255}, thickness = 1), Line(origin = {20, -10}, points = {{-10, 7.5}, {10, 7.5}}, color = {0, 0, 255}, thickness = 1), Polygon(origin = {20, -10}, lineColor = {0, 0, 255}, lineThickness = 1, points = {{-10, -7}, {10, -7}, {0, 7}, {-10, -7}}), Line(origin = {20, -40}, points = {{-20, 0}, {0, 0}, {0, 23}}, color = {0, 0, 255}, thickness = 1), Line(origin = {20, 20}, points = {{-20, 0}, {0, 0}, {0, -23}}, color = {0, 0, 255}, thickness = 1), Text(textColor = {0, 0, 255}, extent = {{-150, 180}, {150, 130}}, textString = "%name")}),
    Diagram(graphics),
  Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
A unit representing a generic implementation of a 3-point commuter for boost converters.<div>The class does not specify anything other than its interface.</div>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
<tr><td><code>p1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>-</td></tr>
<tr><td><code>p2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>-</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>-</td></tr>
</table>
</body>
</html>"));
end AbstractCommutator;
