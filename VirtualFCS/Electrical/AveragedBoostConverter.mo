within VirtualFCS.Electrical;

model AveragedBoostConverter
  extends VirtualFCS.Electrical.AbstractBoostConverter(redeclare AveragedCommutator commutator_A(useHeatPort=useHeatPort),
                                                       redeclare AveragedCommutator commutator_B(useHeatPort=useHeatPort));
  Modelica.Blocks.Interfaces.RealInput D annotation(
    Placement(transformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(D, commutator_B.D) annotation(
    Line(points = {{-60, -120}, {-60, -20}, {-20, -20}, {-20, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(D, commutator_A.D) annotation(
    Line(points = {{-60, -120}, {-60, 40}, {-30, 40}, {-30, 50}, {6, 50}}, color = {0, 0, 127}));
annotation(
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
An averaged model of a boost DC-DC converter with coupled inductors.<div>The usage of averaged units allows a far quicker simulation than with the rigorous model, but also loses track of details: the model is not reliable outside of continuous current mode (CCM).</div>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>D</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td></td></tr>
<tr><td><code>dc_p1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive DC</td></tr>
<tr><td><code>dc_n1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative DC</td></tr>
<tr><td><code>dc_p2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive DC</td></tr>
<tr><td><code>dc_n2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative DC</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
</tbody></table>

</body></html>"));
end AveragedBoostConverter;
