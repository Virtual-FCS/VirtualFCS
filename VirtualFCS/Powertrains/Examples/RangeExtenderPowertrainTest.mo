within VirtualFCS.Powertrains.Examples;

model RangeExtenderPowertrainTest
  extends Powertrains.Examples.BatteryPowertrainTest(redeclare Powertrains.RangeExtenderPowertrain powerTrain(batterySystem(C_bat_pack = 50)));
equation

end RangeExtenderPowertrainTest;
