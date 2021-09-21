within VirtualFCS.Examples.SubsystemExamples;

model TestHydrogenSubsystem "Example to evaluate the performance of the hydrogen subsystem."
  extends Modelica.Icons.Example;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Anode_Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {0, 72}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen subSystemHydrogen annotation(
    Placement(visible = true, transformation(origin = {-0.999964, -0.666637}, extent = {{-30, -20}, {30, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -0.00202 * 1 / (96485 * 2)) annotation(
    Placement(visible = true, transformation(origin = {-34, 80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp setFuelCellCurrent(duration = 50, height = 50, startTime = 100) annotation(
    Placement(visible = true, transformation(origin = {-74, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(V_max_bat_pack = 54, V_min_bat_pack = 40, V_nom_bat_pack = 48) annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(setFuelCellCurrent.y, gain.u) annotation(
    Line(points = {{-63, 80}, {-44, 80}}, color = {0, 0, 127}));
  connect(setFuelCellCurrent.y, subSystemHydrogen.control) annotation(
    Line(points = {{-63, 80}, {-54, 80}, {-54, 11}, {-23, 11}}, color = {0, 0, 127}));
  connect(boundary.ports[1], teeJunctionIdeal.port_3) annotation(
    Line(points = {{0, 62}, {0, 62}, {0, 50}, {0, 50}}, color = {0, 127, 255}));
  connect(teeJunctionIdeal.port_1, subSystemHydrogen.port_H2ToStack) annotation(
    Line(points = {{-10, 40}, {-14, 40}, {-14, 22}, {-12, 22}}, color = {0, 127, 255}));
  connect(teeJunctionIdeal.port_2, subSystemHydrogen.port_StackToH2) annotation(
    Line(points = {{10, 40}, {12, 40}, {12, 24}, {12, 24}}, color = {0, 127, 255}));
  connect(gain.y, boundary.m_flow_in) annotation(
    Line(points = {{-26, 80}, {-20, 80}, {-20, 92}, {-8, 92}, {-8, 82}, {-8, 82}}, color = {0, 0, 127}));
  connect(subSystemHydrogen.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-6, -18}, {-8, -18}, {-8, -40}, {-8, -40}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{10, -18}, {8, -18}, {8, -40}, {8, -40}}, color = {0, 0, 255}));
  annotation(
    Diagram,
    Icon,
    Documentation(info = "<html><head></head><body>This example is intended as a means to evaluate the performance of the hydrogen subsystem both for optimization and troubleshooting purposes.</body></html>"),
    experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-06, Interval = 1));
end TestHydrogenSubsystem;
