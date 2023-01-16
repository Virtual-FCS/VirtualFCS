within VirtualFCS.Fluid;

block PressureRegulator
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // System
  outer Modelica.Fluid.System system "System properties";
  // Medium declaration
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Valves
  Modelica.Fluid.Valves.ValveCompressible valveCompressible(redeclare package Medium = Medium, checkValve = true, dp_nominal(displayUnit = "Pa") = 10000, filteredOpening = false, m_flow_nominal = 0.01, p_nominal = 5*101325) annotation(
    Placement(visible = true, transformation(origin = {31, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  // Other
  Modelica.Blocks.Interfaces.RealInput setDownstreamPressure annotation(
    Placement(visible = true, transformation(origin = {113, -44}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {41, 74}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));
  Modelica.Fluid.Sensors.Pressure pressure_sensor(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {72, -10}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID pid(Td = 1e-3, k = 1e-6, yMax = 1, yMin = 0) annotation(
    Placement(visible = true, transformation(origin = {60, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(valveCompressible.port_b, Output) annotation(
    Line(points = {{41, 0}, {100, 0}}, color = {0, 170, 0}, thickness = 1));
  connect(pressure_sensor.port, valveCompressible.port_b) annotation(
    Line(points = {{72, 0}, {41, 0}}, color = {0, 170, 0}, thickness = 1));
  connect(setDownstreamPressure, pid.u_s) annotation(
    Line(points = {{113, -44}, {72, -44}}, color = {0, 0, 127}));
  connect(pid.u_m, pressure_sensor.p) annotation(
    Line(points = {{60, -32}, {60, -10}, {61, -10}}, color = {0, 0, 127}));
  connect(pid.y, valveCompressible.opening) annotation(
    Line(points = {{49, -44}, {31, -44}, {31, -8}}, color = {0, 0, 127}));
  connect(Input, valveCompressible.port_a) annotation(
    Line(points = {{-100, 0}, {22, 0}}, color = {0, 170, 0}, thickness = 1));
protected
  annotation(
    Icon(graphics = {Polygon(origin = {-50, 0}, points = {{-10, 40}, {-10, -40}, {50, 0}, {-10, 40}}), Polygon(origin = {50, 0}, points = {{10, 40}, {10, -40}, {-50, 0}, {10, 40}}), Line(origin = {0, 30}, points = {{0, -30}, {0, 30}}), Line(origin = {-80, 0}, points = {{-20, 0}, {20, 0}, {20, 0}}), Line(origin = {80, 0}, points = {{20, 0}, {-20, 0}}), Line(origin = {40, 29}, points = {{-40, 31}, {40, 31}, {40, -31}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The PressureRegulator model is designed to reduce the pressure from a high-pressure source on the upstream side to a lower pressure on the downstream side by regulating the opening in a compressible fluid valve. Regulation of the valve opening is managed using a PID controller.</body></html>"));
end PressureRegulator;
