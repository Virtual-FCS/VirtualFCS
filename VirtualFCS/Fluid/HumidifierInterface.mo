within VirtualFCS.Fluid;

model HumidifierInterface
  
  replaceable package dry_medium = Modelica.Media.Interfaces.PartialMedium "Dry gas (shell side)" annotation(
    choicesAllMatching = true);
  replaceable package wet_medium = Modelica.Media.Interfaces.PartialMedium "Wet side (fiber side)" annotation(
    choicesAllMatching = true);
  
  Modelica.Fluid.Interfaces.FluidPort_a portA_in(replaceable package Medium = wet_medium) annotation(
    Placement(transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a portB_in(replaceable package Medium = dry_medium) annotation(
    Placement(transformation(origin = {100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b portA_out(replaceable package Medium = wet_medium) annotation(
    Placement(transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b portB_out(replaceable package Medium = dry_medium) annotation(
    Placement(transformation(origin = {-100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  
equation

annotation(
    Icon(graphics = {Rectangle(fillColor = {189, 189, 189}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-100, 60}, {100, -60}}, radius = 30), Rectangle(origin = {-62, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 60}, {6, -60}}), Rectangle(origin = {62, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 60}, {6, -60}}), Line(origin = {0.2, 56}, points = {{-56, 0}, {56, 0}}, thickness = 1), Line(origin = {0.2, -56}, points = {{-56, 0}, {56, 0}}, thickness = 1), Text(origin = {29, 51}, extent = {{-15, 9}, {15, -9}}, textString = "wet_in"), Text(origin = {29, -49}, extent = {{-15, 9}, {15, -9}}, textString = "wet_out"), Text(origin = {-83, 17}, extent = {{-15, 9}, {15, -9}}, textString = "dry_in"), Text(origin = {85, 19}, extent = {{-15, 9}, {15, -9}}, textString = "dry_out")}),
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Interface for humidifier components with separate air-side and hydrogen-side fluid ports.</p>
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
<tr><td><code>portA_in</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>Wet-side connection at the first axial cell</td></tr>
<tr><td><code>portB_in</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>Dry-side connection at the last axial cell (counter-current flow)</td></tr>
<tr><td><code>portA_out</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Wet-side connection at the last axial cell</td></tr>
<tr><td><code>portB_out</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Dry-side connection at the first axial cell (counter-current flow)</td></tr>
</table>
</body>
</html>"));
end HumidifierInterface;
