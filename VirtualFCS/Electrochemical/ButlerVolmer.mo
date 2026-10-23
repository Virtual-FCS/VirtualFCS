within VirtualFCS.Electrochemical;

model ButlerVolmer
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  
  parameter Real alpha = 0.3419 "Charge transfer coefficient";
  parameter Integer N = 2 "Number of exchanged electrons";
  parameter Modelica.Units.SI.CurrentDensity i_0 "Exchange current, assumed constant";
  
equation
  i = i_0 * (exp(alpha*N*F*v/R/T_heatPort) - exp(-(1-alpha)*N*F*v/R/T_heatPort));
  LossPower = v*i;

annotation(
    Diagram(graphics),
    Icon(graphics = {Line(points = {{-90, 0}, {90, 0}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {-60, 20}}, color = {0, 0, 255}), Line(points = {{-70, 30}, {-70, 10}}, color = {0, 0, 255}), Line(points = {{60, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-50, 0}, {0, 50}, {50, 0}, {0, -50}, {-50, 0}}), Line(origin = {-4, 0}, points = {{-36, 0}, {36, 0}}, color = {0, 0, 255}), Line(origin = {20, 0}, points = {{0, 10}, {12, 0}, {0, -10}}, color = {0, 0, 255}), Text(textColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name")}),
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Butler-Volmer electrochemical reaction model relating activation overpotential to current density.</p>
<h2>Governing Equations</h2>
<pre>i = i_0 * (exp(alpha*N*F*v/R/T_heatPort) - exp(-(1-alpha)*N*F*v/R/T_heatPort));
LossPower = v*i;</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
<tr><td><code>alpha</code></td><td>Real</td><td>1</td><td><code>0.3419</code></td><td>Charge transfer coefficient</td></tr>
<tr><td><code>N</code></td><td>Integer</td><td>1</td><td><code>2</code></td><td>Number of exchanged electrons</td></tr>
<tr><td><code>i_0</code></td><td>Modelica.Units.SI.CurrentDensity</td><td>-</td><td><code>-</code></td><td>Exchange current, assumed constant</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
</table>
</body>
</html>"));
end ButlerVolmer;
