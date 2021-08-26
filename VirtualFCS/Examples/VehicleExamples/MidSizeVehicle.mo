within VirtualFCS.Examples.VehicleExamples;

model MidSizeVehicle
  extends Modelica.Icons.Example;
  VirtualFCS.Powertrains.ParallelHybridPowerTrain parallelHybridPowerTrain  annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-94, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  VirtualFCS.Vehicles.VehicleProfile vehicleProfile(v = VirtualFCS.Vehicles.VehicleProfile.speed_profile.WLTC)  annotation(
    Placement(visible = true, transformation(origin = {-52, 50}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
equation
  connect(vehicleProfile.pin_n, parallelHybridPowerTrain.pin_n) annotation(
    Line(points = {{-42, 46}, {-4, 46}, {-4, 8}, {-4, 8}}, color = {0, 0, 255}));
  connect(vehicleProfile.pin_p, parallelHybridPowerTrain.pin_p) annotation(
    Line(points = {{-42, 54}, {4, 54}, {4, 8}, {4, 8}}, color = {0, 0, 255}));
end MidSizeVehicle;
