within VirtualFCS.Fluid;

model Compressor "Compressor with constant polytropic efficiency"
  extends VirtualFCS.Fluid.CompressorInterface(useHeatPort=true);

  import Modelica.Constants.eps;

  parameter Modelica.Units.SI.Efficiency eta = 0.8 "Isoentropic efficiency";
  parameter Modelica.Units.SI.Power P_nom(displayUnit="kW") = 40000 "Nominal compressor power";
  parameter Modelica.Units.SI.AngularVelocity RPM_nom(displayUnit="rpm") = 8377.580409572781 "Nominal rounds per minute";

  Modelica.Units.SI.AngularVelocity RPM(displayUnit="rpm") "Actual rounds per minute";

  Medium.BaseProperties medium_in, medium_out "Medium properties at inlet and outlet";
  Modelica.Units.SI.MassFlowRate m_flow(min=0) "Mass flow through the unit";

  Modelica.Units.SI.EnthalpyFlowRate Hin  = port_a.m_flow * inStream(port_a.h_outflow) "Enthalpy inflow at inlet";
  Modelica.Units.SI.EnthalpyFlowRate Hout = port_b.m_flow * port_b.h_outflow "Enthalpy inflow at outlet (mind the sign)";
  
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1e-4)  annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.MultiSensor sensor annotation(
    Placement(transformation(origin = {-28, -20}, extent = {{-10, -10}, {10, 10}})));
protected
  Modelica.Units.SI.KinematicViscosity nu_m_flow=1 "Relaxation constant for mass flow";
  Modelica.Mechanics.Rotational.Components.Damper damper(final d = P_nom/RPM_nom^2) annotation(
    Placement(transformation(origin = {10, -20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
    Placement(transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}})));
equation
  port_a.m_flow = m_flow;
  port_b.m_flow = -m_flow "No-holdup model - what goes in leaves immediately";
  RPM = RPM_nom * sensor.power/P_nom;
  port_a.Xi_outflow = inStream(port_a.Xi_outflow) "Compositions do not change";
  medium_in.Xi = port_a.Xi_outflow "Compositions do not change";
  medium_out.Xi = medium_in.Xi "Compositions do not change";
  port_b.Xi_outflow = medium_out.Xi "Compositions do not change";
  medium_in.p = port_a.p "Bind inlet pressures to medium";
  medium_out.p = port_b.p "Bind outlet pressures to medium";
  medium_in.h = inStream(port_a.h_outflow) "Inlet specific enthalpy from upstream";
  medium_out.h = port_b.h_outflow "Outlet specific enthalpy bound to port_b";
  port_a.h_outflow = inStream(port_a.h_outflow) "Not supposed to be used, but must be set to balance equations";
  
  if noEvent(abs(port_b.m_flow) > eps) then
    Hin + Hout + sensor.power - lossPower = 0 "Energy balance, lossPower uses opposite sign convention";
  else
    port_b.h_outflow = port_a.h_outflow "Handle case of no flow, or Hout definition will not be invertible";
  end if;
  TheatPort = medium_out.T "Heat port temperature set at outlet temperature";
  nu_m_flow * der(m_flow) = Hin + sensor.power*eta - m_flow*Medium.isentropicEnthalpy(medium_out.p, medium_in.state) "Avoid spurious branch with dynamic m_flow";

  connect(flange_a, inertia.flange_a) annotation(
    Line(points = {{-100, 0}, {-90, 0}, {-90, -20}, {-80, -20}}));
  connect(inertia.flange_b, sensor.flange_a) annotation(
    Line(points = {{-60, -20}, {-38, -20}}));
  connect(damper.flange_a, fixed.flange) annotation(
    Line(points = {{20, -20}, {50, -20}}));
  connect(damper.flange_b, sensor.flange_b) annotation(
    Line(points = {{0, -20}, {-18, -20}}));

  annotation(
    Documentation(info = "<html><head></head><body>This compressor model takes a set isentropic efficiency, nominal power and RPM, and calculates the change in flow properties from inlet to outlet.<div>The unit does not implement any fluid holdup, but has an adjustable mechanical&nbsp;<tt>inertia.J</tt>.</div><div><br></div><div>Outlet conditions are calculated using the <tt>isentropicEnthalpy</tt> function of the Medium, which will need to have been implemented: this allows to handle non-ideal gases (e.g. water vapour, ammonia, or any gases at high pressures).</div><div><br></div><div>By default, <tt>heatport</tt>&nbsp;is enabled, which will result in an adiabatic compressor if nothing is connected to it; this is usually the normal case.</div><div>If&nbsp;<tt>heatport</tt>&nbsp;is not enabled, the outlet of the compressor will be set at parameter <tt>T</tt>, which may simulate e.g. an ideal cooler downstream a compressor, whose duty will be given by <tt>lossPower</tt>.</div></body></html>"));
end Compressor;
