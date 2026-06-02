within VirtualFCS.ComponentTesting;

model CompressorTest
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}})));
  replaceable package Medium = VirtualFCS.Media.CathodeAir_CC;
  Modelica.Fluid.Sources.FixedBoundary environment(redeclare package Medium = Medium, nPorts = 2, p = system.p_ambient, T = system.T_ambient) annotation(
    Placement(transformation(origin = {-50, 50}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Fluid.Compressor compressor(redeclare package Medium = VirtualFCS.Media.CathodeAir, useHeatPort = true) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifice(diameter = 0.02, zeta = 1, use_zeta = false, m_flow_nominal = 0.1, dp_nominal = 1e5, redeclare package Medium = VirtualFCS.Media.CathodeAir, allowFlowReversal = false) annotation(
    Placement(transformation(origin = {70, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 2) annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrochemical.Hydrogen.Manifold manifold(redeclare package Medium = VirtualFCS.Media.CathodeAir, nu = {-0.5, 0, 1}, useHeatPort = true, MMs = {0.032, 0.028, 0.018}, V = 1, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, p_start = 1.1e5)  annotation(
    Placement(transformation(origin = {42, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(transformation(origin = {10, 70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(torque.flange, compressor.flange) annotation(
    Line(points = {{-40, 0}, {-20, 0}}));
  connect(const.y, torque.tau) annotation(
    Line(points = {{-79, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(environment.ports[1], compressor.inlet) annotation(
    Line(points = {{-40, 50}, {-20, 50}, {-20, 20}}, color = {0, 127, 255}));
  connect(orifice.port_b, environment.ports[2]) annotation(
    Line(points = {{80, 8}, {80, 50}, {-40, 50}}, color = {0, 127, 255}));
  connect(compressor.outlet, manifold.port_a) annotation(
    Line(points = {{20, 8}, {32, 8}}, color = {0, 127, 255}));
  connect(manifold.port_b, orifice.port_a) annotation(
    Line(points = {{52, 8}, {60, 8}}, color = {0, 127, 255}));
  connect(const1.y, manifold.r) annotation(
    Line(points = {{22, 70}, {42, 70}, {42, 16}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.06));
end CompressorTest;
