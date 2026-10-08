within VirtualFCS.Media.Examples;

model CrackedAmmoniaTest
  extends Modelica.Icons.Example;
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.CrackedAmmonia, T_start=298, fixedMassFlowRate(X_ambient = {0.9, 0.1, 0}));

  annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Simulation harness for CrackedAmmonia. The instantiated sources, boundaries, and loads define the test conditions; sensors expose the connected component response.</p>
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
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end CrackedAmmoniaTest;
