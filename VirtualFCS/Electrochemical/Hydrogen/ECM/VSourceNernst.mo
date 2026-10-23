within VirtualFCS.Electrochemical.Hydrogen.ECM;

model VSourceNernst
  extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseVSource;
  import Modelica.Math.log;
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  
  final constant Modelica.Units.SI.AbsolutePressure p_ref = 1e5 "Reference pressure (Pa)";
  final constant Modelica.Units.SI.Voltage E0 = 1.23 "standard potential";
  final constant Integer n_e = 2 "mol e-/mol H2";
  final constant Modelica.Units.SI.Temperature T_ref = 298 "Reference temperature ";
  final constant Modelica.Units.SI.MolarEntropy delta_S = -183 "Reversible entropy change with temperature (J/mol)";
  
  outer Modelica.Units.SI.AbsolutePressure p_H2 "Hydrogen pressure";
  outer Modelica.Units.SI.AbsolutePressure p_O2 "Oxygen pressure";
  outer Modelica.Units.SI.Temperature T_stack "stack temperature";

equation
  v = N_cells*(E0 + R*T_stack/(n_e*F)*log(max(p_H2/p_ref, 1) *(max(p_O2/p_ref, 1))^0.5) + delta_S/(n_e*F)*(T_stack - T_ref));
  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
This unit calculates the Nernst potential of a fuel cell based on oxygen and hydrogen partial pressures and stack temperature.<div>These variables are passed as outer scope declarations.</div>
<h2>Governing Equations</h2>
<pre>v = N_cells*(E0 + R*T_stack/(n_e*F)*log(max(p_H2/p_ref, 1) *(max(p_O2/p_ref, 1))^0.5) + delta_S/(n_e*F)*(T_stack - T_ref));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>p_H2</code></td><td>Hydrogen pressure</td></tr>
<tr><td><code>p_O2</code></td><td>Oxygen pressure</td></tr>
<tr><td><code>T_stack</code></td><td>stack temperature</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>-</code></td><td>number of cells in the stack (inherited)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
</table>
</body>
</html>"));
end VSourceNernst;
