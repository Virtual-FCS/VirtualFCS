within VirtualFCS.Control.ECMS;
function calcFCV
  input Real N_FC; // Number of cells
  input Real temp; // Temperature of stack
  input Real pressure_H2; // Partial pressure of H2
  input Real pressure_O2; // Partial pressure of O2
  input Real R_O_FC; // Ohmic restitance of stack
  input Real A_fc; // Area of FC stack
  input Real i_0; // FC stack cell exchange current
  input Real i_L; // FC stack cell maximum limiting current A/cm2
  input Real i; // current
  output Real V; // Voltage of stack
algorithm
  V := N_FC*(1.229 - (Modelica.Constants.R*temp)/(2*Modelica.Constants.F)*log(pressure_H2*(pressure_O2^0.5)) - (0.85*0.001)*(temp - 298.15) - R_O_FC*(abs(i)/A_fc) - (Modelica.Constants.R*temp)/(2*Modelica.Constants.F*0.3419)*log(max(abs((i/A_fc)/i_0), 0.00001)) + (Modelica.Constants.R*1.4672*temp)/(2*Modelica.Constants.F)*log(1 - (abs(i/A_fc)/i_L)));
annotation(Documentation(info = "<html><p>Calculates the fuel-cell voltage used by the equivalent-consumption minimization controller.</p></html>"));
end calcFCV;
