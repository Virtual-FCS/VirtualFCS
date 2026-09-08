within VirtualFCS.Examples.VehicleExamples;
model RangeExtenderHybridVehicle_woDeg
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Vehicles.VehicleProfile vehicleProfile(VN="Mirai",                                                 useRegenerativeBreaking = true) annotation (
    Placement(visible = true, transformation(origin={-2,0},   extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  VirtualFCS.Vehicles.DriveCycle driveCycle(v="NEDC")                                              annotation (
    Placement(visible = true, transformation(origin = {-60, -6.66134e-16}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));


  Real fuel_consumption(start = 0) "The total fuel consumption at the end of simulation";
  Modelica.Units.SI.Mass hydrogen_mass_init(start = 0) "Initial value of hydrogen mass in tank";
  Modelica.Units.SI.Efficiency eta_vehicle "Vehicle efficiency";
  Powertrains.RangeExtenderPowerTrain_woDeg rangeExtenderPowerTrain_woDeg
    annotation (Placement(transformation(extent={{34,-20},{76,22}})));
equation
  when time > 0.1 then
    hydrogen_mass_init = rangeExtenderPowerTrain_woDeg.fuelCellSystem_woDeg.fuelCellSubSystems.subSystemHydrogen.tankHydrogen.m;
  end when;
  when terminal() then
    fuel_consumption = (hydrogen_mass_init - rangeExtenderPowerTrain_woDeg.fuelCellSystem_woDeg.fuelCellSubSystems.subSystemHydrogen.tankHydrogen.m)/max((vehicleProfile.x * 0.00001), 0.01);
  end when;
  if vehicleProfile.useRegenerativeBreaking then
    if vehicleProfile.P > 0 then
      eta_vehicle = max(((vehicleProfile.P) / max((vehicleProfile.P + (rangeExtenderPowerTrain_woDeg.Power_del_DC_DC * (1 - (rangeExtenderPowerTrain_woDeg.eta_drivetrain))) + (vehicleProfile.F_drag * vehicleProfile.v) + (vehicleProfile.F_accel * vehicleProfile.v) + (vehicleProfile.F_roll * vehicleProfile.v) + (vehicleProfile.P * (1 - vehicleProfile.eff_drivetrain))), 0.00001)),0);
    else
      eta_vehicle = max(((abs(vehicleProfile.P)) / max(abs(vehicleProfile.P) + (abs(rangeExtenderPowerTrain_woDeg.Power_del_DC_DC) * (1 - (rangeExtenderPowerTrain_woDeg.eta_drivetrain))) + (vehicleProfile.F_drag * vehicleProfile.v) + (abs(vehicleProfile.F_accel) * vehicleProfile.v) + (vehicleProfile.F_roll * vehicleProfile.v) + (abs(vehicleProfile.P) * (1 - vehicleProfile.eff_brake)), 0.00001)), 0);
    end if;
  else
    if vehicleProfile.P > 0 then
      eta_vehicle = max(((vehicleProfile.P) / max((vehicleProfile.P + (rangeExtenderPowerTrain_woDeg.Power_del_DC_DC * (1 - (rangeExtenderPowerTrain_woDeg.eta_drivetrain))) + (vehicleProfile.F_drag * vehicleProfile.v) + (vehicleProfile.F_accel * vehicleProfile.v) + (vehicleProfile.F_roll * vehicleProfile.v) + (vehicleProfile.P * (1 - vehicleProfile.eff_drivetrain))), 0.00001)), 0);
    else
      eta_vehicle = 0;
    end if;
  end if;
  connect(driveCycle.y, vehicleProfile.vehicleVelocity) annotation (
    Line(points={{-36.9,0},{-27.2,0}},  color = {0, 0, 127}));
  connect(vehicleProfile.pin_p, rangeExtenderPowerTrain_woDeg.pin_p)
    annotation (Line(points={{16.9,10.5},{30,10.5},{30,11.5},{36.1,11.5}},
        color={0,0,255}));
  connect(vehicleProfile.pin_n, rangeExtenderPowerTrain_woDeg.pin_n)
    annotation (Line(points={{16.9,-10.5},{27.5,-10.5},{27.5,-9.5},{36.1,-9.5}},
        color={0,0,255}));
  annotation(experiment(StartTime = 0, StopTime = 5000, Tolerance = 1e-04, Interval = 1));
annotation(Documentation(info = "<html><p>Range-extender hybrid vehicle example without degradation modeling.</p></html>"));
end RangeExtenderHybridVehicle_woDeg;
