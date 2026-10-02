within VirtualFCS.Examples.VehicleExamples;

partial model PartialVehicleExample
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  replaceable VirtualFCS.Vehicles.DriveCycle speed constrainedby Modelica.Blocks.Interfaces.SO annotation (
    Placement(transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}})));
  Vehicles.VehicleProfile vehicle annotation (
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}})));
  replaceable VirtualFCS.Powertrains.BatteryPowerTrain powertrain annotation (
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation  
  connect(vehicle.pin_n, powertrain.pin_n) annotation (
    Line(points = {{18, -10}, {42, -10}, {42, -10}, {42, -10}}, color = {0, 0, 255}));
  connect(vehicle.pin_p, powertrain.pin_p) annotation (
    Line(points = {{18, 10}, {44, 10}, {44, 10}, {42, 10}}, color = {0, 0, 255}));
  connect(speed.y, vehicle.vehicleVelocity) annotation (
    Line(points = {{-36, 0}, {-28, 0}, {-28, 0}, {-26, 0}}, color = {0, 0, 127}));
annotation(Documentation(info = "<html><head></head><body><p>This is a generic setup for vehicle tests with any powertrain.</p><p>Signal source, vehicle and powertrain can be replaced in child classes.</p></body></html>"));

end PartialVehicleExample;
