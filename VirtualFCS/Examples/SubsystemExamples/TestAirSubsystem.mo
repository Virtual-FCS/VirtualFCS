within VirtualFCS.Examples.SubsystemExamples;

model TestAirSubsystem "Example to evaluate the performance of the air subsystem."
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable package Medium = Modelica.Media.Air.MoistAir(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {0, 76}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain(k = -0.032*1/(96485*2)) annotation(
    Placement(visible = true, transformation(origin = {-35, 81}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {1, 49}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  VirtualFCS.SubSystems.Air.SubSystemAir subSystemAir annotation(
    Placement(visible = true, transformation(origin = {-1.77636e-15, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.9, V_max_bat_pack = 27, V_min_bat_pack = 23, V_nom_bat_pack = 25, m_bat_pack = 1) annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, -70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Trapezoid trapezoid(amplitude = 750, falling = 50, period = 500, rising = 50, startTime = 100, width = 200) annotation(
    Placement(visible = true, transformation(origin = {-76, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(boundary.ports[1], teeJunctionIdeal.port_3) annotation(
    Line(points = {{0, 66}, {2, 66}, {2, 58}, {2, 58}}, color = {0, 127, 255}));
  connect(teeJunctionIdeal.port_1, subSystemAir.Output) annotation(
    Line(points = {{-8, 50}, {-14, 50}, {-14, 24}, {-12, 24}}, color = {0, 170, 255}, thickness = 1));
  connect(teeJunctionIdeal.port_2, subSystemAir.Input) annotation(
    Line(points = {{10, 50}, {12, 50}, {12, 24}, {12, 24}}, color = {0, 170, 255}, thickness = 1));
  connect(gain.y, boundary.m_flow_in) annotation(
    Line(points = {{-28, 82}, {-22, 82}, {-22, 92}, {-8, 92}, {-8, 86}, {-8, 86}}, color = {0, 0, 127}));
  connect(subSystemAir.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-10, -18}, {-10, -18}, {-10, -50}, {-8, -50}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{10, -18}, {8, -18}, {8, -50}, {8, -50}}, color = {0, 0, 255}));
  connect(trapezoid.y, gain.u) annotation(
    Line(points = {{-64, 80}, {-44, 80}, {-44, 82}}, color = {0, 0, 127}));
  connect(trapezoid.y, subSystemAir.control) annotation(
    Line(points = {{-64, 80}, {-54, 80}, {-54, 10}, {-22, 10}}, color = {0, 0, 127}));
  annotation(
    Diagram,
    Icon,
    Documentation(info = "<html><head></head><body>This example is intended as a means to evaluate the performance of the air subsystem both for optimization and troubleshooting purposes.<div><br></div><div><b style=\"font-size: 12px;\"><br></b></div><div><b style=\"font-size: 12px;\">Description</b></div><div><div style=\"font-size: 12px;\"><p class=\"MsoNormal\">The model has three parts (1) Input (includes fuel cell current and its conversion to air mass flow rate), (2)&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">Air Sub System</a> (includes Air Tank, pressure regulator, <a href=\"modelica://VirtualFCS.Fluid.Compressor\">Compressor</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\" style=\"font-size: medium;\">Throttle Valve</a>&nbsp;and <a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>), and (3) Power supply (<a href=\"modelica:///VirtualFCS.Electrochemical.Battery.BatterySystem\">Battery System</a>). The model simulates influence of fuel cell current on air flow rate.</p><p class=\"MsoNormal\"><br></p><p class=\"MsoNormal\"><b>References to base model/related packages</b></p><p class=\"MsoNormal\">&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">Air Sub System</a>&nbsp;and&nbsp;<a href=\"modelica:///VirtualFCS.Electrochemical.Battery.BatterySystem\">Battery System</a></p></div>

<p class=\"MsoNormal\"><o:p>&nbsp;</o:p></p>

<!--EndFragment--></div></body></html>"),
    experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-6, Interval = 1));
end TestAirSubsystem;
