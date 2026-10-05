within VirtualFCS.Control.ECMS;

function fcVoltage
  input Integer N_FC; // Number of cells
  input Modelica.Units.SI.Temperature temp; // Temperature of stack
  input Modelica.Units.SI.AbsolutePressure pressure_H2; // Partial pressure of H2
  input Modelica.Units.SI.AbsolutePressure pressure_O2; // Partial pressure of O2
  input Modelica.Units.SI.Current i "Fuel cell current";
  input Modelica.Units.SI.Area A_fc; // Area of FC stack
  input Modelica.Units.SI.CurrentDensity i_0 = 0.03"Exchange current density A/m^2 (Barbir 2005)";
  input VirtualFCS.Electrochemical.ArealResistivity R_ref = 0.15e-4 "(Ohm.m^2) Reference Internal area resistivity (Barbir 2025)";
  input Modelica.Units.SI.CurrentDensity i_limit = 16000 "Limiting current A/m^2 (Barbir 2005)";
  input Real alpha = 1 "Charge transfer coefficient (-)";
  input Real phi;
  output Modelica.Units.SI.Voltage V; // Voltage of stack
  
protected
  final constant Modelica.Units.SI.Voltage E0 = 1.23 "standard potential";
  final constant Integer n_e = 2 "mol e-/mol H2";
  final constant Modelica.Units.SI.AbsolutePressure p_ref = 1e5 "Reference pressure (Pa)";
  final constant Modelica.Units.SI.MolarEntropy delta_S = -183 "Reversible entropy change with temperature (J/mol)";
  final constant Modelica.Units.SI.Temperature T_ref = 298 "Reference temperature ";
  constant Integer N = 2 "Number of electrons in reaction";
  Modelica.Units.SI.CurrentDensity i_epsilon = 1E-39*i_limit "Very small positive current density";
  Modelica.Units.SI.CurrentDensity i_area;
  Modelica.Units.SI.Voltage Nernst;
  Modelica.Units.SI.Voltage activation;
  Modelica.Units.SI.Voltage ohmic;
  Modelica.Units.SI.Voltage massTransport;

algorithm
  i_area := i/A_fc;
  
  Nernst := N_FC*(E0 + Modelica.Constants.R*temp/(n_e*Modelica.Constants.F)*Modelica.Math.log(pressure_H2/p_ref *(pressure_O2/p_ref)^0.5) + delta_S/(n_e*Modelica.Constants.F)*(temp - T_ref));

  activation := N_FC * Modelica.Constants.R * temp / (alpha * Modelica.Constants.F) * Modelica.Math.log(max(i_area/i_0,1));
  
  ohmic := N_FC * (R_ref*Modelica.Math.exp(1/temp - 1/T_ref) / phi) * i_area;
  
  massTransport := N_FC * Modelica.Constants.R*temp/(N*Modelica.Constants.F) * log(i_limit/max(i_limit-i_area, i_epsilon));

  V := Nernst - activation - ohmic - massTransport;

end fcVoltage;
