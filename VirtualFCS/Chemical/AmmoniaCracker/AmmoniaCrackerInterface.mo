within VirtualFCS.Chemical.AmmoniaCracker;

partial model AmmoniaCrackerInterface "Common interface for ammonia cracker models: fluid ports and a segmented heat port"
  // Define media types
  replaceable package AmmoniaMedium = Media.CrackedAmmonia;
  // Reactor discretization
  parameter Integer N = 50 "Number of reactor computational segments";
  // Define interface
  Modelica.Fluid.Interfaces.FluidPort_a inlet_nh3_feed(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {-104, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-104, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b outlet_cracked_gas(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {104, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPorts[N] "Segmented heat input ports" annotation(
    Placement(transformation(origin = {0, -100}, extent = {{-40, -10}, {40, 10}}), iconTransformation(origin = {0, -100}, extent = {{-40, -10}, {40, 10}})));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {215, 230, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Text(extent = {{-100, 100}, {100, 66}}, textString = "%name")}));
end AmmoniaCrackerInterface;
