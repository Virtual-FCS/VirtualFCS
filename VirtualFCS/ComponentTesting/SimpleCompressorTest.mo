within VirtualFCS.ComponentTesting;

model SimpleCompressorTest
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable package Medium = VirtualFCS.Media.CathodeAir;
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, nPorts = 1, X = {0.2, 0.8, 0}) annotation(
    Placement(transformation(origin = {-70, 50}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step power(height = 64100, offset = 20000, startTime = 0.5) annotation(
    Placement(transformation(origin = {-30, 70}, extent = {{-10, -10}, {10, 10}})));
  Fluid.SimpleCompressor compressor(redeclare package Medium = Medium)  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V = 48)  annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-80, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T sink(nPorts = 1, redeclare package Medium = Medium, final m_flow = -1)  annotation(
    Placement(transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(constantVoltage.n, ground.p) annotation(
    Line(points = {{-80, -10}, {-80, -40}}, color = {0, 0, 255}));
  connect(sink.ports[1], compressor.port_b) annotation(
    Line(points = {{40, 50}, {20, 50}, {20, 8}}, color = {0, 127, 255}));
  connect(source.ports[1], compressor.port_a) annotation(
    Line(points = {{-60, 50}, {-60, 51}, {-20, 51}, {-20, 16}}, color = {0, 127, 255}));
  connect(power.y, compressor.u) annotation(
    Line(points = {{-19, 70}, {0, 70}, {0, 14}}, color = {0, 0, 127}));
  connect(constantVoltage.p, compressor.pin_p) annotation(
    Line(points = {{-80, 10}, {-40, 10}, {-40, 6}, {-20, 6}}, color = {0, 0, 255}));
  connect(compressor.pin_n, constantVoltage.n) annotation(
    Line(points = {{-20, -6}, {-40, -6}, {-40, -10}, {-80, -10}}, color = {0, 0, 255}));
end SimpleCompressorTest;
