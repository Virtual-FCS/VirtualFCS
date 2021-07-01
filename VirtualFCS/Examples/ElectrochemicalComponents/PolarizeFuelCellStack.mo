within VirtualFCS.Examples.ElectrochemicalComponents;

model PolarizeFuelCellStack "Generate a polarization curve for a fuel cell stack."
  extends Modelica.Icons.Example;
  
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  
  VirtualFCS.SubSystems.Air.SubSystemAir subSystemAir annotation(
    Placement(visible = true, transformation(origin = {70, 30}, extent = {{13, -13}, {-13, 13}}, rotation = 0)));
  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen subSystemHydrogen annotation(
    Placement(visible = true, transformation(origin = {-60, 30}, extent = {{-18, -12}, {18, 12}}, rotation = 0)));
  VirtualFCS.SubSystems.Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(visible = true, transformation(origin = {1.77636e-15, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-79, -79}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Control.BatteryManagementSystem BMS_LV(p = liIonBatteryPack_LowVoltage.p, s = liIonBatteryPack_LowVoltage.s) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-15, -10}, {15, 10}}, rotation = 0)));
  Electrochemical.Battery.LiIonBatteryPack_Lumped liIonBatteryPack_LowVoltage(p = 10, s = 6) annotation(
    Placement(visible = true, transformation(origin = {1.76023, -88.5439}, extent = {{-13.2602, -7.95614}, {13.2602, 8.84016}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {31, -93}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity_LV(y = liIonBatteryPack_LowVoltage.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {47, -69}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init_LV(y = liIonBatteryPack_LowVoltage.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {47, -53}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  VirtualFCS.Electrochemical.Hydrogen.FuelCellStack fuelCellStack2(mass = 55)  annotation(
    Placement(visible = true, transformation(origin = {-1, 29}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = {-29, -5}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.RampCurrent rampCurrent(I = 500, duration = 500)  annotation(
    Placement(visible = true, transformation(origin = {0, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-50, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {-20, 70}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
equation
  connect(BMS_LV.SOC_init, getSOC_init_LV.y) annotation(
    Line(points = {{12, -56}, {22, -56}, {22, -52}, {32, -52}, {32, -52}}, color = {0, 0, 127}));
  connect(BMS_LV.chargeCapacity, getChargeCapacity_LV.y) annotation(
    Line(points = {{12, -62}, {22, -62}, {22, -68}, {32, -68}, {32, -68}}, color = {0, 0, 127}));
  connect(fixedTemperature1.port, liIonBatteryPack_LowVoltage.heatBoundary) annotation(
    Line(points = {{26, -92}, {18, -92}, {18, -100}, {6, -100}, {6, -96}, {6, -96}}, color = {191, 0, 0}));
  connect(BMS_LV.pin_n_battery, liIonBatteryPack_LowVoltage.pin_n) annotation(
    Line(points = {{-4, -68}, {-6, -68}, {-6, -80}, {-6, -80}}, color = {0, 0, 255}));
  connect(BMS_LV.pin_p_battery, liIonBatteryPack_LowVoltage.pin_p) annotation(
    Line(points = {{6, -68}, {10, -68}, {10, -80}, {10, -80}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_n, BMS_LV.pin_n_load) annotation(
    Line(points = {{-4, -18}, {-6, -18}, {-6, -50}, {-4, -50}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_p, BMS_LV.pin_p_load) annotation(
    Line(points = {{6, -18}, {4, -18}, {4, -50}, {6, -50}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_p, BMS_LV.pin_p_load) annotation(
    Line(points = {{64, 18}, {64, 18}, {64, -34}, {4, -34}, {4, -50}, {6, -50}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_n, BMS_LV.pin_n_load) annotation(
    Line(points = {{-64, 20}, {-64, 20}, {-64, -48}, {-6, -48}, {-6, -50}, {-4, -50}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_p, BMS_LV.pin_p_load) annotation(
    Line(points = {{-54, 20}, {-54, 20}, {-54, -30}, {4, -30}, {4, -50}, {6, -50}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_n, BMS_LV.pin_n_load) annotation(
    Line(points = {{76, 18}, {76, 18}, {76, -40}, {-6, -40}, {-6, -50}, {-4, -50}}, color = {0, 0, 255}));
  connect(fuelCellStack2.port_a_Air, subSystemAir.Output) annotation(
    Line(points = {{16, 40}, {56, 40}, {56, 38}, {56, 38}}, color = {0, 127, 255}));
  connect(fuelCellStack2.port_b_Air, subSystemAir.Input) annotation(
    Line(points = {{16, 18}, {56, 18}, {56, 22}, {56, 22}}, color = {0, 127, 255}));
  connect(fuelCellStack2.port_b_Coolant, subSystemCooling.Output) annotation(
    Line(points = {{4, 14}, {4, 14}, {4, 4}, {14, 4}, {14, -6}, {12, -6}, {12, -4}}, color = {0, 127, 255}));
  connect(fuelCellStack2.port_a_Coolant, subSystemCooling.Input) annotation(
    Line(points = {{-6, 14}, {-6, 14}, {-6, 8}, {20, 8}, {20, -16}, {12, -16}, {12, -14}}));
  connect(subSystemHydrogen.port_StackToH2, fuelCellStack2.port_b_H2) annotation(
    Line(points = {{-46, 24}, {-20, 24}, {-20, 18}, {-18, 18}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.port_H2ToStack, fuelCellStack2.port_a_H2) annotation(
    Line(points = {{-46, 38}, {-18, 38}, {-18, 40}, {-18, 40}}, color = {0, 127, 255}));
  connect(temperatureSensor.T, subSystemCooling.controlInterface) annotation(
    Line(points = {{-22, -4}, {-12, -4}, {-12, -4}, {-10, -4}}, color = {0, 0, 127}));
  connect(fixedTemperature1.port, temperatureSensor.port) annotation(
    Line(points = {{26, -92}, {-36, -92}, {-36, -4}, {-36, -4}}, color = {191, 0, 0}));
  connect(rampCurrent.p, fuelCellStack2.pin_p) annotation(
    Line(points = {{10, 90}, {22, 90}, {22, 52}, {8, 52}, {8, 54}}, color = {0, 0, 255}));
  connect(ground.p, rampCurrent.n) annotation(
    Line(points = {{-50, 92}, {-10, 92}, {-10, 90}, {-10, 90}}, color = {0, 0, 255}));
  connect(rampCurrent.n, currentSensor.p) annotation(
    Line(points = {{-10, 90}, {-20, 90}, {-20, 76}, {-20, 76}}, color = {0, 0, 255}));
  connect(currentSensor.n, fuelCellStack2.pin_n) annotation(
    Line(points = {{-20, 64}, {-20, 64}, {-20, 52}, {-10, 52}, {-10, 54}}, color = {0, 0, 255}));
  connect(currentSensor.i, subSystemHydrogen.control) annotation(
    Line(points = {{-26, 70}, {-88, 70}, {-88, 38}, {-74, 38}, {-74, 38}}, color = {0, 0, 127}));
  annotation(
    Diagram,
    Icon,
  Documentation(info = "<html><head></head><body>This example demonstrates the setup for a fuel cell system to generate a polarization curve. The fuel cell stack is connected to subsystems for hydrogen, air, and cooling. The electrical load is provided by a ramp voltage source that sweeps the current domain over a period of 500 seconds.&nbsp;</body></html>"),
  experiment(StartTime = 0, StopTime = 500, Tolerance = 1e-6, Interval = 1));
end PolarizeFuelCellStack;