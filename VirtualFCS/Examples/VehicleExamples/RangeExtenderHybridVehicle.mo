within VirtualFCS.Examples.VehicleExamples;

model RangeExtenderHybridVehicle
  extends Modelica.Icons.Example;
  Vehicles.DriveCycle driveCycle annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-19, -19}, {19, 19}})));
  Vehicles.VehicleProfile vehicleProfile annotation(
    Placement(transformation(extent = {{-19, -19}, {19, 19}})));
  replaceable Powertrains.RangeExtenderPowertrain rangeExtenderPowertrain(batterySystem(C_bat_pack = 10, V_max_bat_pack = 600)) annotation(
    Placement(transformation(origin = {60, 0}, extent = {{-18, -18}, {18, 18}})));
equation
  connect(driveCycle.y, vehicleProfile.vehicleVelocity) annotation(
    Line(points = {{-40, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(vehicleProfile.pin_p, rangeExtenderPowertrain.pin_p) annotation(
    Line(points = {{18, 10}, {44, 10}}, color = {0, 0, 255}));
  connect(vehicleProfile.pin_n, rangeExtenderPowertrain.pin_n) annotation(
    Line(points = {{18, -10}, {44, -10}, {44, -8}}, color = {0, 0, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 1000, Tolerance = 1e-06, Interval = 1));
end RangeExtenderHybridVehicle;
