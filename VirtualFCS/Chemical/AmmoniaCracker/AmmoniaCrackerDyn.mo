within VirtualFCS.Chemical.AmmoniaCracker;

model AmmoniaCrackerDyn "Dynamic (lumped-volume per segment) ammonia cracker. Same kinetics as AmmoniaCracker, but each of the N computational segments is a Modelica.Fluid.Interfaces.PartialLumpedVolume-style control volume so that transient pressure build-up is captured."
  extends AmmoniaCrackerInterface;
 
  // Import relevant packages
  import Modelica.Fluid.Utilities.regRoot;
  import Modelica.Fluid.Utilities.regSquare;
  import Modelica.Fluid.Utilities.regStep;
 
  // Define constant parameters
  constant Real M_NH3 = 17 "Molar mass g/mol";
  constant Real M_H2 = 2 "Molar mass g/mol";
  constant Real M_N2 = 28 "Molar mass g/mol";
  constant Integer nu_NH3 = -1 "Stoichiometric coefficient for ammonia in ammonia decomposition reaction";
  constant Real nu_N2 = 0.5 "Stoichiometric coefficient for nitrogen in ammonia decomposition reaction";
  constant Real nu_H2 = 1.5 "Stoichiometric coefficient for hydrogen in ammonia decomposition reaction";
  constant Real Ea = 1.54e5 "Activation energy (J/mol)";
  constant Real a = 0.37 "Kinetic parameter Co-Ba/CeO2 catalyst (Realpe 2023)";
  constant Real b = -1.04 "Kinetic parameter Co-Ba/CeO2 catalyst (Realpe 2023)";
  constant Real R = 8.314 "Gas constant (J/mol/K)";
  // SI molar masses (kg/mol) used consistently in the balances
  constant Modelica.Units.SI.MolarMass MM_NH3 = M_NH3/1000;
  constant Modelica.Units.SI.MolarMass MM_H2 = M_H2/1000;
  constant Modelica.Units.SI.MolarMass MM_N2 = M_N2/1000;
  constant Integer idx_NH3 = 1 "Index of ammonia in Medium's X array";
  constant Integer idx_H2 = 2 "Index of hydrogen in Medium's X array";
  constant Integer idx_N2 = 3 "Index of nitrogen in Medium's X array";
  // Reactor geometry parameters
  parameter Modelica.Units.SI.Length H = 12.0 "Reactor height (m)";
  parameter Modelica.Units.SI.Length L = 1.0 "Reactor length (m)";
  parameter Modelica.Units.SI.Length W = 1.2 "Reactor width (m)";
  parameter Modelica.Units.SI.Length pitch = 10e-2 "Space separation between tubes (where hot stream flows)";
  parameter Real z_head = 0.166 "Fraction of reactor length needed as header space at the inflow + outflow of the reactor";
  parameter Modelica.Units.SI.Length D_tubes = 10e-2 "Tubes diameter (m)";
  parameter Modelica.Units.SI.Length t_tubes = 5e-3 "Tubes wall thickness(m)";
  parameter Real W_cat = 4 "Mass loading catalyst in reactor (g/m^2)";
  // Flow and thermodynamic parameters
  parameter Modelica.Units.SI.Temperature T_out_target = 550 + 273.15 "Outlet temperature target(K)";
  parameter Modelica.Units.SI.Temperature T_start = 550 + 273.15 "Start temperature for whole reactor length";
  // Reaction energetics
  parameter Modelica.Units.SI.MolarEnergy deltaH_rxn = 46.0e3 "Endothermic enthalpy of the ammonia decomposition reaction per mol of NH3 converted (J/mol)";
  parameter Modelica.Units.SI.Temperature T_a = 293.15 "Ambient temperature used by external thermal boundary models (K)";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer U_tot = 1 "Heat transfer coefficient to atmosphere (W/m2/K)";
  // Solid (tube wall + catalyst) thermal inertia seen by the gas
  parameter Modelica.Units.SI.Density rho_wall = 7850 "Tube wall material density (kg/m3)";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_wall = 500 "Tube wall material specific heat capacity (J/kg/K)";
  // Dynamics options
  parameter Modelica.Units.SI.Pressure p_start = 30e5 "Initial pressure in every segment";
  parameter Modelica.Units.SI.MassFraction X_start[3] = {0.998, 0.001, 0.001} "Initial mass fractions {NH3, H2, N2} in every segment";
  // Numerical regularization
  parameter Modelica.Units.SI.Pressure dp_small = 1e3 "Regularization range of the inlet and outlet face pressure drop (Pa)";
  parameter Modelica.Units.SI.Pressure dp_small_internal = 1e8 "Regularization range of the internal face pressure drop (Pa); a large value adds a small linear numerical resistance between segments";
  parameter Modelica.Units.SI.Time tau_rxn_min = 0.05 "Minimum time in which the NH3 inventory of a segment may be consumed (limits the reaction rate)";
  parameter Modelica.Units.SI.Pressure dp_inlet_nominal = 0 "Pressure loss of the inlet header/distributor at m_flow_nominal (added to the inlet face)";
  parameter Modelica.Units.SI.Pressure dp_outlet_nominal = 0 "Pressure loss of the outlet header at m_flow_nominal (added to the outlet face)";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 0.03 "Nominal feed mass flow rate used to scale dp_inlet_nominal";
  parameter Modelica.Units.SI.MassFlowRate m_flow_small = 1e-3 "Flow range over which the upwind face composition switches smoothly between the two neighbours";
  parameter Modelica.Units.SI.DynamicViscosity mu_nominal = 3.5e-5 "Viscosity used to evaluate the friction factor at nominal flow";
  // Calculated parameters
  final parameter Real k0 = 3.33/3.6*1e10 "Pre-exponential factor (mol/(kg*s))";
  final parameter Modelica.Units.SI.Length z_tube = H*(1 - z_head) "Tubes length(m)";
  final parameter Modelica.Units.SI.Length dz = z_tube/N "Segment length (m)";
  final parameter Modelica.Units.SI.Area A_r = N_tubes*2*Modelica.Constants.pi*(D_tubes - t_tubes)/2*z_tube "Catalyst-covered reaction area (m^2)";
  final parameter Modelica.Units.SI.Area A_c = Modelica.Constants.pi*(D_tubes/2)^2 "Cross-sectional area of one tube (m^2)";
  final parameter Modelica.Units.SI.Area A_flow = N_tubes*A_c "Total flow cross-sectional area (m^2)";
  final parameter Modelica.Units.SI.Area A_s = 2*(H*L + W*L + H*W) "External walls surface area (m^2)";
  final parameter Integer N_tubes_x = integer(floor((L + pitch)/(D_tubes + pitch))) "Number of tubes along length of reactor";
  final parameter Integer N_tubes_y = integer(floor((W + pitch)/(D_tubes + pitch))) "Number of tubes along width of reactor";
  final parameter Integer N_tubes = N_tubes_x*N_tubes_y "Number of tubes in the reactor";
  final parameter Modelica.Units.SI.Length z[N] = {dz*i - dz/2 for i in 1:N} "Distances from the centre of the segments to the inlet";
  final parameter Modelica.Units.SI.Volume V_seg = A_flow*dz "Gas volume of one computational segment (m^3)";
  final parameter Real m_cat_seg = W_cat*A_r/N "Catalyst mass in one segment (g)";
  final parameter Modelica.Units.SI.HeatCapacity C_solid_seg = N_tubes*Modelica.Constants.pi*(D_tubes - t_tubes)*t_tubes*dz*rho_wall*cp_wall "Tube wall heat capacity per segment (J/K)";
  final parameter Real deltaG_0 = 95517 - 193.67*T_out_target - 0.035293*T_out_target^2 + (9.22*10e-6*T_out_target^3);
  final parameter Real k_eq = exp(-deltaG_0/R/T_out_target) "Equilibrium constant for the ammonia decomposition reaction";
  final parameter Modelica.Units.SI.Density rho_start = p_start/(R*T_start*(X_start[idx_H2]/MM_H2 + X_start[idx_N2]/MM_N2 + X_start[idx_NH3]/MM_NH3)) "Initial mixture density (ideal gas)";
  final parameter Real Re_nominal = m_flow_nominal*D_tubes/(A_flow*mu_nominal) "Reynolds number at nominal flow";
  final parameter Real f_nominal = frictionFactor(Re_nominal) "Friction factor at nominal flow";
   Modelica.Units.SI.MassFlowRate m_flow_balance "Variable that checks reactor's mass conservation";

  // Segment states (lumped volume inventories, PartialLumpedVolume style)
  Modelica.Units.SI.Mass m_H2[N](each start = X_start[idx_H2]*rho_start*V_seg, each fixed = true) "H2 inventory of each segment";
  Modelica.Units.SI.Mass m_N2[N](each start = X_start[idx_N2]*rho_start*V_seg, each fixed = true) "N2 inventory of each segment";
  Modelica.Units.SI.Mass m_NH3[N](each start = X_start[idx_NH3]*rho_start*V_seg, each fixed = true) "NH3 inventory of each segment";
  Modelica.Units.SI.Temperature T[N](each start = T_start, each fixed = false) "Gas temperature of each segment (K)";
 
  // Segment quantities
  Modelica.Units.SI.Mass m_tot[N] "Total gas inventory of each segment";
  Modelica.Units.SI.Density rho_mix[N] "Mixture density of each segment";
  Modelica.Units.SI.MassFraction w_H2[N] "H2 mass fraction of each segment";
  Modelica.Units.SI.MassFraction w_N2[N] "N2 mass fraction of each segment";
  Modelica.Units.SI.MassFraction w_NH3[N] "NH3 mass fraction of each segment";
  Modelica.Units.SI.AmountOfSubstance n_H2[N] "H2 moles in each segment";
  Modelica.Units.SI.AmountOfSubstance n_N2[N] "N2 moles in each segment";
  Modelica.Units.SI.AmountOfSubstance n_NH3[N] "NH3 moles in each segment";
  Real mol_frac_NH3[N] "Molar fraction NH3 (mol_i/mol_tot)";
  Real mol_frac_N2[N] "Molar fraction N2 (mol_i/mol_tot)";
  Real mol_frac_H2[N] "Molar fraction H2 (mol_i/mol_tot)";
  Modelica.Units.SI.Pressure P_tot[N] "Total pressure of each segment (Pa)";
  Modelica.Units.SI.Pressure P_NH3[N] "Partial pressure NH3 (Pa)";
  Modelica.Units.SI.Pressure P_N2[N] "Partial pressure N2 (Pa)";
  Modelica.Units.SI.Pressure P_H2[N] "Partial pressure H2 (Pa)";
  Real r_rxn[N](each start = 1) "Rate of ammonia decomposition (mol/(s*g_cat))";
  Modelica.Units.SI.MolarFlowRate R_NH3[N] "NH3 converted in each segment (mol/s)";
  Real NH3_conversion[N] "Fraction of ammonia reacted";
  Modelica.Units.SI.HeatFlowRate Q_rxn[N] "Heat consumed by the reaction in each segment (W)";
  Modelica.Units.SI.HeatFlowRate Q_loss[N] "Heat lost from each segment through the thermal boundary (W)";
 
  // Face (segment boundary) quantities: face j is upstream of segment j, face N+1 is the outlet
  Modelica.Units.SI.MassFlowRate m_flow_face[N + 1] "Mass flow rate through each segment boundary";
  Modelica.Units.SI.MassFraction w_H2_face[N + 1] "Upwind H2 mass fraction at each face";
  Modelica.Units.SI.MassFraction w_N2_face[N + 1] "Upwind N2 mass fraction at each face";
  Modelica.Units.SI.MassFraction w_NH3_face[N + 1] "Upwind NH3 mass fraction at each face";
  Real k_face[N + 1] "Quadratic friction coefficient of each face (Pa/(kg/s)^2)";
  
  // Non-dimensional and transport variables
  Modelica.Units.SI.Velocity v_gas[N] "Gas mixture velocity (m/s)";
  Real Re[N] "Reynolds number";
  Real f[N] "Friction factor";
  Modelica.Units.SI.DynamicViscosity mu_mix[N] "Mixture dynamic viscosity";
  Modelica.Units.SI.SpecificHeatCapacity cp_mix[N] "Mixture specific heat capacity";
 
  // Inlet conditions
  Modelica.Units.SI.SpecificEnergy h_inlet "Mixture inlet specific enthalpy";
  Modelica.Units.SI.Temperature T_in "Mixture inlet temperature";
  Modelica.Units.SI.SpecificEnthalpy h_feed_seg1 "Specific enthalpy of the feed composition at the pressure and temperature of segment 1";
  // Reaction rate

  function rate
    input Real a, b, T, k0, Ea, R, k_eq;
    input Real P_NH3, P_N2, P_H2;
    output Real r;
  algorithm
    r := k0*exp(-Ea/(R*T))*max(P_NH3/1e5, 1e-6)^a*max(P_H2/1e5, 1e-6)^b*(1 - 1/k_eq^2*(P_N2/1e5*max(P_H2/1e5, 1e-6)^3/max(P_NH3/1e5, 1e-6)^2));
  end rate;

  // Compute friction factor

  function frictionFactor
    input Real Re "Reynolds number";
    output Real f "Friction factor";
  protected
    Real Re_lim;
  algorithm
    Re_lim := max(Re, 1e-3);
    if Re_lim < 2300 then
      f := 64/Re_lim;
    elseif Re_lim < 4000 then
      f := (4000 - Re_lim)/(4000 - 2300)*64/Re_lim + (Re_lim - 2300)/(4000 - 2300)*0.3163*Re_lim^(-0.25);
    else
      f := 0.3163*Re_lim^(-0.25);
    end if;
  end frictionFactor;
equation
  for i in 1:N loop
// Inventory of the lumped volume
    m_tot[i] = m_H2[i] + m_N2[i] + m_NH3[i];
    w_H2[i] = m_H2[i]/m_tot[i];
    w_N2[i] = m_N2[i]/m_tot[i];
    w_NH3[i] = m_NH3[i]/m_tot[i];
    n_H2[i] = m_H2[i]/MM_H2;
    n_N2[i] = m_N2[i]/MM_N2;
    n_NH3[i] = m_NH3[i]/MM_NH3;
    mol_frac_H2[i] = n_H2[i]/(n_H2[i] + n_N2[i] + n_NH3[i]);
    mol_frac_N2[i] = n_N2[i]/(n_H2[i] + n_N2[i] + n_NH3[i]);
    mol_frac_NH3[i] = n_NH3[i]/(n_H2[i] + n_N2[i] + n_NH3[i]);
// Equation of state: ideal gas partial pressures give the transient pressure build-up
    P_H2[i] = n_H2[i]*R*T[i]/V_seg;
    P_N2[i] = n_N2[i]*R*T[i]/V_seg;
    P_NH3[i] = n_NH3[i]*R*T[i]/V_seg;
    P_tot[i] = P_H2[i] + P_N2[i] + P_NH3[i];
    NH3_conversion[i] = 1 - mol_frac_NH3[i];
// Mixture transport properties. The density follows from the same ideal-gas assumption as P_tot, so no medium call is needed.
    rho_mix[i] = m_tot[i]/V_seg;
    mu_mix[i] = AmmoniaMedium.dynamicViscosity(AmmoniaMedium.setState_pTX(P_tot[i], T[i], {w_NH3[i], w_H2[i]}));
    cp_mix[i] = AmmoniaMedium.specificHeatCapacityCp(AmmoniaMedium.setState_pTX(P_tot[i], T[i], {w_NH3[i], w_H2[i]}));
    v_gas[i] = m_flow_face[i]/(rho_mix[i]*A_flow);
    Re[i] = rho_mix[i]*abs(v_gas[i])*D_tubes/mu_mix[i];
    f[i] = f_nominal;
    //f[i] = frictionFactor(Re[i]);
// Reaction rate, limited by the NH3 inventory of the segment so that it cannot become negative
    r_rxn[i] = max(0, min(rate(a = a, b = b, T = T[i], k0 = k0, Ea = Ea, R = R, k_eq = k_eq, P_NH3 = P_NH3[i], P_N2 = P_N2[i], P_H2 = P_H2[i]), n_NH3[i]/(tau_rxn_min*m_cat_seg)));
    R_NH3[i] = r_rxn[i]*m_cat_seg;
    Q_rxn[i] = deltaH_rxn*R_NH3[i];
    Q_loss[i] = U_tot*A_s/N*(T[i] - T_a);
// Species mass balances of the lumped volume
    der(m_NH3[i]) = m_flow_face[i]*w_NH3_face[i] - m_flow_face[i + 1]*w_NH3_face[i + 1] + nu_NH3*R_NH3[i]*MM_NH3;
    der(m_H2[i]) = m_flow_face[i]*w_H2_face[i] - m_flow_face[i + 1]*w_H2_face[i + 1] + nu_H2*R_NH3[i]*MM_H2;
    der(m_N2[i]) = m_flow_face[i]*w_N2_face[i] - m_flow_face[i + 1]*w_N2_face[i + 1] + nu_N2*R_NH3[i]*MM_N2;
// Energy balance
// Only the streams entering the segment change its temperature (forward inflow through face i, reverse inflow through face i+1).
// The feed term uses enthalpies so that the latent heat of a partly liquid feed is accounted for.
    (m_tot[i]*cp_mix[i] + C_solid_seg)*der(T[i]) = noEvent(max(m_flow_face[i], 0))*(if i == 1 then h_inlet - h_feed_seg1 else cp_mix[i]*(T[i - 1] - T[i])) + noEvent(max(-m_flow_face[i + 1], 0))*cp_mix[i]*((if i == N then T[N] else T[i + 1]) - T[i]) - Q_loss[i] - Q_rxn[i] + heatPorts[i].Q_flow;
    heatPorts[i].T = T[i];
  end for;
// Upwind (donor cell) face compositions for both flow directions (smooth switch within +-m_flow_small)
  w_NH3_face[1] = regStep(m_flow_face[1], inStream(port_a.Xi_outflow[idx_NH3]), w_NH3[1], m_flow_small);
  w_H2_face[1] = regStep(m_flow_face[1], inStream(port_a.Xi_outflow[idx_H2]), w_H2[1], m_flow_small);
  w_N2_face[1] = 1 - w_NH3_face[1] - w_H2_face[1];
  h_inlet = inStream(port_a.h_outflow);
  T_in = AmmoniaMedium.temperature(AmmoniaMedium.setState_phX(port_a.p, h_inlet, inStream(port_a.Xi_outflow)));
  h_feed_seg1 = AmmoniaMedium.specificEnthalpy(AmmoniaMedium.setState_pTX(P_tot[1], T[1], inStream(port_a.Xi_outflow)));
  for j in 2:N loop
    w_H2_face[j] = regStep(m_flow_face[j], w_H2[j - 1], w_H2[j], m_flow_small);
    w_N2_face[j] = regStep(m_flow_face[j], w_N2[j - 1], w_N2[j], m_flow_small);
    w_NH3_face[j] = regStep(m_flow_face[j], w_NH3[j - 1], w_NH3[j], m_flow_small);
  end for;
  w_NH3_face[N + 1] = regStep(m_flow_face[N + 1], w_NH3[N], inStream(port_b.Xi_outflow[idx_NH3]), m_flow_small);
  w_H2_face[N + 1] = regStep(m_flow_face[N + 1], w_H2[N], inStream(port_b.Xi_outflow[idx_H2]), m_flow_small);
  w_N2_face[N + 1] = 1 - w_NH3_face[N + 1] - w_H2_face[N + 1];
// Quadratic friction coefficients of the faces (half a segment at the inlet and outlet faces)
  k_face[1] = f[1]*(dz/2)/(2*D_tubes*rho_mix[1]*A_flow^2) + dp_inlet_nominal/m_flow_nominal^2;
  k_face[N + 1] = f[N]*(dz/2)/(2*D_tubes*rho_mix[N]*A_flow^2) + dp_outlet_nominal/m_flow_nominal^2;
  for j in 2:N loop
    k_face[j] = f[j - 1]*dz/(2*D_tubes*rho_mix[j - 1]*A_flow^2);
  end for;
// Momentum balance (quasi-static): the internal and outlet faces are pressure driven
// The internal friction is so small that the true face pressure drops lie far below the solver tolerance;
// dp_small_internal linearizes these faces to keep the pressure coupling between segments resolvable at low flow.
  for j in 2:N loop
    m_flow_face[j] = regRoot(P_tot[j - 1] - P_tot[j], dp_small_internal)/sqrt(k_face[j]);
  end for;
  m_flow_face[N + 1] = regRoot(P_tot[N] - port_b.p, dp_small)/sqrt(k_face[N + 1]);
// Connect fluid interfaces
  m_flow_face[1] = port_a.m_flow;
// Same regularised law as the internal faces: finite conductance at low (controlled) feed flows
  m_flow_face[1] = regRoot(port_a.p - P_tot[1], dp_small)/sqrt(k_face[1]);
  port_a.h_outflow = AmmoniaMedium.specificEnthalpy(AmmoniaMedium.setState_pTX(P_tot[1], T[1], {w_NH3[1], w_H2[1]}));
  port_a.Xi_outflow = {w_NH3[1], w_H2[1]};
  port_b.m_flow = -m_flow_face[N + 1];
  port_b.h_outflow = AmmoniaMedium.specificEnthalpy(AmmoniaMedium.setState_pTX(P_tot[N], T[N], {w_NH3[N], w_H2[N]}));
  port_b.Xi_outflow = {w_NH3[N], w_H2[N]};
  m_flow_balance = port_a.m_flow + port_b.m_flow - der(sum(m_tot));
  annotation(
    Documentation(info = "<html><head></head><body>
<h2>1. Parameters and inputs</h2>
<p>Parameters define the reactor geometry, initial inventories, thermal response, and regularization of transport and reaction rates. Types abbreviated as SI refer to Modelica.Units.SI. The medium must support the species order {NH3, H2, N2}, with NH3 and H2 as the two independent mass fractions.</p>
<h3>Geometry and catalyst</h3>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N</code></td><td>Integer</td><td>1</td><td>50</td><td>Number of computational segments and heat ports; inherited from AmmoniaCrackerInterface</td></tr>
<tr><td><code>H</code></td><td>SI.Length</td><td>m</td><td>12.0</td><td>Reactor height</td></tr>
<tr><td><code>L</code></td><td>SI.Length</td><td>m</td><td>1.0</td><td>Reactor length used for tube layout and external surface area</td></tr>
<tr><td><code>W</code></td><td>SI.Length</td><td>m</td><td>1.2</td><td>Reactor width</td></tr>
<tr><td><code>pitch</code></td><td>SI.Length</td><td>m</td><td>10e-2</td><td>Separation between tubes</td></tr>
<tr><td><code>z_head</code></td><td>Real</td><td>1</td><td>0.166</td><td>Fraction of reactor height reserved for headers</td></tr>
<tr><td><code>D_tubes</code></td><td>SI.Length</td><td>m</td><td>10e-2</td><td>Tube diameter used in flow area and friction calculations</td></tr>
<tr><td><code>t_tubes</code></td><td>SI.Length</td><td>m</td><td>5e-3</td><td>Tube wall thickness used in catalyst area and wall heat capacity</td></tr>
<tr><td><code>W_cat</code></td><td>Real</td><td>g/m2</td><td>4</td><td>Catalyst mass per unit reaction area</td></tr>
</tbody></table>
<h3>Thermal conditions and initialization</h3>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>T_out_target</code></td><td>SI.Temperature</td><td>K</td><td>550 + 273.15</td><td>Reference temperature for the equilibrium constant; does not impose the outlet temperature</td></tr>
<tr><td><code>T_start</code></td><td>SI.Temperature</td><td>K</td><td>550 + 273.15</td><td>Temperature start guess and reference for initial density; temperature states have fixed = false</td></tr>
<tr><td><code>p_start</code></td><td>SI.Pressure</td><td>Pa</td><td>30e5</td><td>Reference pressure used to calculate the fixed initial species inventories</td></tr>
<tr><td><code>X_start[3]</code></td><td>SI.MassFraction</td><td>1</td><td>{0.998, 0.001, 0.001}</td><td>Initial mass fractions {NH3, H2, N2}</td></tr>
<tr><td><code>deltaH_rxn</code></td><td>SI.MolarEnergy</td><td>J/mol</td><td>46.0e3</td><td>Endothermic heat demand per mole of NH3 converted</td></tr>
<tr><td><code>T_a</code></td><td>SI.Temperature</td><td>K</td><td>293.15</td><td>Ambient temperature in the segment heat-loss expression</td></tr>
<tr><td><code>U_tot</code></td><td>SI.CoefficientOfHeatTransfer</td><td>W/(m2.K)</td><td>1</td><td>External heat-transfer coefficient</td></tr>
<tr><td><code>rho_wall</code></td><td>SI.Density</td><td>kg/m3</td><td>7850</td><td>Tube wall material density</td></tr>
<tr><td><code>cp_wall</code></td><td>SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>500</td><td>Tube wall material specific heat capacity</td></tr>
</tbody></table>
<h3>Flow and numerical regularization</h3>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>dp_small</code></td><td>SI.Pressure</td><td>Pa</td><td>1e3</td><td>Pressure range for regularizing the square-root flow law at the inlet and outlet faces</td></tr>
<tr><td><code>dp_small_internal</code></td><td>SI.Pressure</td><td>Pa</td><td>1e8</td><td>Pressure range for regularizing the square-root flow law at the internal faces. Below this range the flow law is approximately linear, adding a numerical resistance of about sqrt(k_face*dp_small_internal) between segments. This keeps internal pressure differences resolvable by the solver at low flow; the resulting bed pressure drop is of the order of kPa.</td></tr>
<tr><td><code>tau_rxn_min</code></td><td>SI.Time</td><td>s</td><td>0.05</td><td>Minimum inventory-consumption time used to limit reaction rate</td></tr>
<tr><td><code>dp_inlet_nominal</code></td><td>SI.Pressure</td><td>Pa</td><td>0</td><td>Additional inlet header pressure drop at nominal flow</td></tr>
<tr><td><code>dp_outlet_nominal</code></td><td>SI.Pressure</td><td>Pa</td><td>0</td><td>Additional outlet header pressure drop at nominal flow</td></tr>
<tr><td><code>m_flow_nominal</code></td><td>SI.MassFlowRate</td><td>kg/s</td><td>0.3</td><td>Reference flow for header losses and nominal friction factor</td></tr>
<tr><td><code>m_flow_small</code></td><td>SI.MassFlowRate</td><td>kg/s</td><td>1e-3</td><td>Range for smooth switching of donor-side face compositions</td></tr>
<tr><td><code>mu_nominal</code></td><td>SI.DynamicViscosity</td><td>Pa.s</td><td>3.5e-5</td><td>Viscosity used to calculate the nominal Reynolds number</td></tr>
</tbody></table>
<h3>Calculated parameters</h3>
<p>The following parameters are final and are calculated from the settings above.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>k0</code></td><td>Real</td><td>-</td><td>3.33/3.6*1e10</td><td>Kinetic pre-exponential factor used by rate; see the rate-unit convention below</td></tr>
<tr><td><code>z_tube</code></td><td>SI.Length</td><td>m</td><td>H*(1 - z_head)</td><td>Active tube length</td></tr>
<tr><td><code>dz</code></td><td>SI.Length</td><td>m</td><td>z_tube/N</td><td>Segment length</td></tr>
<tr><td><code>N_tubes_x</code></td><td>Integer</td><td>1</td><td>integer(floor((L + pitch)/(D_tubes + pitch)))</td><td>Number of tubes along the reactor length</td></tr>
<tr><td><code>N_tubes_y</code></td><td>Integer</td><td>1</td><td>integer(floor((W + pitch)/(D_tubes + pitch)))</td><td>Number of tubes along the reactor width</td></tr>
<tr><td><code>N_tubes</code></td><td>Integer</td><td>1</td><td>N_tubes_x*N_tubes_y</td><td>Total number of tubes</td></tr>
<tr><td><code>A_r</code></td><td>SI.Area</td><td>m2</td><td>N_tubes*pi*(D_tubes - t_tubes)*z_tube</td><td>Catalyst-covered reaction area</td></tr>
<tr><td><code>A_c</code></td><td>SI.Area</td><td>m2</td><td>pi*(D_tubes/2)^2</td><td>Cross-sectional area of one tube</td></tr>
<tr><td><code>A_flow</code></td><td>SI.Area</td><td>m2</td><td>N_tubes*A_c</td><td>Total flow area of all tubes</td></tr>
<tr><td><code>A_s</code></td><td>SI.Area</td><td>m2</td><td>2*(H*L + W*L + H*W)</td><td>External heat-loss surface area</td></tr>
<tr><td><code>z[N]</code></td><td>SI.Length</td><td>m</td><td>{dz*i - dz/2 for i in 1:N}</td><td>Segment centre positions measured from the inlet</td></tr>
<tr><td><code>V_seg</code></td><td>SI.Volume</td><td>m3</td><td>A_flow*dz</td><td>Gas volume per segment</td></tr>
<tr><td><code>m_cat_seg</code></td><td>Real</td><td>g</td><td>W_cat*A_r/N</td><td>Catalyst mass per segment</td></tr>
<tr><td><code>C_solid_seg</code></td><td>SI.HeatCapacity</td><td>J/K</td><td>N_tubes*pi*(D_tubes - t_tubes)*t_tubes*dz*rho_wall*cp_wall</td><td>Tube wall heat capacity per segment</td></tr>
<tr><td><code>deltaG_0</code></td><td>Real</td><td>J/mol</td><td>95517 - 193.67*T_out_target - 0.035293*T_out_target^2 + 9.22*10e-6*T_out_target^3</td><td>Reference Gibbs-energy expression used for equilibrium</td></tr>
<tr><td><code>k_eq</code></td><td>Real</td><td>1</td><td>exp(-deltaG_0/R/T_out_target)</td><td>Equilibrium constant evaluated at the reference temperature</td></tr>
<tr><td><code>rho_start</code></td><td>SI.Density</td><td>kg/m3</td><td>p_start/(R*T_start*(X_start[2]/MM_H2 + X_start[3]/MM_N2 + X_start[1]/MM_NH3))</td><td>Ideal-gas density used for initial inventories</td></tr>
<tr><td><code>Re_nominal</code></td><td>Real</td><td>1</td><td>m_flow_nominal*D_tubes/(A_flow*mu_nominal)</td><td>Nominal Reynolds number</td></tr>
<tr><td><code>f_nominal</code></td><td>Real</td><td>1</td><td>frictionFactor(Re_nominal)</td><td>Friction factor applied at all segment faces</td></tr>
</tbody></table>
<h3>Inputs and input-side interfaces</h3>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>port_a</code></td><td>Nominal inlet; bidirectional</td><td>FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>Feed pressure, mass flow, stream enthalpy, and composition; medium is AmmoniaMedium</td></tr>
<tr><td><code>heatPorts[N]</code></td><td>Bidirectional thermal interface</td><td>HeatPorts_a</td><td>K; W</td><td>One heat port per segment, at the segment temperature; positive Q_flow supplies heat to the reactor</td></tr>
</tbody></table>
<p>No signal input connectors are declared. Heating and thermal boundary conditions are provided by connected thermal components.</p>
<h2>2. Model description</h2>
<p>AmmoniaCrackerDyn is a segmented catalytic ammonia-decomposition reactor for system-level transient studies. It represents the conversion of ammonia into hydrogen and nitrogen, gas accumulation, pressure-driven transport, and thermal response of the gas and tube walls. Applications include studying feed changes, outlet throttling, and coupling to distributed heaters, gas separation, and hydrogen-consuming equipment.</p>
<p>Each of the N segments contains separate NH3, H2, and N2 mass inventories. Ideal-gas partial pressures determine segment pressure. Adjacent segments exchange mass through regularized quadratic pressure-loss laws, with half-segment friction at the inlet and outlet and optional additional header losses. Face compositions use a smoothed donor-cell formulation for forward and reverse flow. The friction factor is fixed at its nominal-flow value; the locally calculated Reynolds number is a diagnostic, not a friction feedback.</p>
<p>A dynamic temperature balance is solved in every segment. Gas and tube wall share one temperature and a combined heat capacity. Heat supplied through heatPorts balances inflow thermal transport, endothermic reaction demand, and heat exchange with ambient. The forward inlet term uses the incoming stream enthalpy and the enthalpy of the feed composition at segment conditions. Internal transport uses a specific-heat approximation; at the outlet, reverse thermal inflow is approximated at the last segment temperature rather than using the external outlet stream enthalpy.</p>
<p>Species inventories have fixed initial values calculated from p_start, T_start, and X_start. Temperature start values are not fixed, so the surrounding model must provide suitable initialization conditions. T_out_target is used to evaluate k_eq and is not a temperature constraint or an internal controller set-point.</p>
<h2>3. Governing equations and references</h2>
<p>The reaction stoichiometry per mole of ammonia consumed is NH3 -&gt; 1.5 H2 + 0.5 N2. Representative segment equations are:</p>
<pre>m_tot[i] = m_NH3[i] + m_H2[i] + m_N2[i]
P_tot[i] = (n_NH3[i] + n_H2[i] + n_N2[i])*R*T[i]/V_seg
der(m_species[i]) = inlet species flow - outlet species flow
                    + nu_species*R_NH3[i]*MM_species
r_rxn[i] = max(0, min(rate(...), n_NH3[i]/(tau_rxn_min*m_cat_seg)))
R_NH3[i] = r_rxn[i]*m_cat_seg
Q_rxn[i] = deltaH_rxn*R_NH3[i]
Q_loss[i] = U_tot*A_s/N*(T[i] - T_a)
(m_tot[i]*cp_mix[i] + C_solid_seg)*der(T[i])
  = inflow thermal transport - Q_loss[i] - Q_rxn[i] + heatPorts[i].Q_flow
m_flow_face[j] = regRoot(upstream pressure - downstream pressure, dp_reg)
                 /sqrt(k_face[j])
dp_reg = dp_small at the inlet and outlet faces, dp_small_internal at the internal faces</pre>
<p>The quadratic friction between neighbouring segments is very small, so the physical internal pressure drops are much smaller than the absolute tolerance of the segment pressures. Without additional regularization, the internal face flows become dominated by solver noise at low feed flow, causing very small step sizes. The default dp_small_internal = 1e8 Pa makes these faces effectively linear. This has a negligible effect on the overall pressure profile and outlet conditions.</p>
<p>The kinetic expression follows Realpe et al. (2023), <a href=\"https://doi.org/10.1039/d2re00408a\">doi:10.1039/d2re00408a</a>, with activation energy Ea = 1.54e5 J/mol and exponents a = 0.37 and b = -1.04 for the Co-Ba/CeO2 catalyst. Partial pressures are divided by 1e5 in the rate expression; NH3 and H2 pressure ratios are floored at 1e-6. Negative net kinetic rates are clipped to zero, so the model does not implement reverse ammonia synthesis. The inventory-based upper limit restricts ammonia consumption on the timescale tau_rxn_min.</p>
<p>As implemented, r_rxn is interpreted as mol/(s.g_cat) and multiplied by m_cat_seg in grams. The k0 declaration describes its units as mol/(kg.s); this convention should be checked when changing or calibrating catalyst data. Species balances use SI molar masses MM_NH3 = 0.017, MM_H2 = 0.002, and MM_N2 = 0.028 kg/mol.</p>
<p>The nominal friction factor uses 64/Re for laminar flow, a linear blend between Re = 2300 and 4000, and 0.3163*Re^(-0.25) above 4000. The function floors Re at 1e-3. Positive segment volumes, flow areas, nominal flow, regularization scales, and physically consistent initial compositions are required.</p>
<p>The model follows a lumped-inventory approach similar to <a href=\"modelica://Modelica.Fluid.Interfaces.PartialLumpedVolume\">Modelica.Fluid.Interfaces.PartialLumpedVolume</a>, but implements its own species and approximate temperature balances rather than extending that class. Medium properties are supplied by <a href=\"modelica://VirtualFCS.Media.CrackedAmmonia\">CrackedAmmonia</a> by default.</p>
<h2>4. Outputs</h2>
<p>No signal output connectors are declared. The nominal outlet and selected internal variables are available below. Array indices 1 and N identify the inlet-side and outlet-side segments.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>port_b</code></td><td>Nominal outlet; bidirectional</td><td>FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Outlet connection; outflow enthalpy and composition are calculated from segment N</td></tr>
<tr><td><code>T[N]</code></td><td>Monitored state array</td><td>SI.Temperature</td><td>K</td><td>Segment temperatures</td></tr>
<tr><td><code>P_tot[N]</code></td><td>Monitored array</td><td>SI.Pressure</td><td>Pa</td><td>Total segment pressures</td></tr>
<tr><td><code>m_NH3[N], m_H2[N], m_N2[N]</code></td><td>Monitored state arrays</td><td>SI.Mass</td><td>kg</td><td>Species inventories per segment</td></tr>
<tr><td><code>w_NH3[N], w_H2[N], w_N2[N]</code></td><td>Monitored arrays</td><td>SI.MassFraction</td><td>1</td><td>Segment species mass fractions</td></tr>
<tr><td><code>mol_frac_NH3[N], mol_frac_H2[N], mol_frac_N2[N]</code></td><td>Monitored arrays</td><td>Real</td><td>1</td><td>Segment species mole fractions</td></tr>
<tr><td><code>NH3_conversion[N]</code></td><td>Monitored array</td><td>Real</td><td>1</td><td>Defined as 1 - mol_frac_NH3[i]; a composition indicator, not a feed-referenced conversion</td></tr>
<tr><td><code>R_NH3[N]</code></td><td>Monitored array</td><td>SI.MolarFlowRate</td><td>mol/s</td><td>Ammonia consumption rate per segment</td></tr>
<tr><td><code>Q_rxn[N], Q_loss[N]</code></td><td>Monitored arrays</td><td>SI.HeatFlowRate</td><td>W</td><td>Reaction heat demand and ambient heat loss per segment</td></tr>
<tr><td><code>m_flow_face[N + 1]</code></td><td>Monitored array</td><td>SI.MassFlowRate</td><td>kg/s</td><td>Mass flows at segment faces; positive in the nominal inlet-to-outlet direction</td></tr>
<tr><td><code>m_flow_balance</code></td><td>Monitored variable</td><td>SI.MassFlowRate</td><td>kg/s</td><td>port_a.m_flow + port_b.m_flow - der(sum(m_tot)); total mass-balance residual</td></tr>
<tr><td><code>T_in</code></td><td>Monitored variable</td><td>SI.Temperature</td><td>K</td><td>Temperature inferred from the incoming port_a stream</td></tr>
</tbody></table>
</body></html>"),
    Icon(graphics = {Text(extent = {{-100, 100}, {100, 66}}, textString = "%name"), Text(origin = {26, -49}, textColor = {0, 0, 255}, extent = {{-22, -7}, {22, 7}}, textString = "Dynamic")}));
end AmmoniaCrackerDyn;
