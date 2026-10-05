within VirtualFCS.Examples.VehicleExamples;

model RangeExtenderHybridVehicle_ECMS
  extends BatteryElectricVehicle(redeclare Powertrains.RangeExtenderPowertrain_ECMS powertrain(batterySystem(C_bat_pack = 10, V_max_bat_pack=600)));

equation

end RangeExtenderHybridVehicle_ECMS;
