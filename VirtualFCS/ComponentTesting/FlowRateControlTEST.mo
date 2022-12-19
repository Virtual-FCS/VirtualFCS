within VirtualFCS.ComponentTesting;

model FlowRateControlTEST
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15), AbsolutePressure(start = 101325));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Medium, V = 1, nPorts = 1, p_start = 35000000, use_HeatTransfer = false, use_portsData = false)  annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Fluid.Valves.ValveCompressible valveCompressible(redeclare package Medium = Medium, checkValve = true, dp_nominal(displayUnit = "Pa") = 10000, filteredOpening = false, m_flow_nominal = 0.01, p_nominal = 5 * 101325) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Vessels.ClosedVolume closedVolume(redeclare package Medium = Medium, V = 1, nPorts = 1, p_start = 101325, use_HeatTransfer = false, use_portsData = false)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Pressure pressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {30, -30}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 0.00002, uMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {-28, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine(f = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-78, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(volume.ports[1], valveCompressible.port_a) annotation(
    Line(points = {{-40, 0}, {-10, 0}}, color = {0, 127, 255}));
  connect(valveCompressible.port_b, closedVolume.ports[1]) annotation(
    Line(points = {{10, 0}, {40, 0}}, color = {0, 127, 255}));
  connect(valveCompressible.port_a, pressure.port) annotation(
    Line(points = {{-10, 0}, {-20, 0}, {-20, -20}, {-30, -20}}, color = {0, 127, 255}));
  connect(valveCompressible.port_b, pressure1.port) annotation(
    Line(points = {{10, 0}, {20, 0}, {20, -20}, {30, -20}}));
  connect(sine.y, limiter.u) annotation(
    Line(points = {{-66, 48}, {-40, 48}, {-40, 40}}, color = {0, 0, 127}));
  connect(limiter.y, valveCompressible.opening) annotation(
    Line(points = {{-16, 40}, {0, 40}, {0, 8}}, color = {0, 0, 127}));
  annotation (experiment(StopTime = 50, Interval = 0.5, Tolerance = 1e-6));
end FlowRateControlTEST;
