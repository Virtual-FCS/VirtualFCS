within VirtualFCS.ComponentTesting;

model SubSystemHydrogenWithFuelCellTest
  extends Modelica.Icons.Example;
  import Modelica.Constants.F;
  parameter Real lambda = 3;
  parameter Integer N_cells = 42 "Number of cells in the stack";
  package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  package Cathode_Medium = VirtualFCS.Media.MoistAir;
  package Coolant_Medium = Modelica.Media.Incompressible.Examples.Glycol47;

  Electrochemical.Hydrogen.FuelCells.FuelCell fc(N_cells = N_cells, heatCapacitor(T(start = 323.15, fixed = true)), redeclare package Anode_Medium = Anode_Medium, redeclare package Cathode_Medium = Cathode_Medium, redeclare package Coolant_Medium = Coolant_Medium, cathode(massDynamics = Modelica.Fluid.Types.Dynamics.DynamicFreeInitial), anode(massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, p_start = 1e5)) annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary air_sink(redeclare package Medium = Cathode_Medium, nPorts = 1, p = 2e5) annotation(
    Placement(transformation(origin = {60, -10}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary coolant_sink(redeclare package Medium = Coolant_Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {25, -25}, extent = {{5, -5}, {-5, 5}})));
  Modelica.Fluid.Sources.MassFlowSource_T coolant_source(nPorts = 1, redeclare package Medium = Coolant_Medium, m_flow = 1, T = 323.15) annotation(
    Placement(transformation(origin = {-14, -26}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Fluid.Sources.MassFlowSource_T air_source(redeclare package Medium = Cathode_Medium, m_flow = 7.5e-2, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(transformation(origin = {46, 10}, extent = {{6, -6}, {-6, 6}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(transformation(origin = {10, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Blocks.Sources.Step R_values(height = 10, offset = -8, startTime = 250) annotation(
    Placement(transformation(origin = {50, 76}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  SubSystems.Hydrogen.SubSystemHydrogen subSystemHydrogen(N_cells = N_cells, redeclare package Anode_Medium = Anode_Medium, pressureRegulator(pid(controllerType = Modelica.Blocks.Types.SimpleController.P)))  annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-15, -10}, {15, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage V_source(V = 24) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
equation
  connect(fc.pin_n, ground.p) annotation(
    Line(points = {{-10, 14}, {-10, 60}, {-30, 60}}, color = {0, 0, 255}));
  connect(resistor.n, fc.pin_n) annotation(
    Line(points = {{-10, 60}, {-10, 14}}, color = {0, 0, 255}));
  connect(fc.coolant_out, coolant_sink.ports[1]) annotation(
    Line(points = {{4, -12}, {4, -24}, {20, -24}}, color = {0, 127, 255}));
  connect(fc.cathode_out, air_sink.ports[1]) annotation(
    Line(points = {{14, -10}, {56, -10}}, color = {0, 127, 255}));
  connect(air_source.ports[1], fc.cathode_in) annotation(
    Line(points = {{40, 10}, {14, 10}}, color = {0, 127, 255}));
  connect(resistor.p, currentSensor.n) annotation(
    Line(points = {{10, 60}, {10, 50}}, color = {0, 0, 255}));
  connect(currentSensor.p, fc.pin_p) annotation(
    Line(points = {{10, 30}, {10, 14}}, color = {0, 0, 255}));
  connect(fc.coolant_in, coolant_source.ports[1]) annotation(
    Line(points = {{-4, -12}, {-4, -26}, {-8, -26}}, color = {0, 127, 255}));
  connect(R_values.y, resistor.R) annotation(
    Line(points = {{40, 76}, {0, 76}, {0, 72}}, color = {0, 0, 127}));
  connect(currentSensor.i, subSystemHydrogen.stackCurrent) annotation(
    Line(points = {{0, 40}, {-50, 40}, {-50, 11}}, color = {0, 0, 127}));
  connect(subSystemHydrogen.toStack, fc.anode_in) annotation(
    Line(points = {{-38, 5}, {-26, 5}, {-26, 10}, {-14, 10}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.fromStack, fc.anode_out) annotation(
    Line(points = {{-38, -5}, {-26, -5}, {-26, -10}, {-14, -10}}, color = {0, 127, 255}));
  connect(V_source.n, subSystemHydrogen.pin_n) annotation(
    Line(points = {{-80, 10}, {-66, 10}, {-66, 4}, {-58, 4}}, color = {0, 0, 255}));
  connect(V_source.p, subSystemHydrogen.pin_p) annotation(
    Line(points = {{-80, -10}, {-66, -10}, {-66, -4}, {-58, -4}}, color = {0, 0, 255}));
  connect(ground.p, V_source.n) annotation(
    Line(points = {{-30, 60}, {-80, 60}, {-80, 10}}, color = {0, 0, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 500, Tolerance = 1e-06, Interval = 1));
annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This test couples the hydrogen subsystem to a 42-cell fuel cell. The fuel-cell load resistance steps from -8 ohm to 2 ohm at 250 s.</p><p>The air feed is 0.075 kg/s with a 2e5 Pa outlet, the anode starts at 1e5 Pa, and coolant enters at 323.15 K and 1 kg/s. The hydrogen subsystem is supplied at 24 V and uses a proportional pressure regulator.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>fc</code> (Electrochemical.Hydrogen.FuelCells.FuelCell), <code>air_sink</code> (Modelica.Fluid.Sources.FixedBoundary), <code>ground</code> (Modelica.Electrical.Analog.Basic.Ground), <code>resistor</code> (Modelica.Electrical.Analog.Basic.VariableResistor), <code>system</code> (Modelica.Fluid.System), <code>coolant_sink</code> (Modelica.Fluid.Sources.FixedBoundary), <code>coolant_source</code> (Modelica.Fluid.Sources.MassFlowSource_T), <code>air_source</code> (Modelica.Fluid.Sources.MassFlowSource_T), <code>currentSensor</code> (Modelica.Electrical.Analog.Sensors.CurrentSensor), <code>R_values</code> (Modelica.Blocks.Sources.Step), <code>subSystemHydrogen</code> (SubSystems.Hydrogen.SubSystemHydrogen), <code>V_source</code> (Modelica.Electrical.Analog.Sources.ConstantVoltage).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>lambda</code></td><td>Real</td><td>1</td><td><code>3</code></td><td>-</td></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>42</code></td><td>Number of cells in the stack</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end SubSystemHydrogenWithFuelCellTest;
