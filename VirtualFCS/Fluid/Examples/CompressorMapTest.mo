within VirtualFCS.Fluid.Examples;

model CompressorMapTest
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}})));
  replaceable package Medium = VirtualFCS.Media.CathodeAir_CC;
  Modelica.Fluid.Sources.FixedBoundary environment(redeclare package Medium = Medium, nPorts = 2, p = system.p_ambient, T = system.T_ambient) annotation(
    Placement(transformation(origin = {-50, 50}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Fluid.CompressorMap compressor(redeclare package Medium = VirtualFCS.Media.CathodeAir, useHeatPort = true) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifice(diameter = 0.02, zeta = 1, use_zeta = true, redeclare package Medium = VirtualFCS.Media.CathodeAir, allowFlowReversal = false) annotation(
    Placement(transformation(origin = {70, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp_tau(height = 1.5, duration = 12, offset = 2.5, startTime = 1) annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrochemical.Hydrogen.Manifold manifold(redeclare package Medium = VirtualFCS.Media.CathodeAir, nu = {-0.5, 0, 1}, useHeatPort = false, MMs = {0.032, 0.028, 0.018}, V = 1, T = 353.15) annotation(
    Placement(transformation(origin = {40, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant reaction_rate(k = 0) annotation(
    Placement(transformation(origin = {10, 70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(torque.flange, compressor.flange_a) annotation(
    Line(points = {{-40, 0}, {-20, 0}}));
  connect(ramp_tau.y, torque.tau) annotation(
    Line(points = {{-79, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(environment.ports[1], compressor.port_a) annotation(
    Line(points = {{-40, 50}, {-40, 8}, {-20, 8}}, color = {0, 127, 255}));
  connect(orifice.port_b, environment.ports[2]) annotation(
    Line(points = {{80, 8}, {80, 50}, {-40, 50}}, color = {0, 127, 255}));
  connect(compressor.port_b, manifold.port_a) annotation(
    Line(points = {{20, 8}, {30, 8}}, color = {0, 127, 255}));
  connect(manifold.port_b, orifice.port_a) annotation(
    Line(points = {{50, 8}, {60, 8}}, color = {0, 127, 255}));
  connect(reaction_rate.y, manifold.r) annotation(
    Line(points = {{22, 70}, {40, 70}, {40, 16}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.06),
    Documentation(info = "<html><head></head><body>This test drives a <tt>CompressorMap</tt> object, whose pressure ratio and isentropic efficiency are read from <tt>Resources/CompressorMaps/compressor_map.csv</tt>, with a shaft torque that ramps up over the first 20 s. The layout mirrors <tt>CompressorTest</tt>: a manifold with mass and energy hold-up hosting an (inactive) cathodic reaction sits at the outlet, and an orifice returns the air to the environment to create a pressure drop.<div><br></div><div>Plot <tt>compressor.RPM</tt>, <tt>compressor.PR_op</tt> and <tt>compressor.eta_op</tt> against <tt>compressor.m_flow</tt>, and watch <tt>compressor.surgeMargin</tt>, <tt>compressor.surging</tt> and <tt>compressor.choking</tt> to see the operating point move across the map between the surge and choke lines.</div></body></html>"));
end CompressorMapTest;
