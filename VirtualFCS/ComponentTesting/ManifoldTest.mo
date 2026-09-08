within VirtualFCS.ComponentTesting;

model ManifoldTest
  extends Modelica.Icons.Example;
  package medium = Media.CathodeAir;
  Electrochemical.Hydrogen.Manifold manifold(redeclare package Medium = medium, nu = {-0.5, 0, 1}, MMs = {0.032, 0.028, 0.018}, useHeatPort = false, V = 1, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary outlet(nPorts = 1, redeclare package Medium = medium, p = system.p_ambient) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = -0)));
  Modelica.Fluid.Sources.MassFlowSource_T source(nPorts = 1, redeclare package Medium = medium, m_flow = 1) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.RealExpression reactionRate(y = 5) annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(manifold.port_b, outlet.ports[1]) annotation(
    Line(points = {{20, 0}, {60, 0}}, color = {0, 127, 255}));
  connect(source.ports[1], manifold.port_a) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(manifold.r, reactionRate.y) annotation(
    Line(points = {{0, 14}, {0, 59}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.02),
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
annotation(Documentation(info = "<html><p>Test model for the manifold component.</p></html>"));
end ManifoldTest;
