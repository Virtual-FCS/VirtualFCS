within VirtualFCS.ComponentTesting;

model MixingVolumeTest
  extends Modelica.Icons.Example;
  package medium = Media.CathodeAir_CC;
  Fluid.MixingVolume mixvol(redeclare package Medium = medium, useHeatPort = true, V = 1, T_start (displayUnit = "K"), energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary outlet(nPorts = 1, redeclare package Medium = medium, p = system.p_ambient) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = -0)));
  Modelica.Fluid.Sources.MassFlowSource_T source(nPorts = 1, redeclare package Medium = medium, m_flow = 1, T = 303.15, X = {0, 1, 0}) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(mixvol.port_b, outlet.ports[1]) annotation(
    Line(points = {{20, 0}, {60, 0}}, color = {0, 127, 255}));
  connect(source.ports[1], mixvol.port_a) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 127, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.02),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end MixingVolumeTest;
