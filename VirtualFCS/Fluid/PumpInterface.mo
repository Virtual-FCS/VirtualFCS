within VirtualFCS.Fluid;

partial model PumpInterface
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation (choicesAllMatching = true);
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {-30, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {30, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, -100}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Blocks.Interfaces.RealInput u "Control input, can be replaced by whatever the manipulated variable is" annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}})));

annotation(
    Icon(graphics = {Polygon(origin = {0, -70}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-80, -30}, {80, -30}, {40, 30},{-40, 30}, {-80, -30}}), Ellipse(fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-80, 80}, {80, -80}}), Line(origin = {-50, 0}, points = {{-50, 0}, {50, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 10), Line(origin = {48, 80}, points = {{-50, 0}, {40, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 10)}),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
This partial class defines the interfaces of a compressor unit, for flow, power supply (assumed DC), heat exchange (in case of fully isentropic operation,&nbsp;
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
<tr><td><code>u</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td>Control input, can be replaced by whatever the manipulated variable is</td></tr>
<tr><td><code>port_a</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
<tr><td><code>port_b</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end PumpInterface;
