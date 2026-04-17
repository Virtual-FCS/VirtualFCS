within VirtualFCS.Fluid;

model FluidCompressor
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation (choicesAllMatching = true);

  replaceable Modelica.Blocks.Interfaces.RealInput set_control "Control input, can be replaced by whatever the manipulated variable is" annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}})));

  
  parameter Real rpm_nom = 11000 "Nominal RPM of the rotor";
  parameter Modelica.Units.SI.Efficiency eta = 0.8 "Isoentropic efficiency";

  Medium.BaseProperties medium_in, medium_out "Medium properties at inlet and outlet";
  
  Real k = cp/cv "Heat capacity ratio, measured at inlet";
  
  Modelica.Units.SI.SpecificHeatCapacity cv = Medium.specificHeatCapacityCv(medium_in.state);
  Modelica.Units.SI.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(medium_in.state);
  
  Modelica.Units.SI.EnthalpyFlowRate Hin = port_a.m_flow * inStream(port_a.h_outflow);
  Modelica.Units.SI.EnthalpyFlowRate Hout = port_b.m_flow * port_b.h_outflow;
  
  equation
// All compositions equal to upstream
  medium_in.Xi = port_a.Xi_outflow;
// Not supposed to ever be used
  medium_in.Xi = inStream(port_a.Xi_outflow);
  medium_in.Xi = medium_out.Xi;
  medium_out.Xi = port_b.Xi_outflow;
// Bind inlet/outlet pressures
  medium_in.p = port_a.p;
  medium_out.p = port_b.p;
// No-holdup model
  port_a.m_flow + port_b.m_flow = 0;
// Calculate T_in from enthalpy, calculate enthalpy_out
  medium_in.T = Medium.temperature_phX(medium_in.p, inStream(port_a.h_outflow), medium_in.X);
  medium_out.T = Medium.temperature_phX(medium_out.p, port_b.h_outflow, medium_out.X);
  Hin + Hout + set_control = 0;
// Not supposed to be ever used
  port_a.h_outflow = port_b.h_outflow;

// Relate work to p ratio
  set_control*eta/port_a.m_flow = k*medium_in.R_s*medium_in.T/(k - 1)*((medium_out.p/medium_in.p)^((k - 1)/k) - 1);
annotation(
    Icon(graphics = {Polygon(origin = {-4, -64}, fillColor = {204, 204, 204}, fillPattern = FillPattern.Solid, points = {{-58, -32}, {4, 32}, {58, -32}, {58, -32}, {-58, -32}}), Ellipse(origin = {0, -3}, fillColor = {204, 204, 204}, fillPattern = FillPattern.Solid , extent = {{-88, 83}, {88, -83}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier)}),
    Documentation(info = "<html><head></head><body>This model implements the method to compute fan/pump pressure to mass flow curves based on Hermite splines, presented by Michael Wetter (DOI 10.26868/25222708.2013.1040) ,&nbsp;</body></html>"));
end FluidCompressor;
