within VirtualFCS.Examples.VehicleExamples;

model RangeExtenderHybridVehicle
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Powertrains.RangeExtenderPowerTrain rangeExtenderPowerTrain(C_bat_pack = 200, I_rated_FC_stack = 353, N_FC_stack = 1000, SOC_init = 0.5, V_max_bat_pack = 400, V_min_bat_pack = 360, V_nom_bat_pack = 380, V_rated_FC_stack = 643, m_FC_stack = 250) annotation(
    Placement(visible = true, transformation(origin = {60, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  VirtualFCS.Vehicles.VehicleProfile vehicleProfile(A_front = 8, C_D = 0.35, VN = VirtualFCS.Vehicles.VehicleProfile.vehicle_name.UserDefined) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  VirtualFCS.Vehicles.DriveCycle driveCycle(v = VirtualFCS.Vehicles.DriveCycle.speed_profile.NEDC) annotation(
    Placement(visible = true, transformation(origin = {-60, 1}, extent = {{-21, -20}, {21, 20}}, rotation = 0)));
equation
  connect(driveCycle.y, vehicleProfile.vehicleVelocity) annotation(
    Line(points = {{-36, 2}, {-26, 2}, {-26, 0}, {-26, 0}}, color = {0, 0, 127}));
  connect(vehicleProfile.pin_p, rangeExtenderPowerTrain.pin_p) annotation(
    Line(points = {{18, 10}, {42, 10}, {42, 10}, {42, 10}}, color = {0, 0, 255}));
  connect(vehicleProfile.pin_n, rangeExtenderPowerTrain.pin_n) annotation(
    Line(points = {{18, -10}, {42, -10}, {42, -10}, {42, -10}}, color = {0, 0, 255}));
protected
  annotation(
    experiment(StartTime = 0, StopTime = 25000, Tolerance = 1e-06, Interval = 1));
end RangeExtenderHybridVehicle;
