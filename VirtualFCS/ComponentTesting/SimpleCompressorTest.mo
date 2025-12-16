within VirtualFCS.ComponentTesting;

model SimpleCompressorTest
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable package Medium = VirtualFCS.Media.CathodeAir;
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, nPorts = 1, X = {0.2, 0.8, 0}) annotation(
    Placement(transformation(origin = {-72, 0}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step power(height = 30000, offset = 100, startTime = 10) annotation(
    Placement(transformation(origin = {-60, 48}, extent = {{-10, -10}, {10, 10}})));
  Fluid.SimpleCompressor compressor(redeclare package Medium = Medium)  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V = 48)  annotation(
    Placement(transformation(origin = {2, 44}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-32, 78}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T sink(nPorts = 1, redeclare package Medium = Medium, final m_flow = -1)  annotation(
    Placement(transformation(origin = {52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(constantVoltage.n, ground.p) annotation(
    Line(points = {{-8, 44}, {-8.5, 44}, {-8.5, 80}, {-9, 80}, {-9, 88}, {-32, 88}}, color = {0, 0, 255}));
  connect(sink.ports[1], compressor.port_b) annotation(
    Line(points = {{42, 0}, {22, 0}}, color = {0, 127, 255}));
  connect(source.ports[1], compressor.port_a) annotation(
    Line(points = {{-62, 0}, {-22, 0}}, color = {0, 127, 255}));
  connect(constantVoltage.n, compressor.pin_n) annotation(
    Line(points = {{-8, 44}, {-8, 20}, {-2, 20}, {-2, 12}}, color = {0, 0, 255}));
  connect(constantVoltage.p, compressor.pin_p) annotation(
    Line(points = {{12, 44}, {12, 20}, {4, 20}, {4, 12}}, color = {0, 0, 255}));
  connect(power.y, compressor.set_control) annotation(
    Line(points = {{-48, 48}, {-40, 48}, {-40, 12}, {-22, 12}}, color = {0, 0, 127}));
  
end SimpleCompressorTest;
