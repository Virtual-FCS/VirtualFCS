within VirtualFCS.Electrical;

model AveragedCommutator
  extends VirtualFCS.Electrical.AbstractCommutator;
  Modelica.Blocks.Interfaces.RealInput D(min = 0, max = 1) "Duty ratio" annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}})));
equation
  p1.v - n.v = (1 - D)*(p2.v - n.v);
  p1.i + p2.i + n.i = 0;
// Charge balance
  n.i = -D*p1.i;
// Current fraction going straight back to source
  LossPower = 0;
  annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
An averaged commutator for boost converters. The unit is implemented completely in code.<div>The equations state that, given an input duty ratio <i>D</i>:</div><div><ul><li>The input voltage is <i>(1-D)</i> times the output voltage;</li><li>The sum of entering currents is zero;</li><li>The current exiting from the negative pin is <i>D</i> times the input positive pin;</li><li>No power dissipation occurs.</li></ul></div>
<h2>Governing Equations</h2>
<pre>p1.v - n.v = (1 - D)*(p2.v - n.v);
p1.i + p2.i + n.i = 0;
n.i = -D*p1.i;
LossPower = 0;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>D</code></td><td>Duty ratio</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>D</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td>Duty ratio</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
<tr><td><code>p1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>-</td></tr>
<tr><td><code>p2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>-</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>-</td></tr>
</table>
</body>
</html>"));
end AveragedCommutator;
