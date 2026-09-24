within VirtualFCS.ComponentTesting;

model SubSystemAirTest_2
  extends VirtualFCS.ComponentTesting.SubSystemAirTest(redeclare SubSystems.Air.SubSystemAir_2 subSystemAir(redeclare VirtualFCS.Fluid.CompressorSimple compressor(redeclare package Medium = Medium), p_set = 2e5, redeclare VirtualFCS.Fluid.HumidifierV3 humidifier(redeclare package dry_medium = Medium, redeclare package wet_medium = Medium, UA = 0.4, n = 3, nFibers = 7000, m_flow_nom = 0.1, L_fiber = 0.3, dHousing (displayUnit = "mm")= 0.14, V_wet = 0.001, V_dry = 0.003, dFiber_i(displayUnit = "mm"), dFiber_o(displayUnit = "mm") = 0.0011, dp_nominal = 1e4)));
equation

annotation(Documentation(info = "<html><p>Test model for the air subsystem with humidification.</p></html>"));
end SubSystemAirTest_2;
