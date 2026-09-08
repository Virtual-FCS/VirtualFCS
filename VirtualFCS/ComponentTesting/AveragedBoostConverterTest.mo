within VirtualFCS.ComponentTesting;

model AveragedBoostConverterTest
  extends Modelica.Icons.Example;
  Electrical.AveragedBoostConverter booster(useHeatPort = true)  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Basic.Resistor R(R = 10)  annotation(
    Placement(transformation(origin = {60, 0}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor R_internal(R = 0.1) annotation(
    Placement(transformation(origin = {-50, 12}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage source(V = 100)  annotation(
    Placement(transformation(origin = {-66, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Sine sine(amplitude = .4, f = 10, offset = .5)  annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-80, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T(T = 323.15)  annotation(
    Placement(transformation(origin = {30, -50}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Spice3.Basic.C_Capacitor C_in(C(displayUnit = "uF") = 2e-5) annotation(
    Placement(transformation(origin = {-29.9565, 0}, extent = {{-12, -13.0435}, {12, 13.0435}}, rotation = -90)));
equation
  connect(booster.dc_p2, R.p) annotation(
    Line(points = {{20, 12}, {60, 12}}, color = {0, 0, 255}));
  connect(booster.dc_n2, R.n) annotation(
    Line(points = {{20, -12}, {60, -12}}, color = {0, 0, 255}));
  connect(ground.p, source.n) annotation(
    Line(points = {{-80, -20}, {-66, -20}, {-66, -12}}, color = {0, 0, 255}));
  connect(T.port, booster.heatPort) annotation(
    Line(points = {{20, -50}, {0, -50}, {0, -20}}, color = {191, 0, 0}));
  connect(sine.y, booster.D) annotation(
    Line(points = {{-58, -70}, {-12, -70}, {-12, -24}}, color = {0, 0, 127}));
  connect(R_internal.p, source.p) annotation(
    Line(points = {{-60, 12}, {-66, 12}, {-66, 8}}, color = {0, 0, 255}));
  connect(C_in.n, booster.dc_n1) annotation(
    Line(points = {{-30, -12}, {-20, -12}}, color = {0, 0, 255}));
  connect(C_in.p, booster.dc_p1) annotation(
    Line(points = {{-30, 12}, {-20, 12}}, color = {0, 0, 255}));
  connect(R_internal.n, C_in.p) annotation(
    Line(points = {{-40, 12}, {-30, 12}}, color = {0, 0, 255}));
  connect(C_in.n, source.n) annotation(
    Line(points = {{-30, -12}, {-66, -12}}, color = {0, 0, 255}));
  annotation(
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));

annotation(Documentation(info = "<html><p>Test model for the averaged boost converter.</p></html>"));
end AveragedBoostConverterTest;
