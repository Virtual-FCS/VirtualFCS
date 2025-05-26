within VirtualFCS.Fluid;
model Humidifier_test_GPT
  "
  Hollow fiber membrane humidifier:
    - Counterflow NTU-based mass exchanger
    - Optional first-order dynamics for moisture transfer
  Uses only Modelica Standard Library + Buildings.
  "

  //import Buildings.Fluid.Interfaces as Interfaces;
  //import Buildings.Media.Air as Medium;

  replaceable package medium = Buildings.Media.Air(reference_X = {0.0, 1.0});

  // Wet (A) and Dry (B) fluid ports
  Modelica.Fluid.Interfaces.FluidPort_a portA_in(  redeclare package Medium = medium)
    "Wet side inlet"
    annotation(Placement(transformation(extent={{-10, 90},{10,110}})));

  Modelica.Fluid.Interfaces.FluidPort_b portA_out( redeclare package Medium = medium)
    "Wet side outlet"
    annotation(Placement(transformation(extent={{100, 50},{120,70}}, origin={110,-40}, rotation=180)));

  Modelica.Fluid.Interfaces.FluidPort_a portB_in(  redeclare package Medium = medium)
    "Dry side inlet"
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b portB_out( redeclare package Medium = medium)
    "Dry side outlet"
    annotation(Placement(transformation(extent={{100,-70},{120,-50}}, origin={210,-60}, rotation=180)));

  // Geometry & membrane
  parameter Integer nFibers = 488 "Number of hollow fibers";
  parameter Modelica.Units.SI.Length       dF_o = 0.001  "Outer diameter [m]";
  parameter Modelica.Units.SI.Length       lF   = 0.1508 "Fiber length [m]";
  parameter Modelica.Units.SI.Conductivity D_mem=3.63e-7 "Diffusion coeff [m2/s]";
  parameter Modelica.Units.SI.Time         tau_perm = 6.1 "Perm. time constant [s]";
  parameter Boolean useDynamics = true   "Enable 1st-order lag";

  // States & flows
  Real Xi_state(start=0)              "Lagged driving potential";
  Modelica.Units.SI.MassFlowRate m_flowA, m_flowB, m_perm;
  Real Xi_Ain, Xi_Bin, deltaXi, NTU, eta;
  Real Xi_Aout, Xi_Bout;
  Modelica.Units.SI.Area A_mem = nFibers * Modelica.Constants.pi * dF_o * lF;

  // Thermodynamic state records
  Buildings.Media.Air.ThermodynamicState stateA, stateB;
  Real X_A[2], X_B[2]  "Mass-fraction vectors: {dry,water}";

equation
  // Mass flows
  m_flowA = portA_in.m_flow;
  m_flowB = portB_in.m_flow;

  // Inlet water mass-fraction = second entry of the Xi_outflow vector
  Xi_Ain = portA_in.Xi_outflow[1];
  Xi_Bin = portB_in.Xi_outflow[1];
  deltaXi = Xi_Bin - Xi_Ain;

  // NTU & counterflow efficiency
  NTU = D_mem * A_mem / min(m_flowA, m_flowB);
  eta = if abs(1 - m_flowA/m_flowB) < 1e-6 then
          NTU/(1+NTU)
        else
          (1 - exp((m_flowA/m_flowB - 1)*NTU))
          /(1 - (m_flowA/m_flowB)*exp((m_flowA/m_flowB - 1)*NTU));

  // Dynamics or steady-state transfer
  if useDynamics then
    der(Xi_state) = (eta*deltaXi - Xi_state)/tau_perm;
    m_perm = Xi_state * min(m_flowA,m_flowB);
  else
    m_perm = eta * deltaXi * min(m_flowA,m_flowB);
  end if;

  // Update port flows
  portA_out.m_flow = m_flowA - m_perm;
  portB_out.m_flow = m_flowB + m_perm;

  // Compute outlet water fractions
  Xi_Aout = (Xi_Ain*m_flowA - m_perm)/portA_out.m_flow;
  Xi_Bout = (Xi_Bin*m_flowB + m_perm)/portB_out.m_flow;

  // Build full mass-fraction vectors
  X_A = {1 - Xi_Aout, Xi_Aout};
  X_B = {1 - Xi_Bout, Xi_Bout};

  // Reconstruct outlet enthalpies from (p,T,X)
  stateA = medium.setState_pTX(portA_out.p, 293.15, X_A);
  portA_out.h_outflow = medium.specificEnthalpy(stateA);

  stateB = medium.setState_pTX(portB_out.p, 293.15, X_B);
  portB_out.h_outflow = medium.specificEnthalpy(stateB);

  // (No more approximate h equations here)
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
end Humidifier_test_GPT;
