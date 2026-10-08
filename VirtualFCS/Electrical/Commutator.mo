within VirtualFCS.Electrical;

model Commutator
  extends VirtualFCS.Electrical.AbstractCommutator;
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch gate(Ron = 3E-3/4) annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{20, 20}, {-20, -20}}, rotation = -90)));
  Modelica.Electrical.Analog.Semiconductors.Diode diode_gate(useHeatPort = useHeatPort) annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput fire annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(gate.p, n) annotation(
    Line(points = {{-20, -20}, {-20, -40}, {0, -40}, {0, -100}}, color = {0, 0, 255}));
  connect(diode_gate.p, n) annotation(
    Line(points = {{20, -20}, {20, -40}, {0, -40}, {0, -100}}, color = {0, 0, 255}));
  connect(fire, gate.control) annotation(
    Line(points = {{-100, 0}, {-44, 0}}, color = {255, 0, 255}));
  if useHeatPort then
    connect(heatPort, diode_gate.heatPort) annotation(
      Line(points = {{96, 0}, {40, 0}}, color = {191, 0, 0}));
  else
    LossPower = 0;
  end if;
  connect(p1, p2) annotation(
    Line(points = {{-100, 100}, {100, 100}}, color = {0, 0, 255}));
  connect(gate.n, p1) annotation(
    Line(points = {{-20, 20}, {-20, 40}, {0, 40}, {0, 100}, {-100, 100}}, color = {0, 0, 255}));
  connect(diode_gate.n, p2) annotation(
    Line(points = {{20, 20}, {20, 40}, {0, 40}, {0, 100}, {100, 100}}, color = {0, 0, 255}));
annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
A full-blown commutator with a PWM-controlled gate. The unit is realised completely graphically.
<h2>Governing Equations</h2>
<pre>connect(gate.p, n);
connect(diode_gate.p, n);
connect(fire, gate.control);
if useHeatPort then connect(heatPort, diode_gate.heatPort);
else LossPower = 0;
end if;
connect(p1, p2);
connect(gate.n, p1);
connect(diode_gate.n, p2);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>fire</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.BooleanInput</td><td>-</td><td></td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
<tr><td><code>p1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>-</td></tr>
<tr><td><code>p2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>-</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>-</td></tr>
</table>
</body>
</html>"));
end Commutator;
