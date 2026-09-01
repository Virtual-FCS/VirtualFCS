within VirtualFCS.ComponentTesting;

model AmmoniaCrackerTest_2

  extends Modelica.Icons.Example;

  import Modelica.Media.IdealGases.SingleGases;
  
  package AmmoniaMedium = VirtualFCS.Media.NH3Cracked;
  package HydrogenMedium = SingleGases.H2;
  
  parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";
  parameter Modelica.Units.SI.Temperature T_in_degC = 550 "Inlet temperature (K)";
  parameter Modelica.Units.SI.Temperature T_in = T_in_degC + 273.15 "Inlet temperature (K)";

  Fluid.AmmoniaCracker_2 ammoniaCracker(T_in_degC = T_in_degC)  annotation(
    Placement(transformation(origin = {9, 5}, extent = {{-23, -23}, {23, 23}})));

  Modelica.Fluid.Sources.FixedBoundary cracked_gas_sink (
    redeclare package Medium = AmmoniaMedium,
    nPorts = 1, use_p = true, p = P_out, use_T = false, T = T_in) annotation(
    
    Placement(transformation(origin = {86, 10}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, use_m_flow_in = false, m_flow = 0.3, nPorts = 1, X = {0, 0, 1})  annotation(
    Placement(transformation(origin = {-68, 10}, extent = {{-10, -10}, {10, 10}})));
equation

  connect(ammoniaCracker.outlet_cracked_gas, cracked_gas_sink.ports[1]) annotation(
    Line(points = {{32, 10}, {76, 10}}, color = {0, 127, 255}));
  connect(ammoniaCracker.inlet_nh3_feed, ammonia_source.ports[1]) annotation(
    Line(points = {{-14, 10}, {-58, 10}}, color = {0, 127, 255}));
annotation(Documentation(info = "<html><p>This test feeds the ammonia cracker with 0.3 kg/s at 550 degC and evaluates the outlet at 3e5 Pa. The inlet composition is set to X = {0, 0, 1}; interpret the product stream using the connected cracked-ammonia medium.</p></html>"));
end AmmoniaCrackerTest_2;
