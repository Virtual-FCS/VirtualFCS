within VirtualFCS.Electrochemical.Hydrogen;

model OhmicNafion
  extends VirtualFCS.Electrochemical.Hydrogen.BaseOhmic;
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
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td></td><td>number of cells in the stack</td></tr>
<tr><td><code>A_cell</code></td><td>Real</td><td>1</td><td></td><td>Active Area of the Cell</td></tr>
<tr><td><code>T_stack</code></td><td>Real</td><td>1</td><td></td><td>Stack temperature</td></tr>
<tr><td><code>t_ele</code></td><td>SI.Thickness</td><td>-</td><td>1e-3</td><td>Electrode thickness</td></tr>
<tr><td><code>rho_ele</code></td><td>SI.Resistivity</td><td>-</td><td>7.5e-5</td><td>Electrode resistivity</td></tr>
<tr><td><code>lambda</code></td><td>Real</td><td>1</td><td>22</td><td>Number of water molecules per sulfonic acid site</td></tr>
<tr><td><code>t_mem</code></td><td>SI.Thickness</td><td>-</td><td>180e-6</td><td>Membrane thickness</td></tr></tbody></table><h2>2. Model description</h2><div>This is a base class for units calculating the Ohmic loss in a fuel cell stack.</div><p>It only implements the number of cells, which is imported from the <i>outer</i> scope.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>R_ohm_ele = t_ele*rho_ele/A_cell;
E_ohm_A = R_ohm_ele*i;
E_ohm_C = E_ohm_A;
sigma_mem = (0.005139*lambda - 0.00326)*exp(1268*((1/303) - (1/max(T_stack, 293.14))));
R_ohm_mem = t_mem/(sigma_mem);
E_ohm_mem = R_ohm_mem*i;
E_ohm = E_ohm_A + E_ohm_C + E_ohm_mem;
v = E_ohm;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"),
    Diagram(graphics));
end OhmicNafion;
