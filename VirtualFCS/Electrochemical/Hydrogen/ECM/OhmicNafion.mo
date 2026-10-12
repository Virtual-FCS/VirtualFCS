within VirtualFCS.Electrochemical.Hydrogen.ECM;

model OhmicNafion
  extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseOhmic;
  outer parameter Integer N_cells "number of cells in the stack";
  outer parameter Real A_cell "Active Area of the Cell";
  outer parameter Real T_stack "Stack temperature";
  parameter Modelica.Units.SI.Thickness t_ele = 1e-3 "Electrode thickness";
  parameter Modelica.Units.SI.Resistivity rho_ele = 7.5e-5 "Electrode resistivity";
  parameter Real lambda = 22 "Number of water molecules per sulfonic acid site";
  parameter Modelica.Units.SI.Thickness t_mem = 180e-6 "Membrane thickness";
  // Declare param
  Modelica.Units.SI.Conductivity sigma_mem "Membrane conductivity";
  Modelica.Units.SI.Resistance R_ohm_ele "Electronic resistance";
  Modelica.Units.SI.Resistance R_ohm_mem "Membrane resistance";
  Modelica.Units.SI.Voltage E_ohm_A "Anode electronic loss";
  Modelica.Units.SI.Voltage E_ohm_C "Cathode electronic loss";
  Modelica.Units.SI.Voltage E_ohm_mem "Membrane ohmic loss";
  Modelica.Units.SI.Voltage E_ohm "Ohmic Loss";
equation
  R_ohm_ele = t_ele*rho_ele/A_cell;
  E_ohm_A = R_ohm_ele*i;
  E_ohm_C = E_ohm_A;
// Nafion membrane conductivity as a function of water per sulfonic acid group and temperature
  sigma_mem = (0.005139*lambda - 0.00326)*exp(1268*((1/303) - (1/max(T_stack, 293.14))));
  R_ohm_mem = t_mem/(sigma_mem);
  E_ohm_mem = R_ohm_mem*i;
  E_ohm = E_ohm_A + E_ohm_C + E_ohm_mem;
  v = E_ohm;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-70, 30}, {70, -30}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-90, 0}, {-70, 0}}, color = {0, 0, 255}), Line(points = {{70, 0}, {90, 0}}, color = {0, 0, 255}), Text(extent = {{-150, 90}, {150, 50}}, textString = "%name", textColor = {0, 0, 255})}),
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<div>This is a base class for units calculating the Ohmic loss in a fuel cell stack.</div><p>It only implements the number of cells, which is imported from the <i>outer</i> scope.</p>
<h2>Governing Equations</h2>
<pre>R_ohm_ele = t_ele*rho_ele/A_cell;
E_ohm_A = R_ohm_ele*i;
E_ohm_C = E_ohm_A;
sigma_mem = (0.005139*lambda - 0.00326)*exp(1268*((1/303) - (1/max(T_stack, 293.14))));
R_ohm_mem = t_mem/(sigma_mem);
E_ohm_mem = R_ohm_mem*i;
E_ohm = E_ohm_A + E_ohm_C + E_ohm_mem;
v = E_ohm;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>sigma_mem</code></td><td>Membrane conductivity</td></tr>
<tr><td><code>R_ohm_ele</code></td><td>Electronic resistance</td></tr>
<tr><td><code>R_ohm_mem</code></td><td>Membrane resistance</td></tr>
<tr><td><code>E_ohm_A</code></td><td>Anode electronic loss</td></tr>
<tr><td><code>E_ohm_C</code></td><td>Cathode electronic loss</td></tr>
<tr><td><code>E_ohm_mem</code></td><td>Membrane ohmic loss</td></tr>
<tr><td><code>E_ohm</code></td><td>Ohmic Loss</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>-</code></td><td>number of cells in the stack</td></tr>
<tr><td><code>A_cell</code></td><td>Real</td><td>1</td><td><code>-</code></td><td>Active Area of the Cell</td></tr>
<tr><td><code>T_stack</code></td><td>Real</td><td>1</td><td><code>-</code></td><td>Stack temperature</td></tr>
<tr><td><code>t_ele</code></td><td>Modelica.Units.SI.Thickness</td><td>-</td><td><code>1e-3</code></td><td>Electrode thickness</td></tr>
<tr><td><code>rho_ele</code></td><td>Modelica.Units.SI.Resistivity</td><td>-</td><td><code>7.5e-5</code></td><td>Electrode resistivity</td></tr>
<tr><td><code>lambda</code></td><td>Real</td><td>1</td><td><code>22</code></td><td>Number of water molecules per sulfonic acid site</td></tr>
<tr><td><code>t_mem</code></td><td>Modelica.Units.SI.Thickness</td><td>-</td><td><code>180e-6</code></td><td>Membrane thickness</td></tr>
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
end OhmicNafion;
