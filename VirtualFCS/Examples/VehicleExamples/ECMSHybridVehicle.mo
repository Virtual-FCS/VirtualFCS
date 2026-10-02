within VirtualFCS.Examples.VehicleExamples;
model ECMSHybridVehicle
  extends RangeExtenderHybridVehicle(redeclare Powertrains.ECMSPowerTrain powertrain(SOC_init=0.95));
  
  annotation(experiment(StartTime = 0, StopTime = 10000, Tolerance = 1e-04, Interval = 1));
annotation(Documentation(info = "<html><p>This example applies the NEDC drive cycle to a Mirai-profile hybrid vehicle controlled by equivalent-consumption minimization. The battery starts at SOC = 0.95 with 50 Ah capacity, nominal voltage 320 V, and limits of 250 V to 360 V.</p></html>"));
end ECMSHybridVehicle;
