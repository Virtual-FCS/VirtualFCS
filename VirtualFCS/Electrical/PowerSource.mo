within VirtualFCS.Electrical;

model PowerSource
  extends Modelica.Electrical.Analog.Interfaces.TwoPin;
  extends Modelica.Electrical.Analog.Icons.VoltageSource;
  Modelica.Blocks.Interfaces.RealInput P annotation(
    Placement(transformation(origin = {-4, -100}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {0, -64}, extent = {{-14, -14}, {14, 14}}, rotation = 90)));
protected
  Real v "Voltage across component";
  Real i "Current from p to n";
equation
// Pin currents
  p.i = i;
  n.i = -i;
// Constant power relation
  P = v*i;
  annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Electrical source component providing a prescribed power input through a voltage and current interface.</p>
<h2>Governing Equations</h2>
<pre>p.i = i;
n.i = -i;
P = v*i;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>v</code></td><td>Voltage across component</td></tr>
<tr><td><code>i</code></td><td>Current from p to n</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>P</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td></td></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
</table>
</body>
</html>"));
end PowerSource;
