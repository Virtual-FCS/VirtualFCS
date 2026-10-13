within VirtualFCS.Fluid;

partial model HeatExchangerInterface
  import Modelica.Media.Interfaces.PartialMedium;
  
  replaceable package Medium_1 = PartialMedium "Medium for exchanged side 1" annotation(choicesAllMatching = true);
  replaceable package Medium_2 = PartialMedium "Medium for exchanged side 2" annotation(choicesAllMatching = true);
  
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare final package Medium = Medium_1) annotation(
    Placement(transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare final package Medium = Medium_1) annotation(
    Placement(transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare final package Medium = Medium_2) annotation(
    Placement(transformation(origin = {-100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare final package Medium = Medium_2) annotation(
    Placement(transformation(origin = {100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
  annotation(
    Icon(graphics = {Ellipse(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-100, 100}, {100, -100}}), Line(points = {{-100, 0}, {-40, 0}, {-20, 40}, {22, -40}, {40, 0}, {100, 0}}, thickness = 3), Text(origin = {-80, -80}, rotation = -45, textColor = {0, 0, 255}, extent = {{-60, 20}, {60, -20}}, textString = "%name"), Text(origin = {-100, 0}, extent = {{0, 40}, {40, 0}}, textString = "1"), Text(origin = {100, 0}, extent = {{-40, 0}, {0, -40}}, textString = "1"), Text(origin = {0, -100}, extent = {{-40, 40}, {0, 0}}, textString = "2"), Text(origin = {0, 100}, extent = {{0, 0}, {40, -40}}, textString = "2")}),
  Diagram(graphics),
  Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
This is a generic interface for a heat exchanger, with two sides identified by digits 1 and 2, each featuring two ports (port_a{1,2} and port_b{1,2}) and a medium (Medium_{1,2}).<div>The ports are locked to their respective medium; otherwise, no other assumptions are made.</div>
<h2>Governing Equations</h2>
<p>Interface definition; no constitutive equations are specified.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>port_a1</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
<tr><td><code>port_b1</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
<tr><td><code>port_a2</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
<tr><td><code>port_b2</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
</table>
</body>
</html>"));
end HeatExchangerInterface;
