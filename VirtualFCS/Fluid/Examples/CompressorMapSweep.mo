within VirtualFCS.Fluid.Examples;

model CompressorMapSweep
  extends Modelica.Icons.Example;
  import Modelica.Constants.pi;
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}})));
  replaceable package Gas = VirtualFCS.Media.MoistAir;
  Modelica.Fluid.Sources.FixedBoundary environment(redeclare package Medium = Gas, nPorts = 1, p = system.p_ambient, T = system.T_ambient) annotation(
    Placement(transformation(origin = {0, 50}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Fluid.CompressorMap compressor(redeclare package Medium = Gas, useHeatPort = true) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(useSupport = false)  annotation(
    Placement(transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.SlewRateLimiter speedLimiter(Rising = 2E3)  annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(use_m_flow_in = true, nPorts = 1, redeclare package Medium = Gas) annotation(
    Placement(transformation(origin = {70, 8}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter flowLimiter annotation(
    Placement(transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain negate(k = -1)  annotation(
    Placement(transformation(origin = {70, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {0, -50}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Sources.RealExpression surge_limit(y = compressor.m_flow_surge)  annotation(
    Placement(transformation(origin = {-85, -24}, extent = {{-15, -10}, {15, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {-26, -54}, extent = {{-6, 6}, {6, -6}})));
  Modelica.Blocks.Math.Add subtract(k1 = -1)  annotation(
    Placement(transformation(origin = {-54, -46}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Sources.RealExpression choke_limit(y = compressor.m_flow_choke) annotation(
    Placement(transformation(origin = {-85, -50}, extent = {{-15, -10}, {15, 10}})));
  Modelica.Blocks.Math.Gain to_rad_s(k = 2*pi/60) annotation(
    Placement(transformation(origin = {-36, 0}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, table = [0, 5E4; 0.5, 55E3; 1, 6E4; 1.5, 65E3; 2, 7E4; 2.5, 75E3; 3, 8E4; 3.5, 85E3; 4, 9E4; 4.5, 95E3; 5, 10E4], extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, timeScale = 100)  annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Sine sine(amplitude = 0.5, f = 0.05, offset = 0.5)  annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(environment.ports[1], compressor.port_a) annotation(
    Line(points = {{0, 40}, {0, 8}, {10, 8}}, color = {0, 127, 255}));
  connect(speed.flange, compressor.flange_a) annotation(
    Line(points = {{0, 0}, {10, 0}}));
  connect(compressor.port_b, boundary.ports[1]) annotation(
    Line(points = {{50, 8}, {60, 8}}, color = {0, 127, 255}));
  connect(negate.y, boundary.m_flow_in) annotation(
    Line(points = {{81, -50}, {90, -50}, {90, 16}, {80, 16}}, color = {0, 0, 127}));
  connect(flowLimiter.y, negate.u) annotation(
    Line(points = {{41, -50}, {58, -50}}, color = {0, 0, 127}));
  connect(add.y, flowLimiter.u) annotation(
    Line(points = {{7, -50}, {18, -50}}, color = {0, 0, 127}));
  connect(product.y, add.u2) annotation(
    Line(points = {{-19, -54}, {-7, -54}}, color = {0, 0, 127}));
  connect(add.u1, surge_limit.y) annotation(
    Line(points = {{-7, -46}, {-20, -46}, {-20, -24}, {-68.5, -24}}, color = {0, 0, 127}));
  connect(subtract.u1, surge_limit.y) annotation(
    Line(points = {{-61, -42}, {-64, -42}, {-64, -24}, {-68, -24}}, color = {0, 0, 127}));
  connect(choke_limit.y, subtract.u2) annotation(
    Line(points = {{-68.5, -50}, {-61, -50}}, color = {0, 0, 127}));
  connect(subtract.y, product.u2) annotation(
    Line(points = {{-48, -46}, {-40, -46}, {-40, -50}, {-34, -50}}, color = {0, 0, 127}));
  connect(speedLimiter.y, to_rad_s.u) annotation(
    Line(points = {{-48, 0}, {-44, 0}}, color = {0, 0, 127}));
  connect(to_rad_s.y, speed.w_ref) annotation(
    Line(points = {{-30, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(speedLimiter.u, combiTimeTable.y[1]) annotation(
    Line(points = {{-72, 0}, {-78, 0}}, color = {0, 0, 127}));
  connect(product.u1, sine.y) annotation(
    Line(points = {{-34, -58}, {-39.5, -58}, {-39.5, -70}, {-59, -70}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-06, Interval = 0.05),
    Documentation(info = "<html><head></head><body>This test drives a <tt>CompressorMap</tt> object, whose pressure ratio and isentropic efficiency are read fromCSV data file&nbsp;<tt>Resources/CompressorMaps/compressor_map.csv</tt>, with a shaft speed that follows (with a rate change limiter) a table sampling the RPMs values of the map's speed lines.<div><br></div><div>The mass flow is set directly by an outlet <tt>boundary</tt>&nbsp;and oscillates sinusoidally between the surge and choke lines as defined for the present speed line; this is also passed through a rate change limiter.<br><div><br></div><div>Making a parametric plot with&nbsp;<tt>compressor.m_flow</tt>&nbsp;on the X axis and&nbsp;<tt>compressor.p_ratio_dyn</tt>&nbsp;will then provide a decent visualisation of the map, that may be compared to the original plot of the data.</div></div></body></html>"));

end CompressorMapSweep;
