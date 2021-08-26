within VirtualFCS.Powertrains;

model ParallelHybridPowerTrain

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
  
  // Fuel Cell Stack Paramters
  parameter Real m_FC_stack(unit = "kg") = 1 "FC stack mass";
  parameter Real V_FC_stack(unit = "m3") = 0.001 "FC stack volume";
  // Thermal parameters
  parameter Real Cp_FC_stack(unit = "J/(kg.K)") = 800 "FC stack specific heat capacity";
  // Stack design parameters
  parameter Real N_FC_stack(unit = "1") = 100 "FC stack number of cells";
  parameter Real A_FC_stack(unit = "m2") = 0.0237 "FC stack active area of cell";
  // Electrochemical parameters
  parameter Real i_0_FC_stack(unit = "A") = 0.0002 "FC stack cell exchange current";
  parameter Real i_L_FC_stack(unit = "A") = 520 "FC stack cell maximum limiting current";
  parameter Real i_x_FC_stack(unit = "A") = 0.001 "FC stack cell cross-over current";
  parameter Real b_1_FC_stack(unit = "V/dec") = 0.025 "FC stack cell Tafel slope";
  parameter Real b_2_FC_stack(unit = "V/dec") = 0.25 "FC stack cell trasport limitation factor";
  parameter Real R_0_FC_stack(unit = "Ohm") = 0.02 "FC stack cell ohmic resistance";
  parameter Real R_1_FC_stack(unit = "Ohm") = 0.01 "FC stack cell charge transfer resistance";
  parameter Real C_1_FC_stack(unit = "F") = 3e-3 "FC stack cell double layer capacitance";
  
  
  // H2 Subsystem Paramters
  parameter Real V_tank_H2(unit="m3") = 0.13 "H2 tank volume";
  parameter Real p_tank_H2(unit="Pa") = 3500000 "H2 tank initial pressure";

  VirtualFCS.Electrochemical.Hydrogen.FuelCellSystem fuelCellSystem  annotation(
    Placement(visible = true, transformation(origin = {0,-30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(C1_0 = C1_0, C2_0 = C2_0, Cp_bat_HV = Cp_bat_HV, R1_0 = R1_0, R2_0 = R2_0, Rohm_0 = Rohm_0, SOC_init_HV = SOC_init_HV, V_bat_HV = V_bat_HV, cap_bat_HV = cap_bat_HV, coolingArea_cell = coolingArea_cell, m_bat_HV = m_bat_HV, p_bat_HV = p_bat_HV, s_bat_HV = s_bat_HV)   annotation(
    Placement(visible = true, transformation(origin = {70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrical.DC_converter dC_converter(Td = 1e-2) annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  VirtualFCS.Control.EnergyManagementSystem EMS annotation(
    Placement(visible = true, transformation(origin = {30, 10}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-38, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-94, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
equation
  connect(batterySystem.pin_n, dC_converter.pin_nBus) annotation(
    Line(points = {{66, 20}, {66, 20}, {66, 28}, {-10, 28}, {-10, 20}, {-10, 20}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, dC_converter.pin_pBus) annotation(
    Line(points = {{74, 20}, {74, 20}, {74, 34}, {10, 34}, {10, 20}, {10, 20}}, color = {0, 0, 255}));
  connect(EMS.controlInterface, dC_converter.I_Ref) annotation(
    Line(points = {{22, 10}, {12, 10}, {12, 10}, {12, 10}}, color = {0, 0, 127}));
  connect(EMS.sensorInterface, batterySystem.sensorOutput) annotation(
    Line(points = {{40, 10}, {58, 10}, {58, 10}, {60, 10}}, color = {0, 0, 127}));
  connect(fuelCellSystem.pin_n, dC_converter.pin_nFC) annotation(
    Line(points = {{-4, -20}, {-4, -20}, {-4, -8}, {-10, -8}, {-10, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(fuelCellSystem.pin_p, dC_converter.pin_pFC) annotation(
    Line(points = {{4, -20}, {4, -20}, {4, -8}, {10, -8}, {10, 0}, {10, 0}}, color = {0, 0, 255}));
  connect(pin_n, dC_converter.pin_nBus) annotation(
    Line(points = {{-40, 96}, {-40, 96}, {-40, 60}, {-10, 60}, {-10, 20}, {-10, 20}}, color = {0, 0, 255}));
  connect(pin_p, dC_converter.pin_pBus) annotation(
    Line(points = {{40, 96}, {40, 96}, {40, 60}, {10, 60}, {10, 20}, {10, 20}}, color = {0, 0, 255}));
  connect(ground.p, dC_converter.pin_nFC) annotation(
    Line(points = {{-38, -4}, {-10, -4}, {-10, 0}, {-10, 0}}, color = {0, 0, 255}));
end ParallelHybridPowerTrain;
