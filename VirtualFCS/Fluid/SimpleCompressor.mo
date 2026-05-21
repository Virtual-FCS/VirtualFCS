within VirtualFCS.Fluid;

model SimpleCompressor "A simple isentropic compressor"
  extends VirtualFCS.Fluid.CompressorInterface; // FIXME Sure we don't want the heat port?

  import Modelica.Units.Conversions.from_rpm;

  parameter Modelica.Units.SI.Efficiency eta = 0.8 "Fixed isoentropic efficiency";
  parameter Modelica.Units.SI.Power P_nom(displayUnit="kW") = 40000 "Nominal compressor power";
  parameter Modelica.Units.NonSI.AngularVelocity_rpm RPM_nom = 80000 "Nominal rounds per minute";

  Medium.BaseProperties medium_in, medium_out "Medium properties at inlet and outlet";
  
  Modelica.Units.SI.SpecificHeatCapacity cv = Medium.specificHeatCapacityCv(medium_in.state);
  Modelica.Units.SI.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(medium_in.state);
  Real k = cp/cv "Heat capacity ratio, measured at inlet";
  
  Modelica.Units.SI.EnthalpyFlowRate Hin  = port_a.m_flow * inStream(port_a.h_outflow);
  Modelica.Units.SI.EnthalpyFlowRate Hout = port_b.m_flow *          port_b.h_outflow;
  
  Modelica.Units.SI.Power P = flange.tau*der(flange.phi) "Power consumed by the compressor";
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.0001)  annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
protected
  Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Damper damper(final d=P_nom / from_rpm(RPM_nom)^2)  annotation(
    Placement(transformation(origin = {-30, 0}, extent = {{10, -10}, {-10, 10}})));


equation
  // No reverse flow admissible
  assert(port_a.m_flow >= 0, "Reverse flow in compressor.");

  // All compositions equal to upstream (no reaction)
  medium_in.Xi = inStream(port_a.Xi_outflow);
  medium_out.Xi = medium_in.Xi;
  port_b.Xi_outflow = medium_out.Xi;
  
  // Bind inlet/outlet pressures to media
  medium_in.p = port_a.p;
  medium_out.p = port_b.p;
  
  // No-holdup model - what goes in leaves immediately
  port_a.m_flow + port_b.m_flow = 0;
  
  // Calculate temperatures from specific enthalpies
  medium_in.T  = Medium.temperature_phX(medium_in.p,  inStream(port_a.h_outflow), medium_in.X);
  medium_out.T = Medium.temperature_phX(medium_out.p,          port_b.h_outflow,  medium_out.X);
  
  // There is not supposed to be reverse flow, but these must be set to balance equations
  port_a.h_outflow = port_b.h_outflow;
  port_a.Xi_outflow = medium_in.Xi;
  
  // Energy balance (enthalpy in, enthalpy out(will have correct sign), mechanical power in, heat out)
  Hin + Hout + P - LossPower = 0;
  
  // Use average temperature as representative for heatPort
  T_heatPort = (medium_in.T + medium_out.T)/2;
  
  // Relate power to flow and pressure ratio
  P*eta/port_a.m_flow = k*medium_in.R_s*medium_in.T/(k - 1)*((medium_out.p/medium_in.p)^((k - 1)/k) - 1);

  connect(fixed.flange, damper.flange_a) annotation(
    Line(points = {{0, 0}, {-20, 0}}));
  connect(flange, inertia.flange_b) annotation(
    Line(points = {{-100, 0}, {-80, 0}}));
  connect(inertia.flange_a, damper.flange_b) annotation(
    Line(points = {{-60, 0}, {-40, 0}}));
end SimpleCompressor;
