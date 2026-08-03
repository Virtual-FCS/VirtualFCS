within VirtualFCS.ComponentTesting;

model SubSystemAir_humidifierTest
  extends VirtualFCS.ComponentTesting.SubSystemAirTest(redeclare SubSystems.Air.SubSystemAir_humidifier subSystemAir(redeclare VirtualFCS.Fluid.CompressorSimple compressor(redeclare package Medium = Medium)));
equation

end SubSystemAir_humidifierTest;
