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
  
  input Modelica.Units.SI.AbsolutePressure p_H2(min = 0) "Hydrogen pressure";
  input Modelica.Units.SI.AbsolutePressure p_O2(min = 0) "Oxygen pressure";
  input Modelica.Units.SI.Temperature T  "stack temperature";
  
  
equation
  v = U0 + R*T/(n_e*F)*log(p_H2*p_O2^0.5);

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end NernstEquation;
