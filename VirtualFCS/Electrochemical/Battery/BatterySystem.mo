within VirtualFCS.Electrochemical.Battery;

model BatterySystem

  // Battery Pack Parameters
  parameter Real m_bat_HV(unit = "kg")= 100 "HV battery pack mass";
  parameter Real V_bat_HV(unit = "L")= 100 "HV battery pack volume";
  parameter Real Cp_bat_HV(unit = "J/(kg.K)") = 1000 "HV battery pack specific heat capacity";
  parameter Real SOC_init_HV = 0.9 "HV battery pack inital SOC";
  parameter Integer s_bat_HV = 16 "HV battery cells in series";
  parameter Integer p_bat_HV = 32 "HV battery cells in parallel";
  parameter Real cap_bat_HV(unit = "A.h") = 2.2 "HV battery cell capacity";
  parameter Real coolingArea_cell(unit = "m2") = 1 "HV battery cell cooling area";
  parameter Real Rohm_0(unit = "Ohm") = 0.02 "HV battery cell ohmic resistance";
  parameter Real R1_0(unit = "Ohm") = 0.01 "HV battery cell first RC resistance";
  parameter Real R2_0(unit = "Ohm") = 0.005 "HV battery cell second RC resistance";
  parameter Real C1_0(unit = "F") = 5000 "HV battery cell first RC capacitance";
  parameter Real C2_0(unit = "F") = 20000 "HV battery cell second RC capacitance";

  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped batteryPack(C1_0 = C1_0, C2_0 = C2_0, Cp = Cp_bat_HV, R1_0 = R1_0, R2_0 = R2_0, Rohm_0 = Rohm_0,SOC_init = SOC_init_HV, chargeCapacity_cell = cap_bat_HV, coolingArea_cell = coolingArea_cell, mass = m_bat_HV, p = p_bat_HV, s = s_bat_HV)  annotation(
    Placement(visible = true, transformation(origin = {0.369106, -30.5794}, extent = {{-24.8691, -14.9215}, {24.8691, 16.5794}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem batteryManagementSystem(p = batteryPack.p, s = batteryPack.s)  annotation(
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-30, -20}, {30, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = batteryPack.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {61, 40}, extent = {{19, -16}, {-19, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = batteryPack.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {60, 6}, extent = {{18, -16}, {-18, 16}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensorOutput annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-94, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
equation
  connect(batteryManagementSystem.pin_n_battery, batteryPack.pin_n) annotation(
    Line(points = {{-10, 12}, {-10, 12}, {-10, 0}, {-14, 0}, {-14, -16}, {-14, -16}}, color = {0, 0, 255}));
  connect(batteryManagementSystem.pin_p_battery, batteryPack.pin_p) annotation(
    Line(points = {{10, 12}, {10, 12}, {10, 0}, {16, 0}, {16, -16}, {16, -16}}, color = {0, 0, 255}));
  connect(pin_n, batteryManagementSystem.pin_n_load) annotation(
    Line(points = {{-44, 96}, {-44, 96}, {-44, 80}, {-10, 80}, {-10, 48}, {-10, 48}}, color = {0, 0, 255}));
  connect(pin_p, batteryManagementSystem.pin_p_load) annotation(
    Line(points = {{44, 96}, {44, 96}, {44, 80}, {10, 80}, {10, 48}, {10, 48}}, color = {0, 0, 255}));
  connect(batteryManagementSystem.chargeCapacity, getChargeCapacity.y) annotation(
    Line(points = {{22, 24}, {31, 24}, {31, 6}, {40, 6}}, color = {0, 0, 127}));
  connect(getSOC_init.y, batteryManagementSystem.SOC_init) annotation(
    Line(points = {{40, 40}, {32, 40}, {32, 36}, {22, 36}, {22, 36}}, color = {0, 0, 127}));
  connect(batteryPack.heatBoundary, fixedTemperature.port) annotation(
    Line(points = {{8, -44}, {8, -44}, {8, -70}, {60, -70}, {60, -70}}, color = {191, 0, 0}));
  connect(batteryManagementSystem.sensorInterface, sensorOutput) annotation(
    Line(points = {{-22, 30}, {-60, 30}, {-60, 0}, {-110, 0}, {-110, 0}}, color = {0, 0, 127}));
end BatterySystem;
