within VirtualFCS.Fluid;

model Humidifier "Hollow fiber membrane humidifier:
    - Counterflow NTU-based mass exchanger
    - Optional first-order dynamics for moisture transfer
  Uses only Modelica Standard Library"

  
  replaceable package dry_medium = Modelica.Media.Interfaces.PartialMedium "Dry medium in the component" annotation (choicesAllMatching = true);
  replaceable package wet_medium = Modelica.Media.Interfaces.PartialMedium "Wet medium in the component" annotation (choicesAllMatching = true);
  
  import SI = Modelica.Units.SI;
  // Wet (A) and Dry (B) fluid ports
  Modelica.Fluid.Interfaces.FluidPort_a portA_in(redeclare package Medium = wet_medium) "Wet side inlet" annotation(
    Placement(transformation(extent = {{-10, 90}, {10, 110}})));
  Modelica.Fluid.Interfaces.FluidPort_b portA_out(redeclare package Medium = wet_medium) "Wet side outlet" annotation(
    Placement(transformation(extent = {{100, 50}, {120, 70}}, origin = {110, -40}, rotation = 180)));
  Modelica.Fluid.Interfaces.FluidPort_a portB_in(redeclare package Medium = dry_medium) "Dry side inlet" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b portB_out(redeclare package Medium = dry_medium) "Dry side outlet" annotation(
    Placement(transformation(extent = {{100, -70}, {120, -50}}, origin = {210, -60}, rotation = 180)));
  // Define constants
  Real san;
  Real san2;
  Real san3;
  Real pi = Modelica.Constants.pi;
  // Parameters for NTU model
  //parameter Modelica.Units.SI.Area A_mem = 1.0 "Membrane effective area [m2]";
  parameter SI.DiffusionCoefficient D_mem = 3.6e-7 "Membrane diffusion coefficient [m2/s] (to be calibrated)";
  parameter SI.Time tau_perm = 6.1 "Time constant for moisture transfer [s]";
  // Geometric and packing properties
  parameter Integer nFibers = 488 "Number of hollow fibers";
  parameter SI.Diameter dFiber_i = 0.9e-3 "Inner fiber diameter [m]";
  parameter SI.Diameter dFiber_o = 1.0e-3 "Outer fiber diameter [m]";
  parameter SI.Diameter dHousing = 39.2e-3 "Inner diameter of shell [m]";
  parameter SI.Length L_fiber = 150.8e-3 "Fiber length [m]";
  // Intermediate variables for NTU calculation
  SI.VolumeFlowRate V_dot_a "Volumetric flow A [m3/s]";
  SI.VolumeFlowRate V_dot_b "Volumetric flow B [m3/s]";
  SI.DimensionlessRatio VFR "Volume flow ratio";
  SI.Velocity h_conv_a "Convective resistance A [m/s]";
  //Mass transfer velocity
  SI.Velocity h_conv_b "Convective resistance B [m/s]";
  SI.SpectralConcentration R_conv_a "Resistance A [s/m3]";
  //Correct units, but should be mass transfer resistance
  SI.SpectralConcentration R_conv_b "Resistance B [s/m3]";
  SI.SpectralConcentration R_mem "Membrane resistance [s/m3]";
  SI.VolumeFlowRate beta_eff_a "Effective mass transfer coeff. [m3/s]";
  SI.DimensionlessRatio NTU "Number of transfer units";
  SI.Efficiency eta "Effectiveness";
  SI.MassFlowRate m_perm "Instantaneous permeation mass flow [kg/s]";
  SI.MassFlowRate check_perm_A;
  SI.MassFlowRate check_perm_B;
  SI.MoleFraction phi_A_out "Relative humidity of wet gas out";
  SI.MoleFraction phi_B_out "Relative humidity of dry gas out"; 
  //SI.MassFlowRate m_perm_2 "Instantaneous permeation mass flow [kg/s]";
  SI.DimensionlessRatio Xi "Normalized permeation state";
  SI.MassFlowRate m_perm_state "Dynamic permeation flow [kg/s]";
  // State for first-order dynamic of permeation
  SI.DimensionlessRatio Xi_state(start = 0, fixed=true) "State variable for normalized moisture transfer";
  SI.SpecificEnthalpy portA_out_h_outflow "Specific enthalpy set for port A out";
  SI.SpecificEnthalpy portB_out_h_outflow "Specific enthalpy set for port B out";
  
  SI.SpecificEnthalpy A_contrib_1;
  SI.SpecificEnthalpy A_contrib_2;
  SI.SpecificEnthalpy B_contrib_1;
  SI.SpecificEnthalpy B_contrib_2;
  
  SI.EnthalpyFlowRate perm_enthalpy_flow "The enthalpy flow rate for mass transfer";
  //----- TEST IMPLEMENTATION OF RESISTANCES
  SI.Diameter d_hyd_b "Or some effective shell hydraulic diameter";
  Real Re_a, Sc_a, Re_b, Sc_b;
  // Dimensionless number
  Real Sh_wet1, Sh_wet2, Sh_wet;
  // Dimensionless number
  Real Phi, Sh_dry;
  SI.Velocity v_a, v_b;
  SI.Area A_c_fibers_in "Cross-section area of fibers inner diameter";
  SI.Area A_c_fibers_out "Cross-section area of fibers outer diameter";
  SI.Area A_mem "Surface area of fibers";
  SI.Area A_c_shell "Cross-section area of humidifier shell";
  SI.Area A_c_shell_gap "Cross-section area of humidifier shell space not occupied by fibers";
  SI.DiffusionCoefficient D_H2O_Air_ref = 2.6e-5 "Referece binary diffusion coefficient of H2O in air [m2/s] at 25°C, 1 atm";
  
  SI.DiffusionCoefficient D_H2O_Air "Temperature and pressure dependent binary diffusion coefficient of H2O in air [m2/s]";
  SI.ThermodynamicTemperature atm_T = 298.15 "Assumed baseline temp";
  SI.Pressure atm_P = 101325 "Aussumed baseline pressure";
  //---- Define medium states for cleaner implementation
  wet_medium.ThermodynamicState med_state_A_in;
  wet_medium.ThermodynamicState med_state_A_out;
  dry_medium.ThermodynamicState med_state_B_in;
  dry_medium.ThermodynamicState med_state_B_out;
  
  Modelica.Units.SI.MassFraction XiA_out[wet_medium.nXi];
  Modelica.Units.SI.MassFraction XiB_out[dry_medium.nXi];

  //----- TEST IMPLEMENTATION OF RESISTANCES
  
equation
  D_H2O_Air = D_H2O_Air_ref*(((wet_medium.temperature(med_state_A_in) + dry_medium.temperature(med_state_B_in))/2)/atm_T)^(1.75)*(atm_P/((wet_medium.pressure(med_state_A_in) + dry_medium.pressure(med_state_B_in))/2));
//D_H2O_Air = D_H2O_Air_ref;
  med_state_A_in = wet_medium.setState_phX(portA_in.p, inStream(portA_in.h_outflow), inStream(portA_in.Xi_outflow));
  med_state_B_in = dry_medium.setState_phX(portB_in.p, inStream(portB_in.h_outflow), inStream(portB_in.Xi_outflow));
// 1. Compute volumetric flows
  V_dot_a = portA_in.m_flow/wet_medium.density(med_state_A_in);
  V_dot_b = portB_in.m_flow/dry_medium.density(med_state_B_in);
  VFR = V_dot_a/V_dot_b;
//----- TEST IMPLEMENTATION OF RESISTANCES
// Wet side geometry
// Dry side geometry
  d_hyd_b = 4*(dHousing^2 - nFibers*(dFiber_o^2)/4)/(pi*nFibers*dFiber_o);
//d_hyd_b = dFiber_i;
// or some effective shell hydraulic diameter
// 1. Compute Re & Sc
  A_c_shell = pi*(dHousing^2)/4;
  A_c_fibers_out = nFibers*pi*(dFiber_o^2)/4;
  A_c_fibers_in = nFibers*pi*(dFiber_i^2)/4;
  A_c_shell_gap = A_c_shell - A_c_fibers_out;
  A_mem = nFibers*L_fiber*pi*dFiber_o;
  v_a = V_dot_a/A_c_fibers_in;
  v_b = (portB_in.m_flow/dry_medium.density(med_state_B_in))/A_c_shell_gap;
  Re_a = wet_medium.density(med_state_A_in)*v_a*dFiber_i/wet_medium.dynamicViscosity(med_state_A_in);
  Sc_a = wet_medium.dynamicViscosity(med_state_A_in)/(wet_medium.density(med_state_A_in)*D_H2O_Air);
  Re_b = dry_medium.density(med_state_B_in)*v_b*d_hyd_b/dry_medium.dynamicViscosity(med_state_B_in);
  Sc_b = dry_medium.dynamicViscosity(med_state_B_in)/(dry_medium.density(med_state_B_in)*D_H2O_Air);
// 2. Sherwood numbers
  Sh_wet1 = 3.66;
  Sh_wet2 = 1.615*(Re_a*Sc_a*dFiber_i/L_fiber)^(1/3);
  Sh_wet = (Sh_wet1^3 + 0.7^3 + (Sh_wet2 - 0.7)^3)^(1/3);
  Phi = nFibers*dFiber_o^2/dHousing^2;
  Sh_dry = (0.53 - 0.58*Phi)*Re_b^0.53*Sc_b^0.33;
// 3. Convective coefficients & resistances
  h_conv_a = Sh_wet*D_H2O_Air/dFiber_i;
  h_conv_b = Sh_dry*D_H2O_Air/d_hyd_b;
// 2. Resistances (fill with convective correlation or constants) ADDRESS THESE
  R_conv_a = 1.0/(h_conv_a*A_mem);
// placeholder: h_conv_a = f(velocityA, dFiber_o)
  R_conv_b = 1.0/(h_conv_b*A_mem);
// placeholder: h_conv_b = f(velocityB, dHousing)
  R_mem = ((dFiber_o - dFiber_i)/2)/(D_mem*A_mem);
  beta_eff_a = 1/(R_conv_a + R_mem + R_conv_b);
// 3. NTU and effectiveness
  NTU = beta_eff_a/V_dot_a;
  eta = if abs(VFR - 1.0) < 1e-6 then NTU/(1 + NTU) else (1 - exp((VFR - 1)*NTU))/(1 - VFR*exp((VFR - 1)*NTU));
// 4. Steady permeation rate
// Consider changing this to concentrations instead of mass fractions
// Hardcoded mass fractions for oxygen and nitrogen, this should be addressed.
//m_perm = eta*((1 - inStream(portA_in.Xi_outflow[1]) - inStream(portA_in.Xi_outflow[2])) - (1 - inStream(portB_in.Xi_outflow[1]) - inStream(portB_in.Xi_outflow[2])))*portA_in.m_flow;
//m_perm = wet_medium.MMs[3]*eta*((wet_medium.density(med_state_A_in)* (1 - inStream(portA_in.Xi_outflow[1]) - inStream(portA_in.Xi_outflow[2])) / wet_medium.MMs[3])-(dry_medium.density(med_state_B_in)* (1 - inStream(portB_in.Xi_outflow[1]) - inStream(portB_in.Xi_outflow[2])) / wet_medium.MMs[3]))*V_dot_a;
//cA = wet_medium.density(med_state_A_in) *
//   (1 - XiA_O2 - XiA_N2) /
//   wet_medium.MMs[3];
//cB = dry_medium.density(med_state_B_in) *
//   (1 - XiB_O2 - XiB_N2) /
//   dry_medium.MMs[3];
  m_perm = wet_medium.MMs[3]*eta*(wet_medium.density(med_state_A_in)*(1 - inStream(portA_in.Xi_outflow[1]) - inStream(portA_in.Xi_outflow[2]))/wet_medium.MMs[3] - dry_medium.density(med_state_B_in)*(1 - inStream(portB_in.Xi_outflow[1]) - inStream(portB_in.Xi_outflow[2]))/dry_medium.MMs[3])*V_dot_a;
  check_perm_A = portA_in.m_flow*((1 - inStream(portA_in.Xi_outflow[1]) - inStream(portA_in.Xi_outflow[2])) - (1 - inStream(portA_out.Xi_outflow[1]) - inStream(portA_out.Xi_outflow[2])));
  check_perm_B = portB_out.m_flow*(1 - inStream(portB_out.Xi_outflow[1]) - inStream(portB_out.Xi_outflow[2])) - portB_in.m_flow*(1 - inStream(portB_in.Xi_outflow[1]) - inStream(portB_in.Xi_outflow[2]));
//m_perm = 2.3e-05;
// 5. First-order dynamics
  Xi = m_perm/min(portA_in.m_flow, portB_in.m_flow);
  der(Xi_state) = (Xi - Xi_state)/tau_perm;
  m_perm_state = Xi_state*min(portA_in.m_flow, portB_in.m_flow);


// 6. Mass balances 
  
  portA_out.m_flow = portA_in.m_flow - m_perm_state;
  portB_out.m_flow = portB_in.m_flow + m_perm_state;
  
  portA_in.p = portA_out.p;
  portB_in.p = portB_out.p;
  

// 7. Species balances

  XiA_out[1] = (portA_in.m_flow*inStream(portA_in.Xi_outflow[1]))/portA_out.m_flow;
  XiA_out[2] = (portA_in.m_flow*inStream(portA_in.Xi_outflow[2]))/portA_out.m_flow;
  
  XiB_out[1] = (portB_in.m_flow*inStream(portB_in.Xi_outflow[1]))/portB_out.m_flow;
  XiB_out[2] = (portB_in.m_flow*inStream(portB_in.Xi_outflow[2]))/portB_out.m_flow;





// 8. Energy balance (enthalpy flow)
  if m_perm_state > 0 then
    perm_enthalpy_flow = (Media.Shomate.enthalpy(med_state_A_in.T, Media.Shomate.H2O_G)/wet_medium.MMs[3])*m_perm_state;
  else
    perm_enthalpy_flow = (Media.Shomate.enthalpy(med_state_B_in.T, Media.Shomate.H2O_G)/dry_medium.MMs[3])*m_perm_state;
  end if;
  portA_out_h_outflow = (portA_in.m_flow*inStream(portA_in.h_outflow) - perm_enthalpy_flow)/portA_out.m_flow;
  portB_out_h_outflow = (portB_in.m_flow*inStream(portB_in.h_outflow) + perm_enthalpy_flow)/portB_out.m_flow;
  A_contrib_1 = portA_in.m_flow*inStream(portA_in.h_outflow)/portA_out.m_flow;
  A_contrib_2 = -perm_enthalpy_flow/portA_out.m_flow;
  B_contrib_1 = portB_in.m_flow*inStream(portB_in.h_outflow)/portB_out.m_flow;
  B_contrib_2 = perm_enthalpy_flow/portB_out.m_flow;

  med_state_A_out = wet_medium.setState_phX(
    portA_out.p,
    portA_out_h_outflow,
    XiA_out
  );
  
  med_state_B_out = dry_medium.setState_phX(
    portB_out.p,
    portB_out_h_outflow,
    XiB_out
  );

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
  phi_B_out = dry_medium.relativeHumidity(med_state_A_out);

// water content going in = water content going out
  san = (portA_in.m_flow*(1 - inStream(portA_in.Xi_outflow[1]) - inStream(portA_in.Xi_outflow[2]))) + (portB_in.m_flow*(1 - inStream(portB_in.Xi_outflow[1]) - inStream(portB_in.Xi_outflow[2]))) - (portA_out.m_flow*(1 - inStream(portA_out.Xi_outflow[1]) - inStream(portA_out.Xi_outflow[2]))) - (portB_out.m_flow*(1 - inStream(portB_out.Xi_outflow[1]) - inStream(portB_out.Xi_outflow[2])));
  san2 = portA_in.m_flow + portB_in.m_flow - portA_out.m_flow - portB_out.m_flow;
  san3 = portA_in.m_flow*inStream(portA_in.h_outflow) + portB_in.m_flow*inStream(portB_in.h_outflow) - portA_out_h_outflow*portA_out.m_flow - portB_out_h_outflow*portB_out.m_flow;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false), graphics = {Rectangle(fillColor = {189, 189, 189}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}, radius = 30), Rectangle(origin = {-62, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 60}, {6, -60}}), Rectangle(origin = {62, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 60}, {6, -60}}), Line(origin = {0.2, 56}, points = {{-56, 0}, {56, 0}}), Line(origin = {0.2, -56}, points = {{-56, 0}, {56, 0}})}),
    Diagram);
end Humidifier;
