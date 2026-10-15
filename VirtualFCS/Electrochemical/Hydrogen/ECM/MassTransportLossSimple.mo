within VirtualFCS.Electrochemical.Hydrogen.ECM;

model MassTransportLossSimple
extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseMassTransportLoss;
  import Modelica.Constants.R;
  import Modelica.Constants.F;
  
  parameter Modelica.Units.SI.CurrentDensity i_limit = 16000 "Limiting current A/m^2 (Barbir 2005)";
  
  outer Modelica.Units.SI.Temperature T_stack "stack temperature";
  outer Modelica.Units.SI.Area A_el "Area of the fuel cell electrode (m^2)";
  
  Modelica.Units.SI.CurrentDensity i_area;
  
protected
  constant Integer N = 2 "Number of electrons in reaction";
  parameter Modelica.Units.SI.CurrentDensity i_epsilon = 1E-39*i_limit "Very small positive current density";
  
   
equation
  i_area = i/A_el;
  v = N_cells * R*T_stack/(N*F) * log(i_limit/max(i_limit-i_area, i_epsilon));

annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Mass transport loss implemented as loss of reversible potential.<div><br><div>This formulation has the advantage of requiring only one parameter, but it is far steeper than real concentration overpotential, since most of it is due to the reduction of the exchange current density in the catalyst loss term, and will therefore occur on its own assuming the effect of reduced reactant concentration on i<sub>x</sub>&nbsp;has been modelled; in that case this element may be discarded.</div><div>Also, different parts of the CL will have different thickness and thereby different limiting currents, effectively \"diffusing\" the effect which will not be as sudden.</div><div><br></div><div>The formula used in this element is taken from Barbir's \"PEM Fuel Cells - Theory and Practice\", Elsevier, 2013, eq. 3-41.</div><div>It expresses the loss in Nernst potential when reactant concentration goes to zero, so this element should not be deployed if the voltage source is a Nernst element that accounts for concentration already.</div></div><div>A key assumption is that reactant concentration at the reaction site will decrease linearly with current, uniformly across the entire area, which is a simplification of a very complex multiphase, multicomponent diffusion and convection problem.</div><div><br></div><div>As the starving species is almost always oxygen, there should be an additional 0.5 factor to account for its exponent in the Nernst voltage; however, as the function is so steep when closing to the limit current, it will not have any practical effect.</div><div>Note that the denominator of the logarithm argument (I<sub>L</sub>-I)&nbsp;has a lower limit at&nbsp;<span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" font-variant-ligatures:=\"\" normal;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\"><span title=\"Greek-language\" text&quot;=\"\"><span lang=\"el\">I<sub>ε</sub>. This is because the solver will often guess values of current I, and if we are at a place where the mass transport barrier is active, the range through which I will iterate is very short; should I be larger than I<sub>L</sub>, the equation will be undefined, and the solver will not know where to go from there. Putting a floor level slightly larger than zero ensures that the equation always computes. This&nbsp;</span></span></span><span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\">I</span><span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\"><sub>ε</sub></span><span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\">&nbsp;has to be so small that, when active, it can nullify alone the stack voltage, since this class' task is to bring voltage to zero at the mass-transport limit.</span></div><div><span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\"><br></span></div><div><span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\">Therefore, it must be 1.23 V &lt; RT/nF * log(I<sub>L</sub>/I</span><span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\"><sub>ε</sub>), which is ensured when&nbsp;</span><span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\">I</span><span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\"><sub>ε</sub>&lt;10<sup>-37</sup>&nbsp;I<sub>L</sub> using normal values for the variables.</span></div><div><span style=\"color:\" rgb(32,=\"\" 33,=\"\" 34);=\"\" font-family:=\"\" sans-serif;=\"\" orphans:=\"\" 2;=\"\" widows:=\"\" background-color:=\"\" rgb(255,=\"\" 255,=\"\" 255);&quot;=\"\"><br></span></div>
<h2>Governing Equations</h2>
<pre>i_area = i/A_el;
v = N_cells * R*T_stack/(N*F) * log(i_limit/max(i_limit-i_area, i_epsilon));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>T_stack</code></td><td>stack temperature</td></tr>
<tr><td><code>A_el</code></td><td>Area of the fuel cell electrode (m^2)</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>-</code></td><td>number of cells in the stack (inherited)</td></tr>
<tr><td><code>i_limit</code></td><td>Modelica.Units.SI.CurrentDensity</td><td>-</td><td><code>16000</code></td><td>Limiting current A/m^2 (Barbir 2005)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
</table>
</body>
</html>"));


end MassTransportLossSimple;
