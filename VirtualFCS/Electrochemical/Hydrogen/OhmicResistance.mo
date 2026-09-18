within VirtualFCS.Electrochemical.Hydrogen;

model OhmicResistance "Ohmic resistance to proton flow through MEA"
  extends Electrochemical.Hydrogen.BaseOhmic;
  
  import Modelica.Math.exp;

  parameter VirtualFCS.Electrochemical.ArealResistivity R_ref = 0.15e-4 "(Ohm.m^2) Reference Internal area resistivity (Barbir 2025)";
  parameter Modelica.Units.SI.Temperature T_ref = 330 "Reference temperature";
  
  outer Modelica.Units.SI.Temperature T_stack "stack temperature";
  outer Real phi;
  outer Modelica.Units.SI.Area A_el "Area of the fuel cell electrode (m^2)";
  
  Modelica.Units.SI.Resistance R "Actual resistance";
  Modelica.Units.SI.CurrentDensity i_area;
   
equation
  i_area = i/A_el;
  R = R_ref*exp(1/T_stack - 1/T_ref) / phi;
  v = N_cells * R * i_area;

  annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>R_ref</code></td><td>VirtualFCS.Electrochemical.ArealResistivity</td><td>-</td><td>0.15e-4</td><td>(Ohm.m^2) Reference Internal area resistivity (Barbir 2025)</td></tr>
<tr><td><code>T_ref</code></td><td>SI.Temperature</td><td>K</td><td>330</td><td>Reference temperature</td></tr></tbody></table><h2>2. Model description</h2><p>This resistor implements a variable ohmic resistance as typically encountered in PEM fuel cells.</p><p>A reference value is usually provided by the manufacturer for a reference temperature, which is then corrected for temperature and relative humidity.</p><p></p><ul><li>From <a href=\"&quot;http://doi.org/10.1149/2.104203jes&quot;\">Yadav and Fedkiw</a>, temperature dependence of conductivity follows an Arrhenius relationship;</li><li>From <a href=\"&quot;https://doi.org/10.1016/j.electacta.2008.02.074&quot;\">Zhang et al.</a>&nbsp;conductivity is closely linear with relative humidity, meaning the actual resistance value is obtained dividing by φ.</li></ul><p>Relative humidity is provided with the custom input connector; temperature with the conditional heat port.</p><p>The default value for resistance <i>R<sub>ref</sub></i> is taken from Yadav and Fedkiw's typical value for Nafion 117 at 330 K, 0.1 S/cm. A thickness of 0.2 mm and and area of 100 cm<sup>2</sup> are then assumed, resulting in 2 mΩ.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>i_area = i/A_el;
R = R_ref*exp(1/T_stack - 1/T_ref) / phi;
v = N_cells * R * i_area;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end OhmicResistance;
