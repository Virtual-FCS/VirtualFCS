within VirtualFCS.ComponentTesting;

model ManifoldTest
  extends Modelica.Icons.Example;
  Electrochemical.Hydrogen.Manifold manifold(redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2, nu = {-1}, MMs = {0.002}, useHeatPort = false)  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary outlet(nPorts = 1, redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2)  annotation(
    Placement(transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = -0)));
  Modelica.Fluid.Sources.MassFlowSource_T source(nPorts = 1, redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2, m_flow = 1)  annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.RealExpression reactionRate(y = 200)  annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  inner Modelica.Fluid.System system(allowFlowReversal = false)  annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(manifold.port_b, outlet.ports[1]) annotation(
    Line(points = {{20, 0}, {60, 0}}, color = {0, 127, 255}));
  connect(source.ports[1], manifold.port_a) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(manifold.r, reactionRate.y) annotation(
    Line(points = {{0, 14}, {0, 59}}, color = {0, 0, 127}));
end ManifoldTest;
