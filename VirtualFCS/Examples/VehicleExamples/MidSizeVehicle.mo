within VirtualFCS.Examples.VehicleExamples;

model MidSizeVehicle
  extends Modelica.Icons.Example;
  VirtualFCS.Powertrains.ParallelHybridPowerTrain parallelHybridPowerTrain(C_bat_pack = 48, SOC_init = 0.25)   annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-94, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  VirtualFCS.Vehicles.VehicleProfile vehicleProfile  annotation(
    Placement(visible = true, transformation(origin = {-2, 0}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  VirtualFCS.Vehicles.DriveCycle driveCycle(v = VirtualFCS.Vehicles.DriveCycle.speed_profile.WLTC)  annotation(
    Placement(visible = true, transformation(origin = {-59, 0}, extent = {{-10, -9}, {10, 9}}, rotation = 0)));
equation
  connect(vehicleProfile.pin_p, parallelHybridPowerTrain.pin_p) annotation(
    Line(points = {{8, 6}, {50, 6}, {50, 6}, {52, 6}}, color = {0, 0, 255}));
  connect(parallelHybridPowerTrain.pin_n, vehicleProfile.pin_n) annotation(
    Line(points = {{52, -4}, {8, -4}, {8, -6}, {8, -6}}, color = {0, 0, 255}));
  connect(driveCycle.y, vehicleProfile.vehicleVelocity) annotation(
    Line(points = {{-48, 0}, {-16, 0}, {-16, 0}, {-16, 0}}, color = {0, 0, 127}));
end MidSizeVehicle;
