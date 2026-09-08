within VirtualFCS.Fluid;

model Humidifier "Hollow fiber membrane humidifier:
    - Counterflow NTU-based mass exchanger
    - Includes optional first-order dynamics for moisture transfer
    - Based on Pollak et al. (2023)"
  
  extends VirtualFCS.Fluid.HumidifierInterface(redeclare package wet_medium=wet_medium, redeclare package dry_medium=dry_medium);
      
  // Tested with VirtualFCS.Media.CathodeAir -> Still hardcoded with order and number of species in the medium. Can be improved later.
  replaceable package dry_medium = Modelica.Media.Interfaces.PartialMedium "Dry gas (shell side)" annotation(
    choicesAllMatching = true);
  replaceable package wet_medium = Modelica.Media.Interfaces.PartialMedium "Wet side (fiber side)" annotation(
    choicesAllMatching = true);
  import SI = Modelica.Units.SI;
  // Wet (A) and Dry (B) fluid ports
  // Model parameters
  parameter SI.DiffusionCoefficient D_mem = 3.6e-7 "Membrane diffusion coefficient [m2/s] (to be calibrated)";
  parameter SI.Time tau_perm = 6.1 "Time constant for moisture transfer [s] (to be calibrated)";
  // Geometric and packing properties
  parameter Integer nFibers = 488 "Number of hollow fibers";
  parameter SI.Diameter dFiber_i = 0.9e-3 "Inner fiber diameter [m]";
  parameter SI.Diameter dFiber_o = 1.0e-3 "Outer fiber diameter [m]";
  parameter SI.Diameter dHousing = 39.2e-3 "Inner diameter of shell [m]";
  parameter SI.Length L_fiber = 150.8e-3 "Fiber length [m]";
  // Reference values
  SI.ThermodynamicTemperature atm_T = 298.15 "Assumed baseline temp"; // FIXME - should we be using system.T_ambient?
  SI.Pressure atm_P = 101325 "Assumed baseline pressure"; // FIXME - should we be using system.p_ambient?
  SI.DiffusionCoefficient D_H2O_Air_ref = 2.6e-5 "Reference binary diffusion coefficient of H2O in air [m2/s] at 25°C, 1 atm"; // NOTE should this be a variable or a parameter?
  // Numerical stability
  Real eps = 1e-4 "Small number to avoide div by zero";
  SI.MassFlowRate m_flow_min = 1e-9 "Minimum mass flow rate limit to avoid div by zero";
  // Volumetric flow
  SI.VolumeFlowRate V_dot_a, V_dot_b "Volumetric flow rates [m3/s]";
  SI.DimensionlessRatio VFR "Volume flow ratio";
  // Mass transfer velocity
  SI.Velocity v_a, v_b "Flow through fibers [m/s]";
  SI.Velocity h_conv_a, h_conv_b "Convective resistances [m/s]";
  // Geometry-derived variables
  SI.Diameter d_hyd_b "Effective shell hydraulic diameter";
  SI.Area A_mem "Surface area of fibers";
  SI.Area A_c_fibers_in "Cross-section area of fibers inner diameter";
  SI.Area A_c_fibers_out "Cross-section area of fibers outer diameter";
  SI.Area A_c_shell "Cross-section area of humidifier shell";
  SI.Area A_c_shell_gap "Cross-section area of humidifier shell space not occupied by fibers";
  // Transport and dimentionless numbers
  Real Re_a, Sc_a, Re_b, Sc_b;
  Real Sh_wet1, Sh_wet2, Sh_wet;
  SI.DiffusionCoefficient D_H2O_Air "Temperature and pressure dependent binary diffusion coefficient of H2O in air [m2/s]";
  Real Phi, Sh_dry;
  // Mass transfer model
  SI.SpectralConcentration R_conv_a, R_conv_b, R_mem "Resistance [s/m3]";
  SI.VolumeFlowRate beta_eff_a "Effective mass transfer coeff. [m3/s]";
  SI.DimensionlessRatio NTU "Number of transfer units";
  SI.Efficiency eta "Effectiveness";
  // Moisture transfer and dynamics
  SI.MassFlowRate m_perm "Instantaneous permeation mass flow [kg/s]";
  SI.DimensionlessRatio Xi "Normalized permeation state";
  SI.MassFlowRate m_perm_state "Dynamic permeation flow [kg/s]";
  SI.DimensionlessRatio Xi_state(start = 0, fixed = true) "State variable for normalized moisture transfer";
  // Thermodynamics and energy varaibles
  SI.SpecificEnthalpy portA_out_h_outflow, portB_out_h_outflow "Specific enthalpy for the ports";
  SI.EnthalpyFlowRate perm_enthalpy_flow "The enthalpy flow rate for mass transfer";
  // Output /diagnostics
  SI.MoleFraction phi_A_out "Relative humidity of wet gas out";
  SI.MoleFraction phi_B_out "Relative humidity of dry gas out";
  // Medium states
  wet_medium.ThermodynamicState med_state_A_in;
  wet_medium.ThermodynamicState med_state_A_out;
  dry_medium.ThermodynamicState med_state_B_in;
  dry_medium.ThermodynamicState med_state_B_out;
  Modelica.Units.SI.MassFraction XiA_out[wet_medium.nXi] (start=wet_medium.reference_X[1:wet_medium.nXi]);
  Modelica.Units.SI.MassFraction XiB_out[dry_medium.nXi] (start=dry_medium.reference_X[1:dry_medium.nXi]);
  Modelica.Units.SI.MassFraction XiA_out_3 "Mass fractions of H20 for logging";
  Modelica.Units.SI.MassFraction XiB_out_3 "Mass fraction of H20 for logging";
equation
// Diffusion coefficient scaling : Chapman-Enskog theory
// Gas diffusion is changing based on temperature and pressure.
  D_H2O_Air = D_H2O_Air_ref*(((wet_medium.temperature(med_state_A_in) + dry_medium.temperature(med_state_B_in))/2)/atm_T)^(1.75)*(atm_P/((wet_medium.pressure(med_state_A_in) + dry_medium.pressure(med_state_B_in))/2));
// Define input medium states, easy to access and track throughout the code
  med_state_A_in = wet_medium.setState_phX(portA_in.p, inStream(portA_in.h_outflow), inStream(portA_in.Xi_outflow));
  med_state_B_in = dry_medium.setState_phX(portB_in.p, inStream(portB_in.h_outflow), inStream(portB_in.Xi_outflow));
// Compute volumetric flows and ratio of volumetric flow
  V_dot_a = abs(portA_in.m_flow)/wet_medium.density(med_state_A_in);
  V_dot_b = abs(portB_in.m_flow)/dry_medium.density(med_state_B_in);
  VFR = V_dot_a/max(V_dot_b, eps);
// Compute various geometry features of the humidifier
  d_hyd_b = 4*(dHousing^2 - nFibers*(dFiber_o^2)/4)/(Modelica.Constants.pi*nFibers*dFiber_o);
  A_c_shell = Modelica.Constants.pi*(dHousing^2)/4;
  A_c_fibers_out = nFibers*Modelica.Constants.pi*(dFiber_o^2)/4;
  A_c_fibers_in = nFibers*Modelica.Constants.pi*(dFiber_i^2)/4;
  A_c_shell_gap = A_c_shell - A_c_fibers_out;
  A_mem = nFibers*L_fiber*Modelica.Constants.pi*dFiber_o;
// Compute velocities
  v_a = V_dot_a/A_c_fibers_in;
  v_b = (abs(portB_in.m_flow)/dry_medium.density(med_state_B_in))/A_c_shell_gap;
// We compute some dimentionless numbers that are used for Sherwood number correlations
  Re_a = wet_medium.density(med_state_A_in)*v_a*dFiber_i/wet_medium.dynamicViscosity(med_state_A_in);
  Sc_a = wet_medium.dynamicViscosity(med_state_A_in)/(wet_medium.density(med_state_A_in)*D_H2O_Air);
  Re_b = dry_medium.density(med_state_B_in)*v_b*d_hyd_b/dry_medium.dynamicViscosity(med_state_B_in);
  Sc_b = dry_medium.dynamicViscosity(med_state_B_in)/(dry_medium.density(med_state_B_in)*D_H2O_Air);
// Sherwood numbers
// Wet side - Gnielinski correlation
// Dry side - Costello correlation
  Sh_wet1 = 3.66;
  Sh_wet2 = 1.615*(Re_a*Sc_a*dFiber_i/L_fiber)^(1/3);
  Sh_wet = (Sh_wet1^3 + 0.7^3 + (Sh_wet2 - 0.7)^3)^(1/3);
  Phi = nFibers*dFiber_o^2/dHousing^2;
  Sh_dry = (0.53 - 0.58*Phi)*Re_b^0.53*Sc_b^0.33;
// Mass transfer coefficients
  h_conv_a = Sh_wet*D_H2O_Air/dFiber_i;
  h_conv_b = max(Sh_dry*D_H2O_Air/d_hyd_b, eps);
// Resistances (series)
  R_conv_a = 1.0/(h_conv_a*A_mem);
  R_conv_b = 1.0/(h_conv_b*A_mem);
  R_mem = ((dFiber_o - dFiber_i)/2)/(D_mem*A_mem);
  beta_eff_a = 1/(R_conv_a + R_mem + R_conv_b);
// NTU and effectiveness
  NTU = beta_eff_a/max(V_dot_a, eps);
  eta = if abs(VFR - 1.0) < 1e-6 then NTU/(1 + NTU) else (1 - exp((VFR - 1)*NTU))/(1 - VFR*exp((VFR - 1)*NTU));
// Permation rate, based on Fick's law
  m_perm = wet_medium.MMs[3]*eta*(wet_medium.density(med_state_A_in)*(1 - inStream(portA_in.Xi_outflow[1]) - inStream(portA_in.Xi_outflow[2]))/wet_medium.MMs[3] - dry_medium.density(med_state_B_in)*(1 - inStream(portB_in.Xi_outflow[1]) - inStream(portB_in.Xi_outflow[2]))/dry_medium.MMs[3])*V_dot_a;
// First-order dynamics
  Xi = m_perm/max(min(abs(portA_in.m_flow), abs(portB_in.m_flow)), eps);
  der(Xi_state) = (Xi - Xi_state)/tau_perm;
  m_perm_state = Xi_state*min(abs(portA_in.m_flow), abs(portB_in.m_flow));
// Mass and pressure balances
  portA_in.m_flow + portA_out.m_flow = m_perm_state;
  portB_in.m_flow + portB_out.m_flow = -m_perm_state;
  portA_in.p = portA_out.p;
  portB_in.p = portB_out.p;
// Species balances
  XiA_out[1] = (abs(portA_in.m_flow)*inStream(portA_in.Xi_outflow[1]))/max(abs(portA_out.m_flow), m_flow_min);
  XiA_out[2] = (abs(portA_in.m_flow)*inStream(portA_in.Xi_outflow[2]))/max(abs(portA_out.m_flow), m_flow_min);
  XiA_out_3 = 1 - XiA_out[1] - XiA_out[2];

  XiB_out[1] = (abs(portB_in.m_flow)*inStream(portB_in.Xi_outflow[1]))/max(abs(portB_out.m_flow), m_flow_min);
  XiB_out[2] = (abs(portB_in.m_flow)*inStream(portB_in.Xi_outflow[2]))/max(abs(portB_out.m_flow), m_flow_min);
  XiB_out_3 = 1 - XiB_out[1] - XiB_out[2];

// Energy balance (enthalpy flow)
  if m_perm_state > 0 then
    perm_enthalpy_flow = (Media.Shomate.enthalpy(med_state_A_in.T, Media.Shomate.H2O_G)/wet_medium.MMs[3])*m_perm_state;
  else
    perm_enthalpy_flow = (Media.Shomate.enthalpy(med_state_B_in.T, Media.Shomate.H2O_G)/dry_medium.MMs[3])*m_perm_state;
  end if;
  if abs(portA_out.m_flow) > m_flow_min then
    portA_out_h_outflow = (abs(portA_in.m_flow)*inStream(portA_in.h_outflow) - perm_enthalpy_flow)/abs(portA_out.m_flow);
  else
    portA_out_h_outflow = inStream(portA_in.h_outflow);
  end if;
  if abs(portB_out.m_flow) > m_flow_min then
    portB_out_h_outflow = (abs(portB_in.m_flow)*inStream(portB_in.h_outflow) + perm_enthalpy_flow)/abs(portB_out.m_flow);
  else
    portB_out_h_outflow = inStream(portB_in.h_outflow);
  end if;
  med_state_A_out = wet_medium.setState_phX(portA_out.p, portA_out_h_outflow, XiA_out);
  med_state_B_out = dry_medium.setState_phX(portB_out.p, portB_out_h_outflow, XiB_out);
// Assign to ports
  portA_out.h_outflow = wet_medium.specificEnthalpy(med_state_A_out);
  portA_out.Xi_outflow = XiA_out;
  portB_out.h_outflow = dry_medium.specificEnthalpy(med_state_B_out);
  portB_out.Xi_outflow = XiB_out;
  portA_in.h_outflow = inStream(portA_out.h_outflow);
  portA_in.Xi_outflow = inStream(portA_out.Xi_outflow);
  portB_in.h_outflow = inStream(portB_out.h_outflow);
  portB_in.Xi_outflow = inStream(portB_out.Xi_outflow);
  phi_A_out = wet_medium.relativeHumidity(med_state_A_out);
  phi_B_out = dry_medium.relativeHumidity(med_state_B_out);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Diagram,
    Documentation(info = "<html><head></head><body><h1>Hollow Fiber Membrane Humidifier Model</h1>

<p>
This model represents a hollow fiber membrane humidifier based on the
Number of Transfer Units (NTU) method for mass exchangers, as described in
Pollak et al. (2023).
The model simulates water vapor transport between a wet and dry gas stream
in a counterflow configuration.
</p>

<h2>Model Overview</h2>

<p>
The humidifier is modeled as a lumped parameter mass exchanger where mass transfer
is driven by a concentration difference of water vapor across a selective membrane.
Only water vapor is assumed to permeate the membrane.
</p><p>The model works by:</p><p>1. Calculate the geometry of the humidifier. The contact area for mass transfer is established.&nbsp;</p><p>2. The efficiency of mass transfer through the fibers are calculated using Reynolds number (describing flow regime) and Schmidt number (momentum vs diffusion).&nbsp;</p><p>3. Correlations are used to calculate mass transfer coefficient by Sherwood number. These are used to find how fast mass moves between fluid and membrane.&nbsp;</p><p>4. A resistive network describing the resistance for water vapor to move from the wet stream to the dry stream is established.&nbsp;</p><p>5. Based on flow rate, the resistance and geometry, we calculate the NTU. The NTU is the ratio of mass transfer capability to flow rate.&nbsp;</p><p>6. Then the amount of water moving through the membrane is calculated.&nbsp;</p><p>7. A dynamic effect is added by a first order transfer function.&nbsp;</p><p>8. Then mass, pressure, species, and energy is balanced so that the same that goes into the humidifier comes out.&nbsp;</p><ol>

</ol>



<h2>Governing Equations</h2>

<h3>NTU Definition</h3>

<pre>NTU = βeff · A / V̇a
</pre>

<p>
where βeff is the effective mass transfer coefficient and A is the membrane area.
</p>

<h3>Mass Transfer Effectiveness</h3>

<p>
For counterflow operation, the effectiveness is given by:</p><pre>η =   NTU / (1 + NTU),                  if VFR = 1;</pre><pre>      (1 − exp((VFR − 1) · NTU)) /
      (1 − VFR · exp((VFR − 1) · NTU)), otherwise
</pre>

<h3>Permeation Rate</h3>

<p>
The steady-state water vapor transfer is calculated using:
</p>

<pre>ṁperm = M_H2O · η · (c_b − c_a) · V̇a
</pre>

<p>
where c_a and c_b are the water vapor concentrations on the wet and dry side.
</p>

<h2>Mass Transfer</h2>

<p>
The overall mass transfer resistance is modeled as three resistances in series:
</p>

<pre>Reff = Rconv,wet + Rmem + Rconv,dry
βeff = 1 / Reff
</pre>

<p>
Convective resistances are calculated using Sherwood correlations:
</p>

<ul>
<li>Wet side: Gnielinski-type correlation for tube flow</li>
<li>Dry side: Costello correlation for shell-side flow</li>
</ul>

<h2>Dynamic Extension</h2>

<p>
A first-order dynamic model is introduced to capture transient effects:
</p>

<pre>Ξ = ṁperm / min(ṁa, ṁb)

dΞstate/dt = (Ξ − Ξstate) / τperm
</pre>

<p>
The dynamic permeation rate is:
</p>

<pre>ṁperm,state = Ξstate · min(ṁa, ṁb)
</pre>

<p>
This captures observed transient behavior.
</p>

<h2>Assumptions</h2>

<ul>
<li>Flow only from in to out ports for both wet and dry side</li><li>Only water vapor is assumed to permeate the membrane</li>
<li>No pressure drop is considered</li>
<li>No heat transfer is included</li>
<li>Ideal mixture behavior is assumed</li>
<li>Uniform flow distribution across fibers</li></ul><div><h2>Future developement / Improvements</h2><ul><li>No volume inside humidifier. This introduces instant changes in outflow conditions for wet side. Wet side is normally vented for fuel cell applications, but still makes it difficult to validate the whole model.&nbsp;</li><li>Heat transfer between the streams and pressure drop should be added.&nbsp;</li><li>Effect of liquid water (exhaust of FC) should be investigated.&nbsp;</li><li>Medium handling can be generalized. Currently \"hardcoded\" solutions thats fits the CathodeAir model in VirtualFCS, but will likely crash with other mediums. Species indexes is i.e. hardcoded.&nbsp;</li><li>Support flow reversal. Some manual back-assignments for the ports are included now using inStream() operator. Likely crashing if flow reversal is attempted.&nbsp;</li><li>Could be split into submodels for NTU, mass transfer, geometry.. Would be more adaptable in future.&nbsp;</li></ul></div><ul>
</ul>

<h2>References</h2>

<p>
Based on:
<br>
Pollak et al. (2023),
<i>Steady State and Dynamic Simulation of a Small-Scale Hollow Fiber Membrane Humidifier</i>.
</p>

</body></html>", revisions = "<html><head></head><body>Initial development: 06.05.2026<div><br></div><div>Last update: 06.05.2026</div></body></html>"));
end Humidifier;
