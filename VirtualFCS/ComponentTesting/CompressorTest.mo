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
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifice(diameter = 0.02, zeta = 1, use_zeta = true, redeclare package Medium = VirtualFCS.Media.CathodeAir, allowFlowReversal = false) annotation(
    Placement(transformation(origin = {70, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constant_tau(k = 2) annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrochemical.Hydrogen.Manifold manifold(redeclare package Medium = VirtualFCS.Media.CathodeAir, nu = {-0.5, 0, 1}, useHeatPort = false, MMs = {0.032, 0.028, 0.018}, V = 1, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, T = 353.15)  annotation(
    Placement(transformation(origin = {40, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant reaction_rate(k = 1) annotation(
    Placement(transformation(origin = {10, 70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(torque.flange, compressor.flange) annotation(
    Line(points = {{-40, 0}, {-20, 0}}));
  connect(constant_tau.y, torque.tau) annotation(
    Line(points = {{-79, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(environment.ports[1], compressor.inlet) annotation(
    Line(points = {{-40, 50}, {-20, 50}, {-20, 20}}, color = {0, 127, 255}));
  connect(orifice.port_b, environment.ports[2]) annotation(
    Line(points = {{80, 8}, {80, 50}, {-40, 50}}, color = {0, 127, 255}));
  connect(compressor.outlet, manifold.port_a) annotation(
    Line(points = {{20, 8}, {30, 8}}, color = {0, 127, 255}));
  connect(manifold.port_b, orifice.port_a) annotation(
    Line(points = {{50, 8}, {60, 8}}, color = {0, 127, 255}));
  connect(reaction_rate.y, manifold.r) annotation(
    Line(points = {{22, 70}, {40, 70}, {40, 16}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.06),
  Documentation(info = "<html><head></head><body>This test verifies the operation of a Compressor object in combination with an applied constant torque applied on its shaft, a manifold with mass and energy hold-up at the outlet where a FC cathodic reaction occurs, and an orifice leading air back to the environment to realise a pressure drop.<div><br></div><div>Note that the compressor is using its heatPort to simulate adiabatic operation, whereas the manifold does not, since the presence of the reaction without corresponding energy balance would make the temperature diverge (it is possible to operate the manifold adiabatically by activating its heatPort, but only if the reaction rate is set to zero).</div></body></html>"));
end CompressorTest;
