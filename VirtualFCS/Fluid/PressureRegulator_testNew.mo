within VirtualFCS.Fluid;

block PressureRegulator_testNew
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15), AbsolutePressure(start = 101325));
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Valves
  Modelica.Fluid.Valves.ValveCompressible valveCompressible(redeclare package Medium = Medium, checkValve = true, dp_nominal(displayUnit = "Pa") = 10000, filteredOpening = false, m_flow_nominal = 0.01, p_nominal = 5*101325) annotation(
    Placement(visible = true, transformation(origin = {37, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  // Other
  Modelica.Blocks.Interfaces.RealInput setDownstreamPressure annotation(
    Placement(visible = true, transformation(origin = {113, -44}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {41, 74}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));
  Modelica.Fluid.Sensors.Pressure pressure_sensor(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {78, -10}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID pid(Td = 1e-3, k = 1e-6, yMax = 1, yMin = 0) annotation(
    Placement(visible = true, transformation(origin = {62, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Medium, V = 0.0005, nPorts = 1, p_start = 101325*7, use_HeatTransfer = false, use_portsData = false)  annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Valves.ValveCompressible valveCompressible1(redeclare package Medium = Medium, checkValve = true, dp_nominal(displayUnit = "Pa") = 10000, filteredOpening = false, m_flow_nominal = 0.01, p_nominal = 5*101325) annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-32, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Continuous.LimPID limPID(Td = 1e-3, k = 1e-6, yMax = 1, yMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-84, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = 0.001)  annotation(
    Placement(visible = true, transformation(origin = {-62, -28}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 101325*6)  annotation(
    Placement(visible = true, transformation(origin = {-48, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(valveCompressible.port_b, Output) annotation(
    Line(points = {{47, 0}, {98, 0}}, color = {0, 127, 255}));
  connect(pressure_sensor.port, valveCompressible.port_b) annotation(
    Line(points = {{78, 0}, {47, 0}}, color = {0, 127, 255}));
  connect(setDownstreamPressure, pid.u_s) annotation(
    Line(points = {{113, -44}, {74, -44}}, color = {0, 0, 127}));
  connect(pid.u_m, pressure_sensor.p) annotation(
    Line(points = {{62, -32}, {62, -10}, {67, -10}}, color = {0, 0, 127}));
  connect(pid.y, valveCompressible.opening) annotation(
    Line(points = {{51, -44}, {37, -44}, {37, -8}}, color = {0, 0, 127}));
  connect(Input, valveCompressible1.port_a) annotation(
    Line(points = {{-98, 0}, {-78, 0}}));
  connect(valveCompressible1.port_b, teeJunctionIdeal.port_1) annotation(
    Line(points = {{-58, 0}, {-10, 0}}, color = {0, 127, 255}));
  connect(pressure.port, valveCompressible1.port_b) annotation(
    Line(points = {{-32, -10}, {-32, 0}, {-58, 0}}, color = {0, 127, 255}));
  connect(pressure.p, fixedDelay.u) annotation(
    Line(points = {{-42, -20}, {-52, -20}, {-52, -28}}, color = {0, 0, 127}));
  connect(fixedDelay.y, limPID.u_m) annotation(
    Line(points = {{-70, -28}, {-84, -28}, {-84, -38}}, color = {0, 0, 127}));
  connect(realExpression.y, limPID.u_s) annotation(
    Line(points = {{-58, -66}, {-64, -66}, {-64, -50}, {-72, -50}}, color = {0, 0, 127}));
  connect(limPID.y, valveCompressible1.opening) annotation(
    Line(points = {{-94, -50}, {-100, -50}, {-100, -8}, {-68, -8}}, color = {0, 0, 127}));
  connect(teeJunctionIdeal.port_3, volume.ports[1]) annotation(
    Line(points = {{0, -10}, {0, -40}}, color = {0, 127, 255}));
  connect(teeJunctionIdeal.port_2, valveCompressible.port_a) annotation(
    Line(points = {{10, 0}, {28, 0}}, color = {0, 127, 255}));
protected
  annotation(
    Icon(graphics = {Polygon(origin = {-50, 0}, points = {{-10, 40}, {-10, -40}, {50, 0}, {-10, 40}}), Polygon(origin = {50, 0}, points = {{10, 40}, {10, -40}, {-50, 0}, {10, 40}}), Line(origin = {0, 30}, points = {{0, -30}, {0, 30}}), Line(origin = {-80, 0}, points = {{-20, 0}, {20, 0}, {20, 0}}), Line(origin = {80, 0}, points = {{20, 0}, {-20, 0}}), Line(origin = {40, 29}, points = {{-40, 31}, {40, 31}, {40, -31}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The PressureRegulator model is designed to reduce the pressure from a high-pressure source on the upstream side to a lower pressure on the downstream side by regulating the opening in a compressible fluid valve. Regulation of the valve opening is managed using a PID controller.</body></html>"));
end PressureRegulator_testNew;
