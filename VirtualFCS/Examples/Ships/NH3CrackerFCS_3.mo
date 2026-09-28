within VirtualFCS.Examples.Ships;

model NH3CrackerFCS_3
  inner Modelica.Fluid.System system;
  // Medium
  package AmmoniaMedium = Media.CrackedAmmonia;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  // Parameters
  parameter Modelica.Units.SI.Pressure P_H2_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_NH3_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_out_PSA = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Temperature T_out_target = 550 +273.15 "Target outlet temperature for ammonia cracker";
  parameter Modelica.Units.SI.Temperature T_start = T_out_target "Start temperature for ammonia cracker";
  parameter Modelica.Units.SI.Temperature T_NH3_tank = 20 + 273.15 "Start temperature for ammonia cracker";
  parameter Modelica.Units.SI.MassFraction X_start[3] = {0.998, 0.001, 0.001} "Initial mass fractions {NH3, H2, N2}";

  Chemical.AmmoniaCracker.AmmoniaCrackerStatic ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium, T_out_target = T_out_target, T_start = T_start) annotation(
    Placement(transformation(origin = {59, 57}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Pipes.DynamicPipe NH3Vaporizer(use_HeatTransfer = true, redeclare package Medium = AmmoniaMedium, length = 10, nParallel = 20, diameter = 0.1, m_flow_start = 0.3, X_start = X_start, p_a_start = P_NH3_tank_start, p_b_start = P_NH3_tank_start, T_start = T_out_target) annotation(
    Placement(transformation(origin = {-14, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater1(T_ref = 1173.15)  annotation(
    Placement(transformation(origin = {-14, 66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogenSink(nPorts = 1, redeclare package Medium = HydrogenMedium, p = P_out_PSA) annotation(
    Placement(transformation(origin = {44, -78}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Fluid.PSASimple psa(sep_eff = 0.9) annotation(
    Placement(transformation(origin = {62, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = P_out_PSA) annotation(
    Placement(transformation(origin = {74, -80}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant heat(k = 3e5) annotation(
    Placement(transformation(origin = {-37, 85}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, X = X_start, m_flow = 0.3, nPorts = 2, use_m_flow_in = false, T = T_NH3_tank) annotation(
    Placement(transformation(origin = {-74, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_in_cracker(redeclare package Medium = AmmoniaMedium)  annotation(
    Placement(transformation(origin = {24, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m = ammoniaCracker.N) annotation(
    Placement(transformation(origin = {59, 16.6087}, extent = {{-17, -7.3913}, {17, 7.3913}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambient(T = 293.15) annotation(
    Placement(transformation(origin = {56, -13}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Fluid.Sensors.Temperature temp_in_vaporizer(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {-46, 44}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(heater1.port, NH3Vaporizer.heatPorts[1]) annotation(
    Line(points = {{-4, 66}, {-4, 38}, {-13, 38}, {-13, 22}, {-14, 22}}, color = {191, 0, 0}));
  connect(NH3Vaporizer.port_b, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{-4, 18}, {20, 18}, {20, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(ammoniaCracker.outlet_cracked_gas, psa.feed) annotation(
    Line(points = {{78, 62}, {86, 62}, {86, -34}, {72, -34}}, color = {0, 127, 255}));
  connect(psa.product, hydrogenSink.ports[1]) annotation(
    Line(points = {{52, -36}, {44, -36}, {44, -68}}, color = {0, 127, 255}));
  connect(psa.tail, tailSink.ports[1]) annotation(
    Line(points = {{72, -38}, {74, -38}, {74, -70}}, color = {0, 127, 255}));
  connect(heat.y, heater1.Q_flow) annotation(
    Line(points = {{-29.3, 85}, {-23.3, 85}, {-23.3, 65}}, color = {0, 0, 127}));
  connect(ammonia_source.ports[1], NH3Vaporizer.port_a) annotation(
    Line(points = {{-64, 20}, {-24, 20}, {-24, 18}}, color = {0, 127, 255}));
  connect(temp_in_cracker.port, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{24, 74}, {24, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(thermalCollector.port_b, ambient.port) annotation(
    Line(points = {{59, 9.21739}, {59, 1.71739}, {63, 1.71739}, {63, -12.7826}}, color = {191, 0, 0}));
  connect(thermalCollector.port_a, ammoniaCracker.heatPorts) annotation(
    Line(points = {{60, 24}, {60, 38}}, color = {191, 0, 0}, thickness = 0.5));
  connect(temp_in_vaporizer.port, ammonia_source.ports[2]) annotation(
    Line(points = {{-46, 34}, {-46, 20}, {-64, 20}}, color = {0, 127, 255}));
end NH3CrackerFCS_3;
