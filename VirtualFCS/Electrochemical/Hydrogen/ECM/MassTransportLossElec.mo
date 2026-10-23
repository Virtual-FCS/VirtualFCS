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
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<div>This is a base class for units calculating the mass transport loss in a fuel cell stack.</div><p>It only implements the number of cells, which is imported from the <i>outer</i> scope.</p>
<h2>Governing Equations</h2>
<pre>j = i/A_cell;
E_diff = (R*T_stack)/(2*F)*log(abs(1 - (j/i_L)));
v = E_diff;</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>A_cell</code></td><td>Real</td><td>1</td><td><code>-</code></td><td>Active Area of the Cell</td></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>-</code></td><td>number of cells in the stack</td></tr>
<tr><td><code>T_stack</code></td><td>Real</td><td>1</td><td><code>-</code></td><td>Stack temperature</td></tr>
<tr><td><code>a_A</code></td><td>Real</td><td>1</td><td><code>-</code></td><td>Charge transfer coefficient Anode</td></tr>
<tr><td><code>i_L</code></td><td>Modelica.Units.SI.CurrentDensity</td><td>-</td><td><code>6</code></td><td>Maximum Current Limit density</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
</table>
</body>
</html>"),
    Diagram(graphics));
end MassTransportLossElec;
