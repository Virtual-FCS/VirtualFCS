within VirtualFCS.Examples.VehicleExamples;
model BatteryElectricVehicle
  extends PartialVehicleExample(speed(cycle="NEDC"),
                                powertrain(C_bat_pack = 200, SOC_init = 0.9, V_max_bat_pack = 360, V_min_bat_pack = 300, V_nom_bat_pack = 320));
  Modelica.Units.SI.Efficiency eta_vehicle "Vehicle efficiency";
equation
  if vehicle.useRegenerativeBraking then
    if vehicle.P > 0 then
      eta_vehicle = max(((vehicle.P) / max((vehicle.P + (powertrain.Power_del_DC_DC * (1 - (powertrain.eta_drivetrain))) + (vehicle.F_drag * vehicle.v) + (vehicle.F_accel * vehicle.v) + (vehicle.F_roll * vehicle.v) + (vehicle.P * (1 - vehicle.eff_drivetrain))), 0.00001)), 0);
    else
      eta_vehicle = max(((abs(vehicle.P)) / max(abs(vehicle.P) + (abs(powertrain.Power_del_DC_DC) * (1 - (powertrain.eta_drivetrain))) + (vehicle.F_drag * vehicle.v) + (abs(vehicle.F_accel) * vehicle.v) + (vehicle.F_roll * vehicle.v) + (abs(vehicle.P) * (1 - vehicle.eff_brake)), 0.00001)), 0);
    end if;
  else
    if vehicle.P > 0 then
      eta_vehicle = max(((vehicle.P) / max((vehicle.P + (powertrain.Power_del_DC_DC * (1 - (powertrain.eta_drivetrain))) + (vehicle.F_drag * vehicle.v) + (vehicle.F_accel * vehicle.v) + (vehicle.F_roll * vehicle.v) + (vehicle.P * (1 - vehicle.eff_drivetrain))), 0.00001)), 0);
    else
      eta_vehicle = 0;
    end if;
  end if;
  annotation(
    experiment(StartTime = 0, StopTime = 25000, Tolerance = 1e-6, Interval = 1),
    Documentation(info = "<html><head></head><body><p>This example drives the Mirai vehicle profile with the NEDC drive cycle and a battery-electric powertrain. The battery starts at SOC = 0.9 with 200 Ah capacity, nominal voltage 320 V, and operating limits of 300 V to 360 V.</p><p>Vehicle velocity from the drive cycle determines the traction power demand.</p></body></html>"));
end BatteryElectricVehicle;
