within VirtualFCS.Fluid;

model Compressor "Compressor with constant polytropic efficiency"
  extends VirtualFCS.Fluid.CompressorInterface(useHeatPort=true);

  import Modelica.Units.Conversions.from_rpm;
  import Modelica.Constants.eps;

  parameter Modelica.Units.SI.Efficiency eta = 0.8 "Fixed isoentropic efficiency";
  parameter Modelica.Units.SI.Power P_nom(displayUnit="kW") = 40000 "Nominal compressor power";
  parameter Modelica.Units.NonSI.AngularVelocity_rpm RPM_nom = 80000 "Nominal rounds per minute";

  Medium.BaseProperties medium_in, medium_out "Medium properties at inlet and outlet";

  Modelica.Units.SI.EnthalpyFlowRate Hin  = inlet.m_flow * inStream(inlet.h_outflow);
  Modelica.Units.SI.EnthalpyFlowRate Hout = outlet.m_flow * outlet.h_outflow;
  
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1e-4)  annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.MultiSensor sensor annotation(
    Placement(transformation(origin = {-28, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  assert(inlet.m_flow >= -eps, "Reverse flow in compressor.") "No reverse flow admissible";
  inlet.m_flow + outlet.m_flow = 0 "No-holdup model - what goes in leaves immediately";
  medium_in.Xi = actualStream(inlet.Xi_outflow) "Compositions do not change";
  medium_out.Xi = actualStream(outlet.Xi_outflow) "Compositions do not change";
  medium_in.Xi = medium_out.Xi "Compositions do not change";
  medium_in.p = inlet.p "Bind inlet pressures to medium";
  medium_out.p = outlet.p "Bind outlet pressures to medium";
  medium_in.T = Medium.temperature_phX(medium_in.p, inStream(inlet.h_outflow), medium_in.X) "Inlet temperature from specific enthalpy";
  medium_out.T = Medium.temperature_phX(medium_out.p, outlet.h_outflow, medium_out.X) "Outlet temperature from specific enthalpy";
  inlet.h_outflow = outlet.h_outflow "Not supposed to be used, but must be set to balance equations";
  inlet.Xi_outflow = medium_in.Xi "Not supposed to be used, but must be set to balance equations";
  Hin + Hout + sensor.power - lossPower = 0 "Energy balance, lossPower uses opposite sign convention";
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
  protected
  Modelica.Mechanics.Rotational.Components.Damper damper(d = P_nom/(RPM_nom)^2, w_rel(start = 0.01*RPM_nom))  annotation(
    Placement(transformation(origin = {10, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
    Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
  annotation(
    Documentation(info = "<html><head></head><body>Given a set efficiency, nominal power and RPM, this compressor will assume a linear relationship between shaft torque and RPM and implement a polytropic relation based on the specific heats of the entering fluid.<div>The unit does not implement any holdup, but has an adjustable <tt>inertia.J</tt>.</div><div><br></div><div>Outlet pressure is calculated with the polytropic&nbsp;<br><div><br></div><div><br></div><div><li>if&nbsp;<tt>heatport</tt>&nbsp;is&nbsp;<tt>true</tt>&nbsp;(default), the heat port can either be connected or not:</li><ul><li>Without any connection, adiabatic operation is assumed; this is usually what you want.</li><li>Connection are possible to e.g. thermal capacitors or radiators; in this case note that the reference temperature is the&nbsp;<i>outlet</i>'s.</li></ul><li>otherwise, the&nbsp;<i>outlet</i>&nbsp;temperature will be set to a constant value given by&nbsp;<tt>T</tt>.</li></div></div></body></html>"));
end Compressor;
