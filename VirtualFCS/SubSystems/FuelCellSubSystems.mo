within VirtualFCS.SubSystems;

model FuelCellSubSystems

  replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  // H2 Subsystem Paramters
  parameter Real V_tank_H2(unit="m3") = 0.13 "H2 tank volume";
  parameter Real p_tank_H2(unit="Pa") = 3500000 "H2 tank initial pressure";


  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen subSystemHydrogen annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-15, -10}, {15, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped liIonBatteryPack_LowVoltage(SOC_init = 0.9, p = 10, s = 6) annotation(
    Placement(visible = true, transformation(origin = {1.76023, -80.5439}, extent = {{-13.2602, -7.95614}, {13.2602, 8.84016}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init_LV(y = liIonBatteryPack_LowVoltage.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {47, -44}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {37, -92}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity_LV(y = liIonBatteryPack_LowVoltage.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {47, -60}, extent = {{13, -9}, {-13, 9}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS_LV(p = liIonBatteryPack_LowVoltage.p, s = liIonBatteryPack_LowVoltage.s) annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-15, -10}, {15, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a H2_port_a(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-66, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b H2_port_b(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-54, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput contolInput[2] annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a air_port_a(redeclare package Medium = Cathode_Medium) annotation(
    Placement(visible = true, transformation(origin = {52, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b air_port_b(redeclare package Medium = Cathode_Medium) annotation(
    Placement(visible = true, transformation(origin = {66, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Air.SubSystemAir subSystemAir annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a coolant_port_a(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-6, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b coolant_port_b(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {6, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-94, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
equation
  connect(BMS_LV.pin_n_battery, liIonBatteryPack_LowVoltage.pin_n) annotation(
    Line(points = {{-4, -58}, {-6, -58}, {-6, -72}, {-6, -72}}, color = {0, 0, 255}));
  connect(BMS_LV.pin_p_battery, liIonBatteryPack_LowVoltage.pin_p) annotation(
    Line(points = {{6, -58}, {6, -58}, {6, -68}, {10, -68}, {10, -72}, {10, -72}}, color = {0, 0, 255}));
  connect(BMS_LV.SOC_init, getSOC_init_LV.y) annotation(
    Line(points = {{12, -46}, {22, -46}, {22, -44}, {32, -44}, {32, -44}}, color = {0, 0, 127}));
  connect(getChargeCapacity_LV.y, BMS_LV.chargeCapacity) annotation(
    Line(points = {{32, -60}, {24, -60}, {24, -54}, {12, -54}, {12, -52}}, color = {0, 0, 127}));
  connect(liIonBatteryPack_LowVoltage.heatBoundary, fixedTemperature1.port) annotation(
    Line(points = {{6, -88}, {6, -88}, {6, -92}, {32, -92}, {32, -92}}, color = {191, 0, 0}));
  connect(subSystemHydrogen.pin_n, BMS_LV.pin_n_load) annotation(
    Line(points = {{-64, -10}, {-64, -10}, {-64, -30}, {-4, -30}, {-4, -40}, {-4, -40}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_p, BMS_LV.pin_p_load) annotation(
    Line(points = {{-54, -10}, {-54, -10}, {-54, -20}, {4, -20}, {4, -40}, {6, -40}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.port_H2ToStack, H2_port_a) annotation(
    Line(points = {{-66, 12}, {-66, 12}, {-66, 60}, {-66, 60}}, color = {0, 127, 255}));
  connect(H2_port_b, subSystemHydrogen.port_StackToH2) annotation(
    Line(points = {{-54, 60}, {-54, 60}, {-54, 12}, {-54, 12}}));
  connect(subSystemAir.Input, air_port_b) annotation(
    Line(points = {{66, 12}, {66, 12}, {66, 60}, {66, 60}}, color = {0, 127, 255}));
  connect(subSystemAir.Output, air_port_a) annotation(
    Line(points = {{54, 12}, {52, 12}, {52, 60}, {52, 60}}, color = {0, 127, 255}));
  connect(subSystemAir.pin_p, BMS_LV.pin_p_load) annotation(
    Line(points = {{66, -10}, {64, -10}, {64, -20}, {4, -20}, {4, -40}, {6, -40}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_n, BMS_LV.pin_n_load) annotation(
    Line(points = {{54, -10}, {54, -10}, {54, -30}, {-4, -30}, {-4, -40}, {-4, -40}}, color = {0, 0, 255}));
  connect(subSystemCooling.Output, coolant_port_a) annotation(
    Line(points = {{-6, 12}, {-8, 12}, {-8, 60}, {-6, 60}}, color = {0, 127, 255}));
  connect(subSystemCooling.Input, coolant_port_b) annotation(
    Line(points = {{6, 12}, {6, 12}, {6, 60}, {6, 60}}, color = {0, 127, 255}));
  connect(subSystemCooling.pin_n, BMS_LV.pin_n_load) annotation(
    Line(points = {{-6, -10}, {-4, -10}, {-4, -40}, {-4, -40}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_p, BMS_LV.pin_p_load) annotation(
    Line(points = {{6, -10}, {4, -10}, {4, -40}, {6, -40}}, color = {0, 0, 255}));
  connect(contolInput[1], subSystemHydrogen.control) annotation(
    Line(points = {{-120, 0}, {-80, 0}, {-80, 6}, {-70, 6}, {-70, 6}}, color = {0, 0, 127}));
  connect(contolInput[2], subSystemCooling.controlInterface) annotation(
    Line(points = {{-120, 0}, {-20, 0}, {-20, 6}, {-10, 6}, {-10, 6}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Text(origin = {-31, -100}, lineColor = {0, 0, 255}, extent = {{-105, 8}, {167, -40}}, textString = "%name"), Text(origin = {-2, 60}, extent = {{-22, 10}, {22, -10}}, textString = "Cool"), Text(origin = {80, 60}, extent = {{-22, 10}, {22, -10}}, textString = "Air"), Text(origin = {-82, 60}, extent = {{-22, 10}, {22, -10}}, textString = "H2"), Rectangle(extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)));
end FuelCellSubSystems;
