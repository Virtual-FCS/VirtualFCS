within VirtualFCS.Examples.VehicleExamples;

model BatteryElectricVehicle
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Vehicles.DriveCycle driveCycle(v = VirtualFCS.Vehicles.DriveCycle.speed_profile.NEDC) annotation(
    Placement(visible = true, transformation(origin = {-60, -3.55271e-15}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  VirtualFCS.Powertrains.BatteryPowerTrain batteryPowerTrain(C_bat_pack = 200, SOC_init = 0.9, V_max_bat_pack = 360, V_min_bat_pack = 300, V_nom_bat_pack = 320) annotation(
    Placement(visible = true, transformation(origin = {60, -3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Vehicles.VehicleProfile vehicleProfile(VN = VirtualFCS.Vehicles.VehicleProfile.vehicle_name.Mirai) annotation(
    Placement(visible = true, transformation(origin = {4.44089e-16, -7.54952e-15}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Modelica.Units.SI.Efficiency eta_vehicle "Vehicle efficiency";
equation
  if vehicleProfile.useRegenerativeBreaking then
    if vehicleProfile.P > 0 then
      eta_vehicle = max(((vehicleProfile.P) / max((vehicleProfile.P + (batteryPowerTrain.Power_del_DC_DC * (1 - (batteryPowerTrain.eta_drivetrain))) + (vehicleProfile.F_drag * vehicleProfile.v) + (vehicleProfile.F_accel * vehicleProfile.v) + (vehicleProfile.F_roll * vehicleProfile.v) + (vehicleProfile.P * (1 - vehicleProfile.eff_drivetrain))), 0.00001)), 0);
    else
      eta_vehicle = max(((abs(vehicleProfile.P)) / max(abs(vehicleProfile.P) + (abs(batteryPowerTrain.Power_del_DC_DC) * (1 - (batteryPowerTrain.eta_drivetrain))) + (vehicleProfile.F_drag * vehicleProfile.v) + (abs(vehicleProfile.F_accel) * vehicleProfile.v) + (vehicleProfile.F_roll * vehicleProfile.v) + (abs(vehicleProfile.P) * (1 - vehicleProfile.eff_brake)), 0.00001)), 0);
    end if;
  else
    if vehicleProfile.P > 0 then
      eta_vehicle = max(((vehicleProfile.P) / max((vehicleProfile.P + (batteryPowerTrain.Power_del_DC_DC * (1 - (batteryPowerTrain.eta_drivetrain))) + (vehicleProfile.F_drag * vehicleProfile.v) + (vehicleProfile.F_accel * vehicleProfile.v) + (vehicleProfile.F_roll * vehicleProfile.v) + (vehicleProfile.P * (1 - vehicleProfile.eff_drivetrain))), 0.00001)), 0);
    else
      eta_vehicle = 0;
    end if;
  end if;
  connect(vehicleProfile.pin_n, batteryPowerTrain.pin_n) annotation(
    Line(points = {{18, -10}, {42, -10}, {42, -10}, {42, -10}}, color = {0, 0, 255}));
  connect(vehicleProfile.pin_p, batteryPowerTrain.pin_p) annotation(
    Line(points = {{18, 10}, {44, 10}, {44, 10}, {42, 10}}, color = {0, 0, 255}));
  connect(driveCycle.y, vehicleProfile.vehicleVelocity) annotation(
    Line(points = {{-36, 0}, {-28, 0}, {-28, 0}, {-26, 0}}, color = {0, 0, 127}));
protected
  annotation(
    experiment(StartTime = 0, StopTime = 25000, Tolerance = 1e-6, Interval = 1));
end BatteryElectricVehicle;
