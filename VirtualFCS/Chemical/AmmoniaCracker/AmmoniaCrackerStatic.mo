within VirtualFCS.Chemical.AmmoniaCracker;

model AmmoniaCrackerStatic "Ammonia cracker model based on a tube and shell configuration with catalyst-covered outer tube walls for ammonia decomposition reaction. Simplified model from Realpe et al. 2023. DOI: 10.1039/d2re00408a"
  extends AmmoniaCrackerInterface;
  // Define constant parameters
  constant Modelica.Units.SI.MolarMass M_NH3 = 17/1000 "Molar mass kg/mol";
  constant Modelica.Units.SI.MolarMass M_H2 = 2/1000 "Molar mass kg/mol";
  constant Modelica.Units.SI.MolarMass M_N2 = 28/1000 "Molar mass kg/mol";
  constant Integer nu_NH3 = -1 "Stoichiometric coefficient for ammonia in ammonia decomposition reaction";
  constant Real nu_N2 = 0.5 "Stoichiometric coefficient for nitrogen in ammonia decomposition reaction";
  constant Real nu_H2 = 1.5 "Stoichiometric coefficient for hydrogen in ammonia decomposition reaction";
  constant Real Ea = 1.54e5 "Activation energy (J/mol)";
  constant Real a = 0.37 "Kinetic parameter Co–Ba/CeO2 catalyst (Realpe 2023)";
  constant Real b = -1.04 "Kinetic parameter Co–Ba/CeO2 catalyst (Realpe 2023)";
  constant Real R = 8.314 "Gas constant (J/mol/K)";
  constant Real deltaH = -50000 "Reaction enthalpy (J/mol)";
  constant Modelica.Units.SI.Density rho_NH3_start = 7.04 "Parameter to initialize density-related variables";
  constant Real mol_frac_NH3_in = 1 "Parameter to initialize mol fraction arrays. Assumes pure ammonia at inlet";
  // Reactor geometry parameters
  parameter Modelica.Units.SI.Length H = 4.0 "Reactor height (m)";
  parameter Modelica.Units.SI.Length L = 1.0 "Reactor length (m)";
  parameter Modelica.Units.SI.Length W = 1.2 "Reactor width (m)";
  parameter Modelica.Units.SI.Length pitch = 10e-2 "Space separation between tubes (where hot stream flows)";
  parameter Real z_head = 0.166 "Fraction of reactor length needed as header space at the inflow + outflow of the reactor";
  parameter Modelica.Units.SI.Length D_tubes = 10e-2 "Tubes diameter (m)";
  parameter Modelica.Units.SI.Length t_tubes = 5e-3 "Tubes wall thickness(m)";
  parameter Real W_cat = 4 "Mass loading catalyst in reactor (g/m^2)";
  // Flow and thermodynamic parameters
  // parameter Modelica.Units.SI.MassFlowRate mf_NH3 = 1 "Inlet mass flow rate ammonia(kg/s)";
  parameter Real T_in_degC = 550 "Inlet temperature (°C)";
  parameter Modelica.Units.NonSI.Temperature_degC T_a = 20 "Ambient temperature (°C)";
  parameter Real U_tot = 1 "Heat transfer coefficient to atmosphere (W/m^2/K) ";

  parameter Integer idx_NH3 = 1 "Index of ammonia in Medium's X array";
  parameter Integer idx_H2 = 2 "Index of hydrogen in Medium's X array";
  parameter Integer idx_N2 = 3 "Index of nitrogen in Medium's X array";
  //parameter Real f = 0.01 "Friction factor (Should calculate it as function as Re)";
  //parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";
  // Calculated parameters
  //protected
  final parameter Real k0 = 3.33/3.6*1e10 "Pre-exponential factor (mol/(kg*s))";
  final parameter Modelica.Units.SI.Temperature T_in = T_in_degC + 273.15 "Inlet temperature (K)";
  final parameter Modelica.Units.SI.Length z_tube = H*(1 - z_head) "Tubes length(m)";
  final parameter Modelica.Units.SI.Area A_r = N_tubes*2*3.1415*(D_tubes - t_tubes)/2*z_tube "Catalyst-covered reaction area (m^2)";
  final parameter Modelica.Units.SI.Area A_c = N_tubes*3.1415*(D_tubes/2)^2 "Cross-sectional area (m^2)";
  final parameter Modelica.Units.SI.Area A_s = 2*(H*L + W*L + H*W) "External walls surface area (m^2)";

  final parameter Integer N_tubes_x = integer(floor((L + pitch)/(D_tubes + pitch))) "Number of tubes along length of reactor";
  final parameter Integer N_tubes_y = integer(floor((W + pitch)/(D_tubes + pitch))) "Number of tubes along width of reactor";
  final parameter Integer N_tubes = N_tubes_x*N_tubes_y "Number of tubes in the reactor";
  final parameter Modelica.Units.SI.Length z[N] = {z_tube/N*i - z_tube/N/2 for i in 1:N} "Vector holding the distances from the center of the segments to the inlet";
  final parameter Real deltaG_0 = 95517 - 193.67*T_in - 0.035293*T_in^2 + (9.22*10e-6*T_in^3);
  final parameter Real k_eq = exp(-deltaG_0/R/T_in) "Equilibrium constant for the ammonia decomposition reaction";
  // Declare variables
  Modelica.Units.SI.Pressure P_out "Outlet pressure";
  Modelica.Units.SI.MassFlowRate m_flow_feed "Total inlet mass flow rate (kg/s)";
  Modelica.Units.SI.MassFlowRate mf_NH3 "Inlet mass flow rate ammonia(kg/s)";
  Modelica.Units.SI.MolarFlowRate mol_flow_NH3_in;
  Modelica.Units.SI.MolarFlowRate mol_flow_H2_in;
  Modelica.Units.SI.MolarFlowRate mol_flow_N2_in;
  Modelica.Units.SI.MassFraction Xi_inlet_stream[AmmoniaMedium.nXi] "Composition entering the inlet connection set";
  Real g_catalyst_mol_flow_NH3 "g catalyst /(mol_NH3/h*)";
  Real NH3_conversion[N] "Fraction of ammonia reacted";
  Real T[N](start = fill(T_in, N)) "Temperature in each segment (K)";
  Real r_rxn[N](start = fill(1, N)) "Rate of ammonia decomposition(mol/(s*g_cat))";
  // Molar flow rates
  Modelica.Units.SI.MolarFlowRate mol_flow_NH3[N](start = fill(10, N), nominal = fill(10, N)) "Molar flow NH3(mol/s)";
  Modelica.Units.SI.MolarFlowRate mol_flow_N2[N] "Molar flow N2(mol/s)";
  Modelica.Units.SI.MolarFlowRate mol_flow_H2[N] "Molar flow H2(mol/s)";
  // Mass flow rate at outlet
  Modelica.Units.SI.MassFraction Xi_outflow_NH3[N] "Mass fraction ammonia outlet";
  Modelica.Units.SI.MassFraction Xi_outflow_H2[N] "Mass fraction hydrogen outlet";
  Modelica.Units.SI.MassFraction Xi_outflow_N2[N] "Mass fraction nitrogen outlet";
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
  Modelica.Units.SI.HeatFlowRate Q_r[N] "Reaction heat W)";
  Modelica.Units.SI.HeatFlowRate Q_loss[N] "Heat lost to ambient (W)";
  Modelica.Units.SI.HeatFlowRate Q_tot "Total heat flow (W)";
  // Declare medium state records and thermodynamic properties
  Modelica.Units.SI.Density rho_mix[N](start = fill(rho_NH3_start, N));
  Modelica.Units.SI.DynamicViscosity mu_mix[N];
  
  AmmoniaMedium.BaseProperties medium_inlet "Medium in the source";
  AmmoniaMedium.BaseProperties medium_outlet "Medium in the source";
  
  // Reaction rate
  function rate
    input Real a, b, T, k0, Ea, R, k_eq;
    input Real P_NH3, P_N2, P_H2;
    output Real r;
  algorithm
    r := k0*exp(-Ea/(R*T))*max(P_NH3/1e5, 1e-6)^a*max(P_H2/1e5, 1e-6)^b*(1 - 1/k_eq^2*(P_N2/1e5*max(P_H2/1e5, 1e-6)^3/max(P_NH3/1e5, 1e-6)^2));
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
  end frictionFactor;

  // Compute mass, momentum and energy balances
equation
     
  g_catalyst_mol_flow_NH3 = W_cat*A_r/(mol_flow_NH3_in*3600);
// Compute variables along reactor length
  for i in 1:N loop
// Momentum balance
    rho_mix[i] = AmmoniaMedium.density(AmmoniaMedium.setState_pTX(P_tot[i], T[i], {Xi_outflow_NH3[i], Xi_outflow_H2[i]}));
    mu_mix[i] = AmmoniaMedium.dynamicViscosity(AmmoniaMedium.setState_pTX(P_tot[i], T[i], {Xi_outflow_NH3[i], Xi_outflow_H2[i]}));
    v_gas[i] = m_flow_feed/rho_mix[i]/A_c;
    P_tot[i] = pressureDrop(v_gas[i], z[i], rho_mix[i], f[i], D_tubes, P_out, z_tube);
    P_NH3[i] = P_tot[i]*mol_frac_NH3[i];
    P_H2[i] = P_tot[i]*mol_frac_H2[i];
    P_N2[i] = P_tot[i]*mol_frac_N2[i];
    NH3_conversion[i] = 1 - mol_flow_NH3[i]/mol_flow_NH3_in;
//Non-dimensional variables
    Re[i] = rho_mix[i]*v_gas[i]*D_tubes/mu_mix[i];
    Da[i] = k0*exp(-Ea/R/T[i])*P_tot[1]^(a + b)/(W_cat*A_r/mol_flow_NH3_in);
    f[i] = frictionFactor(Re[i]);
// Inlet boundary
    if i == 1 then
// Compute reaction rate (minimume ensures no negative ammonia fractions)
      r_rxn[i] = max(0, min(rate(a = a, b = b, T = T[i], k0 = k0, Ea = Ea, R = R, k_eq = k_eq, P_NH3 = P_NH3[i], P_N2 = P_N2[i], P_H2 = P_H2[i]), mol_flow_NH3_in/W_cat/A_r*N));
      
// Mass balance
      mol_flow_NH3[i] = mol_flow_NH3_in + nu_NH3*r_rxn[i]*W_cat*A_r/N;
      mol_flow_H2[i] = mol_flow_H2_in + nu_H2*r_rxn[i]*W_cat*A_r/N;
      mol_flow_N2[i] = mol_flow_N2_in + nu_N2*r_rxn[i]*W_cat*A_r/N;
      mol_frac_NH3[i] = mol_flow_NH3[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      mol_frac_H2[i] = mol_flow_H2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      mol_frac_N2[i] = mol_flow_N2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      Xi_outflow_NH3[i] = mol_flow_NH3[i]*M_NH3/(mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
      Xi_outflow_H2[i] = mol_flow_H2[i]*M_H2/(mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
      Xi_outflow_N2[i] = mol_flow_N2[i]*M_N2/(mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
// Energy balance
      der(T[i]) = 0;
      Q_r[i] = deltaH*W_cat*A_r/N*nu_NH3*r_rxn[i];
      Q_loss[i] = U_tot*A_s/N*(T[i] - T_a);
    else
// Compute reaction rate (minimume ensures no negative ammonia fractions)
      r_rxn[i] = max(0, min(rate(a = a, b = b, T = T[i], k0 = k0, Ea = Ea, R = R, k_eq = k_eq, P_NH3 = P_NH3[i], P_N2 = P_N2[i], P_H2 = P_H2[i]), mol_flow_NH3[i - 1]/W_cat/A_r*N));
// Mass balance
      mol_flow_NH3[i] = mol_flow_NH3[i - 1] + nu_NH3*r_rxn[i]*W_cat*A_r/N;
      mol_flow_H2[i] = mol_flow_H2[i - 1] + nu_H2*r_rxn[i]*W_cat*A_r/N;
      mol_flow_N2[i] = mol_flow_N2[i - 1] + nu_N2*r_rxn[i]*W_cat*A_r/N;
      mol_frac_NH3[i] = mol_flow_NH3[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      mol_frac_H2[i] = mol_flow_H2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      mol_frac_N2[i] = mol_flow_N2[i]/(mol_flow_NH3[i] + mol_flow_H2[i] + mol_flow_N2[i]);
      Xi_outflow_NH3[i] = mol_flow_NH3[i]*M_NH3/(mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
      Xi_outflow_H2[i] = mol_flow_H2[i]*M_H2/(mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
      Xi_outflow_N2[i] = mol_flow_N2[i]*M_N2/(mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
// Energy balance
      der(T[i]) = 0;
      Q_r[i] = deltaH*W_cat*A_r/N*nu_NH3*r_rxn[i];
      Q_loss[i] = U_tot*A_s/N*(T[i] - T_a);
    end if;
  end for;
  
 // Calculate total heat duty
  Q_tot = sum(Q_r) + sum(Q_loss);
// Expose the total heat duty, evenly split, on the segmented heat port
  for i in 1:N loop
    heatPorts[i].Q_flow = Q_tot/N;
  end for;
// Connect fluid interfaces
  m_flow_feed = inlet_nh3_feed.m_flow;
  Xi_inlet_stream = inStream(inlet_nh3_feed.Xi_outflow);
  mf_NH3 = m_flow_feed*Xi_inlet_stream[1];
  mol_flow_NH3_in = mf_NH3/M_NH3;
  mol_flow_H2_in = m_flow_feed*Xi_inlet_stream[2]/M_H2;
  mol_flow_N2_in = m_flow_feed*(1 - sum(Xi_inlet_stream))/M_N2;
  inlet_nh3_feed.h_outflow = AmmoniaMedium.specificEnthalpy(AmmoniaMedium.setState_pTX(P_tot[1], T_in, Xi_inlet_stream));
  inlet_nh3_feed.p = P_tot[1];
  inlet_nh3_feed.Xi_outflow = {Xi_outflow_NH3[1], Xi_outflow_H2[1]};
  outlet_cracked_gas.h_outflow = AmmoniaMedium.specificEnthalpy(AmmoniaMedium.setState_pTX(P_out, T_in, {Xi_outflow_NH3[N], Xi_outflow_H2[N]}));
  outlet_cracked_gas.p = P_out;
  outlet_cracked_gas.m_flow = -m_flow_feed;
  outlet_cracked_gas.Xi_outflow = {Xi_outflow_NH3[N], Xi_outflow_H2[N]};
  
  //Inlet/outlet monitoring
   inlet_nh3_feed.p          = medium_inlet.p;
   inlet_nh3_feed.h_outflow  = medium_inlet.h;
   inlet_nh3_feed.Xi_outflow = medium_inlet.Xi;
   
   outlet_cracked_gas.p          = medium_outlet.p;
   outlet_cracked_gas.h_outflow  = medium_outlet.h;
   outlet_cracked_gas.Xi_outflow = medium_outlet.Xi;
   
  annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>N</code></td><td>Integer</td><td>1</td><td>50</td><td>Number of reactor computational segments</td></tr>
<tr><td><code>H</code></td><td>SI.Length</td><td>m</td><td>12.0</td><td>Reactor height (m)</td></tr>
<tr><td><code>L</code></td><td>SI.Length</td><td>m</td><td>1.0</td><td>Reactor length (m)</td></tr>
<tr><td><code>W</code></td><td>SI.Length</td><td>m</td><td>1.2</td><td>Reactor width (m)</td></tr>
<tr><td><code>pitch</code></td><td>SI.Length</td><td>m</td><td>10e-2</td><td>Space separation between tubes (where hot stream flows)</td></tr>
<tr><td><code>z_head</code></td><td>Real</td><td>1</td><td>0.166</td><td>Fraction of reactor length needed as header space at the inflow + outflow of the reactor</td></tr>
<tr><td><code>D_tubes</code></td><td>SI.Length</td><td>m</td><td>10e-2</td><td>Tubes diameter (m)</td></tr>
<tr><td><code>t_tubes</code></td><td>SI.Length</td><td>m</td><td>5e-3</td><td>Tubes wall thickness(m)</td></tr>
<tr><td><code>W_cat</code></td><td>Real</td><td>1</td><td>0.0045</td><td>Mass loading catalyst in reactor (g/m^2)</td></tr>
<tr><td><code>T_in_degC</code></td><td>Real</td><td>1</td><td>550</td><td>Inlet temperature (°C)</td></tr>
<tr><td><code>k0</code></td><td>Real</td><td>1</td><td>3.33/3.6*1e10</td><td>Pre-exponential factor (mol/(kg*s))</td></tr>
<tr><td><code>T_in</code></td><td>SI.Temperature</td><td>K</td><td>T_in_degC + 273.15</td><td>Inlet temperature (K)</td></tr>
<tr><td><code>z_tube</code></td><td>SI.Length</td><td>m</td><td>H*(1 - z_head)</td><td>Tubes length(m)</td></tr>
<tr><td><code>A_r</code></td><td>SI.Area</td><td>m2</td><td>N_tubes*2*3.1415*(D_tubes - t_tubes)/2*z_tube</td><td>Catalyst-covered reaction area (m^2)</td></tr>
<tr><td><code>A_c</code></td><td>SI.Area</td><td>m2</td><td>3.1415*(D_tubes/2)^2</td><td>Cross-sectional area (m^2)</td></tr>
<tr><td><code>N_tubes_x</code></td><td>Integer</td><td>1</td><td>integer(floor((L + pitch)/(D_tubes + pitch)))</td><td>Number of tubes along length of reactor</td></tr>
<tr><td><code>N_tubes_y</code></td><td>Integer</td><td>1</td><td>integer(floor((W + pitch)/(D_tubes + pitch)))</td><td>Number of tubes along width of reactor</td></tr>
<tr><td><code>N_tubes</code></td><td>Integer</td><td>1</td><td>N_tubes_x*N_tubes_y</td><td>Number of tubes in the reactor</td></tr>
<tr><td><code>z[N]</code></td><td>SI.Length</td><td>m</td><td>{z_tube/N*i - z_tube/N/2 for i in 1:N}</td><td>Vector holding the distances from the center of the segments to the inlet</td></tr>
<tr><td><code>deltaG_0</code></td><td>Real</td><td>1</td><td>95517 - 193.67*T_in - 0.035293*T_in^2 + (9.22*10e-6*T_in^3)</td><td></td></tr>
<tr><td><code>k_eq</code></td><td>Real</td><td>1</td><td>exp(-deltaG_0/R/T_in)</td><td>Equilibrium constant for the ammonia decomposition reaction</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>inlet_nh3_feed</code></td><td>Input-side interface</td><td>FluidPort_a</td><td>-</td><td></td></tr>
<tr><td><code>a</code></td><td>input</td><td>Real</td><td>1</td><td></td></tr>
<tr><td><code>P_NH3</code></td><td>input</td><td>Real</td><td>1</td><td></td></tr>
<tr><td><code>u</code></td><td>input</td><td>Real</td><td>1</td><td>Velocity [m/s]</td></tr>
<tr><td><code>z</code></td><td>input</td><td>Real</td><td>1</td><td>Axial position [m]</td></tr>
<tr><td><code>rho</code></td><td>input</td><td>Real</td><td>1</td><td>Density [kg/m³]</td></tr>
<tr><td><code>f</code></td><td>input</td><td>Real</td><td>1</td><td>Friction factor</td></tr>
<tr><td><code>D</code></td><td>input</td><td>Real</td><td>1</td><td>Hydraulic diameter [m]</td></tr>
<tr><td><code>P_outlet</code></td><td>input</td><td>Real</td><td>1</td><td>Outlet pressure [Pa]</td></tr>
<tr><td><code>L</code></td><td>input</td><td>Real</td><td>1</td><td>Reactor length [m]</td></tr>
<tr><td><code>Re</code></td><td>input</td><td>Real</td><td>1</td><td>Reynolds number</td></tr></tbody></table><h2>2. Model description</h2><p>Alternative simplified tube-and-shell ammonia cracker with catalytic decomposition and heat transfer through the outer tube wall.</p><p>The model is intended for system-level studies.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>g_catalyst_mol_flow_NH3 = W_cat*A_r/(mf_NH3*1000/M_NH3/3600);
state_NH3 = AmmoniaMedium.setState_pTX(P_out, T_in);
state_H2 = HydrogenMedium.setState_pT(P_out, T_in);
state_N2 = NitrogenMedium.setState_pT(P_out, T_in);
rho_NH3 = AmmoniaMedium.density(state_NH3);
rho_H2 = HydrogenMedium.density(state_H2);
rho_N2 = NitrogenMedium.density(state_N2);
mu_NH3 = AmmoniaMedium.dynamicViscosity(state_NH3);</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>outlet_cracked_gas</code></td><td>Output-side interface</td><td>FluidPort_b</td><td>-</td><td></td></tr>
<tr><td><code>r</code></td><td>output</td><td>Real</td><td>1</td><td></td></tr>
<tr><td><code>Pz</code></td><td>output</td><td>Real</td><td>1</td><td>Pressure at position z [Pa]</td></tr>
<tr><td><code>f</code></td><td>output</td><td>Real</td><td>1</td><td>Friction factor</td></tr></tbody></table></body></html>"));
end AmmoniaCrackerStatic;
