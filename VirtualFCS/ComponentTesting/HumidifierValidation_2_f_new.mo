within VirtualFCS.ComponentTesting;

model HumidifierValidation_2_f_new
extends Modelica.Icons.Example;
  replaceable package dry_medium = VirtualFCS.Media.CathodeAir;
  replaceable package wet_medium = VirtualFCS.Media.CathodeAir;
  Modelica.Fluid.Sources.MassFlowSource_T dry_air_source(redeclare package Medium = dry_medium, m_flow = 0.0004, nPorts = 1, X = {0.24, 0.76, 0}, T = 353.15) annotation(
    Placement(transformation(origin = {32, 0}, extent = {{-120, -10}, {-100, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T wet_air_source(redeclare package Medium = wet_medium, nPorts = 1, use_m_flow_in = true, use_X_in = true, T = 353.15) annotation(
    Placement(transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Fluid.Sources.FixedBoundary dry_air_sink(redeclare package Medium = dry_medium, nPorts = 1, p = 2e5) annotation(
    Placement(transformation(origin = {76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.FixedBoundary wet_air_sink(redeclare package Medium = wet_medium, nPorts = 1, p = 2e5) annotation(
    Placement(transformation(origin = {-78, -60}, extent = {{-28, -88}, {-8, -68}}, rotation = 90)));
  Fluid.Humidifier humidifier(redeclare package dry_medium = dry_medium, redeclare package wet_medium = wet_medium) annotation(
    Placement(transformation(origin = {0, -1}, extent = {{-18, -17}, {18, 17}})));
  Modelica.Blocks.Sources.Step step_m_flow(height = 0.00003, offset = 0.0004, startTime = 300)  annotation(
    Placement(transformation(origin = {48, 88}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.Step step_O2(height = -0.01656, offset = 0.24, startTime = 300)  annotation(
    Placement(transformation(origin = {-54, 88}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step_N2(height = -0.05244, offset = 0.76, startTime = 300)  annotation(
    Placement(transformation(origin = {-54, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step_H2O(height = 0.069, startTime = 300)  annotation(
    Placement(transformation(origin = {-54, 28}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(dry_air_source.ports[1], humidifier.portB_in) annotation(
    Line(points = {{-68, 0}, {-18, 0}}, color = {0, 127, 255}, thickness = 0.75));
  connect(wet_air_source.ports[1], humidifier.portA_in) annotation(
    Line(points = {{0, 30}, {0, 16}}, color = {0, 127, 255}, thickness = 0.75));
  connect(humidifier.portB_out, dry_air_sink.ports[1]) annotation(
    Line(points = {{18, 0}, {66, 0}}, color = {0, 127, 255}));
  connect(humidifier.portA_out, wet_air_sink.ports[1]) annotation(
    Line(points = {{0, -18}, {0, -68}}, color = {0, 127, 255}));
  connect(step_m_flow.y, wet_air_source.m_flow_in) annotation(
    Line(points = {{38, 88}, {8, 88}, {8, 50}}, color = {0, 0, 127}));
  connect(step_O2.y, wet_air_source.X_in[1]) annotation(
    Line(points = {{-43, 88}, {-4, 88}, {-4, 52}}, color = {0, 0, 127}));
  connect(step_N2.y, wet_air_source.X_in[2]) annotation(
    Line(points = {{-42, 58}, {-4, 58}, {-4, 52}}, color = {0, 0, 127}));
  connect(step_H2O.y, wet_air_source.X_in[3]) annotation(
    Line(points = {{-42, 28}, {-4, 28}, {-4, 52}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 400, StartTime = 0, Tolerance = 1e-06, Interval = 0.1));


end HumidifierValidation_2_f_new;
