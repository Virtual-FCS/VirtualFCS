within VirtualFCS.Examples.VehicleExamples;

model MidSizeVehicle
  extends Modelica.Icons.Example;
  VirtualFCS.Powertrains.ParallelHybridPowerTrain parallelHybridPowerTrain(SOC_init = 0.205)   annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Vehicles.VehicleProfile vehicleProfile(VN = VirtualFCS.Vehicles.VehicleProfile.vehicle_name.Mirai)   annotation(
    Placement(visible = true, transformation(origin = {0, -1}, extent = {{-21, -20}, {21, 20}}, rotation = 0)));
  VirtualFCS.Vehicles.DriveCycle driveCycle(v = VirtualFCS.Vehicles.DriveCycle.speed_profile.WLTC)  annotation(
    Placement(visible = true, transformation(origin = {-60, -3.55271e-15}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
equation
  connect(vehicleProfile.pin_p, parallelHybridPowerTrain.pin_p) annotation(
    Line(points = {{19, 9}, {32, 9}, {32, 10}, {42, 10}}, color = {0, 0, 255}));
  connect(parallelHybridPowerTrain.pin_n, vehicleProfile.pin_n) annotation(
    Line(points = {{42, -10}, {30, -10}, {30, -11}, {19, -11}}, color = {0, 0, 255}));
  connect(driveCycle.y, vehicleProfile.vehicleVelocity) annotation(
    Line(points = {{-37, 0}, {-31, 0}, {-31, -1}, {-25, -1}}, color = {0, 0, 127}));
end MidSizeVehicle;
