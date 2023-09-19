within VirtualFCS.SubSystems;

model FuelCellSubSystems
  // System
  outer Modelica.Fluid.System system "System properties";
  // Medium decleration
  replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2 constrainedby Modelica.Media.Interfaces.PartialSimpleIdealGasMedium;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  // H2 Subsystem Paramters
  parameter Modelica.Units.SI.Mass m_FC_subsystems = subSystemHydrogen.m_system_H2 + subSystemAir.m_system_air + subSystemCooling.m_system_coolant + batterySystem.m_bat_pack;
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.13 "H2 tank volume";
  parameter Modelica.Units.SI.Pressure p_tank_H2 = 35000000 "H2 tank initial pressure";
  parameter Real N_FC_stack(unit = "1") = 455 "FC stack number of cells";
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
  Modelica.Fluid.Interfaces.FluidPort_a coolant_port_a(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-6, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b coolant_port_b(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {6, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Hydrogen.SubSystemHydrogen subSystemHydrogen(N_FC_stack = N_FC_stack,V_tank_H2 = V_tank_H2, p_tank_H2 = p_tank_H2)  annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-15, -10}, {15, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Air.SubSystemAir subSystemAir(N_FC_stack = N_FC_stack)  annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrochemical.Battery.BatterySystem batterySystem(C_bat_pack = 400,SOC_init = 0.9, V_max_bat_pack = 50, V_min_bat_pack = 46, V_nom_bat_pack = 48, m_bat_pack = 1) annotation(
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(contolInput[1], subSystemHydrogen.control) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, 6}, {-70, 6}}, color = {0, 0, 127}));
  connect(subSystemHydrogen.port_H2ToStack, H2_port_b) annotation(
    Line(points = {{-66, 12}, {-66, 36}, {-54, 36}, {-54, 60}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.port_StackToH2, H2_port_a) annotation(
    Line(points = {{-54, 12}, {-54, 32}, {-58, 32}, {-58, 38}, {-66, 38}, {-66, 60}}, color = {0, 127, 255}));
  connect(subSystemAir.Output, air_port_b) annotation(
    Line(points = {{54, 12}, {54, 34}, {66, 34}, {66, 60}}, color = {0, 127, 255}));
  connect(subSystemAir.Input, air_port_a) annotation(
    Line(points = {{66, 12}, {66, 30}, {62, 30}, {62, 38}, {52, 38}, {52, 60}}, color = {0, 127, 255}));
  connect(contolInput[2], subSystemCooling.controlInterface) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, 6}, {-10, 6}}, color = {0, 0, 127}));
  connect(subSystemCooling.port_b, coolant_port_b) annotation(
    Line(points = {{-6, 12}, {-6, 36}, {6, 36}, {6, 60}}, color = {0, 127, 255}));
  connect(subSystemCooling.port_a, coolant_port_a) annotation(
    Line(points = {{6, 12}, {6, 32}, {2, 32}, {2, 38}, {-6, 38}, {-6, 60}}, color = {0, 127, 255}));
  connect(batterySystem.pin_n, subSystemHydrogen.pin_n) annotation(
    Line(points = {{-4, -60}, {-4, -40}, {-62, -40}, {-62, -8}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-4, -8}, {-4, -60}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{56, -8}, {54, -8}, {54, -40}, {-4, -40}, {-4, -60}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, subSystemAir.pin_p) annotation(
    Line(points = {{4, -60}, {4, -44}, {66, -44}, {66, -8}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, subSystemCooling.pin_p) annotation(
    Line(points = {{4, -60}, {4, -35}, {6, -35}, {6, -8}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{-54, -8}, {-54, -44}, {4, -44}, {4, -60}}, color = {0, 0, 255}));
  connect(contolInput[1], subSystemAir.control) annotation(
    Line(points = {{-120, 0}, {20, 0}, {20, 6}, {50, 6}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Text(origin = {-31, -100}, lineColor = {0, 0, 255}, extent = {{-105, 8}, {167, -40}}, textString = "%name"), Rectangle(extent = {{-100, 100}, {100, -100}}), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-82, 60}, lineColor = {255, 255, 255}, extent = {{-22, 10}, {22, -10}}, textString = "H2"), Text(origin = {-2, 60}, lineColor = {255, 255, 255}, extent = {{-22, 10}, {22, -10}}, textString = "Cool"), Text(origin = {80, 60}, lineColor = {255, 255, 255}, extent = {{-22, 10}, {22, -10}}, textString = "Air")}, coordinateSystem(initialScale = 0.1)));
end FuelCellSubSystems;
