within VirtualFCS.ComponentTesting;

model SubSystemAirWithFuelCellTest
  extends Modelica.Icons.Example;
  import Modelica.Constants.F;

  parameter Integer N_cells = 42 "Number of cells in the stack";
  
  Electrochemical.Hydrogen.FuelCells.FuelCell fc(N_cells = N_cells) annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogen(redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2, nPorts = 1) annotation(
    Placement(transformation(origin = {-44, 10}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary coolant_sink(redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, nPorts = 1) annotation(
    Placement(transformation(origin = {25, -25}, extent = {{5, -5}, {-5, 5}})));
  Modelica.Fluid.Sources.MassFlowSource_T coolant_source(nPorts = 1, redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, m_flow = 1, T = 323.15) annotation(
    Placement(transformation(origin = {-14, -26}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(transformation(origin = {10, 40}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  Modelica.Blocks.Sources.Step R_values(height = 20, offset = 30, startTime = 250) annotation(
    Placement(transformation(origin = {50, 76}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  SubSystems.Air.SubSystemAir subSystemAir(environment(redeclare package Medium = Media.MoistAir))  annotation(
    Placement(transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage V_source(V = 24) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{-6, 6}, {6, -6}}, rotation = 90)));
equation
  connect(fc.pin_n, ground.p) annotation(
    Line(points = {{-10, 14}, {-10, 80}, {-30, 80}, {-30, 60}}, color = {0, 0, 255}));
  connect(resistor.n, fc.pin_n) annotation(
    Line(points = {{-10, 60}, {-10, 14}}, color = {0, 0, 255}));
  connect(fc.coolant_out, coolant_sink.ports[1]) annotation(
    Line(points = {{4, -12}, {4, -24}, {20, -24}}, color = {0, 127, 255}));
  connect(fc.anode_in, hydrogen.ports[1]) annotation(
    Line(points = {{-14, 10}, {-40, 10}}, color = {0, 127, 255}));
  connect(resistor.p, currentSensor.n) annotation(
    Line(points = {{10, 60}, {10, 50}}, color = {0, 0, 255}));
  connect(currentSensor.p, fc.pin_p) annotation(
    Line(points = {{10, 30}, {10, 14}}, color = {0, 0, 255}));
  connect(fc.coolant_in, coolant_source.ports[1]) annotation(
    Line(points = {{-4, -12}, {-4, -26}, {-8, -26}}, color = {0, 127, 255}));
  connect(R_values.y, resistor.R) annotation(
    Line(points = {{40, 76}, {0, 76}, {0, 72}}, color = {0, 0, 127}));
  connect(fc.cathode_out, subSystemAir.fromStack) annotation(
    Line(points = {{14, -10}, {26, -10}, {26, -6}, {38, -6}}, color = {0, 127, 255}));
  connect(fc.cathode_in, subSystemAir.toStack) annotation(
    Line(points = {{14, 10}, {28, 10}, {28, 6}, {38, 6}}, color = {0, 127, 255}));
  connect(subSystemAir.pin_p, V_source.p) annotation(
    Line(points = {{60, -4}, {59.25, -4}, {59.25, -6}, {80, -6}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_n, V_source.n) annotation(
    Line(points = {{60, 6}, {80, 6}}, color = {0, 0, 255}));
  connect(V_source.n, ground.p) annotation(
    Line(points = {{80, 6}, {80, 100}, {-30, 100}, {-30, 60}}, color = {0, 0, 255}));
  connect(subSystemAir.stackCurrent, currentSensor.i) annotation(
    Line(points = {{46, 12}, {46, 40}, {22, 40}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This test couples the air subsystem to a 42-cell fuel cell with 0.075 kg/s air feed, 1 kg/s coolant, 323.15 K coolant inlet, and a 24 V subsystem supply.</p><p>A load-resistance step from 30 ohm to 50 ohm is scheduled at 250 s.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>fc</code> (Electrochemical.Hydrogen.FuelCells.FuelCell), <code>hydrogen</code> (Modelica.Fluid.Sources.FixedBoundary), <code>ground</code> (Modelica.Electrical.Analog.Basic.Ground), <code>resistor</code> (Modelica.Electrical.Analog.Basic.VariableResistor), <code>system</code> (Modelica.Fluid.System), <code>coolant_sink</code> (Modelica.Fluid.Sources.FixedBoundary), <code>coolant_source</code> (Modelica.Fluid.Sources.MassFlowSource_T), <code>currentSensor</code> (Modelica.Electrical.Analog.Sensors.CurrentSensor), <code>R_values</code> (Modelica.Blocks.Sources.Step), <code>subSystemAir</code> (SubSystems.Air.SubSystemAir), <code>V_source</code> (Modelica.Electrical.Analog.Sources.ConstantVoltage).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>42</code></td><td>Number of cells in the stack</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end SubSystemAirWithFuelCellTest;
