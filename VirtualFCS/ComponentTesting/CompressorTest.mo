within VirtualFCS.ComponentTesting;

model CompressorTest
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable package Medium = VirtualFCS.Media.CathodeAir_CC;
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, nPorts = 2, X = {0.2, 0.8, 0}) annotation(
    Placement(transformation(origin = {-20, 50}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Fluid.Compressor compressor(redeclare package Medium = VirtualFCS.Media.CathodeAir, inertia(J = 0.015))  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(height = 10, duration = 8, startTime = 1)  annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifice(diameter = 0.02, zeta = 1, use_zeta = false, m_flow_nominal = 0.1, dp_nominal = 1e5, redeclare package Medium = VirtualFCS.Media.CathodeAir)  annotation(
    Placement(transformation(origin = {44, 8}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(torque.flange, compressor.flange) annotation(
    Line(points = {{-40, 0}, {-20, 0}}));
  connect(ramp.y, torque.tau) annotation(
    Line(points = {{-78, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(compressor.outlet, orifice.port_a) annotation(
    Line(points = {{20, 8}, {34, 8}}, color = {0, 127, 255}));
  connect(orifice.port_b, source.ports[1]) annotation(
    Line(points = {{54, 8}, {54, 36}, {-20, 36}, {-20, 40}}, color = {0, 127, 255}));
  connect(compressor.inlet, source.ports[2]) annotation(
    Line(points = {{-20, 20}, {-20, 40}}, color = {0, 127, 255}));

annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.02));
end CompressorTest;
