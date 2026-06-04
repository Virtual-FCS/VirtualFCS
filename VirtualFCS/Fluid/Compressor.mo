within VirtualFCS.Fluid;

model Compressor "Compressor with constant polytropic efficiency"
  extends VirtualFCS.Fluid.CompressorInterface(useHeatPort=true);

  import Modelica.Constants.eps;

  parameter Modelica.Units.SI.Efficiency eta = 0.8 "Isoentropic efficiency";
  parameter Modelica.Units.SI.Power P_nom(displayUnit="kW") = 40000 "Nominal compressor power";
  parameter Modelica.Units.SI.AngularVelocity RPM_nom(displayUnit="rpm") = 8377.580409572781 "Nominal rounds per minute";

  Medium.BaseProperties medium_in, medium_out "Medium properties at inlet and outlet";

  Modelica.Units.SI.EnthalpyFlowRate Hin  = inlet.m_flow * inStream(inlet.h_outflow) "Enthalpy inflow at inlet";
  Modelica.Units.SI.EnthalpyFlowRate Hout = outlet.m_flow * outlet.h_outflow "Enthalpy inflow at outlet (mind the sign)";
  
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1e-4)  annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.MultiSensor sensor annotation(
    Placement(transformation(origin = {-28, 0}, extent = {{-10, -10}, {10, 10}})));
protected
  Modelica.Mechanics.Rotational.Components.Damper damper(final d = P_nom/RPM_nom^2) annotation(
    Placement(transformation(origin = {10, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
    Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  assert(inlet.m_flow >= -eps, "Reverse flow in compressor.") "No reverse flow admissible";
  inlet.m_flow + outlet.m_flow = 0 "No-holdup model - what goes in leaves immediately";
  inlet.Xi_outflow = inStream(inlet.Xi_outflow) "Compositions do not change";
  medium_in.Xi = inlet.Xi_outflow "Compositions do not change";
  medium_out.Xi = medium_in.Xi "Compositions do not change";
  outlet.Xi_outflow = medium_out.Xi "Compositions do not change";
  medium_in.p = inlet.p "Bind inlet pressures to medium";
  medium_out.p = outlet.p "Bind outlet pressures to medium";
  medium_in.T = Medium.temperature_phX(medium_in.p, inStream(inlet.h_outflow), medium_in.X) "Inlet temperature from specific enthalpy";
  medium_out.T = Medium.temperature_phX(medium_out.p, outlet.h_outflow, medium_out.X) "Outlet temperature from specific enthalpy";
  inlet.h_outflow = inStream(inlet.h_outflow) "Not supposed to be used, but must be set to balance equations";
  
  if noEvent(inlet.m_flow > eps) then
    Hin + Hout + sensor.power - lossPower = 0 "Energy balance, lossPower uses opposite sign convention";
  else
    outlet.h_outflow = inlet.h_outflow "Handle case of no flow, or Hout definition will not be invertible";
  end if;
  TheatPort = medium_out.T "Heat port temperature set at outlet temperature";
  -sensor.power*eta = outlet.m_flow*Medium.isentropicEnthalpy(medium_out.p, medium_in.state) + Hin "Relate power to flow isentropic enthalpy";

  connect(flange, inertia.flange_a) annotation(
    Line(points = {{-100, 0}, {-80, 0}}));
  connect(inertia.flange_b, sensor.flange_a) annotation(
    Line(points = {{-60, 0}, {-38, 0}}));
  connect(damper.flange_a, fixed.flange) annotation(
    Line(points = {{20, 0}, {50, 0}}));
  connect(damper.flange_b, sensor.flange_b) annotation(
    Line(points = {{0, 0}, {-18, 0}}));
  annotation(
    Documentation(info = "<html><head></head><body>This compressor model takes a set isentropic efficiency, nominal power and RPM, and calculates the change in flow properties from inlet to outlet.<div>The unit does not implement any fluid holdup, but has an adjustable mechanical&nbsp;<tt>inertia.J</tt>.</div><div><br></div><div>Outlet conditions are calculated using the <tt>isentropicEnthalpy</tt> function of the Medium, which will need to have been implemented: this allows to handle non-ideal gases (e.g. water vapour, ammonia, or any gases at high pressures).</div><div><br></div><div>By default, <tt>heatport</tt>&nbsp;is enabled, which will result in an adiabatic compressor if nothing is connected to it; this is usually the normal case.</div><div>If&nbsp;<tt>heatport</tt>&nbsp;is not enabled, the outlet of the compressor will be set at parameter <tt>T</tt>, which may simulate e.g. an ideal cooler downstream a compressor, whose duty will be given by <tt>lossPower</tt>.</div></body></html>"));
end Compressor;
