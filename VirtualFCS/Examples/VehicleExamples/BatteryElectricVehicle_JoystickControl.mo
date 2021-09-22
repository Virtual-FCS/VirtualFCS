within VirtualFCS.Examples.VehicleExamples;

model BatteryElectricVehicle_JoystickControl
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Powertrains.BatteryPowerTrain batteryPowerTrain(C_bat_pack = 200, SOC_init = 0.9, V_max_bat_pack = 360, V_min_bat_pack = 300, V_nom_bat_pack = 320) annotation(
    Placement(visible = true, transformation(origin = {60, -3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Vehicles.VehicleProfile vehicleProfile(VN = VirtualFCS.Vehicles.VehicleProfile.vehicle_name.Mirai) annotation(
    Placement(visible = true, transformation(origin = {4.44089e-16, -7.54952e-15}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  VirtualFCS.Vehicles.JoystickDriveInput joystickDriveInput annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(vehicleProfile.pin_n, batteryPowerTrain.pin_n) annotation(
    Line(points = {{18, -10}, {42, -10}, {42, -10}, {42, -10}}, color = {0, 0, 255}));
  connect(vehicleProfile.pin_p, batteryPowerTrain.pin_p) annotation(
    Line(points = {{18, 10}, {44, 10}, {44, 10}, {42, 10}}, color = {0, 0, 255}));
  connect(joystickDriveInput.setVelocity, vehicleProfile.vehicleVelocity) annotation(
    Line(points = {{-38, 0}, {-28, 0}, {-28, 0}, {-26, 0}}, color = {0, 0, 127}));
protected
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.1));
end BatteryElectricVehicle_JoystickControl;
