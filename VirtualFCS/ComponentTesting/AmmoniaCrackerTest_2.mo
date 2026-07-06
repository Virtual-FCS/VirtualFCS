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
  Modelica.Media.Examples.Utilities.FixedMassFlowRate ammonia_source(redeclare package Medium = AmmoniaMedium, m_flow = 0.3, X_ambient = {0.01, 0.01, 0.98})  annotation(
    Placement(transformation(origin = {-72, 10}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(ammoniaCracker.outlet_cracked_gas, cracked_gas_sink.ports[1]) annotation(
    Line(points = {{32, 10}, {76, 10}}, color = {0, 127, 255}));
end AmmoniaCrackerTest_2;
