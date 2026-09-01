within VirtualFCS.ComponentTesting;

model MixingVolumeTest
  extends Modelica.Icons.Example;
  package Medium = Media.CathodeAir;
  Fluid.MixingVolume mixvol(redeclare package Medium = Medium, useHeatPort = true, V = 1, T_start (displayUnit = "K"), energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary outlet(nPorts = 1, redeclare package Medium = Medium, p = system.p_ambient) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = -0)));
  Modelica.Fluid.Sources.MassFlowSource_T source(nPorts = 1, redeclare package Medium = Medium, m_flow = 1, T = 303.15, X = {0.21, 0.79, 0}) annotation(
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
annotation(Documentation(info = "<html><p>This test feeds a 1 m3 mixing volume with 1 kg/s at 303.15 K and X = {0, 1, 0}. The outlet is connected to an ambient-pressure boundary and the heat port is enabled.</p><p>Ambient pressure and the initial volume temperature are inherited from the connected boundary and volume defaults. </p></html>"));
end MixingVolumeTest;
