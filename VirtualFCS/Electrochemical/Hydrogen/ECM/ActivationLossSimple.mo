within VirtualFCS.Electrochemical.Hydrogen.ECM;

model ActivationLossSimple
extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseActivationLoss;
  import Modelica.Constants.R;
  import Modelica.Constants.F;
    
  parameter Modelica.Units.SI.CurrentDensity i_0 = 0.03"Exchange current density A/m^2 (Barbir 2005)";
  parameter Real alpha = 1 "Charge transfer coefficient (-)";
  
  outer Modelica.Units.SI.Temperature T_stack "stack temperature";
  outer Modelica.Units.SI.Area A_el "Area of the fuel cell electrode (m^2)";
  
  Modelica.Units.SI.CurrentDensity i_area;
   
equation
  i_area = i/A_el;
  v = N_cells * R*T_stack/(alpha*F) * log(max(i_area/i_0, 1));

annotation(Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>i_0</code></td><td>SI.CurrentDensity</td><td>-</td><td>0.03</td><td>Exchange current density A/m^2 (Barbir 2005)</td></tr>
<tr><td><code>alpha</code></td><td>Real</td><td>1</td><td>1</td><td>Charge transfer coefficient (-)</td></tr></tbody></table><h2>2. Model description</h2>Voltage activation loss which occurs due to sluggish kinetics associated with small overpotentials, i.e low current regime. The formula used in this element is taken from Barbir's \"PEM Fuel Cells - Theory and Practice\", Elsevier, 2013, eq. 3-41.<div>It expresses the loss in Nernst potential when drawn current approaches the exchange current density i<sub>0</sub>&nbsp;</div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>i_area = i/A_el;
v = N_cells * R*T_stack/(alpha*F) * log(max(i_area/i_0, 1));</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));


end ActivationLossSimple;
