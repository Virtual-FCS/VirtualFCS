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
  Modelica.Blocks.Sources.SawTooth sawTooth(period = 10)  annotation(
    Placement(transformation(origin = {-60, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {0, -50}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Sources.RealExpression surge_limit(y = compressor.m_flow_surge)  annotation(
    Placement(transformation(origin = {-85, -24}, extent = {{-15, -10}, {15, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {-26, -54}, extent = {{-6, 6}, {6, -6}})));
  Modelica.Blocks.Math.Add add1(k1 = -1)  annotation(
    Placement(transformation(origin = {-54, -46}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Sources.RealExpression choke_limit(y = compressor.m_flow_choke) annotation(
    Placement(transformation(origin = {-85, -50}, extent = {{-15, -10}, {15, 10}})));
  Modelica.Blocks.Math.Gain to_rad_s(k = 2*pi/60) annotation(
    Placement(transformation(origin = {-36, 0}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, table = [0, 5E4; 1, 6E4; 2, 7E4; 3, 8E4; 4, 9E4; 5, 10E4], extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, timeScale = 100)  annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
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
  connect(add1.u1, surge_limit.y) annotation(
    Line(points = {{-61, -42}, {-64, -42}, {-64, -24}, {-68, -24}}, color = {0, 0, 127}));
  connect(choke_limit.y, add1.u2) annotation(
    Line(points = {{-68.5, -50}, {-61, -50}}, color = {0, 0, 127}));
  connect(add1.y, product.u2) annotation(
    Line(points = {{-48, -46}, {-34, -46}, {-34, -50}}, color = {0, 0, 127}));
  connect(sawTooth.y, product.u1) annotation(
    Line(points = {{-49, -80}, {-40, -80}, {-40, -58}, {-34, -58}}, color = {0, 0, 127}));
  connect(speedLimiter.y, to_rad_s.u) annotation(
    Line(points = {{-48, 0}, {-44, 0}}, color = {0, 0, 127}));
  connect(to_rad_s.y, speed.w_ref) annotation(
    Line(points = {{-30, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(speedLimiter.u, combiTimeTable.y[1]) annotation(
    Line(points = {{-72, 0}, {-78, 0}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-06, Interval = 0.05),
    Documentation(info = "<html><head></head><body>This test drives a <tt>CompressorMap</tt> object, whose pressure ratio and isentropic efficiency are read from <tt>Resources/CompressorMaps/compressor_map.csv</tt>, with a shaft torque that ramps up over the first 20 s. The layout mirrors <tt>CompressorTest</tt>: a mixing volume with mass and energy hold-up sits at the outlet, and an orifice returns the air to the environment to create a pressure drop.<div><br></div><div>Plot <tt>compressor.RPM</tt>, <tt>compressor.PR_op</tt> and <tt>compressor.eta_op</tt> against <tt>compressor.m_flow</tt>, and watch <tt>compressor.surgeMargin</tt>, <tt>compressor.surging</tt> and <tt>compressor.choking</tt> to see the operating point move across the map between the surge and choke lines.</div></body></html>"));

end CompressorMapSweep;
