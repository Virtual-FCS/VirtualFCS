within VirtualFCS.ComponentTesting;

model SubsystemAir_wHumidifierTest
extends Modelica.Icons.Example;
  import Modelica.Constants.F;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
  package Medium = Media.CathodeAir;
  parameter Integer N_cells = 42;
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {0, -70}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  SubSystems.Air.SubSystemAir_wHumidifier subSystemAir(redeclare package Medium = Medium, N_cells = N_cells, redeclare VirtualFCS.Fluid.SimpleCompressor compressor(redeclare package Medium = Medium), redeclare VirtualFCS.Fluid.Humidifier humidifier(redeclare package dry_medium=Medium, redeclare package wet_medium=Medium, nFibers=10000)) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Electrochemical.Hydrogen.Manifold manifold(redeclare package Medium = Medium, nu = {-0.5, 0, 1}, MMs = {0.032, 0.028, 0.018}, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, p_start = 1.2e5, V = 0.001, useHeatPort = true) annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain I_to_reactionRate(k = N_cells/2/F) annotation(
    Placement(transformation(origin = {-30, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step currentFC(height = 4000, offset = 14, startTime = 10) annotation(
    Placement(transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}})));

//Logging, delete later
  Modelica.Units.SI.MassFraction Xi_in_manifold[Medium.nXi];
  Modelica.Units.SI.MassFraction Xi_out_manifold[Medium.nXi];
  Real Xi_in_manifold_3;
  Real Xi_out_manifold_3;
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 353.15) annotation(
    Placement(transformation(origin = {66, 60}, extent = {{10, -10}, {-10, 10}})));
equation
  
  Xi_in_manifold = actualStream(manifold.port_a.Xi_outflow);
  Xi_out_manifold = actualStream(manifold.port_b.Xi_outflow);
  Xi_in_manifold_3 = 1 - actualStream(manifold.port_a.Xi_outflow[1]) - actualStream(manifold.port_a.Xi_outflow[2]);
  Xi_out_manifold_3 = 1- actualStream(manifold.port_b.Xi_outflow[1]) - actualStream(manifold.port_b.Xi_outflow[2]);
//test = inStream(manifold.port_a.Xi_outflow[1]);
  connect(batterySystem.pin_n, subSystemAir.pin_n) annotation(
    Line(points = {{-4, -60}, {-8.75, -60}, {-8.75, -18}, {-10, -18}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, subSystemAir.pin_p) annotation(
    Line(points = {{4, -60}, {10, -60}, {10, -18}}, color = {0, 0, 255}));
  connect(subSystemAir.toStack, manifold.port_a) annotation(
    Line(points = {{-12, 24}, {-12, 70}, {-10, 70}}, color = {0, 127, 255}));
  connect(manifold.port_b, subSystemAir.fromStack) annotation(
    Line(points = {{10, 70}, {12, 70}, {12, 24}}, color = {0, 127, 255}));
  connect(I_to_reactionRate.y, manifold.r) annotation(
    Line(points = {{-18, 90}, {0, 90}, {0, 77}}, color = {0, 0, 127}));
  connect(currentFC.y, subSystemAir.stackCurrent) annotation(
    Line(points = {{-58, 10}, {-22, 10}}, color = {0, 0, 127}));
  connect(currentFC.y, I_to_reactionRate.u) annotation(
    Line(points = {{-58, 10}, {-50, 10}, {-50, 90}, {-42, 90}}, color = {0, 0, 127}));
  connect(manifold.heatPort, fixedTemperature.port) annotation(
    Line(points = {{0, 60}, {56, 60}}, color = {191, 0, 0}));
  annotation(
    experiment(StopTime = 40, Interval = 0.01, Tolerance = 1e-06, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));


end SubsystemAir_wHumidifierTest;
