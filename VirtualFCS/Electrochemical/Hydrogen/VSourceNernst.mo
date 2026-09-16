within VirtualFCS.Electrochemical.Hydrogen;

model VSourceNernst
  extends Electrochemical.Hydrogen.BaseVSource;
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
  annotation(Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No user-settable parameters are declared.</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table><h2>2. Model description</h2>This unit calculates the Nernst potential of a fuel cell based on oxygen and hydrogen partial pressures and stack temperature.<div>These variables are passed as outer scope declarations.</div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>v = N_cells*(E0 + R*T_stack/(n_e*F)*log(max(p_H2/p_ref, 1) *(max(p_O2/p_ref, 1))^0.5) + delta_S/(n_e*F)*(T_stack - T_ref));</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end VSourceNernst;
