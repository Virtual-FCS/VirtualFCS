within VirtualFCS.ComponentTesting;

model ElectricCompressorTest
  extends Modelica.Icons.Example;
  package Medium = VirtualFCS.Media.MoistAir;
  Fluid.ElectricCompressor compressor(redeclare package Medium = Medium, K(k = 2e2, Ti = 1))  annotation(
    Placement(transformation(origin = {-30, -26}, extent = {{-30, -30}, {30, 30}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary environment(nPorts = 2, redeclare package Medium = VirtualFCS.Media.MoistAir)  annotation(
    Placement(transformation(origin = {-50, 70}, extent = {{-10, 10}, {10, -10}})));
  VirtualFCS.Electrochemical.Hydrogen.Manifold manifold(MMX = {0.032, 0.028, 0.018}, redeclare package Medium = Medium, T = 353.15, V = 1, nu = {-0.5, 0, 1}, useHeatPort = false) annotation(
    Placement(transformation(origin = {30, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant reaction_rate(k = 0) annotation(
    Placement(transformation(origin = {-10, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-72, 18}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage V_s(V = 48)  annotation(
    Placement(transformation(origin = {-50, 24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 0.3, offset = 0.001, startTime = 10)  annotation(
    Placement(transformation(origin = {-90, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID_valve(Ti = 2, controllerType = Modelica.Blocks.Types.SimpleController.PI, k = -1e-4, yMax = 1, yMin = 0) annotation(
    Placement(transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant p_set_point(k = 2e5) annotation(
    Placement(transformation(origin = {30, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Valves.ValveCompressible valve(redeclare package Medium = Medium, dp_nominal(displayUnit = "bar") = 1.5e5, m_flow_nominal = 0.3, opening(start = 0), p_nominal = 2.5e5)  annotation(
    Placement(transformation(origin = {76, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {50, -12}, extent = {{-6, -6}, {6, 6}})));
equation
  connect(environment.ports[1], compressor.port_a) annotation(
    Line(points = {{-40, 70}, {-40, 68}, {-36, 68}, {-36, -14}}, color = {0, 127, 255}));
  connect(compressor.port_b, manifold.port_a) annotation(
    Line(points = {{0, -26}, {20, -26}}, color = {0, 127, 255}));
  connect(V_s.p, compressor.pin_p) annotation(
    Line(points = {{-60, 24}, {-56, 24}, {-56, 4}}, color = {0, 0, 255}));
  connect(V_s.n, compressor.pin_n) annotation(
    Line(points = {{-40, 24}, {-44, 24}, {-44, 4}}, color = {0, 0, 255}));
  connect(ground.p, V_s.n) annotation(
    Line(points = {{-72, 24}, {-72, 36}, {-40, 36}, {-40, 24}}, color = {0, 0, 255}));
  connect(step.y, compressor.set_mass_flow) annotation(
    Line(points = {{-79, -10}, {-66, -10}}, color = {0, 0, 127}));
  connect(manifold.port_b, valve.port_a) annotation(
    Line(points = {{40, -26}, {66, -26}}, color = {0, 127, 255}));
  connect(valve.port_b, environment.ports[2]) annotation(
    Line(points = {{86, -26}, {96, -26}, {96, 70}, {-40, 70}}, color = {0, 127, 255}));
  connect(pressure.port, manifold.port_b) annotation(
    Line(points = {{50, -18}, {50, -26}, {40, -26}}, color = {0, 127, 255}));
  connect(PID_valve.u_s, p_set_point.y) annotation(
    Line(points = {{58, 30}, {41, 30}}, color = {0, 0, 127}));
  connect(pressure.p, PID_valve.u_m) annotation(
    Line(points = {{56, -12}, {70, -12}, {70, 18}}, color = {0, 0, 127}));
  connect(PID_valve.y, valve.opening) annotation(
    Line(points = {{81, 30}, {92, 30}, {92, -18}, {76, -18}}, color = {0, 0, 127}));
  connect(reaction_rate.y, manifold.r) annotation(
    Line(points = {{2, 10}, {30, 10}, {30, -18}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.06),
    Diagram);
annotation(Documentation(info = "<html><p>This test starts the compressor at 0.001 kg/s and steps the commanded mass flow to 0.301 kg/s at 10 s.</p><p>The bench uses a 48 V supply, a 2e5 Pa pressure setpoint, a 2.5e5 Pa nominal valve pressure, and a 1 m3 manifold at 353.15 K. The nominal flow is 0.3 kg/s with a 1.5e5 Pa nominal pressure difference.</p></html>"));
end ElectricCompressorTest;
