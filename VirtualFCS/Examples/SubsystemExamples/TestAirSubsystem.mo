within VirtualFCS.Examples.SubsystemExamples;

model TestAirSubsystem "Example to evaluate the performance of the air subsystem."
  extends Modelica.Icons.Example;
  
  replaceable package Medium = Modelica.Media.Air.MoistAir;
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {0, 76}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain(k = -0.032 * 1 / (96485 * 2)) annotation(
    Placement(visible = true, transformation(origin = {-35, 81}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp setFuelCellCurrent(duration = 5, height = 50, startTime = 10) annotation(
    Placement(visible = true, transformation(origin = {-68, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {1, 49}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  VirtualFCS.SubSystems.Air.SubSystemAir subSystemAir annotation(
    Placement(visible = true, transformation(origin = {-1.77636e-15, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, -70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(setFuelCellCurrent.y, gain.u) annotation(
    Line(points = {{-56, 80}, {-44, 80}, {-44, 82}, {-44, 82}}, color = {0, 0, 127}));
  connect(boundary.ports[1], teeJunctionIdeal.port_3) annotation(
    Line(points = {{0, 66}, {2, 66}, {2, 58}, {2, 58}}, color = {0, 127, 255}));
  connect(teeJunctionIdeal.port_1, subSystemAir.Output) annotation(
    Line(points = {{-8, 50}, {-14, 50}, {-14, 24}, {-12, 24}}, color = {0, 127, 255}));
  connect(teeJunctionIdeal.port_2, subSystemAir.Input) annotation(
    Line(points = {{10, 50}, {12, 50}, {12, 24}, {12, 24}}, color = {0, 127, 255}));
  connect(gain.y, boundary.m_flow_in) annotation(
    Line(points = {{-28, 82}, {-22, 82}, {-22, 92}, {-8, 92}, {-8, 86}, {-8, 86}}, color = {0, 0, 127}));
  connect(subSystemAir.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-10, -18}, {-10, -18}, {-10, -50}, {-8, -50}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{10, -18}, {8, -18}, {8, -50}, {8, -50}}, color = {0, 0, 255}));
  annotation(
    Diagram,
    Icon,
  Documentation(info = "<html><head></head><body>This example is intended as a means to evaluate the performance of the air subsystem both for optimization and troubleshooting purposes.</body></html>"),
  experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-6, Interval = 1));
end TestAirSubsystem;
