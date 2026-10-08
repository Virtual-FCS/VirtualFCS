within VirtualFCS.Examples.VehicleExamples;

partial model PartialVehicleExample
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  replaceable VirtualFCS.Vehicles.DriveCycle speed constrainedby Modelica.Blocks.Interfaces.SO annotation (
    Placement(transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}})));
  Vehicles.VehicleProfile vehicle annotation (
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}})));
  replaceable VirtualFCS.Powertrains.BatteryPowertrain powertrain annotation (
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation  
  connect(vehicle.pin_n, powertrain.pin_n) annotation (
    Line(points = {{18, -10}, {42, -10}, {42, -10}, {42, -10}}, color = {0, 0, 255}));
  connect(vehicle.pin_p, powertrain.pin_p) annotation (
    Line(points = {{18, 10}, {44, 10}, {44, 10}, {42, 10}}, color = {0, 0, 255}));
  connect(speed.y, vehicle.vehicleVelocity) annotation (
    Line(points = {{-36, 0}, {-28, 0}, {-28, 0}, {-26, 0}}, color = {0, 0, 127}));
annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This is a generic setup for vehicle tests with any powertrain.</p><p>Signal source, vehicle and powertrain can be replaced in child classes.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>system</code> (Modelica.Fluid.System), <code>speed</code> (VirtualFCS.Vehicles.DriveCycle), <code>vehicle</code> (Vehicles.VehicleProfile), <code>powertrain</code> (VirtualFCS.Powertrains.BatteryPowertrain).</p>
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

end PartialVehicleExample;
