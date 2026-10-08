within VirtualFCS.Electrochemical.Hydrogen.ECM;

partial model BaseVSource
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Icons.VoltageSource;
  
  outer parameter Integer N_cells "number of cells in the stack";

  annotation(
    Icon,
  Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
This is the abstract base unit for voltage sources in fuel cells.
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Electrical.Analog.Interfaces.OnePort</code>, <code>Modelica.Electrical.Analog.Icons.VoltageSource</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>-</code></td><td>number of cells in the stack</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
</table>
</body>
</html>"));

end BaseVSource;
