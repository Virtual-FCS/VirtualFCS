within VirtualFCS.Electrochemical.Hydrogen;

model NernstSimple
  extends Electrochemical.Hydrogen.BaseNernst;
  import Modelica.Math.log;
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  final parameter Modelica.Units.SI.Voltage U0 = 1.23 "standard potential";
  final parameter Integer n_e = 2 "mol é/mol H2";
  //parameter Integer N_cells = 10 "number of cells in the stack";
  final parameter Modelica.Units.SI.Temperature T_ref = 298 "Reference temperature ";
  final parameter Real delta_S = -183 "Reversible entropy change with temperature (J/mol)";
  outer Modelica.Units.SI.AbsolutePressure p_H2 "Hydrogen pressure";
  outer Modelica.Units.SI.AbsolutePressure p_O2 "Oxygen pressure";
  outer Modelica.Units.SI.Temperature T "stack temperature";
equation
//anode.h_outflow = Anode_Medium.h_default;
//anode.Xi_outflow = Anode_Medium.X_default[1:Anode_Medium.nXi];
//cathode.h_outflow = Cathode_Medium.h_default;
//cathode.Xi_outflow = Cathode_Medium.X_default[1:Cathode_Medium.nXi];
//p_H2 = anode.p;
//p_O2 = cathode.p;
//T = heatPort.T;
  v = N_cells*(U0 + R*T/(n_e*F)*log(p_H2*p_O2^0.5) + delta_S/(n_e*F)*(T - T_ref));
  annotation(
    experiment(StartTime = 0, StopTime = 500, Tolerance = 1e-06, Interval = 0.002));
end NernstSimple;
