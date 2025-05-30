within VirtualFCS.Fluid;
model Humidifier_test_v2 "Hollow fiber membrane humidifier:
    - Counterflow NTU-based mass exchanger
    - Optional first-order dynamics for moisture transfer
  Uses only Modelica Standard Library + Buildings."

  replaceable package dry_medium_in = Buildings.Media.Air;
  replaceable package dry_medium_out = Buildings.Media.Air;
  replaceable package wet_medium_in = Buildings.Media.Air;
  replaceable package wet_medium_out = Buildings.Media.Air;

  // Wet (A) and Dry (B) fluid ports
  Modelica.Fluid.Interfaces.FluidPort_a portA_in(  redeclare package Medium =
        wet_medium_in)
    "Wet side inlet"
    annotation(Placement(transformation(extent={{-10, 90},{10,110}})));

  Modelica.Fluid.Interfaces.FluidPort_b portA_out( redeclare package Medium =
        wet_medium_out)
    "Wet side outlet"
    annotation(Placement(transformation(extent={{100, 50},{120,70}}, origin={110,-40}, rotation=180)));

  Modelica.Fluid.Interfaces.FluidPort_a portB_in(  redeclare package Medium =
        dry_medium_in)
    "Dry side inlet"
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b portB_out( redeclare package Medium =
        dry_medium_out)
    "Dry side outlet"
    annotation(Placement(transformation(extent={{100,-70},{120,-50}}, origin={210,-60}, rotation=180)));

 // Parameters for NTU model
  parameter Real A_mem = 1.0 "Membrane effective area [m2]";
  parameter Real D_mem = 3.6e-7 "Membrane diffusion coefficient [m2/s] (to be calibrated)";
  parameter Real tau_perm = 6.1 "Time constant for moisture transfer [s]";

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
  Real Xi_state(start=0) "State variable for normalized moisture transfer";

  Real portA_out_m_flow "Mass flow port A out";
  Real portB_out_m_flow "Mass flow port B out";
  Real portA_out_Xi "Species balance port A out";
  Real portB_out_Xi "Species balance port B out";
  Real portA_out_h_outflow "Enthalpy flow port A out";
  Real portB_out_h_outflow "Enthalpy flow port B out";


  //----- TEST IMPLEMENTATION OF RESISTANCES

  Real d_hyd_b "Or some effective shell hydraulic diameter";


  Real Re_a, Sc_a, Re_b, Sc_b;
  Real Sh_wet1, Sh_wet2, Sh_wet;
  Real Phi, Sh_dry, v_a, A_shell, A_fibers, A_shell_gap, v_b;
  parameter Real D_H2O_Air = 2.5e-5 "Binary diffusion coefficient of H2O in air [m2/s] at 25°C, 1 atm";




  //----- TEST IMPLEMENTATION OF RESISTANCES


  Modelica.Fluid.Sources.FixedBoundary sinkPortA_in(redeclare package Medium =
        wet_medium_in, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={96,74})));
  Buildings.Fluid.Sensors.DensityTwoPort senDenPortA_in(redeclare package
      Medium =
        wet_medium_in, m_flow_nominal=0.01)
                annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={28,74})));
  Buildings.Fluid.Sensors.DensityTwoPort senDenPortB_in(redeclare package
      Medium =
        dry_medium_in, m_flow_nominal=0.01)
                annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-68,-16})));
  Modelica.Fluid.Sources.FixedBoundary sinkPortB_in(redeclare package Medium =
        dry_medium_in, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-68,-90})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort senSpeEntPortA_in(redeclare
      package Medium =
        wet_medium_in,
      m_flow_nominal=0.01)
    annotation (Placement(transformation(extent={{46,64},{66,84}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort senSpeEntPortB_in(redeclare
      package Medium =
        dry_medium_in,
      m_flow_nominal=0.01)                                                                             annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-68,-46})));
  Buildings.Fluid.Sources.MassFlowSource_h genPortB_out(redeclare package
      Medium =
        dry_medium_out,
    use_Xi_in=true,
    use_m_flow_in=true,
    use_h_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{58,-10},{78,10}})));
  Buildings.Fluid.Sources.MassFlowSource_h genPortA_out(redeclare package
      Medium =
        wet_medium_out,
    use_Xi_in=true,
    use_m_flow_in=true,
    use_h_in=true,
    nPorts=1)                                                                              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-74})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=portB_out_m_flow)
    annotation (Placement(transformation(extent={{6,4},{26,24}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=portB_out_h_outflow)
    annotation (Placement(transformation(extent={{6,-10},{26,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=portB_out_Xi)
    annotation (Placement(transformation(extent={{6,-24},{26,-4}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=portA_out_m_flow)
    annotation (Placement(transformation(extent={{-40,-36},{-20,-16}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=portA_out_h_outflow)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=portA_out_Xi)
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=0.05)
    annotation (Placement(transformation(extent={{26,-48},{46,-28}})));
equation
  // 1. Compute volumetric flows
  V_dot_a =portA_in.m_flow/senDenPortA_in.d;
  V_dot_b =portB_in.m_flow/senDenPortB_in.d;
  VFR = V_dot_a / V_dot_b;


  //----- TEST IMPLEMENTATION OF RESISTANCES

  // Wet side geometry
  // Dry side geometry
  d_hyd_b = 4*(dHousing^2 - nFibers*(dFiber_o^2)/4)/(Modelica.Constants.pi * nFibers * dFiber_o);
  // or some effective shell hydraulic diameter

  // 1. Compute Re & Sc
  v_a = (V_dot_a/nFibers) / (Modelica.Constants.pi*(dFiber_i^2)/4);

  A_shell    = Modelica.Constants.pi*(dHousing^2)/4;
  A_fibers   = nFibers * Modelica.Constants.pi*(dFiber_o^2)/4;
  A_shell_gap = A_shell - A_fibers;
  v_b = (portB_in.m_flow/senDenPortB_in.d) / A_shell_gap;

  Re_a = senDenPortA_in.d*v_a*dFiber_i/wet_medium_in.dynamicViscosity(wet_medium_in.setState_phX(portA_in.p, portA_in.h_outflow, portA_in.Xi_outflow));
  Sc_a = wet_medium_in.dynamicViscosity(wet_medium_in.setState_phX(portA_in.p, portA_in.h_outflow, portA_in.Xi_outflow))/(senDenPortA_in.d*D_H2O_Air);
  Re_b = senDenPortB_in.d*v_b*d_hyd_b/dry_medium_in.dynamicViscosity(dry_medium_in.setState_phX(portB_in.p, portB_in.h_outflow, portB_in.Xi_outflow));
  Sc_b = dry_medium_in.dynamicViscosity(dry_medium_in.setState_phX(portB_in.p, portB_in.h_outflow, portB_in.Xi_outflow))/(senDenPortB_in.d*D_H2O_Air);





  // 2. Sherwood numbers
  Sh_wet1 = 3.66;
  Sh_wet2 = 1.615*(Re_a*Sc_a*dFiber_i/L_fiber)^(1/3);
  Sh_wet  = (Sh_wet1^3 + 0.73 + (Sh_wet2 - 0.7)^3)^(1/3);

  Phi     = nFibers*dFiber_o^2/dHousing^2;
  Sh_dry  = (0.53 - 0.58*Phi)*Re_b^0.53*Sc_b^0.33;

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
  R_conv_a = 1.0 / h_conv_a; // placeholder: h_conv_a = f(velocityA, dFiber_o)
  R_conv_b = 1.0 / h_conv_b; // placeholder: h_conv_b = f(velocityB, dHousing)
  R_mem = dFiber_o / (D_mem * A_mem);
  beta_eff = 1 / (R_conv_a + R_mem + R_conv_b);

  // 3. NTU and effectiveness
  NTU = beta_eff * A_mem / V_dot_a;
  eta = if VFR == 1 then NTU / (1 + NTU)
        else (1 - exp((VFR - 1) * NTU)) / (1 - VFR * exp((VFR - 1) * NTU));

  // 4. Steady permeation rate
  m_perm = eta * (portA_in.Xi_outflow[1] - portB_in.Xi_outflow[1]) * portA_in.m_flow;


  // 5. First-order dynamics
  Xi = m_perm / min(portA_in.m_flow, portB_in.m_flow);
  der(Xi_state) = (Xi - Xi_state) / tau_perm;
  m_perm_state = Xi_state * min(portA_in.m_flow, portB_in.m_flow);

  // 6. Mass balances
  portA_out_m_flow = portA_in.m_flow - m_perm_state;
  portB_out_m_flow = portB_in.m_flow + m_perm_state;

  // 7. Species balances (water mass fraction at index 2)
  portA_out_Xi = (portA_in.m_flow * portA_in.Xi_outflow[1] - m_perm_state) / portA_out_m_flow;
  portB_out_Xi = (portB_in.m_flow * portB_in.Xi_outflow[1] + m_perm_state) / portB_out_m_flow;

  // 8. Energy balance (enthalpy flow)
  portA_out_h_outflow = portA_in.h_outflow - m_perm_state*senSpeEntPortA_in.h_out;
  portB_out_h_outflow = portB_in.h_outflow + m_perm_state*senSpeEntPortB_in.h_out;





  connect(portA_in, senDenPortA_in.port_a)
    annotation (Line(points={{0,100},{0,74},{18,74}}, color={0,127,255}));
  connect(portB_in, senDenPortB_in.port_a)
    annotation (Line(points={{-100,0},{-68,0},{-68,-6}}, color={0,127,255}));
  connect(senDenPortA_in.port_b, senSpeEntPortA_in.port_a)
    annotation (Line(points={{38,74},{46,74}}, color={0,127,255}));
  connect(senSpeEntPortA_in.port_b, sinkPortA_in.ports[1])
    annotation (Line(points={{66,74},{86,74}}, color={0,127,255}));
  connect(senDenPortB_in.port_b, senSpeEntPortB_in.port_a)
    annotation (Line(points={{-68,-26},{-68,-36}}, color={0,127,255}));
  connect(senSpeEntPortB_in.port_b, sinkPortB_in.ports[1])
    annotation (Line(points={{-68,-56},{-68,-80}}, color={0,127,255}));
  connect(genPortA_out.ports[1], portA_out) annotation (Line(points={{-1.77636e-15,
          -84},{-1.77636e-15,-92},{-7.10543e-15,-92},{-7.10543e-15,-100}},
        color={0,127,255}));
  connect(genPortB_out.ports[1], portB_out) annotation (Line(points={{78,0},{89,
          0},{89,1.42109e-14},{100,1.42109e-14}}, color={0,127,255}));
  connect(realExpression.y, genPortB_out.m_flow_in)
    annotation (Line(points={{27,14},{46,14},{46,8},{56,8}}, color={0,0,127}));
  connect(genPortB_out.h_in, realExpression1.y)
    annotation (Line(points={{56,4},{56,0},{27,0}}, color={0,0,127}));
  connect(realExpression3.y, genPortA_out.m_flow_in) annotation (Line(points={{-19,
          -26},{2,-26},{2,-54},{12,-54},{12,-62},{8,-62}}, color={0,0,127}));
  connect(realExpression4.y, genPortA_out.h_in)
    annotation (Line(points={{-19,-40},{4,-40},{4,-62}}, color={0,0,127}));
  connect(realExpression5.y, genPortA_out.Xi_in[1])
    annotation (Line(points={{-19,-54},{-4,-54},{-4,-62}}, color={0,0,127}));
  connect(realExpression2.y, genPortB_out.Xi_in[1]) annotation (Line(points={{27,
          -14},{48,-14},{48,-4},{56,-4}}, color={0,0,127}));
annotation (
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
      Rectangle(fillColor={189,189,189}, fillPattern=FillPattern.Solid,
                extent={{-100,60},{100,-60}}, radius=30),
      Rectangle(origin={-62,0},  fillPattern=FillPattern.Solid,
                extent={{-6,60},{6,-60}}),
      Rectangle(origin={62,0},   fillPattern=FillPattern.Solid,
                extent={{-6,60},{6,-60}}),
      Line(origin={0.2,56},   points={{-56,0},{56,0}}),
      Line(origin={0.2,-56},  points={{-56,0},{56,0}})}));
end Humidifier_test_v2;
