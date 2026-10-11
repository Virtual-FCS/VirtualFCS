within VirtualFCS.Examples.VehicleExamples;
model BatteryElectricVehicle
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable VirtualFCS.Vehicles.DriveCycle driveCycle annotation (
    Placement(visible = true, transformation(origin = {-60, -3.55271e-15}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  replaceable VirtualFCS.Powertrains.BatteryPowertrain powertrain annotation (
    Placement(visible = true, transformation(origin = {60, -3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Vehicles.VehicleProfile vehicleProfile annotation (
    Placement(visible = true, transformation(origin = {4.44089e-16, -7.54952e-15}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
equation
  connect(vehicleProfile.pin_n, powertrain.pin_n) annotation (
    Line(points = {{18, -10}, {42, -10}, {42, -10}, {42, -10}}, color = {0, 0, 255}));
  connect(vehicleProfile.pin_p, powertrain.pin_p) annotation (
    Line(points = {{18, 10}, {44, 10}, {44, 10}, {42, 10}}, color = {0, 0, 255}));
  connect(driveCycle.y, vehicleProfile.vehicleVelocity) annotation (
    Line(points = {{-36, 0}, {-28, 0}, {-28, 0}, {-26, 0}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 10000, Tolerance = 1e-06, Interval = 1),
    Documentation(info = "<html><p>This example drives the Mirai vehicle profile with the NEDC drive cycle and a battery-electric powertrain. The battery starts at SOC = 0.9 with 200 Ah capacity, nominal voltage 320 V, and operating limits of 300 V to 360 V.</p><p>Vehicle velocity from the drive cycle determines the traction power demand.</p></html>"));
end BatteryElectricVehicle;
