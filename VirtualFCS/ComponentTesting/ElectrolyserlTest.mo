within VirtualFCS.ComponentTesting;

model ElectrolyserlTest
  extends Modelica.Icons.Example;
  import Modelica.Constants.F;
  // Medium
  package Anode_Medium = Media.CathodeAir;
  package Cathode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  // Electrical
  // Electrolyser
  VirtualFCS.Electrochemical.Hydrogen.Electrolyser electrolyser annotation(
    Placement(visible = true, transformation(origin = {-5, -13}, extent = {{-28, -28}, {28, 28}}, rotation = 0)));
  // Anode
  Modelica.Fluid.Sources.MassFlowSource_T source_anode(redeclare package Medium = Anode_Medium, m_flow = 2, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.FixedBoundary sink_anode(nPorts = 1, redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {68, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Cathode
  Modelica.Fluid.Sources.FixedBoundary sink_cathode(nPorts = 1, redeclare package Medium = Cathode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-74, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {78, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.ConstantCurrent constantCurrent(I = 10) annotation(
    Placement(visible = true, transformation(origin = {-6, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-56, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(constantCurrent.n, electrolyser.pin_p) annotation(
    Line(points = {{4, 46}, {10, 46}, {10, 8}}, color = {0, 0, 255}));
  connect(constantCurrent.p, electrolyser.pin_n) annotation(
    Line(points = {{-16, 46}, {-20, 46}, {-20, 8}}, color = {0, 0, 255}));
  connect(electrolyser.cathode_out, sink_cathode.ports[1]) annotation(
    Line(points = {{-26, -26}, {-64, -26}, {-64, -36}}, color = {0, 127, 255}));
  connect(electrolyser.anode_out, sink_anode.ports[1]) annotation(
    Line(points = {{16, -26}, {58, -26}, {58, -34}}, color = {0, 127, 255}));
  connect(source_anode.ports[1], electrolyser.anode_in) annotation(
    Line(points = {{56, 0}, {16, 0}}, color = {0, 127, 255}));
  connect(ground.p, constantCurrent.p) annotation(
    Line(points = {{-56, 64}, {-16, 64}, {-16, 46}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 60, Tolerance = 1e-06, Interval = 0.03));
end ElectrolyserlTest;
