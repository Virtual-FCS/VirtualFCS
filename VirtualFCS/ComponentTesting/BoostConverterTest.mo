within VirtualFCS.ComponentTesting;

model BoostConverterTest
  extends Modelica.Icons.Example;
  Electrical.BoostConverter booster(useHeatPort = true)  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Control.TwoPhasedPWM twoPhasedPWM(f(displayUnit = "kHz") = 1e5, theta = 3.141592653589793)  annotation(
    Placement(transformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Resistor R(R = 10)  annotation(
    Placement(transformation(origin = {60, 0}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor R_internal(R = 0.1) annotation(
    Placement(transformation(origin = {-42, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage source(V = 100)  annotation(
    Placement(transformation(origin = {-66, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Sine sine(amplitude = .2, f = 10, offset = .3)  annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-80, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T(T = 323.15)  annotation(
    Placement(transformation(origin = {30, -50}, extent = {{10, -10}, {-10, 10}})));
equation
  connect(twoPhasedPWM.PWM_1, booster.fire_p) annotation(
    Line(points = {{-19, -65}, {-12, -65}, {-12, -24}}, color = {255, 0, 255}));
  connect(twoPhasedPWM.PWM_2, booster.fire_n) annotation(
    Line(points = {{-19, -75}, {12, -75}, {12, -24}}, color = {255, 0, 255}));
  connect(booster.dc_p2, R.p) annotation(
    Line(points = {{20, 12}, {60, 12}}, color = {0, 0, 255}));
  connect(booster.dc_n2, R.n) annotation(
    Line(points = {{20, -12}, {60, -12}}, color = {0, 0, 255}));
  connect(R_internal.p, booster.dc_p1) annotation(
    Line(points = {{-32, 12}, {-20, 12}}, color = {0, 0, 255}));
  connect(source.n, booster.dc_n1) annotation(
    Line(points = {{-66, -12}, {-20, -12}}, color = {0, 0, 255}));
  connect(source.p, R_internal.n) annotation(
    Line(points = {{-66, 8}, {-66, 12}, {-52, 12}}, color = {0, 0, 255}));
  connect(sine.y, twoPhasedPWM.D) annotation(
    Line(points = {{-58, -70}, {-42, -70}}, color = {0, 0, 127}));
  connect(ground.p, source.n) annotation(
    Line(points = {{-80, -20}, {-66, -20}, {-66, -12}}, color = {0, 0, 255}));
  connect(T.port, booster.heatPort) annotation(
    Line(points = {{20, -50}, {0, -50}, {0, -20}}, color = {191, 0, 0}));

annotation(
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end BoostConverterTest;
