within VirtualFCS.Fluid;

model NonHumidifier
  extends VirtualFCS.Fluid.HumidifierInterface;
equation
  connect(portA_in, portA_out) annotation(
    Line(points = {{-100, 50}, {100, 50}}));
  connect(portB_out, portB_in) annotation(
    Line(points = {{-100, -50}, {100, -50}}));

annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Pass-through implementation of the humidifier interface. Streams are connected without humidification.</p>
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
<tr><td><code>portA_in</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>Wet-side connection at the first axial cell</td></tr>
<tr><td><code>portB_in</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>Dry-side connection at the last axial cell (counter-current flow)</td></tr>
<tr><td><code>portA_out</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Wet-side connection at the last axial cell</td></tr>
<tr><td><code>portB_out</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Dry-side connection at the first axial cell (counter-current flow)</td></tr>
</tbody></table>

</body></html>"));
end NonHumidifier;
