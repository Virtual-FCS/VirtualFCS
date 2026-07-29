within VirtualFCS.ComponentTesting;

model ElectricCompressorTest
  Fluid.ElectricCompressor compressor_block(redeclare package Medium = VirtualFCS.Media.CathodeAir, K(k = 2e2, Ti = 1))  annotation(
    Placement(transformation(origin = {-30, -26}, extent = {{-30, -30}, {30, 30}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifice(redeclare package Medium = VirtualFCS.Media.CathodeAir, allowFlowReversal = false, diameter = 0.02, use_zeta = true, zeta = 1) annotation(
    Placement(transformation(origin = {70, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary environment(nPorts = 2, redeclare package Medium = VirtualFCS.Media.CathodeAir)  annotation(
    Placement(transformation(origin = {-50, 70}, extent = {{-10, 10}, {10, -10}})));
  VirtualFCS.Electrochemical.Hydrogen.Manifold manifold(MMs = {0.032, 0.028, 0.018}, redeclare package Medium = VirtualFCS.Media.CathodeAir, T = 353.15, V = 1, nu = {-0.5, 0, 1}, useHeatPort = false) annotation(
    Placement(transformation(origin = {30, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant reaction_rate(k = 1) annotation(
    Placement(transformation(origin = {10, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant set_flow(k = 1) annotation(
    Placement(transformation(origin = {-90, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-72, 18}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage V_s(V = 48)  annotation(
    Placement(transformation(origin = {-50, 24}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(environment.ports[1], compressor_block.port_a) annotation(
    Line(points = {{-40, 70}, {-40, 68}, {-36, 68}, {-36, -14}}, color = {0, 127, 255}));
  connect(environment.ports[2], orifice.port_b) annotation(
    Line(points = {{-40, 70}, {80, 70}, {80, -26}}, color = {0, 127, 255}));
  connect(compressor_block.port_b, manifold.port_a) annotation(
    Line(points = {{0, -26}, {20, -26}}, color = {0, 127, 255}));
  connect(manifold.port_b, orifice.port_a) annotation(
    Line(points = {{40, -26}, {60, -26}}, color = {0, 127, 255}));
  connect(set_flow.y, compressor_block.massflow) annotation(
    Line(points = {{-79, -10}, {-67, -10}}, color = {0, 0, 127}));
  connect(V_s.p, compressor_block.pin_p) annotation(
    Line(points = {{-60, 24}, {-56, 24}, {-56, 4}}, color = {0, 0, 255}));
  connect(V_s.n, compressor_block.pin_n) annotation(
    Line(points = {{-40, 24}, {-44, 24}, {-44, 4}}, color = {0, 0, 255}));
  connect(ground.p, V_s.n) annotation(
    Line(points = {{-72, 24}, {-72, 36}, {-40, 36}, {-40, 24}}, color = {0, 0, 255}));
  connect(reaction_rate.y, manifold.r) annotation(
    Line(points = {{22, 30}, {30, 30}, {30, -18}}, color = {0, 0, 127}));

annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.06));
end ElectricCompressorTest;
