within VirtualFCS.Fluid;

model Compressor "Compressor with constant isentropic efficiency"
  extends VirtualFCS.Fluid.CompressorInterface(useHeatPort=true);

  import Modelica.Constants.eps;

  parameter Modelica.Units.SI.Efficiency eta = 0.8 "Isoentropic efficiency";
  parameter Modelica.Units.SI.Power P_nom(displayUnit="kW") = 40000 "Nominal compressor power";
  parameter Modelica.Units.SI.AngularVelocity RPM_nom(displayUnit="rpm") = 8377.580409572781 "Nominal rounds per minute";

  Modelica.Units.SI.AngularVelocity RPM(displayUnit="rpm") = RPM_nom * sqrt(sensor.power/P_nom) "Actual rounds per minute";
  Modelica.Units.SI.MassFlowRate m_flow(min=0, start=1e-4, fixed=true) "Mass flow through the unit";

  Modelica.Units.SI.EnthalpyFlowRate Hin  = port_a.m_flow * inStream(port_a.h_outflow) "Enthalpy inflow at inlet";
  Modelica.Units.SI.EnthalpyFlowRate Hout = port_b.m_flow * port_b.h_outflow "Enthalpy inflow at outlet (mind the sign)";
  
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1e-4)  annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.MultiSensor sensor annotation(
    Placement(transformation(origin = {-28, -20}, extent = {{-10, -10}, {10, 10}})));
protected
  Medium.ThermodynamicState state_in = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow));
  Medium.ThermodynamicState state_out = Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow);
  Modelica.Units.SI.KinematicViscosity m_flow_relax=1 "Relaxation constant for mass flow, time scale << 1 s";
  Modelica.Mechanics.Rotational.Components.Damper damper(final d = P_nom/RPM_nom^2) annotation(
    Placement(transformation(origin = {10, -20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
    Placement(transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}})));
equation
  port_a.m_flow = m_flow;
  port_b.m_flow = -m_flow "No-holdup model - what goes in leaves immediately";
  port_a.Xi_outflow = inStream(port_a.Xi_outflow) "Compositions do not change";
  port_b.Xi_outflow  = port_a.Xi_outflow "Compositions do not change";
  port_a.h_outflow = inStream(port_a.h_outflow) "Not supposed to be used, but must be set to balance equations";
  
  if noEvent(abs(port_b.m_flow) > eps) then
    Hin + Hout + sensor.power - lossPower = 0 "Energy balance, lossPower uses opposite sign convention";
  else
    port_b.h_outflow = port_a.h_outflow "Handle case of no flow, or Hout definition will not be invertible";
  end if;
  TheatPort = Medium.temperature(state_out) "Heat port temperature set at outlet temperature";
  m_flow_relax * der(m_flow) = Hin + sensor.power*eta - m_flow*Medium.isentropicEnthalpy(port_b.p, state_in) "Avoid spurious branch with dynamic m_flow";

  connect(flange_a, inertia.flange_a) annotation(
    Line(points = {{-100, 0}, {-90, 0}, {-90, -20}, {-80, -20}}));
  connect(inertia.flange_b, sensor.flange_a) annotation(
    Line(points = {{-60, -20}, {-38, -20}}));
  connect(damper.flange_a, fixed.flange) annotation(
    Line(points = {{20, -20}, {50, -20}}));
  connect(damper.flange_b, sensor.flange_b) annotation(
    Line(points = {{0, -20}, {-18, -20}}));

  annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>eta</code></td><td>SI.Efficiency</td><td>1</td><td>0.8</td><td>Isoentropic efficiency</td></tr>
<tr><td><code>P_nom</code></td><td>SI.Power</td><td>W</td><td>40000</td><td>kW</td></tr>
<tr><td><code>RPM_nom</code></td><td>SI.AngularVelocity</td><td>rad/s</td><td>8377.580409572781</td><td>rpm</td></tr></tbody></table><h2>2. Model description</h2>This compressor model takes a set isentropic efficiency, nominal power and RPM, and calculates the change in flow properties from inlet to outlet.<div>The unit does not implement any fluid holdup, but has an adjustable mechanical&nbsp;<tt>inertia.J</tt>.</div><div><br></div><div>Outlet conditions are calculated using the <tt>isentropicEnthalpy</tt> function of the Medium, which will need to have been implemented: this allows to handle non-ideal gases (e.g. water vapour, ammonia, or any gases at high pressures).</div><div><br></div><div>By default, <tt>heatport</tt>&nbsp;is enabled, which will result in an adiabatic compressor if nothing is connected to it; this is usually the normal case.</div><div>If&nbsp;<tt>heatport</tt>&nbsp;is not enabled, the outlet of the compressor will be set at parameter <tt>T</tt>, which may simulate e.g. an ideal cooler downstream a compressor, whose duty will be given by <tt>lossPower</tt>.</div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>port_a.m_flow = m_flow;
port_b.m_flow = -m_flow \"No-holdup model - what goes in leaves immediately\";
port_a.Xi_outflow = inStream(port_a.Xi_outflow) \"Compositions do not change\";
port_b.Xi_outflow  = port_a.Xi_outflow \"Compositions do not change\";
port_a.h_outflow = inStream(port_a.h_outflow) \"Not supposed to be used, but must be set to balance equations\";
Hin + Hout + sensor.power - lossPower = 0 \"Energy balance, lossPower uses opposite sign convention\";
port_b.h_outflow = port_a.h_outflow \"Handle case of no flow, or Hout definition will not be invertible\";</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end Compressor;
