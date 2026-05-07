within VirtualFCS.ComponentTesting;

model FluidCompressorTest "Simple model to test the compressor component"
 extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(transformation(origin = {140, 82}, extent = {{-10, -10}, {10, 10}})));
  package Medium = Media.CathodeAir;
  parameter Modelica.Units.SI.AbsolutePressure p_set = 2e5 "Outlet set pressure";
  
  Modelica.Blocks.Sources.Step step(height = 11000, offset = 0.01, startTime = 10) annotation(
    Placement(transformation(origin = {-74, 42}, extent = {{-10, -10}, {10, 10}})));
  Fluid.FluidCompressor compressor(redeclare package Medium = Medium, rpm_nom = 11000) annotation(
    Placement(transformation(origin = {-42, -6}, extent = {{-16, -16}, {16, 16}})));
 Modelica.Fluid.System system1 annotation(
    Placement(transformation(origin = {90, 92}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Blocks.Sources.RealExpression setPressure(y = p_set) annotation(
    Placement(transformation(origin = {-8, 54}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Fluid.Sensors.Pressure inletPressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-8, 18}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Fluid.Valves.ValveCompressible outletValve(redeclare package Medium = Medium, dp_nominal(displayUnit = "bar") = 1.5e5, m_flow_nominal = 0.3, opening(start = 0), p_nominal = 2.5e5) annotation(
    Placement(transformation(origin = {52, -6}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
 Modelica.Blocks.Math.Add error_pressure(k2 = -1) annotation(
    Placement(transformation(origin = {18, 22}, extent = {{-6, -6}, {6, 6}})));
 Modelica.Blocks.Continuous.PI PI_valve(T = 10, k = -1e-4) annotation(
    Placement(transformation(origin = {46, 26}, extent = {{-10, -10}, {10, 10}})));
 Modelica.Blocks.Nonlinear.Limiter valveInputLimiter(uMax = 1, uMin = 0) annotation(
    Placement(transformation(origin = {70, 26}, extent = {{-4, -4}, {4, 4}})));
 Modelica.Fluid.Sources.FixedBoundary exhaust(redeclare package Medium = Medium, nPorts = 1, use_T = false) annotation(
    Placement(transformation(origin = {90, -6}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
 Modelica.Fluid.Vessels.ClosedVolume FuelCellDummy(redeclare package Medium = Medium, V = 1, nPorts = 2, use_portsData = false) annotation(
    Placement(transformation(origin = {20, -32}, extent = {{-10, 10}, {10, -10}})));
 Modelica.Fluid.Sensors.Temperature temp_out_comp(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-12, -46}, extent = {{-10, 10}, {10, -10}})));
 Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, X = {0.2, 0.8, 0}, nPorts = 1) annotation(
    Placement(transformation(origin = {-90, -6}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
equation
  connect(setPressure.y, error_pressure.u1) annotation(
    Line(points = {{3, 54}, {6, 54}, {6, 26}, {11, 26}}, color = {0, 0, 127}));
  connect(inletPressure.p, error_pressure.u2) annotation(
    Line(points = {{3, 18}, {11, 18}}, color = {0, 0, 127}));
  connect(error_pressure.y, PI_valve.u) annotation(
    Line(points = {{24.6, 22}, {34.6, 22}, {34.6, 26}}, color = {0, 0, 127}));
  connect(PI_valve.y, valveInputLimiter.u) annotation(
    Line(points = {{57, 26}, {65, 26}}, color = {0, 0, 127}));
  connect(valveInputLimiter.y, outletValve.opening) annotation(
    Line(points = {{74.4, 26}, {86.4, 26}, {86.4, 6}, {52, 6}, {52, 2}}, color = {0, 0, 127}));
 connect(compressor.port_a, source.ports[1]) annotation(
    Line(points = {{-58, -6}, {-80, -6}}, color = {0, 127, 255}));
 connect(compressor.port_b, FuelCellDummy.ports[1]) annotation(
    Line(points = {{-26, -6}, {20, -6}, {20, -22}}, color = {0, 127, 255}));
 connect(FuelCellDummy.ports[2], outletValve.port_a) annotation(
    Line(points = {{20, -22}, {20, -6}, {42, -6}}, color = {0, 127, 255}));
 connect(outletValve.port_b, exhaust.ports[1]) annotation(
    Line(points = {{62, -6}, {80, -6}}, color = {0, 127, 255}));
 connect(inletPressure.port, compressor.port_b) annotation(
    Line(points = {{-8, 8}, {-8, -6}, {-26, -6}}, color = {0, 127, 255}));
 connect(temp_out_comp.port, compressor.port_b) annotation(
    Line(points = {{-12, -36}, {-12, -6}, {-26, -6}}, color = {0, 127, 255}));
 connect(step.y, compressor.set_control) annotation(
    Line(points = {{-62, 42}, {-42, 42}, {-42, 8}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 20, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})));
 end FluidCompressorTest;
