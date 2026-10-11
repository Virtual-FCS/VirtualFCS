within VirtualFCS.SubSystems.Examples;

model SubSystemAirTest "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  import Modelica.Constants.F;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 1e-4) annotation(
    Placement(transformation(origin = {90, -90}, extent = {{-10, -10}, {10, 10}})));
  package Medium = Media.MoistAir;
  parameter Integer N_cells = 42;
  replaceable SubSystems.Air.SubSystemAir subSystemAir(redeclare package Medium = Medium, N_cells = N_cells, redeclare VirtualFCS.Fluid.ElectricCompressor compressor(redeclare package Medium = Medium), p_set = 2e5) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Electrochemical.Hydrogen.Manifold manifold(redeclare package Medium = Medium, nu = {-0.5, 0, 1}, MMX = {Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM, Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM}, V = 1E-3, useHeatPort = true, R_flow = 10000) annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step currentFC(height = 2000, offset = 10, startTime = 10) annotation(
    Placement(transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage battery(V = 24) annotation(
    Placement(transformation(origin = {0, -60}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant reaction_rate(k = 0) annotation(
    Placement(transformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step reaction_rate_step(height = 0.6, offset = 0, startTime = 10) annotation(
    Placement(transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(transformation(origin = {52, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step heatFlowStep(height = -145000, offset = 0, startTime = 10) annotation(
    Placement(transformation(origin = {100, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(subSystemAir.toStack, manifold.port_a) annotation(
    Line(points = {{-12, 24}, {-12, 70}, {-10, 70}}, color = {0, 127, 255}));
  connect(manifold.port_b, subSystemAir.fromStack) annotation(
    Line(points = {{10, 70}, {12, 70}, {12, 24}}, color = {0, 127, 255}));
  connect(currentFC.y, subSystemAir.stackCurrent) annotation(
    Line(points = {{-58, 10}, {-22, 10}}, color = {0, 0, 127}));
  connect(battery.p, subSystemAir.pin_p) annotation(
    Line(points = {{10, -60}, {10, -18}}, color = {0, 0, 255}));
  connect(battery.n, subSystemAir.pin_n) annotation(
    Line(points = {{-10, -60}, {-10, -18}}, color = {0, 0, 255}));
  connect(ground.p, battery.n) annotation(
    Line(points = {{-30, -60}, {-10, -60}}, color = {0, 0, 255}));
  connect(reaction_rate_step.y, manifold.r) annotation(
    Line(points = {{-59, 50}, {-24, 50}, {-24, 90}, {0, 90}, {0, 78}}, color = {0, 0, 127}));
  connect(prescribedHeatFlow.Q_flow, heatFlowStep.y) annotation(
    Line(points = {{62, 58}, {78, 58}, {78, 32}, {90, 32}}, color = {0, 0, 127}));
  connect(prescribedHeatFlow.port, manifold.heatPort) annotation(
    Line(points = {{42, 58}, {0, 58}, {0, 60}}, color = {191, 0, 0}));
  annotation(
    experiment(StopTime = 20, Interval = 0.02, Tolerance = 1e-06, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
  Documentation(info = "<html><head></head><body>This test case tests the operation of the air subsystem against a simple manifold.<div>Note that, if you set a reaction rate larger than zero, you <i>must</i>&nbsp;deactivate the manifold's heat port, or connect it to some constant or prescribed temperature source.</div><div>This is because the reaction makes matter \"disappear\" without changing the enthalpy content, and therefore the enthalpy balance will become nonsensical; this balance works only when multiple manifolds (e.g. cathode and anode) with matching stoichiometric coefficients are connected.</div></body></html>"));
end SubSystemAirTest;
