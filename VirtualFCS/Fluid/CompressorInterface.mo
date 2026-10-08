within VirtualFCS.Fluid;

partial model CompressorInterface
  extends Modelica.Fluid.Interfaces.PartialTwoPort(final allowFlowReversal=false, final showDesignFlowDirection=false) annotation(
    IconMap(extent = {{-100, -79}, {100, 121}}),
    DiagramMap(extent = {{-100, -79}, {100, 121}}));
  extends Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPort;
  extends Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;
equation
  connect(flange_a, flange_b) annotation(
    Line(points = {{-100, 0}, {100, 0}}));
  annotation(
    Icon(graphics = {Polygon(fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-100, -100}, {100, -40}, {100, 40}, {-100, 100}, {-100, -100}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier)}),
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
This partial class defines the interfaces of a mechanically-driven compressor, combining several standard Modelica classes.<div><br><div>Mechanical work is delivered to the compressor via a shaft, which connects&nbsp;<tt>flange_a</tt> and <tt>flange_b</tt> internally; this allows connecting a motor on one flange and a turbine on the other.<br><br></div><div>Heat can be set in different ways depending on the value of <tt>heatport</tt>: the exact mechanisms are set in child classes.</div></div>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Fluid.Interfaces.PartialTwoPort</code>, <code>Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPort</code>, <code>Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>allowFlowReversal</code></td><td>Boolean</td><td>1</td><td><code>system.allowFlowReversal</code></td><td>= true to allow flow reversal, false restricts to design direction (port_a -&gt; port_b) (inherited)</td></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>port_a</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>Fluid connector a (positive design flow direction is from port_a to port_b)</td></tr>
<tr><td><code>port_b</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Fluid connector b (positive design flow direction is from port_a to port_b)</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Optional port to which dissipated losses are transported in form of heat</td></tr>
<tr><td><code>flange_a</code></td><td>Connection</td><td>Modelica.Mechanics.Rotational.Interfaces.Flange_a</td><td>rad; N.m</td><td>Flange of left shaft</td></tr>
<tr><td><code>flange_b</code></td><td>Connection</td><td>Modelica.Mechanics.Rotational.Interfaces.Flange_b</td><td>rad; N.m</td><td>Flange of right shaft</td></tr>
</table>
</body>
</html>"));
end CompressorInterface;
