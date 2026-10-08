within VirtualFCS.Electrical;

model BoostConverter
  extends VirtualFCS.Electrical.AbstractBoostConverter(redeclare Commutator commutator_A(useHeatPort=useHeatPort),
                                                       redeclare Commutator commutator_B(useHeatPort=useHeatPort));
  extends Modelica.Electrical.PowerConverters.Interfaces.Enable.Enable2;
equation
  connect(andCondition_n.y, commutator_A.fire) annotation(
    Line(points = {{60, -68}, {60, 40}, {0, 40}, {0, 50}, {8, 50}}, color = {255, 0, 255}));
  connect(andCondition_p.y, commutator_B.fire) annotation(
    Line(points = {{-60, -68}, {-60, -14}, {-20, -14}, {-20, -10}, {0, -10}}, color = {255, 0, 255}));
annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
A rigorous model for DC-DC boost converters. The two boolean inputs allow firing the gates separately.<div>Note that the rate of simulation is directly dependent on the PWM frequency, since at each change an event is triggered. In practice, this model can be used for detailed simulations in the sub-second range.</div>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>VirtualFCS.Electrical.AbstractBoostConverter</code>, <code>Modelica.Electrical.PowerConverters.Interfaces.Enable.Enable2</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
<tr><td><code>useConstantEnable</code></td><td>Boolean</td><td>1</td><td><code>true</code></td><td>Disable boolean input and use constantEnable, if true (inherited)</td></tr>
<tr><td><code>constantEnable</code></td><td>Boolean</td><td>1</td><td><code>true</code></td><td>Constant enabling of firing signals (inherited)</td></tr>
<tr><td><code>m</code></td><td>Integer</td><td>1</td><td><code>3</code></td><td>Number of phases (inherited)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>dc_p1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive DC</td></tr>
<tr><td><code>dc_n1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative DC</td></tr>
<tr><td><code>dc_p2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive DC</td></tr>
<tr><td><code>dc_n2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative DC</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
<tr><td><code>enable</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.BooleanInput</td><td>-</td><td>Enables fire and notFire</td></tr>
<tr><td><code>fire_p</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.BooleanInput</td><td>-</td><td>Firing signal of positive potential transistor</td></tr>
<tr><td><code>fire_n</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.BooleanInput</td><td>-</td><td>Firing signal of negative potential transistor</td></tr>
</table>
</body>
</html>"));
end BoostConverter;
