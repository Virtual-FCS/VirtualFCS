within VirtualFCS.Electrochemical.Hydrogen;

model VSourceNernst
  extends Electrochemical.Hydrogen.BaseVSource;
  import Modelica.Math.log;
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  
  final constant Modelica.Units.SI.Voltage E0 = 1.23 "standard potential";
  final constant Integer n_e = 2 "mol e-/mol H2";
  final constant Modelica.Units.SI.Temperature T_ref = 298 "Reference temperature ";
  final constant Modelica.Units.SI.MolarEntropy delta_S = -183 "Reversible entropy change with temperature (J/mol)";
  
  outer Modelica.Units.SI.AbsolutePressure p_H2 "Hydrogen pressure";
  outer Modelica.Units.SI.AbsolutePressure p_O2 "Oxygen pressure";
  outer Modelica.Units.SI.Temperature T_stack "stack temperature";

equation
  v = N_cells*(E0 + R*T_stack/(n_e*F)*log(p_H2*p_O2^0.5) + delta_S/(n_e*F)*(T_stack - T_ref));
  annotation(Documentation(info = "<html><head></head><body>This unit calculates the Nernst potential of a fuel cell based on oxygen and hydrogen partial pressures and stack temperature.<div>These variables are passed as outer scope declarations.</div></body></html>"));
end VSourceNernst;
