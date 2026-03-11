within VirtualFCS.Fluid;

model Humidifier "Hollow fiber membrane humidifier:
    - Counterflow NTU-based mass exchanger
    - Optional first-order dynamics for moisture transfer
  Uses only Modelica Standard Library + Buildings."
  replaceable package dry_medium = VirtualFCS.Media.CathodeAir;
  replaceable package wet_medium = VirtualFCS.Media.CathodeAir;


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
  Real pi = Modelica.Constants.pi;
  // Parameters for NTU model
  //parameter Modelica.Units.SI.Area A_mem = 1.0 "Membrane effective area [m2]";
  parameter Modelica.Units.SI.DiffusionCoefficient D_mem = 3.6e-7 "Membrane diffusion coefficient [m2/s] (to be calibrated)";
  parameter Modelica.Units.SI.Time tau_perm = 6.1 "Time constant for moisture transfer [s]";
  // Geometric and packing properties
  parameter Integer nFibers = 488 "Number of hollow fibers";
  parameter Real dFiber_i = 0.9e-3 "Inner fiber diameter [m]";
  parameter Real dFiber_o = 1.0e-3 "Outer fiber diameter [m]";
  parameter Real dHousing = 39.2e-3 "Inner diameter of shell [m]";
  parameter Real L_fiber = 150.8e-3 "Fiber length [m]";
  // Intermediate variables for NTU calculation
  Real V_dot_a "Volumetric flow A [m3/s]";
  Real V_dot_b "Volumetric flow B [m3/s]";
  Real VFR "Volume flow ratio";
  Real h_conv_a "Convective resistance A [s/m]";
  Real h_conv_b "Convective resistance B [s/m]";
  Real R_conv_a "Resistance A [s/m]";
  Real R_conv_b "Resistance B [s/m]";
  Real R_mem "Membrane resistance [s/m]";
  Real beta_eff "Effective mass transfer coeff. [m/s]";
  Real NTU "Number of transfer units";
  Real eta "Effectiveness";
  Real m_perm "Instantaneous permeation mass flow [kg/s]";
  Real Xi "Normalized permeation state";
  Real m_perm_state "Dynamic permeation flow [kg/s]";
  // State for first-order dynamic of permeation
  Real Xi_state(start = 0) "State variable for normalized moisture transfer";
  Real portA_out_m_flow "Mass flow port A out";
  Real portB_out_m_flow "Mass flow port B out";
  Real portA_out_Xi_oxygen "Species balance port A out";
  Real portA_out_Xi_nitrogen "Species balance port A out";
  Real portA_out_Xi_water "Species balance port A out";
  Real portB_out_Xi_oxygen "Species balance port B out";
  Real portB_out_Xi_nitrogen "Species balance port B out";
  Real portB_out_Xi_water "Species balance port B out";
  Real portA_out_h_outflow "Enthalpy flow port A out";
  Real portB_out_h_outflow "Enthalpy flow port B out";
  //----- TEST IMPLEMENTATION OF RESISTANCES
  Real d_hyd_b "Or some effective shell hydraulic diameter";
  Real Re_a, Sc_a, Re_b, Sc_b;
  Real Sh_wet1, Sh_wet2, Sh_wet;
  Real Phi, Sh_dry, v_a, v_b;
  Modelica.Units.SI.Area A_c_fibers_in "Cross-section area of fibers inner diameter";
  Modelica.Units.SI.Area A_c_fibers_out "Cross-section area of fibers outer diameter";
  Modelica.Units.SI.Area A_mem "Surface area of fibers";
  Modelica.Units.SI.Area A_c_shell "Cross-section area of humidifier shell";
  Modelica.Units.SI.Area A_c_shell_gap "Cross-section area of humidifier shell space not occupied by fibers";
  parameter Real D_H2O_Air = 2.63e-7 "Binary diffusion coefficient of H2O in air [m2/s] at 25°C, 1 atm";
  
  //---- Define medium states for cleaner implementation
  VirtualFCS.Media.CathodeAir.ThermodynamicState med_state_A_in;
  VirtualFCS.Media.CathodeAir.ThermodynamicState med_state_B_in;
  
  //----- TEST IMPLEMENTATION OF RESISTANCES
  Modelica.Fluid.Sources.FixedBoundary sinkPortA_in(redeclare package Medium = wet_medium, nPorts = 1) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {96, 74})));
  Modelica.Fluid.Sources.FixedBoundary sinkPortB_in(redeclare package Medium = dry_medium, nPorts = 1) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {-68, -90})));
  Modelica.Fluid.Sources.MassFlowSource_h genPortB_out_2(redeclare package Medium = dry_medium, use_m_flow_in = true, use_h_in = true, use_X_in = true, nPorts = 1) annotation(
    Placement(transformation(origin = {70, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression massFraction_water_b(y = portB_out_Xi_water) annotation(
    Placement(transformation(origin = {16, -8.4}, extent = {{6, -21.6}, {26, -3.6}})));
  Modelica.Blocks.Sources.RealExpression massFraction_nitrogen_b(y = portB_out_Xi_nitrogen) annotation(
    Placement(transformation(origin = {16, 7.6}, extent = {{6, -21.6}, {26, -3.6}})));
  Modelica.Blocks.Sources.RealExpression massFraction_oxygen_b(y = portB_out_Xi_oxygen) annotation(
    Placement(transformation(origin = {16, 23.6}, extent = {{6, -21.6}, {26, -3.6}})));
  Modelica.Blocks.Sources.RealExpression enthalpy_out_b(y = portB_out_h_outflow) annotation(
    Placement(transformation(origin = {16, 26}, extent = {{6, -10}, {26, 10}})));
  Modelica.Blocks.Sources.RealExpression massFlow_out_b(y = portB_out_m_flow) annotation(
    Placement(transformation(origin = {16, 28}, extent = {{6, 4}, {26, 24}})));
  Modelica.Fluid.Sources.MassFlowSource_h genPortA_out_2(redeclare package Medium = wet_medium, nPorts = 1, use_X_in = true, use_h_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {0, -76}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression massFraction_water_a(y = portA_out_Xi_water) annotation(
    Placement(transformation(origin = {-50, -40.4}, extent = {{6, -21.6}, {26, -3.6}})));
  Modelica.Blocks.Sources.RealExpression massFraction_nitrogen_a(y = portA_out_Xi_nitrogen) annotation(
    Placement(transformation(origin = {-50, -24.4}, extent = {{6, -21.6}, {26, -3.6}})));
  Modelica.Blocks.Sources.RealExpression massFraction_oxygen_a(y = portA_out_Xi_oxygen) annotation(
    Placement(transformation(origin = {-50, -8.4}, extent = {{6, -21.6}, {26, -3.6}})));
  Modelica.Blocks.Sources.RealExpression enthalpy_out_a(y = portA_out_h_outflow) annotation(
    Placement(transformation(origin = {-50, -6}, extent = {{6, -10}, {26, 10}})));
  Modelica.Blocks.Sources.RealExpression massFlow_out_a(y = portA_out_m_flow) annotation(
    Placement(transformation(origin = {-50, -4}, extent = {{6, 4}, {26, 24}})));
  Modelica.Fluid.Sensors.Density portB_in_den(redeclare package Medium = dry_medium) annotation(
    Placement(transformation(origin = {-88, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFractions portB_in_massfraction_oxygen(redeclare package Medium = dry_medium, substanceName = "oxygen")  annotation(
    Placement(transformation(origin = {-60, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.SpecificEnthalpy portB_in_h(redeclare package Medium = dry_medium) annotation(
    Placement(transformation(origin = {-86, -64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFractions portB_in_massfraction_nitrogen(redeclare package Medium = dry_medium, substanceName = "nitrogen") annotation(
    Placement(transformation(origin = {-38, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.SpecificEnthalpy portA_in_h(redeclare package Medium = dry_medium) annotation(
    Placement(transformation(origin = {74, 104}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Density portA_in_den(redeclare package Medium = dry_medium) annotation(
    Placement(transformation(origin = {26, 102}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFractions portA_in_massfraction_oxygen(redeclare package Medium = dry_medium, substanceName = "oxygen") annotation(
    Placement(transformation(origin = {-24, 92}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFractions portA_in_massfraction_nitrogen(redeclare package Medium = dry_medium, substanceName = "nitrogen") annotation(
    Placement(transformation(origin = {52, 100}, extent = {{-10, -10}, {10, 10}})));
equation

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
// or some effective shell hydraulic diameter
// 1. Compute Re & Sc
  A_c_shell = pi*(dHousing^2)/4;
  A_c_fibers_out = nFibers*pi*(dFiber_o^2)/4;
  A_c_fibers_in = nFibers*pi*(dFiber_i^2)/4;
  A_c_shell_gap = A_c_shell - A_c_fibers_out;
  A_mem = nFibers*L_fiber*pi*dFiber_o^2;
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
//R_conv_a = 1/h_conv_a;
//R_conv_b = 1/h_conv_b;
//----- TEST IMPLEMENTATION OF RESISTANCES
// FIX THIS:
//h_conv_a = 1;
//h_conv_b = 1;
// 2. Resistances (fill with convective correlation or constants)
  R_conv_a = 1.0/h_conv_a;
// placeholder: h_conv_a = f(velocityA, dFiber_o)
  R_conv_b = 1.0/h_conv_b;
// placeholder: h_conv_b = f(velocityB, dHousing)
  R_mem = (dFiber_o - dFiber_i)/(D_mem*A_mem);
  beta_eff = 1/((R_conv_a + R_mem + R_conv_b)*A_mem);
// 3. NTU and effectiveness
  NTU = beta_eff*A_mem/V_dot_a;
  eta = if VFR == 1 then NTU/(1 + NTU) else (1 - exp((VFR - 1)*NTU))/(1 - VFR*exp((VFR - 1)*NTU));
// 4. Steady permeation rate
  m_perm = eta*((1 - inStream(portA_in.Xi_outflow[1]) - inStream(portA_in.Xi_outflow[2])) - (1 - inStream(portB_in.Xi_outflow[1]) -  inStream(portB_in.Xi_outflow[2]))) * portA_in.m_flow;  
// 5. First-order dynamics
  Xi = m_perm/min(portA_in.m_flow, portB_in.m_flow);
  der(Xi_state) = (Xi - Xi_state)/tau_perm;
  m_perm_state = Xi_state*min(portA_in.m_flow, portB_in.m_flow);
// 6. Mass balances
  portA_out_m_flow = portA_in.m_flow - m_perm_state;
  portB_out_m_flow = portB_in.m_flow + m_perm_state;
// 7. Species balances
  portA_out_Xi_oxygen = (portA_in.m_flow*inStream(portA_in.Xi_outflow[1]))/portA_out_m_flow;
  portA_out_Xi_nitrogen = (portA_in.m_flow*inStream(portA_in.Xi_outflow[2]))/portA_out_m_flow;
  portA_out_Xi_water = (portA_in.m_flow*(1-inStream(portA_in.Xi_outflow[1])-inStream(portA_in.Xi_outflow[2])) - m_perm_state)/portA_out_m_flow;
  
  portB_out_Xi_oxygen = (portB_in.m_flow*inStream(portB_in.Xi_outflow[1]))/portB_out_m_flow;
  portB_out_Xi_nitrogen = (portB_in.m_flow*inStream(portB_in.Xi_outflow[2]))/portB_out_m_flow;
  portB_out_Xi_water = (portB_in.m_flow*(1-inStream(portB_in.Xi_outflow[1])-inStream(portB_in.Xi_outflow[2])) + m_perm_state)/portB_out_m_flow;

// 8. Energy balance (enthalpy flow)
  
  portA_out_h_outflow = (portA_in.m_flow*inStream(portA_in.h_outflow) - m_perm_state*inStream(portA_in.h_outflow)) / portA_out_m_flow;
  portB_out_h_outflow = (portB_in.m_flow*inStream(portB_in.h_outflow) + m_perm_state*inStream(portA_in.h_outflow)) / portB_out_m_flow;
  
  connect(massFraction_oxygen_b.y, genPortB_out_2.X_in[1]) annotation(
    Line(points = {{44, 12}, {58, 12}}, color = {0, 0, 127}));
  connect(massFraction_nitrogen_b.y, genPortB_out_2.X_in[2]) annotation(
    Line(points = {{44, -6}, {58, -6}, {58, 12}}, color = {0, 0, 127}));
  connect(massFlow_out_b.y, genPortB_out_2.m_flow_in) annotation(
    Line(points = {{44, 42}, {60, 42}, {60, 24}}, color = {0, 0, 127}));
  connect(genPortB_out_2.h_in, enthalpy_out_b.y) annotation(
    Line(points = {{58, 20}, {44, 20}, {44, 26}}, color = {0, 0, 127}));
  connect(genPortB_out_2.ports[1], portB_out) annotation(
    Line(points = {{80, 16}, {100, 16}, {100, 0}}, color = {0, 127, 255}));
  connect(massFraction_water_b.y, genPortB_out_2.X_in[3]) annotation(
    Line(points = {{44, -20}, {58, -20}, {58, 12}}, color = {0, 0, 127}));
  connect(genPortA_out_2.ports[1], portA_out) annotation(
    Line(points = {{0, -86}, {0, -100}}, color = {0, 127, 255}));
  connect(massFlow_out_a.y, genPortA_out_2.m_flow_in) annotation(
    Line(points = {{-22, 10}, {8, 10}, {8, -66}}, color = {0, 0, 127}));
  connect(enthalpy_out_a.y, genPortA_out_2.h_in) annotation(
    Line(points = {{-22, -6}, {4, -6}, {4, -64}}, color = {0, 0, 127}));
  connect(massFraction_oxygen_a.y, genPortA_out_2.X_in[1]) annotation(
    Line(points = {{-22, -20}, {-4, -20}, {-4, -64}}, color = {0, 0, 127}));
  connect(massFraction_nitrogen_a.y, genPortA_out_2.X_in[2]) annotation(
    Line(points = {{-22, -36}, {-4, -36}, {-4, -64}}, color = {0, 0, 127}));
  connect(massFraction_water_a.y, genPortA_out_2.X_in[3]) annotation(
    Line(points = {{-22, -52}, {-4, -52}, {-4, -64}}, color = {0, 0, 127}));
  connect(portB_in, sinkPortB_in.ports[1]) annotation(
    Line(points = {{-100, 0}, {-68, 0}, {-68, -80}}));
  connect(portB_in_den.port, portB_in) annotation(
    Line(points = {{-88, 32}, {-100, 32}, {-100, 0}}, color = {0, 127, 255}));
  connect(portB_in_h.port, portB_in) annotation(
    Line(points = {{-86, -74}, {-98, -74}, {-98, 0}, {-100, 0}}, color = {0, 127, 255}, thickness = 0.75));
  connect(portB_in_massfraction_oxygen.port, portB_in) annotation(
    Line(points = {{-60, 32}, {-100, 32}, {-100, 0}}, color = {0, 127, 255}));
  connect(portB_in, portB_in_massfraction_nitrogen.port) annotation(
    Line(points = {{-100, 0}, {-38, 0}, {-38, 32}}));
  connect(sinkPortA_in.ports[1], portA_in) annotation(
    Line(points = {{86, 74}, {0, 74}, {0, 100}}, color = {0, 127, 255}));
  connect(portA_in_massfraction_oxygen.port, portA_in) annotation(
    Line(points = {{-24, 82}, {0, 82}, {0, 100}}, color = {0, 127, 255}));
  connect(portA_in_den.port, portA_in) annotation(
    Line(points = {{26, 92}, {0, 92}, {0, 100}}, color = {0, 127, 255}));
  connect(portA_in_massfraction_nitrogen.port, portA_in) annotation(
    Line(points = {{52, 90}, {0, 90}, {0, 100}}, color = {0, 127, 255}));
  connect(portA_in_h.port, portA_in) annotation(
    Line(points = {{74, 94}, {0, 94}, {0, 100}}, color = {0, 127, 255}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false), graphics = {Rectangle(fillColor = {189, 189, 189}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}, radius = 30), Rectangle(origin = {-62, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 60}, {6, -60}}), Rectangle(origin = {62, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 60}, {6, -60}}), Line(origin = {0.2, 56}, points = {{-56, 0}, {56, 0}}), Line(origin = {0.2, -56}, points = {{-56, 0}, {56, 0}})}),
    Diagram);
end Humidifier;
