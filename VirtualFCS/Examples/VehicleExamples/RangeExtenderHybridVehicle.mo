within VirtualFCS.Examples.VehicleExamples;
model RangeExtenderHybridVehicle
  extends PartialVehicleExample(speed(cycle="NEDC"),
                                vehicle(VN = "Mirai", useRegenerativeBreaking = true),
                                redeclare Powertrains.RangeExtenderPowerTrain powertrain(C_bat_pack=50, SOC_init=0.5, V_max_bat_pack = 360, V_min_bat_pack = 250, V_nom_bat_pack = 320));

  Real fuel_consumption(start = 0) "The total fuel consumption at the end of simulation";
  Modelica.Units.SI.Mass hydrogen_mass_init(start = 0) "Initial value of hydrogen mass in tank";
  Modelica.Units.SI.Efficiency eta_vehicle "Vehicle efficiency";
equation
  when time > 0.1 then
    hydrogen_mass_init = powertrain.fuelCellSystem.subSystemHydrogen.tankHydrogen.m;
  end when;
  when terminal() then
    fuel_consumption = (hydrogen_mass_init - powertrain.fuelCellSystem.subSystemHydrogen.tankHydrogen.m)/max((vehicle.x * 0.00001), 0.01);
  end when;
  if vehicle.useRegenerativeBreaking then
    if vehicle.P > 0 then
      eta_vehicle = max(((vehicle.P) / max((vehicle.P + (powertrain.Power_del_DC_DC *(1 - (powertrain.eta_drivetrain))) + (vehicle.F_drag * vehicle.v) + (vehicle.F_accel * vehicle.v) + (vehicle.F_roll * vehicle.v) + (vehicle.P * (1 - vehicle.eff_drivetrain))), 0.00001)),0);
    else
      eta_vehicle = max(((abs(vehicle.P)) / max(abs(vehicle.P) + (abs(powertrain.Power_del_DC_DC) *(1 - (powertrain.eta_drivetrain))) + (vehicle.F_drag * vehicle.v) + (abs(vehicle.F_accel) * vehicle.v) + (vehicle.F_roll * vehicle.v) + (abs(vehicle.P) * (1 - vehicle.eff_brake)), 0.00001)), 0);
    end if;
  else
    if vehicle.P > 0 then
      eta_vehicle = max(((vehicle.P) / max((vehicle.P + (powertrain.Power_del_DC_DC *(1 - (powertrain.eta_drivetrain))) + (vehicle.F_drag * vehicle.v) + (vehicle.F_accel * vehicle.v) + (vehicle.F_roll * vehicle.v) + (vehicle.P * (1 - vehicle.eff_drivetrain))), 0.00001)), 0);
    else
      eta_vehicle = 0;
    end if;
  end if;
  annotation(experiment(StartTime = 0, StopTime = 10000, Tolerance = 1e-04, Interval = 1));
annotation(Documentation(info = "<html><p>This example applies the NEDC drive cycle to a Mirai-vehicle range-extender vehicle. A battery starting at SOC = 0.5 (50 Ah, 320 V nominal, 250 V to 360 V limits) supplies the drive while the fuel-cell generator extends the operating range.</p></html>"));
end RangeExtenderHybridVehicle;
