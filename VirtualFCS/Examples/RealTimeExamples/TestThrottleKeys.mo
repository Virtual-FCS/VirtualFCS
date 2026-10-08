within VirtualFCS.Examples.RealTimeExamples;
model TestThrottleKeys
  extends Modelica.Icons.Example;
  VirtualFCS.XInTheLoop.UserInTheLoop.ThrottleKeys throttleKeys annotation (
    Placement(visible = true, transformation(origin = {0, 2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
equation

  annotation (
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This real-time example exposes the up and down keyboard states as a throttle-control signal. It has no prescribed simulation horizon or physical boundary conditions; user key events provide the excitation.</p><p>It requires Modelica_DeviceDrivers.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>throttleKeys</code> (VirtualFCS.XInTheLoop.UserInTheLoop.ThrottleKeys).</p>
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
end TestThrottleKeys;
