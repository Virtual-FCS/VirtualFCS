within VirtualFCS.Powertrains.Examples;

model RangeExtenderPowertrainTest_ECMS
    extends Powertrains.Examples.BatteryPowertrainTest(redeclare Powertrains.RangeExtenderPowertrain_ECMS powertrain(batterySystem(C_bat_pack = 50)));
equation

end RangeExtenderPowertrainTest_ECMS;
