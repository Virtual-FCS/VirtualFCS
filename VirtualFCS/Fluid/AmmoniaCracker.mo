within VirtualFCS.Fluid;

model AmmoniaCracker "Ammonia cracker model based on a tube and shell configuration with catalyst-covered outer tube walls for ammonia decomposition reaction. Simplified model from Realpe et al. 2023. DOI: 10.1039/d2re00408a"
  constant Real M_NH3 = 17 "Molar mass g/mol";
  constant Real M_H2 = 2 "Molar mass g/mol";
  constant Real M_N2 = 28 "Molar mass g/mol";
  constant Integer nu_NH3 = -1 "Stoichiometric coefficient for ammonia in ammonia decomposition reaction";
  constant Real nu_N2 = 0.5 "Stoichiometric coefficient for nitrogen in ammonia decomposition reaction";
  constant Real nu_H2 = 1.5 "Stoichiometric coefficient for hydrohen in ammonia decomposition reaction";
  
  parameter Integer N = 10 "Number of reactor segments";
  parameter Real L = 1.0 "Reactor length (m)";
  parameter Modelica.Units.SI.Length D = 10e-2 "Tubes diameter (m)";
  parameter Real A = 3.1415 * (D/2)^2 "Cross-sectional area (m^2)";
  parameter Modelica.Units.SI.MassFlowRate mf_NH3 = 1.0 "Inlet mass flow rate ammonia(kg/s)";
  parameter Real T_in = 350 "Inlet temperature (K)";
  parameter Real k0 = 3.33/3.6*1e10 "Pre-exponential factor (mol/(kg*s))";
  parameter Real Ea = 1.54e5 "Activation energy (J/mol)";
  parameter Real a = 0.37 "Kinetic parameter";
  parameter Real b = -1.04 "Kinetic parameter";
  parameter Real R = 8.314 "Gas constant (J/mol/K)";
  parameter Real deltaH = -50000 "Reaction enthalpy (J/mol)";
  parameter Real rho = 10 "Fluid density (kg/m^3)";
  parameter Real Cp = 4184 "Heat capacity (J/kg/K)";
  
  parameter Real dz = L / N "Segment length";
  parameter Real V = A * dz "Volume per segment";
  parameter Modelica.Units.SI.Length z[N] = {L/2/N * i for i in 1:N};

  parameter Real W_cat = 10 "Mass catalyst in reactor (g)";
  
  parameter Real f = 0.01 "Friction factor (Should calculate it as function as Re)";
  
  parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";

  Real T[N](start=fill(T_in, N)) "Temperature in each segment (K)";
  Real r_rxn[N](start=fill(0, N)) "Rate of ammonia decomposition(mol/(s*g_cat))";
 
  parameter Real deltaG_0 = 95517 - 193.67 * T_in - 0.035293 * T_in^2 + (9.22 * 10e-6 * T_in^3);
  
  parameter Real k_eq = exp(-deltaG_0/R/T_in) "Equilibrium constant for the ammonia decomposition reaction";
 
  Modelica.Units.SI.MolarFlowRate mol_flow_NH3[N](start=fill(mf_NH3, N)) "Molar flow NH3(mol/s)";
  Modelica.Units.SI.MolarFlowRate mol_flow_N2[N](start=fill(0, N)) "Molar flow N2(mol/s)";
  Modelica.Units.SI.MolarFlowRate mol_flow_H2[N](start=fill(0, N)) "Molar flow H2(mol/s)";
  
  Real mol_frac_NH3[N](start=fill(1, N)) "Molar fraction NH3(mol_i/mol_tot)";
  Real mol_frac_N2[N](start=fill(0, N)) "Molar fraction N2(mol_i/mol_tot)";
  Real mol_frac_H2[N](start=fill(0, N)) "Molar fraction H2(mol_i/mol_tot)";
 
  Modelica.Units.SI.Pressure P_tot[N](start=fill(start = P_init)) "Reactor total Pressure (Pa)";
  Modelica.Units.SI.Pressure P_NH3[N](start=fill(start = P_init)) "Partial Pressure NH3 (Pa)";
  Modelica.Units.SI.Pressure P_N2[N](start=fill(0, N)) "Partial Pressure N2 (Pa)";
  Modelica.Units.SI.Pressure P_H2[N](start=fill(0, N)) "Partial Pressure H2 (Pa)";
  
  // Initialize gas velocities along the reactor
  Modelica.Units.SI.Velocity v_gas[N](start= fill(mf_NH3/rho_mix[1]/A, N)) "Gas mixture velocity (m/s)";


// Initialize ideal gas Medium objects for the different species
 import Modelica.Media.IdealGases.SingleGases;

  // Define media types
  package AmmoniaMedium = SingleGases.NH3;
  package HydrogenMedium = SingleGases.H2;
  package NitrogenMedium = SingleGases.N2;

  // Declare medium state records and thermodynamic properties
  AmmoniaMedium.ThermodynamicState state_NH3;
  HydrogenMedium.ThermodynamicState state_H2;
  NitrogenMedium.ThermodynamicState state_N2;
  
  Modelica.Units.SI.Density rho_NH3(start=7.04) "Initial density ammonia 30 bar 600degC";
  Modelica.Units.SI.Density rho_H2;
  Modelica.Units.SI.Density rho_N2;
  Modelica.Units.SI.Density rho_mix[N](start=fill(rho_NH3, N));
  
  Modelica.Units.SI.SpecificHeatCapacity cp_NH3;
  Modelica.Units.SI.SpecificHeatCapacity cp_H2;
  Modelica.Units.SI.SpecificHeatCapacity cp_N2;
  
  // Reaction rate
  function rate
    input Real a, b, T, k0, Ea, R, k_eq;
    input Real P_NH3, P_N2, P_H2;
    output Real r;
    algorithm
      r := k0 * exp(-Ea / (R*T)) * P_NH3^a * P_H2^b *
         (1 - 1/k_eq^2 * (P_N2 * P_H2^3 / P_NH3^2));
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
  Pz := P_outlet + f * (rho * u^2 / (2 * D)) * (L - z);
end pressureDrop;

equation
  
  // Calculate initial Pressure
  for i in 1:N loop
    P_init[i] = pressureDrop(v_gas[i], z[i], rho_NH3[i], f, D, P_out, L);
  end for;
  // Calculate the different relevant thermodynamic properties
  state_NH3 = AmmoniaMedium.setState_pT(P_out, T_in);
  state_H2 = HydrogenMedium.setState_pT(P_out, T_in);
  state_N2 = NitrogenMedium.setState_pT(P_out, T_in);

  // Densities
  rho_NH3 = AmmoniaMedium.density(state_NH3);
  rho_H2 = HydrogenMedium.density(state_H2);
  rho_N2 = NitrogenMedium.density(state_N2);

  // Heat capacities at constant pressure
  cp_NH3 = AmmoniaMedium.specificHeatCapacityCp(state_NH3);
  cp_H2 = HydrogenMedium.specificHeatCapacityCp(state_H2);
  cp_N2 = NitrogenMedium.specificHeatCapacityCp(state_N2);
  
  for i in 1:N loop
    r_rxn[i] = rate(a=a, b=b, T=T[i], k0=k0, Ea=Ea, R=R, k_eq=k_eq, P_NH3=P_NH3[i], P_N2=P_N2[i], P_H2=P_H2[i]);
    rho_mix[i] = rho_NH3*mol_frac_NH3 + rho_H2*mol_frac_H2 + rho_N2*mol_frac_N2; 
    v_gas[i] = mf_NH3/rho_mix[i]/A;
    P_tot[i] = pressureDrop(v_gas[i], z[i], rho_mix[i], f, D, P_out, L);
    
    if i == 1 then
      // Inlet boundary
      mol_flow_NH3[i] = mf_NH3/M_NH3 + nu_NH3*r_rxn[i]*W_cat/N;
      mol_flow_H2[i] = mf_H2/M_H2 + nu_H2*r_rxn[i]*W_cat/N;
      mol_flow_N2[i] = mf_N2/M_N2 + nu_N2*r_rxn[i]*W_cat/N;
      
      mol_frac_NH3[i] = mol_flow_NH3[i] / (mol_flow_NH3[i] + mol_flow_H2[i] +  mol_flow_N2[i]);
      mol_frac_H2[i] = mol_flow_H2[i] / (mol_flow_NH3[i] + mol_flow_H2[i] +  mol_flow_N2[i]);
      mol_frac_N2[i] = mol_flow_N2[i] / (mol_flow_NH3[i] + mol_flow_H2[i] +  mol_flow_N2[i]);
     
      T[i] = T_in;
    else
      // Mass balance
      mol_flow_NH3[i] = mol_flow_NH3[i-1] + nu_NH3*r_rxn[i]*W_cat/N;
      mol_flow_H2[i] = mol_flow_H2[i-1] + nu_H2*r_rxn[i]*W_cat/N;
      mol_flow_N2[i] = mol_flow_N2[i-1] + nu_N2*r_rxn[i]*W_cat/N;

      mol_frac_NH3[i] = mol_flow_NH3[i] / (mol_flow_NH3[i] + mol_flow_H2[i] +  mol_flow_N2[i]);
      mol_frac_H2[i] = mol_flow_H2[i] / (mol_flow_NH3[i] + mol_flow_H2[i] +  mol_flow_N2[i]);
      mol_frac_N2[i] = mol_flow_N2[i] / (mol_flow_NH3[i] + mol_flow_H2[i] +  mol_flow_N2[i]);
      
     
      
      // Energy balance
      //der(T[i]) = (F/V) * (T[i-1] - T[i]) - (deltaH / (rho * Cp)) * rate(cA[i], T[i], k0, Ea, R);
    end if;
  end for;
end AmmoniaCracker;
