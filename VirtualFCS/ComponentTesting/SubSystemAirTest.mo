within VirtualFCS.ComponentTesting;

model SubSystemAirTest "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  import Modelica.Constants.F;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
  package Medium = VirtualFCS.Media.CathodeAir;
  parameter Integer N_cell = 42;
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {0, -70}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  SubSystems.Air.SubSystemAir subSystemAir(redeclare package Medium = Medium, N_stack = N_cell) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Trapezoid CurrentFC(amplitude = 2000, rising = 5, width = 20, falling = 5, offset = 1000, period = 50) annotation(
    Placement(transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}})));
  Electrochemical.Hydrogen.Manifold manifold(redeclare package Medium = VirtualFCS.Media.CathodeAir, nu = {-0.5, 0, 1}, MMs = {0.032, 0.028, 0.018}, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, p_start = 1.2e5, V = 1) annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain I_to_reactionRate(k = N_cell/2/F) annotation(
    Placement(transformation(origin = {-30, 90}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(batterySystem.pin_n, subSystemAir.pin_n) annotation(
    Line(points = {{-4, -60}, {-8.75, -60}, {-8.75, -18}, {-10, -18}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, subSystemAir.pin_p) annotation(
    Line(points = {{4, -60}, {10, -60}, {10, -18}}, color = {0, 0, 255}));
  connect(CurrentFC.y, subSystemAir.stackCurrent) annotation(
    Line(points = {{-58, 10}, {-22, 10}}, color = {0, 0, 127}));
  connect(subSystemAir.toStack, manifold.port_a) annotation(
    Line(points = {{-12, 24}, {-12, 70}, {-10, 70}}, color = {0, 127, 255}));
  connect(manifold.port_b, subSystemAir.fromStack) annotation(
    Line(points = {{10, 70}, {12, 70}, {12, 24}}, color = {0, 127, 255}));
  connect(CurrentFC.y, I_to_reactionRate.u) annotation(
    Line(points = {{-58, 10}, {-50, 10}, {-50, 90}, {-42, 90}}, color = {0, 0, 127}));
  connect(I_to_reactionRate.y, manifold.r) annotation(
    Line(points = {{-18, 90}, {0, 90}, {0, 77}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 600, Interval = 0.6, Tolerance = 1e-06, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end SubSystemAirTest;
