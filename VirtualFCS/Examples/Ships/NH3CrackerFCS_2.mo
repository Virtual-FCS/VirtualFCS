within VirtualFCS.Examples.Ships;

model NH3CrackerFCS_2
  inner Modelica.Fluid.System system;
  // Medium
  package AmmoniaMedium = VirtualFCS.Media.CrackedAmmonia;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  // Parameters
  parameter Modelica.Units.SI.Pressure P_H2_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_NH3_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Temperature T_in_degC = 550 "Inlet temperature (K)";
  parameter Modelica.Units.SI.Temperature T_in = T_in_degC + 273.15 "Inlet temperature (K)";
  parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";
  Chemical.AmmoniaCracker.AmmoniaCrackerStatic ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium, T_in_degC = T_in_degC) annotation(
    Placement(transformation(origin = {51, 57}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogenSink(nPorts = 1, redeclare package Medium = HydrogenMedium, p = P_out, T = T_in) annotation(
    Placement(transformation(origin = {52, -78}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Fluid.PSASimple psa(sep_eff = 0.9, redeclare package Medium_feed = AmmoniaMedium, redeclare package Medium_tail = AmmoniaMedium,  redeclare package Medium_product = HydrogenMedium) annotation(
    Placement(transformation(origin = {70, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = P_out, T = T_in) annotation(
    Placement(transformation(origin = {82, -80}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, X = {0.8, 0.1, 0.1}, m_flow = 0.3, nPorts = 2, use_m_flow_in = false) annotation(
    Placement(transformation(origin = {-60, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m = ammoniaCracker.N) annotation(
    Placement(transformation(origin = {51, 18.6087}, extent = {{-17, -7.3913}, {17, 7.3913}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambient(T = 293.15) annotation(
    Placement(transformation(origin = {48, -11}, extent = {{-7, -7}, {7, 7}})));


initial algorithm

print("p = " + String(ammoniaCracker.outlet_cracked_gas.p));



equation
  connect(psa.product, hydrogenSink.ports[1]) annotation(
    Line(points = {{60, -36}, {52, -36}, {52, -68}}, color = {0, 127, 255}));
  connect(psa.tail, tailSink.ports[1]) annotation(
    Line(points = {{80, -38}, {82, -38}, {82, -70}}, color = {0, 127, 255}));
  connect(ammonia_source.ports[1], ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{-50, 60}, {-50, 61}, {31, 61}}, color = {0, 127, 255}));
  connect(ammoniaCracker.outlet_cracked_gas, psa.feed) annotation(
    Line(points = {{70, 62}, {94, 62}, {94, -34}, {80, -34}}, color = {0, 127, 255}));
  connect(thermalCollector.port_b, ambient.port) annotation(
    Line(points = {{51, 11.2174}, {51, 3.7174}, {55, 3.7174}, {55, -10.7826}}, color = {191, 0, 0}));
  connect(thermalCollector.port_a, ammoniaCracker.heatPorts) annotation(
    Line(points = {{52, 26}, {52, 38}}, color = {191, 0, 0}, thickness = 0.5));
end NH3CrackerFCS_2;
