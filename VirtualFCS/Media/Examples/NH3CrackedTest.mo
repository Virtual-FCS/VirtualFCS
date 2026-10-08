within VirtualFCS.Media.Examples;

model NH3CrackedTest
  //X_ambient = X_start + {-x_NH3_conversion, x_NH3_conversion*0.5, x_NH3_conversion*3}
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.NH3Cracked, fixedMassFlowRate(T_ambient = T_source, redeclare package Medium = VirtualFCS.Media.NH3Cracked));
  extends Modelica.Icons.Example;
  
  parameter Modelica.Units.SI.MassFraction x_NH3_conversion = 0.1;
  parameter Modelica.Units.SI.Temperature T_source = 193;
equation

annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Test model for cracked-ammonia medium flow.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Media.Examples.Utilities.PartialTestModel</code>, <code>Modelica.Icons.Example</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>x_NH3_conversion</code></td><td>Modelica.Units.SI.MassFraction</td><td>1</td><td><code>0.1</code></td><td>-</td></tr>
<tr><td><code>T_source</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>193</code></td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end NH3CrackedTest;
