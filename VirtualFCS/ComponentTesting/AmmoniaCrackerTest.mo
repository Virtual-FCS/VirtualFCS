within VirtualFCS.ComponentTesting;

model AmmoniaCrackerTest
  import Modelica.Media.IdealGases.SingleGases;
  
  package AmmoniaMedium_CP = VirtualFCS.Media.NH3_CP;
  package CrackedNH3Medium = VirtualFCS.Media.CrackedNH3;
  package AmmoniaMedium = SingleGases.NH3;
  package HydrogenMedium = SingleGases.H2;
  
  parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";
  parameter Modelica.Units.SI.Temperature T_in_degC = 550 "Inlet temperature (K)";
  parameter Modelica.Units.SI.Temperature T_in = T_in_degC + 273.15 "Inlet temperature (K)";

  Fluid.AmmoniaCracker ammoniaCracker(T_in_degC = T_in_degC)  annotation(
    Placement(transformation(origin = {13, 5}, extent = {{-23, -23}, {23, 23}})));

  Modelica.Fluid.Sources.FixedBoundary cracked_gas_sink (
    redeclare package Medium = HydrogenMedium,
    nPorts = 1, use_p = true, p = P_out, use_T = false, T = T_in) annotation(
    
    Placement(transformation(origin = {86, 8}, extent = {{10, -10}, {-10, 10}})));
  
  
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(
  redeclare package Medium = AmmoniaMedium,
  use_m_flow_in = false,
  use_T_in = false,
  m_flow = 1,
  nPorts = 1)  annotation(
    Placement(transformation(origin = {-76, 8}, extent = {{-16, -16}, {16, 16}})));

equation
  connect(ammoniaCracker.outlet_cracked_gas, cracked_gas_sink.ports[1]) annotation(
    Line(points = {{36, 10}, {54, 10}, {54, 8}, {76, 8}}, color = {0, 127, 255}));
  connect(ammonia_source.ports[1], ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{-60, 8}, {-36, 8}, {-36, 10}, {-10, 10}}, color = {0, 127, 255}));
end AmmoniaCrackerTest;
