within VirtualFCS.Fluid.Examples;

model SeparatorTest
  extends Modelica.Icons.Example;
  Separator separator(useHeatPort = true, redeclare package Medium = VirtualFCS.Media.MoistAir) annotation(
    Placement(transformation(origin = {-20, -4}, extent = {{-30, -30}, {30, 30}})));
  Modelica.Fluid.Sources.MassFlowSource_T source(nPorts = 1, redeclare package Medium = VirtualFCS.Media.MoistAir, use_T_in = false, m_flow = 1, T = 353.15, X = {0.1, 0.4, 0.5}, use_X_in = true) annotation(
    Placement(transformation(origin = {-60, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.Boundary_pT sink(nPorts = 2, redeclare package Medium = VirtualFCS.Media.MoistAir) annotation(
    Placement(transformation(origin = {90, 0}, extent = {{10, -10}, {-10, 10}})));
  inner Modelica.Fluid.System system(T_start = 300, m_flow_start = 0, p_start = 101325) annotation(
    Placement(transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Valves.ValveIncompressible valve_liq(redeclare package Medium = VirtualFCS.Media.MoistAir, dp_nominal = 1e5, m_flow_nominal = 1, opening_nominal = 0.5) annotation(
    Placement(transformation(origin = {40, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Valves.ValveCompressible valve_gas(redeclare package Medium = VirtualFCS.Media.MoistAir, dp_nominal = 1e5, m_flow_nominal = 1, p_nominal = 2e5, opening_nominal = 0.5) annotation(
    Placement(transformation(origin = {50, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID_level(controllerType = Modelica.Blocks.Types.SimpleController.PI, yMax = 1, yMin = 0) annotation(
    Placement(transformation(origin = {40, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID_pressure(controllerType = Modelica.Blocks.Types.SimpleController.PI, yMax = 1, yMin = 0, k = 1e-4) annotation(
    Placement(transformation(origin = {30, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant pressure_reference(k = 200000) annotation(
    Placement(transformation(origin = {-60, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant level_reference(k = 0.25) annotation(
    Placement(transformation(origin = {20, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable cut_water(smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, table = [0, 0.1, 0.4, 0.5; 1, 0.2, 0.8, 0.0]) annotation(
    Placement(transformation(origin = {-90, -8}, extent = {{-10, -10}, {10, 10}})));
equation
//source.X_in = if time < 1 then {0.1, 0.4, 0.5} else {0.2, 0.8, 0.0};
  connect(source.ports[1], separator.port_mid) annotation(
    Line(points = {{-50, -4}, {-38, -4}}, color = {0, 127, 255}));
  connect(separator.port_top, valve_gas.port_a) annotation(
    Line(points = {{-5, 23}, {-5, 36}, {40, 36}}, color = {0, 127, 255}));
  connect(valve_liq.port_b, sink.ports[1]) annotation(
    Line(points = {{50, -80}, {70, -80}, {70, 0}, {80, 0}}, color = {0, 127, 255}));
  connect(separator.port_bottom, valve_liq.port_a) annotation(
    Line(points = {{-5, -31}, {-5, -80}, {30, -80}}, color = {0, 127, 255}));
  connect(separator.level, PID_level.u_s) annotation(
    Line(points = {{1, -10}, {28, -10}}, color = {0, 0, 127}));
  connect(PID_level.y, valve_liq.opening) annotation(
    Line(points = {{51, -10}, {60, -10}, {60, -60}, {40, -60}, {40, -72}}, color = {0, 0, 127}));
  connect(PID_pressure.u_s, separator.p) annotation(
    Line(points = {{18, 90}, {10, 90}, {10, 11}, {1, 11}}, color = {0, 0, 127}));
  connect(PID_pressure.y, valve_gas.opening) annotation(
    Line(points = {{41, 90}, {49, 90}, {49, 44}}, color = {0, 0, 127}));
  connect(pressure_reference.y, PID_pressure.u_m) annotation(
    Line(points = {{-49, 70}, {29, 70}, {29, 78}}, color = {0, 0, 127}));
  connect(level_reference.y, PID_level.u_m) annotation(
    Line(points = {{31, -50}, {40, -50}, {40, -22}}, color = {0, 0, 127}));
  connect(cut_water.y, source.X_in) annotation(
    Line(points = {{-79, -8}, {-72, -8}}, color = {0, 0, 127}, thickness = 0.5));
  connect(valve_gas.port_b, sink.ports[2]) annotation(
    Line(points = {{60, 36}, {70, 36}, {70, 0}, {80, 0}}, color = {0, 127, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.002),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
This example implements a separator layout with level and pressure control.<div>The input is initially 50% water in dry air, allowing the separator to fill, after which only dry air is fed, evaporating the water and emptying the separator again.</div>
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
end SeparatorTest;
