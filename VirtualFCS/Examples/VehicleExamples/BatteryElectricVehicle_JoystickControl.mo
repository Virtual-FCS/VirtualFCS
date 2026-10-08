within VirtualFCS.Examples.VehicleExamples;
model BatteryElectricVehicle_JoystickControl
  extends BatteryElectricVehicle(redeclare Vehicles.JoystickDriveInput driveCycle);
  
  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This example replaces a prescribed drive cycle with joystick velocity input for a Mirai-profile battery-electric vehicle. The battery starts at SOC = 0.9 with 200 Ah capacity, nominal voltage 320 V, and limits of 300 V to 360 V.</p><p>The user provides the driving excitation.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>BatteryElectricVehicle</code>.</p>
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
end BatteryElectricVehicle_JoystickControl;
