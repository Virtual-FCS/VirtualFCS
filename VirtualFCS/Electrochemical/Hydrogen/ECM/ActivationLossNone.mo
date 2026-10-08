within VirtualFCS.Electrochemical.Hydrogen.ECM;

model ActivationLossNone
  extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseActivationLoss;
equation
  v = 0;
  annotation(
    Icon(graphics = {Text(textColor = {0, 0, 255}, extent = {{20, -20}, {-20, 20}}, textString = "None")}),
  Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Trivial implementation of mass transport element with no mass transport losses.<div>Voltage across the item is simply set to zero.</div>
<h2>Governing Equations</h2>
<pre>v = 0;</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>-</code></td><td>number of cells in the stack (inherited)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
</table>
</body>
</html>"));

end ActivationLossNone;
