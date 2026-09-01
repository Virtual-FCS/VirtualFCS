within VirtualFCS.Electrochemical.Hydrogen.AmmoniaCracker;

model AmmoniaCracker "Ammonia cracker model based on a tube and shell configuration with catalyst-covered outer tube walls for ammonia decomposition reaction. Simplified model from Realpe et al. 2023. DOI: 10.1039/d2re00408a"
  // Import relevant packages
  // Initialize ideal gas Medium objects for the different species
  import Modelica.Media.IdealGases.SingleGases;
  // Define media types
  replaceable package AmmoniaMedium = Media.NH3Cracked;
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
  
  // Mass flow rate at outlet
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
  // Declare medium state records and thermodynamic properties
  AmmoniaMedium.ThermodynamicState state_NH3;
  AmmoniaMedium.ThermodynamicState state_NH3_outlet;
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
  g_catalyst_mol_flow_NH3 = W_cat*A_r/(mf_NH3*1000/M_NH3/3600);
// Calculate the different relevant thermodynamic properties
  state_NH3 = AmmoniaMedium.setState_pTX(P_out, T_in);
  state_NH3_outlet = AmmoniaMedium.setState_pTX(P_out, T_in, outlet_cracked_gas.Xi_outflow);
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
      
      Xi_outflow_H2[i] = mol_flow_H2[i]*M_H2 / (mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
      Xi_outflow_N2[i] = mol_flow_N2[i]*M_N2 / (mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
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
      
      Xi_outflow_H2[i] = mol_flow_H2[i]*M_H2 / (mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
      Xi_outflow_N2[i] = mol_flow_N2[i]*M_N2 / (mol_flow_H2[i]*M_H2 + mol_flow_N2[i]*M_N2 + mol_flow_NH3[i]*M_NH3);
// Energy balance
      der(T[i]) = 0;
    end if;
  end for;
// Connect fluid interfaces
  mf_NH3 = inlet_nh3_feed.m_flow;
  inlet_nh3_feed.h_outflow = AmmoniaMedium.specificEnthalpy(state_NH3);
  inlet_nh3_feed.p = P_tot[1];
  inlet_nh3_feed.Xi_outflow = {Xi_outflow_H2[1], Xi_outflow_N2[1]};
  outlet_cracked_gas.h_outflow = AmmoniaMedium.specificEnthalpy(state_NH3_outlet);
  outlet_cracked_gas.p = P_out;
  outlet_cracked_gas.m_flow = mf_NH3;

  outlet_cracked_gas.Xi_outflow = {Xi_outflow_H2[N], Xi_outflow_N2[N]};


end AmmoniaCracker;
