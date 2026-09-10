within VirtualFCS.ComponentTesting;

model HeatExchangerTest
  extends Modelica.Icons.Example;
  Modelica.Fluid.Sources.MassFlowSource_T source_1(nPorts = 1, redeclare package Medium = Modelica.Media.Water.StandardWater, T = 353.15, m_flow = 1)  annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_2(nPorts = 1, redeclare package Medium = Modelica.Media.Air.SimpleAir, m_flow = 1)  annotation(
    Placement(transformation(origin = {0, 62}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.Boundary_pT sink_1(nPorts = 1, redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater)  annotation(
    Placement(transformation(origin = {80, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Fluid.Sources.Boundary_pT sink_2(nPorts = 1, redeclare package Medium = Modelica.Media.Air.SimpleAir)  annotation(
    Placement(transformation(origin = {0, -70}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Fluid.HeatExchanger hex(redeclare package Medium_1 = Modelica.Media.Water.ConstantPropertyLiquidWater, redeclare package Medium_2 = Modelica.Media.Air.SimpleAir, n = 50)  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
equation
  connect(source_1.ports[1], hex.port_a1) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(hex.port_b1, sink_1.ports[1]) annotation(
    Line(points = {{20, 0}, {70, 0}}, color = {0, 127, 255}));
  connect(source_2.ports[1], hex.port_a2) annotation(
    Line(points = {{0, 52}, {0, 20}}, color = {0, 127, 255}));
  connect(hex.port_b2, sink_2.ports[1]) annotation(
    Line(points = {{0, -20}, {0, -60}}, color = {0, 127, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.004));
annotation(Documentation(info = "<html><p>This test runs 1 kg/s water at 353.15 K through one side of a 50-cell heat exchanger while 1 kg/s air flows on the other side. The sink pressure and temperature conditions use Boundary_pT defaults.</p></html>"));
end HeatExchangerTest;
