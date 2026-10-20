within VirtualFCS.Chemical.AmmoniaCracker;

partial model AmmoniaCrackerInterface "Common interface for ammonia cracker models: fluid ports and a segmented heat port"
  // Define media types
  replaceable package AmmoniaMedium = Media.CrackedAmmonia;
  // Reactor discretization
  parameter Integer N = 50 "Number of reactor computational segments";
  // Define interface
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {-104, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-104, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {104, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts[N] "Segmented heat input ports" annotation(
    Placement(transformation(origin = {0, -100}, extent = {{-40, -10}, {40, 10}}), iconTransformation(origin = {0, -96}, extent = {{-40, -10}, {40, 10}})));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {215, 230, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Text(extent = {{-100, 100}, {100, 66}}, textString = "%name"), Line(origin = {-90, -0.335463}, points = {{0, 60}, {0, -60}, {0, -60}}), Line(origin = {90, -0.335463}, points = {{0, 60}, {0, -60}, {0, -60}}), Line(origin = {0.335463, 42.6579}, points = {{-90, 0}, {90, 0}}), Line(origin = {(-0 - 7), 25.2142}, points = {{-90, 0}, {90, 0}}), Line(origin = {0.335463, 7.76981}, points = {{-90, 0}, {90, 0}}), Line(origin = {0, -11.0161}, points = {{-90, 0}, {90, 0}}), Line(origin = {0, -25.1054}, points = {{-90, 0}, {90, 0}}), Line(origin = {-0.335463, -40.8723}, points = {{-90, 0}, {90, 0}}), Text(origin = {-76, -2}, extent = {{-10, 6}, {10, -6}}, textString = "NH3"), Text(origin = {80, 32}, extent = {{-10, 6}, {10, -6}}, textString = "H2"), Text(origin = {80, -34}, extent = {{-10, 6}, {10, -6}}, textString = "N2"), Line(origin = {2.44165, -1.66453}, points = {{-102.171, 0}, {67.8292, 0}, {63.8292, -2}, {67.8292, 0}, {63.8292, 2}, {67.8292, 0}}, color = {0, 0, 255}), Text(origin = {-33, -44}, extent = {{31, -12}, {-31, 0}}, textString = "NH3 Cracker"), Line(origin = {1.52604, 35.1398}, points = {{-98.1708, 0}, {67.8292, 0}, {63.8292, -2}, {67.8292, 0}, {63.8292, 2}, {67.8292, 0}}, color = {0, 0, 255}), Line(origin = {1.48653, -33.1014}, points = {{-98.1708, 0}, {67.8292, 0}, {63.8292, -2}, {67.8292, 0}, {63.8292, 2}, {67.8292, 0}}, color = {0, 0, 255}), Line(origin = {-96.4264, 0.115881}, points = {{0, 35}, {0, -31}, {0, -33}}, color = {0, 0, 255})}));
end AmmoniaCrackerInterface;
