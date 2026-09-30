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
  parameter Boolean constantTemperature = true "= true, the gas temperature is fixed at T_out_target (isothermal first step); = false, a dynamic energy balance is solved" annotation(
    Evaluate = true,
    choices(checkBox = true));
  parameter Modelica.Units.SI.Pressure p_start = 30e5 "Initial pressure in every segment";
  parameter Modelica.Units.SI.MassFraction X_start[3] = {0.998, 0.001, 0.001} "Initial mass fractions {NH3, H2, N2} in every segment";
 
  // Numerical regularization
  parameter Modelica.Units.SI.Pressure dp_small = 1e3 "Regularization range of the face pressure drop (Pa)";
  parameter Modelica.Units.SI.Time tau_rxn_min = 0.05 "Minimum time in which the NH3 inventory of a segment may be consumed (limits the reaction rate)";
  parameter Modelica.Units.SI.Pressure dp_inlet_nominal = 0 "Pressure loss of the inlet header/distributor at m_flow_nominal (added to the inlet face)";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 0.3 "Nominal feed mass flow rate used to scale dp_inlet_nominal";
  parameter Modelica.Units.SI.MassFlowRate m_flow_small = 1e-3 "Flow range over which the upwind face composition switches smoothly between the two neighbours";
  
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
 
  // Segment states (lumped volume inventories, PartialLumpedVolume style)
  Modelica.Units.SI.Mass m_H2[N](each start = X_start[idx_H2]*rho_start*V_seg, each fixed = true) "H2 inventory of each segment";
  Modelica.Units.SI.Mass m_N2[N](each start = X_start[idx_N2]*rho_start*V_seg, each fixed = true) "N2 inventory of each segment";
  Modelica.Units.SI.Mass m_NH3[N](each start = X_start[idx_NH3]*rho_start*V_seg, each fixed = true) "NH3 inventory of each segment";
  Modelica.Units.SI.Temperature T[N](each start = T_start, each fixed = not constantTemperature) "Gas temperature of each segment (K)";
 
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
  Modelica.Units.SI.MassFlowRate m_flow_balance "Variable that checks reactor's mass conservation";
  Modelica.Units.SI.MassFraction w_H2_face[N + 1] "Upwind H2 mass fraction at each face";
  Modelica.Units.SI.MassFraction w_N2_face[N + 1] "Upwind N2 mass fraction at each face";
  Modelica.Units.SI.MassFraction w_NH3_face[N + 1] "Upwind NH3 mass fraction at each face";
  Real k_face[N + 1] "Quadratic friction coefficient of each face (Pa/(kg/s)^2)";
  
  // Non-dimensional and transport variables
  Modelica.Units.SI.Velocity v_gas[N] "Gas mixture velocity (m/s)";
  Real Re[N] "Reynolds number";
  Real Da[N] "Damkoehler number. Reaction rate vs convective mass transfer";
  Real f[N] "Friction factor";
  Modelica.Units.SI.DynamicViscosity mu_mix[N] "Mixture dynamic viscosity";
  Modelica.Units.SI.SpecificHeatCapacity cp_mix[N] "Mixture specific heat capacity";
  Modelica.Units.SI.SpecificEnergy h_mix[N] "Mixture specific enthalpy";
  
  // Inlet conditions
  Modelica.Units.SI.SpecificEnergy h_inlet "Mixture inlet specific enthalpy";
  Modelica.Units.SI.Temperature T_in "Mixture inlet temperature";
  Modelica.Units.SI.SpecificEnthalpy h_feed_seg1 "Specific enthalpy of the feed composition at the pressure and temperature of segment 1";
  
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
// Mixture transport properties
    rho_mix[i] = AmmoniaMedium.density(AmmoniaMedium.setState_pTX(P_tot[i], T[i], {w_NH3[i], w_H2[i]}));
    mu_mix[i] = AmmoniaMedium.dynamicViscosity(AmmoniaMedium.setState_pTX(P_tot[i], T[i], {w_NH3[i], w_H2[i]}));
    cp_mix[i] = AmmoniaMedium.specificHeatCapacityCp(AmmoniaMedium.setState_pTX(P_tot[i], T[i], {w_NH3[i], w_H2[i]}));
    h_mix[i] = AmmoniaMedium.specificEnthalpy(AmmoniaMedium.setState_pTX(P_tot[i], T[i], {w_NH3[i], w_H2[i]}));
    v_gas[i] = m_flow_face[i]/(rho_mix[i]*A_flow);
    Re[i] = rho_mix[i]*abs(v_gas[i])*D_tubes/mu_mix[i];
    f[i] = frictionFactor(Re[i]);
    Da[i] = k0*exp(-Ea/R/T[i])*P_tot[i]^(a + b)*m_cat_seg*N/max(abs(m_flow_face[1])/MM_NH3, Modelica.Constants.eps);
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
    if constantTemperature then
      T[i] = T_out_target;
    else
// Only the streams entering the segment change its temperature (forward inflow through face i, reverse inflow through face i+1).
// The feed term uses enthalpies so that the latent heat of a partly liquid feed is accounted for.
      (m_tot[i]*cp_mix[i] + C_solid_seg)*der(T[i]) = noEvent(max(m_flow_face[i], 0))*(if i == 1 then h_inlet - h_feed_seg1 else cp_mix[i]*(T[i - 1] - T[i])) + noEvent(max(-m_flow_face[i + 1], 0))*cp_mix[i]*((if i == N then T[N] else T[i + 1]) - T[i]) - Q_loss[i] - Q_rxn[i] + heatPorts[i].Q_flow;

    end if;
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
  k_face[N + 1] = f[N]*(dz/2)/(2*D_tubes*rho_mix[N]*A_flow^2);
  for j in 2:N loop
    k_face[j] = f[j - 1]*dz/(2*D_tubes*rho_mix[j - 1]*A_flow^2);
  end for;
// Momentum balance (quasi-static): the internal and outlet faces are pressure driven
  for j in 2:N loop
    m_flow_face[j] = regRoot(P_tot[j - 1] - P_tot[j], dp_small)/sqrt(k_face[j]);
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
  
  //Inlet/outlet monitoring
   port_a.p          = medium_inlet.p;
   port_a.h_outflow  = medium_inlet.h;
   port_a.Xi_outflow = medium_inlet.Xi;
   
   port_b.p          = medium_outlet.p;
   port_b.h_outflow  = medium_outlet.h;
   port_b.Xi_outflow = medium_outlet.Xi;

  annotation(
    Documentation(info = "<html>
<p>Dynamic version of <code>AmmoniaCracker</code>. The reactor is discretised into <code>N</code> segments and each segment is treated as a lumped control volume following the
<code>Modelica.Fluid.Interfaces.PartialLumpedVolume</code> approach: species inventories are states, the pressure follows from the ideal gas equation of state applied to the
inventory of the volume, and the flow between segments is driven by the pressure difference through a quadratic friction law. This makes the model capture transient
pressure build-up (e.g. when the outlet is throttled or the feed flow changes).</p>
<p>Kinetics (Realpe et al. 2023, DOI: 10.1039/d2re00408a) are unchanged with respect to <code>AmmoniaCracker</code>; the reaction rate is additionally limited by the NH3
inventory of the segment so that the ammonia mass cannot become negative.</p>
<p>Two temperature modes are available through <code>constantTemperature</code>:</p>
<ul>
<li><code>true</code> (default): every segment is kept at the inlet temperature <code>T_in</code> (isothermal first step).</li>
<li><code>false</code>: a dynamic energy balance is solved per segment between the convective enthalpy transport, the endothermic heat of reaction
<code>deltaH_rxn</code> and the heat supplied by the external model through the segmented heat port vector <code>heatPorts[N]</code>. The thermal inertia of the tube walls
is included via <code>C_solid_seg</code>.</li>
</ul>
<p>Note that, unlike <code>AmmoniaCracker</code>, all balances use SI molar masses (kg/mol) and the total flow area of all tubes.</p>
</html>"),
    Icon(graphics = {Rectangle(fillColor = {215, 230, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Text(extent = {{-100, 100}, {100, 66}}, textString = "%name"), Text(extent = {{-80, 30}, {80, -30}}, textString = "NH3 cracker\ndynamic")}));
end AmmoniaCrackerDyn;
