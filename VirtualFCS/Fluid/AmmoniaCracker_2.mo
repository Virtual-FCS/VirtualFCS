within VirtualFCS.Fluid;

model AmmoniaCracker_2 "Ammonia cracker model based on a tube and shell configuration with catalyst-covered outer tube walls for ammonia decomposition reaction. Simplified model from Realpe et al. 2023. DOI: 10.1039/d2re00408a"
  // Import relevant packages
  // Initialize ideal gas Medium objects for the different species
  import Modelica.Media.IdealGases.SingleGases;
  // Define media types
  replaceable package AmmoniaMedium = VirtualFCS.Media.NH3Cracked;
  package HydrogenMedium = SingleGases.H2;
  package NitrogenMedium = SingleGases.N2;
  // Define interface
  Modelica.Fluid.Interfaces.FluidPort_a inlet_nh3_feed(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {-104, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-104, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b outlet_cracked_gas(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {104, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 22}, extent = {{-10, -10}, {10, 10}})));
  // Define constant parameters
  constant Real M_NH3 = 17 "Molar mass g/mol";
  constant Real M_H2 = 2 "Molar mass g/mol";
  constant Real M_N2 = 28 "Molar mass g/mol";
  constant Integer nu_NH3 = -1 "Stoichiometric coefficient for ammonia in ammonia decomposition reaction";
  constant Real nu_N2 = 0.5 "Stoichiometric coefficient for nitrogen in ammonia decomposition reaction";
  constant Real nu_H2 = 1.5 "Stoichiometric coefficient for hydrogen in ammonia decomposition reaction";
  constant Real Ea = 1.54e5 "Activation energy (J/mol)";
  constant Real a = 0.37 "Kinetic parameter Co–Ba/CeO2 catalyst (Realpe 2023)";
  constant Real b = -1.04 "Kinetic parameter Co–Ba/CeO2 catalyst (Realpe 2023)";
  constant Real R = 8.314 "Gas constant (J/mol/K)";
  constant Real deltaH = -50000 "Reaction enthalpy (J/mol)";
  constant Modelica.Units.SI.Density rho_NH3_start = 7.04 "Parameter to initialize density-related variables";
  constant Real mol_frac_NH3_in = 0.95 "Parameter to initialize mol fraction arrays";
  // Reactor geometry parameters
  parameter Integer N = 50 "Number of reactor computational segments";
  parameter Modelica.Units.SI.Length H = 12.0 "Reactor height (m)";
  parameter Modelica.Units.SI.Length L = 1.0 "Reactor length (m)";
  parameter Modelica.Units.SI.Length W = 1.2 "Reactor width (m)";
  parameter Modelica.Units.SI.Length pitch = 10e-2 "Space separation between tubes (where hot stream flows)";
  parameter Real z_head = 0.166 "Fraction of reactor length needed as header space at the inflow + outflow of the reactor";
  parameter Modelica.Units.SI.Length D_tubes = 10e-2 "Tubes diameter (m)";
  parameter Modelica.Units.SI.Length t_tubes = 5e-3 "Tubes wall thickness(m)";
  parameter Real W_cat = 0.0045 "Mass loading catalyst in reactor (g/m^2)";
  // Flow and thermodynamic parameters
  // parameter Modelica.Units.SI.MassFlowRate mf_NH3 = 1 "Inlet mass flow rate ammonia(kg/s)";
  parameter Real T_in_degC = 550 "Inlet temperature (°C)";
  //parameter Real f = 0.01 "Friction factor (Should calculate it as function as Re)";
  //parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";
  // Calculated parameters
  //protected
  final parameter Real k0 = 3.33/3.6*1e10 "Pre-exponential factor (mol/(kg*s))";
  final parameter Modelica.Units.SI.Temperature T_in = T_in_degC + 273.15 "Inlet temperature (K)";
  final parameter Modelica.Units.SI.Length z_tube = H*(1 - z_head) "Tubes length(m)";
  final parameter Modelica.Units.SI.Area A_r = N_tubes*2*3.1415*(D_tubes - t_tubes)/2*z_tube "Catalyst-covered reaction area (m^2)";
  final parameter Modelica.Units.SI.Area A_c = 3.1415*(D_tubes/2)^2 "Cross-sectional area (m^2)";
  final parameter Integer N_tubes_x = integer(floor((L + pitch)/(D_tubes + pitch))) "Number of tubes along length of reactor";
  final parameter Integer N_tubes_y = integer(floor((W + pitch)/(D_tubes + pitch))) "Number of tubes along width of reactor";
  final parameter Integer N_tubes = N_tubes_x*N_tubes_y "Number of tubes in the reactor";
  final parameter Modelica.Units.SI.Length z[N] = {z_tube/N*i - z_tube/N/2 for i in 1:N} "Vector holding the distances from the center of the segments to the inlet";
  final parameter Real deltaG_0 = 95517 - 193.67*T_in - 0.035293*T_in^2 + (9.22*10e-6*T_in^3);
  final parameter Real k_eq = exp(-deltaG_0/R/T_in) "Equilibrium constant for the ammonia decomposition reaction";
  // Declare variables
  Modelica.Units.SI.Pressure P_out "Outlet pressure";
  Modelica.Units.SI.MassFlowRate mf_NH3 "Inlet mass flow rate ammonia(kg/s)";
  Real g_catalyst_mol_flow_NH3 "g catalyst /(mol_NH3/h*)";
  Real NH3_conversion[N] "Fraction of ammonia reacted";
  Real T[N](start = fill(T_in, N)) "Temperature in each segment (K)";
  Real r_rxn[N](start = fill(1, N)) "Rate of ammonia decomposition(mol/(s*g_cat))";
  // Molar flow rates
  Modelica.Units.SI.MolarFlowRate mol_flow_NH3[N] "Molar flow NH3(mol/s)";
  Modelica.Units.SI.MolarFlowRate mol_flow_N2[N] "Molar flow N2(mol/s)";
  Modelica.Units.SI.MolarFlowRate mol_flow_H2[N] "Molar flow H2(mol/s)";
  // Mol fractions
  Real mol_frac_NH3[N](start = fill(mol_frac_NH3_in, N)) "Molar fraction NH3(mol_i/mol_tot)";
  Real mol_frac_N2[N](start = fill((1 - mol_frac_NH3_in)/2, N)) "Molar fraction N2(mol_i/mol_tot)";
  Real mol_frac_H2[N](start = fill((1 - mol_frac_NH3_in)/2, N)) "Molar fraction H2(mol_i/mol_tot)";
  // Pressures
  Modelica.Units.SI.Pressure P_tot[N] "Reactor total Pressure (Pa)";
  Modelica.Units.SI.Pressure P_NH3[N] "Partial Pressure NH3 (Pa)";
  Modelica.Units.SI.Pressure P_N2[N] "Partial Pressure N2 (Pa)";
  Modelica.Units.SI.Pressure P_H2[N] "Partial Pressure H2 (Pa)";
  // Non-dimentional variables
  Real Re[N] "Reynolds number";
  Real Da[N] "Damköhler number. Reaction rate vs convective mass transfer";
  Real f[N] "Friction factor";
  // Initialize gas velocities along the reactor
  Modelica.Units.SI.Velocity v_gas[N] "Gas mixture velocity (m/s)";
  // Declare medium state records and thermodynamic properties
  AmmoniaMedium.ThermodynamicState state_NH3;
  HydrogenMedium.ThermodynamicState state_H2;
  NitrogenMedium.ThermodynamicState state_N2;
  Modelica.Units.SI.Density rho_NH3(start = rho_NH3_start) "Density ammonia 30 bar 600degC";
  Modelica.Units.SI.Density rho_H2;
  Modelica.Units.SI.Density rho_N2;
  Modelica.Units.SI.Density rho_mix[N](start = fill(rho_NH3_start, N));
  Modelica.Units.SI.DynamicViscosity mu_NH3(start = 2.6e-5) "Dynamic viscosity ammonia 30 bar 600degC";
  Modelica.Units.SI.DynamicViscosity mu_H2;
  Modelica.Units.SI.DynamicViscosity mu_N2;
  Modelica.Units.SI.DynamicViscosity mu_mix[N];
  Modelica.Units.SI.SpecificHeatCapacity cp_NH3 "Heat capacity ammonia";
  Modelica.Units.SI.SpecificHeatCapacity cp_H2;
  Modelica.Units.SI.SpecificHeatCapacity cp_N2;
  // Reaction rate

  function rate
    input Real a, b, T, k0, Ea, R, k_eq;
    input Real P_NH3, P_N2, P_H2;
    output Real r;
  algorithm
    r := k0*exp(-Ea/(R*T))*max(P_NH3/1e5, 1e-6)^a*max(P_H2/1e5, 1e-6)^b*(1 - 1/k_eq^2*(P_N2/1e5*max(P_H2/1e5, 1e-6)^3/max(P_NH3/1e5, 1e-6)^2));
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Rate calculation, evaluating <code>r</code> from <code>a</code>, <code>P_NH3</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>r := k0*exp(-Ea/(R*T))*max(P_NH3/1e5, 1e-6)^a*max(P_H2/1e5, 1e-6)^b*(1 - 1/k_eq^2*(P_N2/1e5*max(P_H2/1e5, 1e-6)^3/max(P_NH3/1e5, 1e-6)^2));</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>a</code></td><td>Input signal</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>P_NH3</code></td><td>Input signal</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>r</code></td><td>Output signal</td><td>Real</td><td>1</td><td>-</td></tr>
</table>
</body>
</html>"));
end rate;

  // Compute Pressure drop

  function pressureDrop
    input Real u "Velocity [m/s]";
    input Real z "Axial position [m]";
    input Real rho "Density [kg/m³]";
    input Real f "Friction factor";
    input Real D "Hydraulic diameter [m]";
    input Real P_outlet "Outlet pressure [Pa]";
    input Real L "Reactor length [m]";
    output Real Pz "Pressure at position z [Pa]";
  algorithm
// Integrate backward from outlet to position z
    Pz := P_outlet + f*(rho*u^2/(2*D))*(L - z);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Pressure Drop calculation, evaluating <code>Pz</code> from <code>u</code> (Velocity [m/s]), <code>z</code> (Axial position [m]), <code>rho</code> (Density [kg/m³]), <code>f</code> (Friction factor), <code>D</code> (Hydraulic diameter [m]), <code>P_outlet</code> (Outlet pressure [Pa]), <code>L</code> (Reactor length [m]). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>Pz := P_outlet + f*(rho*u^2/(2*D))*(L - z);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>u</code></td><td>Velocity [m/s]</td></tr>
<tr><td><code>z</code></td><td>Axial position [m]</td></tr>
<tr><td><code>rho</code></td><td>Density [kg/m³]</td></tr>
<tr><td><code>f</code></td><td>Friction factor</td></tr>
<tr><td><code>D</code></td><td>Hydraulic diameter [m]</td></tr>
<tr><td><code>P_outlet</code></td><td>Outlet pressure [Pa]</td></tr>
<tr><td><code>L</code></td><td>Reactor length [m]</td></tr>
<tr><td><code>Pz</code></td><td>Pressure at position z [Pa]</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>u</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Velocity [m/s]</td></tr>
<tr><td><code>z</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Axial position [m]</td></tr>
<tr><td><code>rho</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Density [kg/m³]</td></tr>
<tr><td><code>f</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Friction factor</td></tr>
<tr><td><code>D</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Hydraulic diameter [m]</td></tr>
<tr><td><code>P_outlet</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Outlet pressure [Pa]</td></tr>
<tr><td><code>L</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Reactor length [m]</td></tr>
<tr><td><code>Pz</code></td><td>Output signal</td><td>Real</td><td>1</td><td>Pressure at position z [Pa]</td></tr>
</table>
</body>
</html>"));
end pressureDrop;

  // Compute friction factor

  function frictionFactor
    input Real Re "Reynolds number";
    output Real f "Friction factor";
  algorithm
// For laminar flow
    if Re < 2300 then
      f := 64/Re;
    elseif Re < 4000 then
      f := (4000 - Re)/(4000 - 2300)*64/Re + (Re - 2300)/(4000 - 2300)*0.3163*Re^(-0.25);
    else
      f := 0.3163*Re^(-0.25);
    end if;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Friction Factor calculation, evaluating <code>f</code> from <code>Re</code> (Reynolds number). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>if Re &lt; 2300 then f := 64/Re;
elseif Re &lt; 4000 then f := (4000 - Re)/(4000 - 2300)*64/Re + (Re - 2300)/(4000 - 2300)*0.3163*Re^(-0.25);
else f := 0.3163*Re^(-0.25);
end if;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>Re</code></td><td>Reynolds number</td></tr>
<tr><td><code>f</code></td><td>Friction factor</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>Re</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Reynolds number</td></tr>
<tr><td><code>f</code></td><td>Output signal</td><td>Real</td><td>1</td><td>Friction factor</td></tr>
</table>
</body>
</html>"));
end frictionFactor;

  // Compute mass, momentum and energy balances
equation
  g_catalyst_mol_flow_NH3 = W_cat*A_r/(mf_NH3*1000/M_NH3/3600);
// Calculate the different relevant thermodynamic properties
  state_NH3 = AmmoniaMedium.setState_pTX(P_out, T_in);
  state_H2 = HydrogenMedium.setState_pT(P_out, T_in);
  state_N2 = NitrogenMedium.setState_pT(P_out, T_in);
// Densities
  rho_NH3 = AmmoniaMedium.density(state_NH3);
  rho_H2 = HydrogenMedium.density(state_H2);
  rho_N2 = NitrogenMedium.density(state_N2);
// Dynamic viscosities
  mu_NH3 = AmmoniaMedium.dynamicViscosity(state_NH3);
  mu_H2 = HydrogenMedium.dynamicViscosity(state_H2);
  mu_N2 = NitrogenMedium.dynamicViscosity(state_N2);
// Heat capacities at constant pressure
  cp_NH3 = AmmoniaMedium.specificHeatCapacityCp(state_NH3);
  cp_H2 = HydrogenMedium.specificHeatCapacityCp(state_H2);
  cp_N2 = NitrogenMedium.specificHeatCapacityCp(state_N2);
// Compute variables along reactor length
  for i in 1:N loop
// Momentum balance
    rho_mix[i] = rho_NH3*mol_frac_NH3[i] + rho_H2*mol_frac_H2[i] + rho_N2*mol_frac_N2[i];
    mu_mix[i] = mu_NH3*mol_frac_NH3[i] + mu_H2*mol_frac_H2[i] + mu_N2*mol_frac_N2[i];
    v_gas[i] = mf_NH3/rho_mix[i]/A_c;
    P_tot[i] = pressureDrop(v_gas[i], z[i], rho_mix[i], f[i], D_tubes, P_out, z_tube);
    P_NH3[i] = P_tot[i]*mol_frac_NH3[i];
    P_H2[i] = P_tot[i]*mol_frac_H2[i];
    P_N2[i] = P_tot[i]*mol_frac_N2[i];
    NH3_conversion[i] = 1 - mol_frac_NH3[i];
//Non-dimensional variables
    Re[i] = rho_mix[i]*v_gas[i]*D_tubes/mu_mix[i];
    Da[i] = k0*exp(-Ea/R/T[i])*P_tot[1]^(a + b)/(W_cat*A_r/(mf_NH3*1000/M_NH3));
    f[i] = frictionFactor(Re[i]);
// Inlet boundary
    if i == 1 then
// Compute reaction rate (minimume ensures no negative ammonia fractions)
      r_rxn[i] = min(rate(a = a, b = b, T = T[i], k0 = k0, Ea = Ea, R = R, k_eq = k_eq, P_NH3 = P_NH3[i], P_N2 = P_N2[i], P_H2 = P_H2[i]), mf_NH3/M_NH3/W_cat/A_r*N);
// Mass balance
      mol_flow_NH3[i] = mf_NH3/M_NH3 + nu_NH3*r_rxn[i]*W_cat*A_r/N;
      mol_flow_H2[i] = nu_H2*r_rxn[i]*W_cat*A_r/N;
      mol_flow_N2[i] = nu_N2*r_rxn[i]*W_cat*A_r/N;
      mol_frac_NH3[i] = mol_flow_NH3[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      mol_frac_H2[i] = mol_flow_H2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      mol_frac_N2[i] = mol_flow_N2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
// Energy balance
      der(T[i]) = 0;
    else
// Compute reaction rate (minimume ensures no negative ammonia fractions)
      r_rxn[i] = min(rate(a = a, b = b, T = T[i], k0 = k0, Ea = Ea, R = R, k_eq = k_eq, P_NH3 = P_NH3[i], P_N2 = P_N2[i], P_H2 = P_H2[i]), mol_flow_NH3[i - 1]/W_cat/A_r*N);
// Mass balance
      mol_flow_NH3[i] = mol_flow_NH3[i - 1] + nu_NH3*r_rxn[i]*W_cat*A_r/N;
      mol_flow_H2[i] = mol_flow_H2[i - 1] + nu_H2*r_rxn[i]*W_cat*A_r/N;
      mol_flow_N2[i] = mol_flow_N2[i - 1] + nu_N2*r_rxn[i]*W_cat*A_r/N;
      mol_frac_NH3[i] = mol_flow_NH3[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      mol_frac_H2[i] = mol_flow_H2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      mol_frac_N2[i] = mol_flow_N2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
// Energy balance
      der(T[i]) = 0;
    end if;
  end for;
// Connect fluid interfaces
  mf_NH3 = inlet_nh3_feed.m_flow;
  inlet_nh3_feed.h_outflow = AmmoniaMedium.specificEnthalpy(state_NH3);
  inlet_nh3_feed.p = P_tot[1];
  inlet_nh3_feed.Xi_outflow = {mol_frac_N2[1], mol_frac_H2[1]};
  outlet_cracked_gas.h_outflow = AmmoniaMedium.specificEnthalpy(state_NH3);
  outlet_cracked_gas.p = P_out;
  outlet_cracked_gas.m_flow = mf_NH3;
  outlet_cracked_gas.Xi_outflow = {mol_frac_H2[N], mol_frac_H2[N]};
// outlet.Xi_outflow is the vector of independent mass fractions (length = Medium.nXi = nX-1)
//outlet_cracked_gas.Xi_outflow = X_full[1:Medium.nXi];
// this component is the state-setter for pressure:
  annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Alternative simplified tube-and-shell ammonia cracker with catalytic decomposition and heat transfer through the outer tube wall.</p><p>The model is intended for system-level studies.</p>
<h2>Governing Equations</h2>
<pre>g_catalyst_mol_flow_NH3 = W_cat*A_r/(mf_NH3*1000/M_NH3/3600);
state_NH3 = AmmoniaMedium.setState_pTX(P_out, T_in);
state_H2 = HydrogenMedium.setState_pT(P_out, T_in);
state_N2 = NitrogenMedium.setState_pT(P_out, T_in);
rho_NH3 = AmmoniaMedium.density(state_NH3);
rho_H2 = HydrogenMedium.density(state_H2);
rho_N2 = NitrogenMedium.density(state_N2);
mu_NH3 = AmmoniaMedium.dynamicViscosity(state_NH3);
mu_H2 = HydrogenMedium.dynamicViscosity(state_H2);
mu_N2 = NitrogenMedium.dynamicViscosity(state_N2);
cp_NH3 = AmmoniaMedium.specificHeatCapacityCp(state_NH3);
cp_H2 = HydrogenMedium.specificHeatCapacityCp(state_H2);
cp_N2 = NitrogenMedium.specificHeatCapacityCp(state_N2);
for i in 1:N loop // Momentum balance rho_mix[i] = rho_NH3*mol_frac_NH3[i] + rho_H2*mol_frac_H2[i] + rho_N2*mol_frac_N2[i];
mu_mix[i] = mu_NH3*mol_frac_NH3[i] + mu_H2*mol_frac_H2[i] + mu_N2*mol_frac_N2[i];
v_gas[i] = mf_NH3/rho_mix[i]/A_c;
P_tot[i] = pressureDrop(v_gas[i], z[i], rho_mix[i], f[i], D_tubes, P_out, z_tube);
P_NH3[i] = P_tot[i]*mol_frac_NH3[i];
P_H2[i] = P_tot[i]*mol_frac_H2[i];
P_N2[i] = P_tot[i]*mol_frac_N2[i];
NH3_conversion[i] = 1 - mol_frac_NH3[i];
Re[i] = rho_mix[i]*v_gas[i]*D_tubes/mu_mix[i];
Da[i] = k0*exp(-Ea/R/T[i])*P_tot[1]^(a + b)/(W_cat*A_r/(mf_NH3*1000/M_NH3));
f[i] = frictionFactor(Re[i]);
if i == 1 then // Compute reaction rate (minimume ensures no negative ammonia fractions) r_rxn[i] = min(rate(a = a, b = b, T = T[i], k0 = k0, Ea = Ea, R = R, k_eq = k_eq, P_NH3 = P_NH3[i], P_N2 = P_N2[i], P_H2 = P_H2[i]), mf_NH3/M_NH3/W_cat/A_r*N);
mol_flow_NH3[i] = mf_NH3/M_NH3 + nu_NH3*r_rxn[i]*W_cat*A_r/N;
mol_flow_H2[i] = nu_H2*r_rxn[i]*W_cat*A_r/N;
mol_flow_N2[i] = nu_N2*r_rxn[i]*W_cat*A_r/N;
mol_frac_NH3[i] = mol_flow_NH3[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
mol_frac_H2[i] = mol_flow_H2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
mol_frac_N2[i] = mol_flow_N2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
der(T[i]) = 0;
else // Compute reaction rate (minimume ensures no negative ammonia fractions) r_rxn[i] = min(rate(a = a, b = b, T = T[i], k0 = k0, Ea = Ea, R = R, k_eq = k_eq, P_NH3 = P_NH3[i], P_N2 = P_N2[i], P_H2 = P_H2[i]), mol_flow_NH3[i - 1]/W_cat/A_r*N);
mol_flow_NH3[i] = mol_flow_NH3[i - 1] + nu_NH3*r_rxn[i]*W_cat*A_r/N;
mol_flow_H2[i] = mol_flow_H2[i - 1] + nu_H2*r_rxn[i]*W_cat*A_r/N;
mol_flow_N2[i] = mol_flow_N2[i - 1] + nu_N2*r_rxn[i]*W_cat*A_r/N;
mol_frac_NH3[i] = mol_flow_NH3[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
mol_frac_H2[i] = mol_flow_H2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
mol_frac_N2[i] = mol_flow_N2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
der(T[i]) = 0;
end if;
end for;
mf_NH3 = inlet_nh3_feed.m_flow;
inlet_nh3_feed.h_outflow = AmmoniaMedium.specificEnthalpy(state_NH3);
inlet_nh3_feed.p = P_tot[1];
inlet_nh3_feed.Xi_outflow = {mol_frac_N2[1], mol_frac_H2[1]};
outlet_cracked_gas.h_outflow = AmmoniaMedium.specificEnthalpy(state_NH3);
outlet_cracked_gas.p = P_out;
outlet_cracked_gas.m_flow = mf_NH3;
outlet_cracked_gas.Xi_outflow = {mol_frac_H2[N], mol_frac_H2[N]};</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>P_out</code></td><td>Outlet pressure</td></tr>
<tr><td><code>mf_NH3</code></td><td>Inlet mass flow rate ammonia(kg/s)</td></tr>
<tr><td><code>g_catalyst_mol_flow_NH3</code></td><td>g catalyst /(mol_NH3/h*)</td></tr>
<tr><td><code>NH3_conversion</code></td><td>Fraction of ammonia reacted</td></tr>
<tr><td><code>T</code></td><td>Temperature in each segment (K)</td></tr>
<tr><td><code>r_rxn</code></td><td>Rate of ammonia decomposition(mol/(s*g_cat))</td></tr>
<tr><td><code>mol_flow_NH3</code></td><td>Molar flow NH3(mol/s)</td></tr>
<tr><td><code>mol_flow_N2</code></td><td>Molar flow N2(mol/s)</td></tr>
<tr><td><code>mol_flow_H2</code></td><td>Molar flow H2(mol/s)</td></tr>
<tr><td><code>mol_frac_NH3</code></td><td>Molar fraction NH3(mol_i/mol_tot)</td></tr>
<tr><td><code>mol_frac_N2</code></td><td>Molar fraction N2(mol_i/mol_tot)</td></tr>
<tr><td><code>mol_frac_H2</code></td><td>Molar fraction H2(mol_i/mol_tot)</td></tr>
<tr><td><code>P_tot</code></td><td>Reactor total Pressure (Pa)</td></tr>
<tr><td><code>P_NH3</code></td><td>Partial Pressure NH3 (Pa)</td></tr>
<tr><td><code>P_N2</code></td><td>Partial Pressure N2 (Pa)</td></tr>
<tr><td><code>P_H2</code></td><td>Partial Pressure H2 (Pa)</td></tr>
<tr><td><code>Re</code></td><td>Reynolds number</td></tr>
<tr><td><code>Da</code></td><td>Damköhler number. Reaction rate vs convective mass transfer</td></tr>
<tr><td><code>f</code></td><td>Friction factor</td></tr>
<tr><td><code>v_gas</code></td><td>Gas mixture velocity (m/s)</td></tr>
<tr><td><code>rho_NH3</code></td><td>Density ammonia 30 bar 600degC</td></tr>
<tr><td><code>mu_NH3</code></td><td>Dynamic viscosity ammonia 30 bar 600degC</td></tr>
<tr><td><code>cp_NH3</code></td><td>Heat capacity ammonia</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N</code></td><td>Integer</td><td>1</td><td><code>50</code></td><td>Number of reactor computational segments</td></tr>
<tr><td><code>H</code></td><td>Modelica.Units.SI.Length</td><td>m</td><td><code>12.0</code></td><td>Reactor height (m)</td></tr>
<tr><td><code>L</code></td><td>Modelica.Units.SI.Length</td><td>m</td><td><code>1.0</code></td><td>Reactor length (m)</td></tr>
<tr><td><code>W</code></td><td>Modelica.Units.SI.Length</td><td>m</td><td><code>1.2</code></td><td>Reactor width (m)</td></tr>
<tr><td><code>pitch</code></td><td>Modelica.Units.SI.Length</td><td>m</td><td><code>10e-2</code></td><td>Space separation between tubes (where hot stream flows)</td></tr>
<tr><td><code>z_head</code></td><td>Real</td><td>1</td><td><code>0.166</code></td><td>Fraction of reactor length needed as header space at the inflow + outflow of the reactor</td></tr>
<tr><td><code>D_tubes</code></td><td>Modelica.Units.SI.Length</td><td>m</td><td><code>10e-2</code></td><td>Tubes diameter (m)</td></tr>
<tr><td><code>t_tubes</code></td><td>Modelica.Units.SI.Length</td><td>m</td><td><code>5e-3</code></td><td>Tubes wall thickness(m)</td></tr>
<tr><td><code>W_cat</code></td><td>Real</td><td>1</td><td><code>0.0045</code></td><td>Mass loading catalyst in reactor (g/m^2)</td></tr>
<tr><td><code>T_in_degC</code></td><td>Real</td><td>1</td><td><code>550</code></td><td>Inlet temperature (°C)</td></tr>
<tr><td><code>k0</code></td><td>Real</td><td>1</td><td><code>3.33/3.6*1e10</code></td><td>Pre-exponential factor (mol/(kg*s))</td></tr>
<tr><td><code>T_in</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>T_in_degC + 273.15</code></td><td>Inlet temperature (K)</td></tr>
<tr><td><code>z_tube</code></td><td>Modelica.Units.SI.Length</td><td>m</td><td><code>H*(1 - z_head)</code></td><td>Tubes length(m)</td></tr>
<tr><td><code>A_r</code></td><td>Modelica.Units.SI.Area</td><td>m2</td><td><code>N_tubes*2*3.1415*(D_tubes - t_tubes)/2*z_tube</code></td><td>Catalyst-covered reaction area (m^2)</td></tr>
<tr><td><code>A_c</code></td><td>Modelica.Units.SI.Area</td><td>m2</td><td><code>3.1415*(D_tubes/2)^2</code></td><td>Cross-sectional area (m^2)</td></tr>
<tr><td><code>N_tubes_x</code></td><td>Integer</td><td>1</td><td><code>integer(floor((L + pitch)/(D_tubes + pitch)))</code></td><td>Number of tubes along length of reactor</td></tr>
<tr><td><code>N_tubes_y</code></td><td>Integer</td><td>1</td><td><code>integer(floor((W + pitch)/(D_tubes + pitch)))</code></td><td>Number of tubes along width of reactor</td></tr>
<tr><td><code>N_tubes</code></td><td>Integer</td><td>1</td><td><code>N_tubes_x*N_tubes_y</code></td><td>Number of tubes in the reactor</td></tr>
<tr><td><code>z</code></td><td>Modelica.Units.SI.Length[N]</td><td>m</td><td><code>{z_tube/N*i - z_tube/N/2 for i in 1:N}</code></td><td>Vector holding the distances from the center of the segments to the inlet</td></tr>
<tr><td><code>deltaG_0</code></td><td>Real</td><td>1</td><td><code>95517 - 193.67*T_in - 0.035293*T_in^2 + (9.22*10e-6*T_in^3)</code></td><td></td></tr>
<tr><td><code>k_eq</code></td><td>Real</td><td>1</td><td><code>exp(-deltaG_0/R/T_in)</code></td><td>Equilibrium constant for the ammonia decomposition reaction</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>inlet_nh3_feed</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td></td></tr>
<tr><td><code>P_NH3</code></td><td>Observed variable</td><td>Modelica.Units.SI.Pressure[N]</td><td>Pa</td><td>Partial Pressure NH3 (Pa)</td></tr>
<tr><td><code>f</code></td><td>Observed variable</td><td>Real[N]</td><td>1</td><td>Friction factor</td></tr>
<tr><td><code>Re</code></td><td>Observed variable</td><td>Real[N]</td><td>1</td><td>Reynolds number</td></tr>
<tr><td><code>outlet_cracked_gas</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td></td></tr>
</table>
</body>
</html>"));
end AmmoniaCracker_2;
