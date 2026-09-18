within VirtualFCS.Electrochemical.Hydrogen;

model ActivationLossAnCa
extends Electrochemical.Hydrogen.BaseActivationLoss;
  import Modelica.Constants.R;
  import Modelica.Constants.F;
    
  outer parameter Real A_cell "Active Area of the Cell";
  outer parameter Real T_stack "Stack temperature";
  outer parameter Real a_A "Charge transfer coefficient Anode";
  
  parameter Modelica.Units.SI.CurrentDensity i_0 = 1.7e-6 "Exchange Current density";
  constant Real a_C = 0.5 "Cathode charge Transfer coefficient";
  // Declare parameters
  Modelica.Units.SI.Voltage E_act_C;
  Modelica.Units.SI.Voltage E_act_A;
  Modelica.Units.SI.Voltage E_act;
  Modelica.Units.SI.CurrentDensity j;
   
equation
   j = i/A_cell;
   E_act_C = R*T_stack/(a_C*F)*Modelica.Math.asinh(j/2*i_0);
   E_act_A = R*T_stack/(a_A*F)*Modelica.Math.asinh(j/2*i_0);
   E_act = E_act_A + E_act_C;
   v = E_act;
annotation(Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>A_cell</code></td><td>Real</td><td>1</td><td></td><td>Active Area of the Cell</td></tr>
<tr><td><code>T_stack</code></td><td>Real</td><td>1</td><td></td><td>Stack temperature</td></tr>
<tr><td><code>a_A</code></td><td>Real</td><td>1</td><td></td><td>Charge transfer coefficient Anode</td></tr>
<tr><td><code>i_0</code></td><td>Modelica.Units.SI.CurrentDensity</td><td>-</td><td>1.7e-6</td><td>Exchange Current density</td></tr></tbody></table><h2>2. Model description</h2><p>Activation-loss model for the anode and cathode of a hydrogen fuel cell.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>j = i/A_cell;
E_act_C = R*T_stack/(a_C*F)*Modelica.Math.asinh(j/2*i_0);
E_act_A = R*T_stack/(a_A*F)*Modelica.Math.asinh(j/2*i_0);
E_act = E_act_A + E_act_C;
v = E_act;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end ActivationLossAnCa;
