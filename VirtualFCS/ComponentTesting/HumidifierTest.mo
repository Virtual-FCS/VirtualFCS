within VirtualFCS.ComponentTesting;

model HumidifierTest "Pollak humidifier test case using the volume model"
  extends Modelica.Icons.Example;
  replaceable package dry_medium = VirtualFCS.Media.MoistAir;
  replaceable package wet_medium = VirtualFCS.Media.MoistAir;
  Modelica.Fluid.Sources.MassFlowSource_T dry_air_source(redeclare package Medium = dry_medium, m_flow = 0.0004, nPorts = 2, X = {0.24, 0.76, 0}, T = 353.15) annotation(
    Placement(transformation(origin = {32, -10}, extent = {{-120, -10}, {-100, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T wet_air_source(redeclare package Medium = wet_medium, nPorts = 1, use_m_flow_in = true, use_X_in = true, T = 353.15) annotation(
    Placement(transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Fluid.Sources.FixedBoundary dry_air_sink(redeclare package Medium = dry_medium, nPorts = 1, p = 2e5) annotation(
    Placement(transformation(origin = {76, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.FixedBoundary wet_air_sink(redeclare package Medium = wet_medium, nPorts = 1, p = 2e5) annotation(
    Placement(transformation(origin = {-78, -70}, extent = {{-28, -88}, {-8, -68}}, rotation = 90)));
  Modelica.Blocks.Sources.Step step_m_flow(height = 0.00003, offset = 0.0004, startTime = 300) annotation(
    Placement(transformation(origin = {48, 88}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.Step step_O2(height = -0.01656, offset = 0.24, startTime = 300) annotation(
    Placement(transformation(origin = {-54, 88}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step_N2(height = -0.05244, offset = 0.76, startTime = 300) annotation(
    Placement(transformation(origin = {-54, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step_H2O(height = 0.069, startTime = 300) annotation(
    Placement(transformation(origin = {-54, 28}, extent = {{-10, -10}, {10, 10}})));
  Fluid.RelativeHumiditySensor sensorDrySink(redeclare package Medium = dry_medium) annotation(
    Placement(transformation(origin = {40, 26}, extent = {{-10, -10}, {10, 10}})));
  VirtualFCS.Fluid.RelativeHumiditySensor sensorWetSink(redeclare package Medium = wet_medium) annotation(
    Placement(transformation(origin = {34, -56}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  VirtualFCS.Fluid.RelativeHumiditySensor sensorDrySource(redeclare package Medium = dry_medium) annotation(
    Placement(transformation(origin = {-60, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Fluid.RelativeHumiditySensor sensorWetSource(redeclare package Medium = wet_medium) annotation(
    Placement(transformation(origin = {-26, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Fluid.Humidifier humidifier(redeclare package dry_medium = dry_medium, redeclare package wet_medium = wet_medium, n = 5, wet_p_start = 2e5, dry_p_start = 2e5, wet_T_start = 353.15, dry_T_start = 353.15, wet_X_start = {0.24, 0.76, 0}, dry_X_start = {0.24, 0.76, 0}, V_wet = 0.0000468, V_dry = 0.000005, UA = 0.4, dp_nominal = 1e4) annotation(
    Placement(transformation(origin = {0, -10}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(step_m_flow.y, wet_air_source.m_flow_in) annotation(
    Line(points = {{38, 88}, {8, 88}, {8, 50}}, color = {0, 0, 127}));
  connect(step_O2.y, wet_air_source.X_in[1]) annotation(
    Line(points = {{-43, 88}, {-4, 88}, {-4, 52}}, color = {0, 0, 127}));
  connect(step_N2.y, wet_air_source.X_in[2]) annotation(
    Line(points = {{-42, 58}, {-4, 58}, {-4, 52}}, color = {0, 0, 127}));
  connect(step_H2O.y, wet_air_source.X_in[3]) annotation(
    Line(points = {{-42, 28}, {-4, 28}, {-4, 52}}, color = {0, 0, 127}));
  connect(wet_air_source.ports[1], humidifier.portA_in) annotation(
    Line(points = {{0, 30}, {0, 2}}, color = {0, 127, 255}));
  connect(dry_air_source.ports[2], humidifier.portB_in) annotation(
    Line(points = {{-68, -10}, {-20, -10}}, color = {0, 127, 255}));
  connect(humidifier.portA_out, wet_air_sink.ports[1]) annotation(
    Line(points = {{0, -22}, {0, -78}}, color = {0, 127, 255}));
  connect(humidifier.portB_out, dry_air_sink.ports[1]) annotation(
    Line(points = {{20, -10}, {66, -10}}, color = {0, 127, 255}));
  connect(sensorDrySource.port, humidifier.portB_in) annotation(
    Line(points = {{-60, -36}, {-20, -36}, {-20, -10}}, color = {0, 127, 255}));
  connect(sensorWetSource.port, humidifier.portA_in) annotation(
    Line(points = {{-16, 16}, {0, 16}, {0, 2}}, color = {0, 127, 255}));
  connect(sensorDrySink.port, humidifier.portB_out) annotation(
    Line(points = {{40, 16}, {20, 16}, {20, -10}}, color = {0, 127, 255}));
  connect(sensorWetSink.port, humidifier.portA_out) annotation(
    Line(points = {{24, -56}, {0, -56}, {0, -22}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 400, StartTime = 0, Tolerance = 1e-06, Interval = 0.1),
    Diagram,
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Pollak humidifier test case using the volume model.</p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end HumidifierTest;
