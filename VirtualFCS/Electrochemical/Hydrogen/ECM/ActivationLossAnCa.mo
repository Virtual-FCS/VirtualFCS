within VirtualFCS.Electrochemical.Hydrogen.ECM;

model ActivationLossAnCa
extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseActivationLoss;
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
annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Activation-loss model for the anode and cathode of a hydrogen fuel cell.</p>
<h2>Governing Equations</h2>
<pre>j = i/A_cell;
E_act_C = R*T_stack/(a_C*F)*Modelica.Math.asinh(j/2*i_0);
E_act_A = R*T_stack/(a_A*F)*Modelica.Math.asinh(j/2*i_0);
E_act = E_act_A + E_act_C;
v = E_act;</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>-</code></td><td>number of cells in the stack (inherited)</td></tr>
<tr><td><code>A_cell</code></td><td>Real</td><td>1</td><td><code>-</code></td><td>Active Area of the Cell</td></tr>
<tr><td><code>T_stack</code></td><td>Real</td><td>1</td><td><code>-</code></td><td>Stack temperature</td></tr>
<tr><td><code>a_A</code></td><td>Real</td><td>1</td><td><code>-</code></td><td>Charge transfer coefficient Anode</td></tr>
<tr><td><code>i_0</code></td><td>Modelica.Units.SI.CurrentDensity</td><td>-</td><td><code>1.7e-6</code></td><td>Exchange Current density</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
</table>
</body>
</html>"));
end ActivationLossAnCa;
