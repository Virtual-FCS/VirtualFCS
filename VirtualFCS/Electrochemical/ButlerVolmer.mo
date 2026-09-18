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
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>alpha</code></td><td>Real</td><td>1</td><td>0.3419</td><td>Charge transfer coefficient</td></tr>
<tr><td><code>N</code></td><td>Integer</td><td>1</td><td>2</td><td>Number of exchanged electrons</td></tr>
<tr><td><code>i_0</code></td><td>SI.CurrentDensity</td><td>-</td><td></td><td>Exchange current, assumed constant</td></tr></tbody></table><h2>2. Model description</h2><p>Butler-Volmer electrochemical reaction model relating activation overpotential to current density.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>i = i_0 * (exp(alpha*N*F*v/R/T_heatPort) - exp(-(1-alpha)*N*F*v/R/T_heatPort));
LossPower = v*i;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end ButlerVolmer;
