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
  output Modelica.Units.SI.Voltage V;   // Voltage of stack
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

  annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Estimates total fuel-cell stack voltage as the Nernst voltage minus activation, ohmic, and mass-transport losses. Stack current is divided by active area to obtain current density. Each voltage contribution is multiplied by N_FC. The activation logarithm is limited below by one, and the limiting-current logarithm denominator is bounded by a small positive current density. The ohmic term scales with R_ref, temperature, and the hydration factor phi, which must be nonzero. Temperature, active area, and reactant partial pressures must be positive.</p><p>Note: Must rethink this approach.&nbsp;</p>
<h2>Governing Equations</h2>
<pre>i_0 = 0.03;
R_ref = 0.15e-4;
i_limit = 16000;
alpha = 1;
i_epsilon = 1E-39*i_limit;
i_area := i/A_fc;
Nernst := N_FC*(E0 + Modelica.Constants.R*temp/(n_e*Modelica.Constants.F)*Modelica.Math.log(pressure_H2/p_ref *(pressure_O2/p_ref)^0.5) + delta_S/(n_e*Modelica.Constants.F)*(temp - T_ref));
activation := N_FC * Modelica.Constants.R * temp / (alpha * Modelica.Constants.F) * Modelica.Math.log(max(i_area/i_0,1));
ohmic := N_FC * (R_ref*Modelica.Math.exp(1/temp - 1/T_ref) / phi) * i_area;
massTransport := N_FC * Modelica.Constants.R*temp/(N*Modelica.Constants.F) * log(i_limit/max(i_limit-i_area, i_epsilon));
V := Nernst - activation - ohmic - massTransport;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>i</code></td><td>Fuel cell current</td></tr>
<tr><td><code>i_0</code></td><td>Exchange current density A/m^2 (Barbir 2005)</td></tr>
<tr><td><code>R_ref</code></td><td>(Ohm.m^2) Reference Internal area resistivity (Barbir 2025)</td></tr>
<tr><td><code>i_limit</code></td><td>Limiting current A/m^2 (Barbir 2005)</td></tr>
<tr><td><code>alpha</code></td><td>Charge transfer coefficient (-)</td></tr>
<tr><td><code>i_epsilon</code></td><td>Very small positive current density</td></tr>
</tbody></table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>N_FC</code></td><td>Input signal</td><td>Integer</td><td>1</td><td>Number of fuel-cell stack cells</td></tr>
<tr><td><code>temp</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>Stack temperature</td></tr>
<tr><td><code>pressure_H2</code></td><td>Input signal</td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td>Hydrogen partial pressure</td></tr>
<tr><td><code>pressure_O2</code></td><td>Input signal</td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td>Oxygen partial pressure</td></tr>
<tr><td><code>i</code></td><td>Input signal</td><td>Modelica.Units.SI.Current</td><td>A</td><td>Fuel cell current</td></tr>
<tr><td><code>A_fc</code></td><td>Input signal</td><td>Modelica.Units.SI.Area</td><td>m2</td><td>Active area used to convert current to current density</td></tr>
<tr><td><code>i_0</code></td><td>Input signal</td><td>Modelica.Units.SI.CurrentDensity</td><td>-</td><td>Exchange current density A/m^2 (Barbir 2005)</td></tr>
<tr><td><code>R_ref</code></td><td>Input signal</td><td>VirtualFCS.Electrochemical.ArealResistivity</td><td>-</td><td>(Ohm.m^2) Reference Internal area resistivity (Barbir 2025)</td></tr>
<tr><td><code>i_limit</code></td><td>Input signal</td><td>Modelica.Units.SI.CurrentDensity</td><td>-</td><td>Limiting current A/m^2 (Barbir 2005)</td></tr>
<tr><td><code>alpha</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Charge transfer coefficient (-)</td></tr>
<tr><td><code>phi</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Hydration factor in the ohmic-loss correlation</td></tr>
<tr><td><code>V</code></td><td>Output signal</td><td>Modelica.Units.SI.Voltage</td><td>V</td><td>Total stack voltage</td></tr>
</tbody></table>

</body></html>"));
end fcVoltage;
