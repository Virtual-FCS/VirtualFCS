within VirtualFCS.Electrochemical.Hydrogen.AmmoniaCracker;

model AmmoniaCrackerTestOld

  extends Modelica.Icons.Example;

  import Modelica.Media.IdealGases.SingleGases;
  //package AmmoniaMedium = VirtualFCS.Media.NH3Cracked;
  package AmmoniaMedium = SingleGases.NH3;
  package HydrogenMedium = SingleGases.H2;
  
  parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";
  parameter Modelica.Units.SI.Temperature T_in_degC = 550 "Inlet temperature (K)";
  parameter Modelica.Units.SI.Temperature T_in = T_in_degC + 273.15 "Inlet temperature (K)";

  Electrochemical.Hydrogen.AmmoniaCracker.AmmoniaCrackerOld ammoniaCracker(T_in_degC = T_in_degC)  annotation(
    Placement(transformation(origin = {13, 5}, extent = {{-23, -23}, {23, 23}})));

  Modelica.Fluid.Sources.FixedBoundary cracked_gas_sink (
    redeclare package Medium = HydrogenMedium,
    nPorts = 1, use_p = true, p = P_out, use_T = false, T = T_in) annotation(
    
    Placement(transformation(origin = {86, 10}, extent = {{10, -10}, {-10, 10}})));
  
  
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(
  redeclare package Medium = AmmoniaMedium,
  use_m_flow_in = false,
  use_T_in = false,
  m_flow = 0.3,
  nPorts = 1)  annotation(
    Placement(transformation(origin = {-76, 10}, extent = {{-16, -16}, {16, 16}})));

equation
  connect(ammoniaCracker.outlet_cracked_gas, cracked_gas_sink.ports[1]) annotation(
    Line(points = {{36, 10}, {76, 10}}, color = {0, 127, 255}));
  connect(ammonia_source.ports[1], ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{-60, 10}, {-10, 10}}, color = {0, 127, 255}));
annotation(Documentation(info = "<html><p>This test feeds the ammonia cracker with a constant 0.3 kg/s ammonia stream at 550 degC and observes the outlet at 3e5 Pa. The outlet temperature is not explicitly enabled, so temperature behavior follows the component defaults.</p></html>"));
