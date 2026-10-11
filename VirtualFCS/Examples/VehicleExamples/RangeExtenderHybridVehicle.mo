within VirtualFCS.Examples.VehicleExamples;

model RangeExtenderHybridVehicle
  extends BatteryElectricVehicle(redeclare Powertrains.RangeExtenderPowertrain powertrain(batterySystem(C_bat_pack = 10, V_max_bat_pack=600)));
equation
  
end RangeExtenderHybridVehicle;
