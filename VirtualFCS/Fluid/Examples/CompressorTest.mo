within VirtualFCS.Fluid.Examples;

model CompressorTest
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}})));
  replaceable package Medium = VirtualFCS.Media.MoistAir;
  Modelica.Fluid.Sources.FixedBoundary environment(redeclare package Medium = Medium, nPorts = 2, p = system.p_ambient, T = system.T_ambient) annotation(
    Placement(transformation(origin = {-50, 50}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Fluid.Compressor compressor(redeclare package Medium = Medium, useHeatPort = true) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifice(diameter = 0.02, zeta = 1, use_zeta = true, redeclare package Medium = Medium, allowFlowReversal = false) annotation(
    Placement(transformation(origin = {70, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constant_tau(k = 2) annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Fluid.MixingVolume mixvol(redeclare package Medium = Medium, useHeatPort = false, V = 1, T = 353.15, p_start = system.p_ambient*1.01)  annotation(
    Placement(transformation(origin = {40, 8}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(torque.flange, compressor.flange_a) annotation(
    Line(points = {{-40, 0}, {-20, 0}}));
  connect(constant_tau.y, torque.tau) annotation(
    Line(points = {{-79, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(environment.ports[1], compressor.port_a) annotation(
    Line(points = {{-40, 50}, {-40, 8}, {-20, 8}}, color = {0, 127, 255}));
  connect(orifice.port_b, environment.ports[2]) annotation(
    Line(points = {{80, 8}, {80, 50}, {-40, 50}}, color = {0, 127, 255}));
  connect(compressor.port_b, mixvol.port_a) annotation(
    Line(points = {{20, 8}, {30, 8}}, color = {0, 127, 255}));
  connect(mixvol.port_b, orifice.port_a) annotation(
    Line(points = {{50, 8}, {60, 8}}, color = {0, 127, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.06),
  Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
This test verifies the operation of a Compressor object in combination with an applied constant torque applied on its shaft, a mixing volume with mass and energy hold-up at the outlet, and an orifice leading air back to the environment to realise a pressure drop.<div><br></div><div>Note that the compressor is using its heatPort to simulate adiabatic operation.</div><div><br></div><div>For correct initialisation, the pressure of the compressor outlet (i.e. the mixing volume) is set to 1% higher than the environment's at start; this avoid spurious solutions in the calculation of the compressor.</div>
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
end CompressorTest;
