within VirtualFCS.Media.Examples;

model MoistAirTest
  extends Modelica.Icons.Example;
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.MoistAir);

  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Simulation harness for MoistAir. The instantiated sources, boundaries, and loads define the test conditions; sensors expose the connected component response.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Example</code>, <code>Modelica.Media.Examples.Utilities.PartialTestModel</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end MoistAirTest;
