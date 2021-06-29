within VirtualFCS.Examples;

model VehicleRangeExtender "Example of a hybrid fuel cell & battery system as a range extended in an electric vehicle."
  extends Modelica.Icons.Example;
  VirtualFCS.Vehicles.VehicleProfile vehicleProfile(v = VirtualFCS.Vehicles.VehicleProfile.speed_profile.WLTC)  annotation(
    Placement(visible = true, transformation(origin = {-70, 68}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  VirtualFCS.Electrical.DC_converter dC_converter(Td = 1e-2)  annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  VirtualFCS.Control.EnergyManagementSystem EMS annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS(p = liIonBatteryPack_HighVoltage.p, s = liIonBatteryPack_HighVoltage.s)  annotation(
    Placement(visible = true, transformation(origin = {60, 70}, extent = {{-15, -10}, {15, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonBatteryPack_HighVoltage.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {95, 75}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonBatteryPack_HighVoltage.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {95, 59}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {93, 25}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen subSystemHydrogen annotation(
    Placement(visible = true, transformation(origin = {-60, 10}, extent = {{-15, -10}, {15, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Air.SubSystemAir subSystemAir annotation(
    Placement(visible = true, transformation(origin = {60, 8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init_LV(y = liIonBatteryPack_LowVoltage.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {47, -58}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS_LV(p = liIonBatteryPack_LowVoltage.p, s = liIonBatteryPack_LowVoltage.s)  annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-15, -10}, {15, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity_LV(y = liIonBatteryPack_LowVoltage.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {47, -70}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {31, -93}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getFuelCellCurrent(y = dC_converter.I_Ref) annotation(
    Placement(visible = true, transformation(origin = {-90, 15}, extent = {{-10, -7}, {10, 7}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = { -26, -24}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-94, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped liIonBatteryPack_HighVoltage(SOC_init = 0.9, p = 16, s = 32)  annotation(
    Placement(visible = true, transformation(origin = {61.6687, 36.8875}, extent = {{-15.1687, -9.10122}, {15.1687, 10.1125}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped liIonBatteryPack_LowVoltage(SOC_init = 0.9,p = 10, s = 6)  annotation(
    Placement(visible = true, transformation(origin = {1.76023, -88.5439}, extent = {{-13.2602, -7.95614}, {13.2602, 8.84016}}, rotation = 0)));
  VirtualFCS.Electrochemical.Hydrogen.FuelCellStack fuelCellStack(mass = 100)  annotation(
    Placement(visible = true, transformation(origin = {0, 6}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-38, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(BMS.sensorInterface, EMS.sensorInterface) annotation(
    Line(points = {{49, 70}, {40, 70}, {40, 40}}, color = {0, 0, 127}));
  connect(EMS.controlInterface, dC_converter.I_Ref) annotation(
    Line(points = {{22, 40}, {12, 40}, {12, 40}, {12, 40}}, color = {0, 0, 127}));
  connect(BMS.SOC_init, getSOC_init.y) annotation(
    Line(points = {{72, 74}, {82, 74}, {82, 76}, {80, 76}}, color = {0, 0, 127}));
  connect(BMS.chargeCapacity, getChargeCapacity.y) annotation(
    Line(points = {{72, 66}, {76, 66}, {76, 58}, {80, 58}, {80, 60}}, color = {0, 0, 127}));
  connect(BMS.pin_n_load, dC_converter.pin_nBus) annotation(
    Line(points = {{54, 80}, {54, 80}, {54, 82}, {-10, 82}, {-10, 50}, {-10, 50}}, color = {0, 0, 255}));
  connect(BMS.pin_p_load, dC_converter.pin_pBus) annotation(
    Line(points = {{66, 80}, {64, 80}, {64, 86}, {10, 86}, {10, 50}, {10, 50}}, color = {0, 0, 255}));
  connect(vehicleProfile.pin_n, dC_converter.pin_nBus) annotation(
    Line(points = {{-62, 66}, {-12, 66}, {-12, 50}, {-10, 50}, {-10, 50}}, color = {0, 0, 255}));
  connect(vehicleProfile.pin_p, dC_converter.pin_pBus) annotation(
    Line(points = {{-62, 70}, {8, 70}, {8, 50}, {10, 50}, {10, 50}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_n, BMS_LV.pin_n_load) annotation(
    Line(points = {{-6, -40}, {-6, -40}, {-6, -50}, {-4, -50}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_p, BMS_LV.pin_p_load) annotation(
    Line(points = {{6, -40}, {6, -40}, {6, -50}, {6, -50}}, color = {0, 0, 255}));
  connect(getFuelCellCurrent.y, subSystemHydrogen.control) annotation(
    Line(points = {{-79, 15}, {-51.5, 15}, {-51.5, 16}, {-71, 16}}, color = {0, 0, 127}));
  connect(temperatureSensor.T, subSystemCooling.controlInterface) annotation(
    Line(points = {{-20, -24}, {-12, -24}, {-12, -24}, {-10, -24}}, color = {0, 0, 127}));
  connect(subSystemHydrogen.pin_n, BMS_LV.pin_n_load) annotation(
    Line(points = {{-64, 0}, {-64, 0}, {-64, -44}, {-6, -44}, {-6, -50}, {-4, -50}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_p, BMS_LV.pin_p_load) annotation(
    Line(points = {{-54, 0}, {-52, 0}, {-52, -42}, {6, -42}, {6, -50}, {6, -50}}, color = {0, 0, 255}));
  connect(BMS.pin_n_battery, liIonBatteryPack_HighVoltage.pin_n) annotation(
    Line(points = {{56, 62}, {56, 62}, {56, 52}, {52, 52}, {52, 46}, {52, 46}}, color = {0, 0, 255}));
  connect(BMS.pin_p_battery, liIonBatteryPack_HighVoltage.pin_p) annotation(
    Line(points = {{66, 62}, {64, 62}, {64, 52}, {72, 52}, {72, 46}, {70, 46}}, color = {0, 0, 255}));
  connect(liIonBatteryPack_HighVoltage.heatBoundary, fixedTemperature.port) annotation(
    Line(points = {{66, 30}, {66, 30}, {66, 24}, {88, 24}, {88, 26}}, color = {191, 0, 0}));
  connect(BMS_LV.pin_n_battery, liIonBatteryPack_LowVoltage.pin_n) annotation(
    Line(points = {{-4, -68}, {-6, -68}, {-6, -80}, {-6, -80}}, color = {0, 0, 255}));
  connect(BMS_LV.pin_p_battery, liIonBatteryPack_LowVoltage.pin_p) annotation(
    Line(points = {{6, -68}, {6, -68}, {6, -76}, {10, -76}, {10, -80}, {10, -80}}, color = {0, 0, 255}));
  connect(fixedTemperature1.port, liIonBatteryPack_LowVoltage.heatBoundary) annotation(
    Line(points = {{26, -92}, {20, -92}, {20, -98}, {6, -98}, {6, -96}, {6, -96}}, color = {191, 0, 0}));
  connect(BMS_LV.SOC_init, getSOC_init_LV.y) annotation(
    Line(points = {{12, -56}, {32, -56}, {32, -58}, {32, -58}}, color = {0, 0, 127}));
  connect(getChargeCapacity_LV.y, BMS_LV.chargeCapacity) annotation(
    Line(points = {{32, -70}, {20, -70}, {20, -64}, {12, -64}, {12, -62}}, color = {0, 0, 127}));
  connect(subSystemAir.pin_p, BMS_LV.pin_p_load) annotation(
    Line(points = {{56, 0}, {54, 0}, {54, -44}, {6, -44}, {6, -50}, {6, -50}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_n, BMS_LV.pin_n_load) annotation(
    Line(points = {{66, 0}, {64, 0}, {64, -46}, {-6, -46}, {-6, -50}, {-4, -50}}, color = {0, 0, 255}));
  connect(dC_converter.pin_nFC, fuelCellStack.pin_n) annotation(
    Line(points = {{-10, 30}, {-6, 30}, {-6, 22}, {-6, 22}}, color = {0, 0, 255}));
  connect(dC_converter.pin_pFC, fuelCellStack.pin_p) annotation(
    Line(points = {{10, 30}, {6, 30}, {6, 22}, {6, 22}}, color = {0, 0, 255}));
  connect(fuelCellStack.port_a_Air, subSystemAir.Output) annotation(
    Line(points = {{12, 14}, {48, 14}, {48, 14}, {50, 14}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_b_Air, subSystemAir.Input) annotation(
    Line(points = {{12, -2}, {48, -2}, {48, 2}, {50, 2}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_b_H2, subSystemHydrogen.port_StackToH2) annotation(
    Line(points = {{-12, -2}, {-48, -2}, {-48, 4}, {-48, 4}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.port_H2ToStack, fuelCellStack.port_a_H2) annotation(
    Line(points = {{-48, 16}, {-10, 16}, {-10, 14}, {-12, 14}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_a_Coolant, subSystemCooling.Output) annotation(
    Line(points = {{-4, -4}, {-4, -4}, {-4, -16}, {16, -16}, {16, -26}, {12, -26}, {12, -24}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_b_Coolant, subSystemCooling.Input) annotation(
    Line(points = {{4, -4}, {4, -4}, {4, -12}, {24, -12}, {24, -36}, {12, -36}, {12, -34}}, color = {0, 127, 255}));
  connect(temperatureSensor.port, fuelCellStack.heatPort) annotation(
    Line(points = {{-32, -24}, {-38, -24}, {-38, -10}, {0, -10}, {0, -2}, {0, -2}}, color = {191, 0, 0}));
  connect(ground.p, fuelCellStack.pin_n) annotation(
    Line(points = {{-38, 48}, {-18, 48}, {-18, 20}, {-6, 20}, {-6, 22}}, color = {0, 0, 255}));
  annotation(
    Documentation(info = "<html><head></head><body>This example demonstrates the use of the VirtualFCS library to simulate the performance of a hybrid fuel cell range extender for an electric vehicle.<div><br></div><div>The model includes three power sources: a high voltage Li-ion battery pack to power the vehicle, a fuel cell stack to extend the range of the vehicle, and a low-voltage Li-ion battery pack to power the vehicle support systems.</div><div><br></div><div>The operation profiles of the two batteries are controlled using dedicated battery management systems. The division of power demand between the battery and fuel cell is achieved in the energy management system. &nbsp;</div></body></html>"));
end VehicleRangeExtender;
