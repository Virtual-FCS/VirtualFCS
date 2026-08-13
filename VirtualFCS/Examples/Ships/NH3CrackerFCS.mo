within VirtualFCS.Examples.Ships;

model NH3CrackerFCS
  // Medium
  package AmmoniaMedium = VirtualFCS.Media.NH3Cracked;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  
  // Parameters
  parameter Modelica.Units.SI.Pressure P_H2_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_NH3_tank_start = 20e5 "Initial H2 tank pressure";


  Electrochemical.Hydrogen.AmmoniaCracker.AmmoniaCracker ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium)  annotation(
    Placement(transformation(origin = {59, 57}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Vessels.ClosedVolume ammoniaTank(redeclare package Medium = AmmoniaMedium, nPorts = 1)  annotation(
    Placement(transformation(origin = {-76, 60}, extent = {{-10, -10}, {10, 10}})));
  Fluid.SimplePump ammoniaPump(redeclare package Medium = AmmoniaMedium)  annotation(
    Placement(transformation(origin = {-62, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Pipes.DynamicPipe NH3Vaporizer(use_HeatTransfer = true, redeclare package Medium = AmmoniaMedium)  annotation(
    Placement(transformation(origin = {-14, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater1 annotation(
    Placement(transformation(origin = {-28, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogen(nPorts = 1, redeclare package Medium = AmmoniaMedium)  annotation(
    Placement(transformation(origin = {84, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
equation
  connect(heater1.port, NH3Vaporizer.heatPorts[1]) annotation(
    Line(points = {{-18, 56}, {-14, 56}, {-14, 34}}, color = {191, 0, 0}));
  connect(ammoniaTank.ports[1], ammoniaPump.port_a) annotation(
    Line(points = {{-76, 50}, {-78, 50}, {-78, 22}, {-72, 22}}, color = {0, 127, 255}));
  connect(ammoniaPump.port_b, NH3Vaporizer.port_a) annotation(
    Line(points = {{-52, 30}, {-24, 30}}, color = {0, 127, 255}));
  connect(NH3Vaporizer.port_b, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{-4, 30}, {20, 30}, {20, 62}, {40, 62}}, color = {0, 127, 255}));
end NH3CrackerFCS;
