within VirtualFCS.Fluid;

model Compressor "Compressor with constant polytropic efficiency"
  extends VirtualFCS.Fluid.CompressorInterface(useHeatPort=true);

  import Modelica.Units.Conversions.from_rpm;
  import Modelica.Constants.eps;

  parameter Modelica.Units.SI.Efficiency eta = 0.8 "Fixed isoentropic efficiency";
  parameter Modelica.Units.SI.Power P_nom(displayUnit="kW") = 40000 "Nominal compressor power";
  parameter Modelica.Units.NonSI.AngularVelocity_rpm RPM_nom = 80000 "Nominal rounds per minute";

  Medium.BaseProperties medium_in, medium_out "Medium properties at inlet and outlet";
  
  Modelica.Units.SI.SpecificHeatCapacity cv = Medium.specificHeatCapacityCv(medium_in.state);
  Modelica.Units.SI.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(medium_in.state);
  
  Modelica.Units.SI.EnthalpyFlowRate Hin  = inlet.m_flow * inStream(inlet.h_outflow);
  Modelica.Units.SI.EnthalpyFlowRate Hout = outlet.m_flow *          outlet.h_outflow;
  
  Modelica.Units.SI.Power P = flange.tau*der(flange.phi) "Power consumed by the compressor";
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.21)  annotation(
    Placement(transformation(origin = {-30, 0}, extent = {{10, -10}, {-10, 10}})));
protected
  Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Damper damper(final d=P_nom / from_rpm(RPM_nom)^2)  annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{10, -10}, {-10, 10}})));

equation
  // No reverse flow admissible
  //assert(inlet.m_flow >= -1E-6, "Reverse flow in compressor.");

  // All compositions equal to upstream (no reaction)
  medium_in.Xi = inStream(inlet.Xi_outflow);
  medium_out.Xi = medium_in.Xi;
  outlet.Xi_outflow = medium_out.Xi;

  // Bind inlet/outlet pressures to media
  medium_in.p = inlet.p;
  medium_out.p = outlet.p;

  // No-holdup model - what goes in leaves immediately
  inlet.m_flow + outlet.m_flow = 0;

  // Calculate temperatures from specific enthalpies
  medium_in.T  = Medium.temperature_phX(medium_in.p,  inStream(inlet.h_outflow), medium_in.X);
  medium_out.T = Medium.temperature_phX(medium_out.p,          outlet.h_outflow,  medium_out.X);

  // There is not supposed to be reverse flow, but these must be set to balance equations
  inlet.h_outflow = outlet.h_outflow;
  inlet.Xi_outflow = medium_in.Xi;

  // Outlet specific enthalpy = inlet specific enthalpy + actual specific work FIXME lossPower?
  //outlet.h_outflow = inStream(inlet.h_outflow) + (Medium.isentropicEnthalpy(medium_out.p, medium_in.state) - medium_in.h) / eta;
  // Energy balance (enthalpy in, enthalpy out(will have correct sign), mechanical power in, heat out)
  Hin + Hout + P - lossPower = 0;
  
  // Heat port temperature set at outlet temperature
  TheatPort = medium_out.T;

  // Relate power to flow and pressure ratio
  P*eta = inlet.m_flow * (Medium.isentropicEnthalpy(medium_out.p, medium_in.state) - medium_in.h);

  connect(flange, damper.flange_b) annotation(
    Line(points = {{-100, 0}, {-80, 0}}));
  connect(damper.flange_a, inertia.flange_b) annotation(
    Line(points = {{-60, 0}, {-40, 0}}));
  connect(fixed.flange, inertia.flange_a) annotation(
    Line(points = {{0, 0}, {-20, 0}}));

annotation(
    Documentation(info = "<html><head></head><body>Given a set efficiency, nominal power and RPM, this compressor will assume a linear relationship between shaft torque and RPM and implement a polytropic relation based on the specific heats of the entering fluid.<div>The unit does not implement any holdup, but has an adjustable <tt>inertia.J</tt>.</div><div><br></div><div>Outlet pressure is calculated with the polytropic&nbsp;<br><div><br></div><div><br></div><div><li>if&nbsp;<tt>heatport</tt>&nbsp;is&nbsp;<tt>true</tt>&nbsp;(default), the heat port can either be connected or not:</li><ul><li>Without any connection, adiabatic operation is assumed; this is usually what you want.</li><li>Connection are possible to e.g. thermal capacitors or radiators; in this case note that the reference temperature is the&nbsp;<i>outlet</i>'s.</li></ul><li>otherwise, the&nbsp;<i>outlet</i>&nbsp;temperature will be set to a constant value given by&nbsp;<tt>T</tt>.</li></div></div></body></html>"));
end Compressor;
