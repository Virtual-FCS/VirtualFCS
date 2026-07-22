within VirtualFCS.ComponentTesting;

model HeatExchangerTest
  extends Modelica.Icons.Example;
  Modelica.Fluid.Sources.MassFlowSource_T source_1(nPorts = 1, redeclare package Medium = Modelica.Media.Water.StandardWater, T = 353.15, m_flow = 1)  annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T source_2(nPorts = 1, redeclare package Medium = Modelica.Media.Air.SimpleAir, m_flow = 1)  annotation(
    Placement(transformation(origin = {0, 62}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.Boundary_pT sink_1(nPorts = 1, redeclare package Medium = Modelica.Media.Water.StandardWater)  annotation(
    Placement(transformation(origin = {80, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Fluid.Sources.Boundary_pT sink_2(nPorts = 1, redeclare package Medium = Modelica.Media.Air.SimpleAir)  annotation(
    Placement(transformation(origin = {0, -70}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Fluid.HeatExchanger_Simple hex(redeclare package Medium_1 = Modelica.Media.Water.StandardWater, redeclare package Medium_2 = Modelica.Media.Air.SimpleAir)  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
equation
  connect(source_1.ports[1], hex.port_a1) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(hex.port_b1, sink_1.ports[1]) annotation(
    Line(points = {{20, 0}, {70, 0}}, color = {0, 127, 255}));
  connect(source_2.ports[1], hex.port_a2) annotation(
    Line(points = {{0, 52}, {0, 20}}, color = {0, 127, 255}));
  connect(sink_2.ports[1], hex.port_b2) annotation(
    Line(points = {{0, -60}, {0, -20}}, color = {0, 127, 255}));
end HeatExchangerTest;
