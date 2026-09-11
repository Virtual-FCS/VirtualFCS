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
    Placement(transformation(origin = {44, -30}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Fluid.PSASimple psa(sep_eff = 0.9, redeclare package Medium_feed = AmmoniaMedium, redeclare package Medium_tail = AmmoniaMedium,  redeclare package Medium_product = HydrogenMedium) annotation(
    Placement(transformation(origin = {62, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = P_out, T = T_in) annotation(
    Placement(transformation(origin = {74, -32}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, X = {0.1, 0.1, 0.8}, m_flow = 0.3, nPorts = 2, use_m_flow_in = false) annotation(
    Placement(transformation(origin = {-60, 60}, extent = {{-10, -10}, {10, 10}})));


initial algorithm

print("p = " + String(ammoniaCracker.outlet_cracked_gas.p));



equation
  connect(psa.product, hydrogenSink.ports[1]) annotation(
    Line(points = {{52, 12}, {44, 12}, {44, -20}}, color = {0, 127, 255}));
  connect(psa.tail, tailSink.ports[1]) annotation(
    Line(points = {{72, 10}, {74, 10}, {74, -22}}, color = {0, 127, 255}));
  connect(ammonia_source.ports[1], ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{-50, 60}, {-50, 61}, {31, 61}}, color = {0, 127, 255}));
  connect(ammoniaCracker.outlet_cracked_gas, psa.feed) annotation(
    Line(points = {{70, 62}, {94, 62}, {94, 14}, {72, 14}}, color = {0, 127, 255}));
end NH3CrackerFCS_2;
