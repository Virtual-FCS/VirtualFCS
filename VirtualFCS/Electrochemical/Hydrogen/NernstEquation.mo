within VirtualFCS.Electrochemical.Hydrogen;

model NernstEquation
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Icons.VoltageSource;
  
  import Modelica.Math.log;
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  
  parameter Modelica.Units.SI.Voltage U0 = 1.23 "standard potential";
  parameter Integer n_e = 2 "mol é/mol H2";
  parameter Integer N_cells = 10 "number of cells in the stack";
  
  final parameter Modelica.Units.SI.Temperature T_ref = 298 "Reference temperature ";
  final parameter Real delta_S = -183 "Reversible entropy change with temperature (J/mol)";
  
  input Modelica.Units.SI.AbsolutePressure p_H2(min = 0) "Hydrogen pressure";
  input Modelica.Units.SI.AbsolutePressure p_O2(min = 0) "Oxygen pressure";
  input Modelica.Units.SI.Temperature T  "stack temperature";
  
  
equation
  v = N_cells*(U0 + R*T/(n_e*F)*log(p_H2*p_O2^0.5) + delta_S/(n_e*F)*(T - T_ref));

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end NernstEquation;
