within VirtualFCS.ComponentTesting;

model ElectricCompressorTest
  package Medium = VirtualFCS.Media.CathodeAir;
  Fluid.ElectricCompressor compressor(redeclare package Medium = Medium, K(k = 2e2, Ti = 1))  annotation(
    Placement(transformation(origin = {-30, -26}, extent = {{-30, -30}, {30, 30}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary environment(nPorts = 2, redeclare package Medium = VirtualFCS.Media.CathodeAir)  annotation(
    Placement(transformation(origin = {-50, 70}, extent = {{-10, 10}, {10, -10}})));
  VirtualFCS.Electrochemical.Hydrogen.Manifold manifold(MMs = {0.032, 0.028, 0.018}, redeclare package Medium = Medium, T = 353.15, V = 1, nu = {-0.5, 0, 1}, useHeatPort = false) annotation(
    Placement(transformation(origin = {30, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant reaction_rate(k = 1) annotation(
    Placement(transformation(origin = {4, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-72, 18}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage V_s(V = 48)  annotation(
    Placement(transformation(origin = {-50, 24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 0.3, offset = 0.001, startTime = 10)  annotation(
    Placement(transformation(origin = {-98, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID_valve(Ti = 2, controllerType = Modelica.Blocks.Types.SimpleController.PI, k = -1e-4, yMax = 1, yMin = 0) annotation(
    Placement(transformation(origin = {74, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.Constant p_set_point(k = 2e5) annotation(
    Placement(transformation(origin = {36, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
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
  connect(reaction_rate.y, manifold.r) annotation(
    Line(points = {{15, 6}, {15, -18}, {30, -18}}, color = {0, 0, 127}));
  connect(step.y, compressor.set_mass_flow) annotation(
    Line(points = {{-86, -10}, {-66, -10}}, color = {0, 0, 127}));
  connect(manifold.port_b, valve.port_a) annotation(
    Line(points = {{40, -26}, {66, -26}}, color = {0, 127, 255}));
  connect(valve.port_b, environment.ports[2]) annotation(
    Line(points = {{86, -26}, {96, -26}, {96, 70}, {-40, 70}}, color = {0, 127, 255}));
  connect(pressure.port, manifold.port_b) annotation(
    Line(points = {{50, -18}, {50, -26}, {40, -26}}, color = {0, 127, 255}));
  connect(PID_valve.u_s, p_set_point.y) annotation(
    Line(points = {{62, 26}, {48, 26}, {48, 28}}, color = {0, 0, 127}));
  connect(pressure.p, PID_valve.u_m) annotation(
    Line(points = {{56, -12}, {72, -12}, {72, 14}, {74, 14}}, color = {0, 0, 127}));
  connect(PID_valve.y, valve.opening) annotation(
    Line(points = {{86, 26}, {92, 26}, {92, -18}, {76, -18}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.06),
    Diagram);
end ElectricCompressorTest;
