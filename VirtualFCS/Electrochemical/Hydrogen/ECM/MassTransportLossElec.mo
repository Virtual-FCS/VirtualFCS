within VirtualFCS.Electrochemical.Hydrogen.ECM;

model MassTransportLossElec
  extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseMassTransportLoss;
  import Modelica.Constants.R;
  import Modelica.Constants.F;
  outer parameter Real A_cell "Active Area of the Cell";
  outer parameter Integer N_cells "number of cells in the stack";
  outer parameter Real T_stack "Stack temperature";
  outer parameter Real a_A "Charge transfer coefficient Anode";
  // Declare parameters
  Modelica.Units.SI.CurrentDensity j;
  Modelica.Units.SI.Voltage E_diff;
  // Constants
  parameter Modelica.Units.SI.CurrentDensity i_L = 6 "Maximum Current Limit density";
equation
  j = i/A_cell;
// Mass transport not relavant for el, (R*T_stack)/(2* A_a*F) used in previous Electrolyser model
  E_diff = (R*T_stack)/(2*F)*log(abs(1 - (j/i_L)));
  v = E_diff;
  annotation(
    Icon(graphics = {Line(points = {{-90, 0}, {-40, 0}}, color = {0, 0, 255}), Line(points = {{40, 0}, {90, 0}}, color = {0, 0, 255}), Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-40, 40}, {40, -40}}), Line(origin = {40, 0}, points = {{0, 40}, {0, -40}, {0, -40}, {0, -40}}, color = {0, 0, 255}), Bitmap(extent = {{-78, 0}, {-78, 0}}), Text(textColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name")}),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>A_cell</code></td><td>Real</td><td>1</td><td></td><td>Active Area of the Cell</td></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td></td><td>number of cells in the stack</td></tr>
<tr><td><code>T_stack</code></td><td>Real</td><td>1</td><td></td><td>Stack temperature</td></tr>
<tr><td><code>a_A</code></td><td>Real</td><td>1</td><td></td><td>Charge transfer coefficient Anode</td></tr>
<tr><td><code>i_L</code></td><td>Modelica.Units.SI.CurrentDensity</td><td>-</td><td>6</td><td>Maximum Current Limit density</td></tr></tbody></table><h2>2. Model description</h2><div>This is a base class for units calculating the mass transport loss in a fuel cell stack.</div><p>It only implements the number of cells, which is imported from the <i>outer</i> scope.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>j = i/A_cell;
E_diff = (R*T_stack)/(2*F)*log(abs(1 - (j/i_L)));
v = E_diff;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"),
    Diagram(graphics));
end MassTransportLossElec;
