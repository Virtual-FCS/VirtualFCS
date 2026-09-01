within VirtualFCS.ComponentTesting;

model PSATest
  extends Modelica.Icons.Example;
  package AmmoniaMedium = Media.NH3Cracked;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  
  Fluid.PSASimple pSASimple(sep_eff = 0.9)  annotation(
    Placement(transformation(origin = {-2, 2}, extent = {{-22, -22}, {22, 22}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, nPorts = 1, m_flow = 0.3)  annotation(
    Placement(transformation(origin = {-66, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.Boundary_pT sink_H2(redeclare package Medium = HydrogenMedium, nPorts = 1, p = 2e6)  annotation(
    Placement(transformation(origin = {58, 42}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Fluid.Sources.Boundary_pT sink_tail(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = 2e6, use_p_in = false)  annotation(
    Placement(transformation(origin = {64, -34}, extent = {{10, -10}, {-10, 10}})));  equation
  connect(ammonia_source.ports[1], pSASimple.feed) annotation(
    Line(points = {{-56, -34}, {-10, -34}, {-10, -20}, {-8, -20}}, color = {0, 127, 255}));
  connect(sink_tail.ports[1], pSASimple.tail) annotation(
    Line(points = {{54, -34}, {2, -34}, {2, -20}}, color = {0, 127, 255}));
  connect(sink_H2.ports[1], pSASimple.product) annotation(
    Line(points = {{48, 42}, {-4, 42}, {-4, 24}, {-2, 24}}, color = {0, 127, 255}));
end PSATest;
