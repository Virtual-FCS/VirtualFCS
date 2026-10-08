within VirtualFCS.ComponentTesting;

model SimplePumpTest
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, nPorts = 1, p = 2e5, T = 323.15) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step massFlow(height = 5, offset = 1, startTime = 0.5) annotation(
    Placement(transformation(origin = {-30, 52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage voltageSource(V = 48) annotation(
    Placement(transformation(origin = {0, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {20, -50}, extent = {{-10, -10}, {10, 10}})));
  Fluid.SimplePump simplePump(redeclare package Medium = Medium)  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary sink(redeclare package Medium = Medium, nPorts = 1, p = 1e6) annotation(
    Placement(transformation(origin = {70, 16}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
equation
  connect(simplePump.pin_p, voltageSource.p) annotation(
    Line(points = {{-10, -20}, {-10, -40}}, color = {0, 0, 255}));
  connect(simplePump.pin_n, voltageSource.n) annotation(
    Line(points = {{8, -20}, {10, -20}, {10, -40}}, color = {0, 0, 255}));
  connect(voltageSource.n, ground.p) annotation(
    Line(points = {{10, -40}, {20, -40}}, color = {0, 0, 255}));
  connect(source.ports[1], simplePump.port_a) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(massFlow.y, simplePump.u) annotation(
    Line(points = {{-18, 52}, {0, 52}, {0, 18}}, color = {0, 0, 127}));
  connect(simplePump.port_b, sink.ports[1]) annotation(
    Line(points = {{20, 16}, {60, 16}}, color = {0, 127, 255}));
annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This test steps the pump mass-flow command from 1 kg/s to 6 kg/s at 0.5 s. The inlet is held at 2e5 Pa and 323.15 K, the outlet at 1e6 Pa, and the electrical supply at 48 V.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>system</code> (Modelica.Fluid.System), <code>source</code> (Modelica.Fluid.Sources.FixedBoundary), <code>massFlow</code> (Modelica.Blocks.Sources.Step), <code>voltageSource</code> (Modelica.Electrical.Analog.Sources.ConstantVoltage), <code>ground</code> (Modelica.Electrical.Analog.Basic.Ground), <code>simplePump</code> (Fluid.SimplePump), <code>sink</code> (Modelica.Fluid.Sources.FixedBoundary).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end SimplePumpTest;
