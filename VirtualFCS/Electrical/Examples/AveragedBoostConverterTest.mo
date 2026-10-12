within VirtualFCS.Electrical.Examples;

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
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>This test drives the averaged boost converter with a 10 Hz sinusoidal duty command of amplitude 0.4 and offset 0.5. It uses a 100 V source, 10 ohm load, 0.1 ohm internal resistance, 20 uF input capacitor, and a 323.15 K thermal boundary.</p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end AveragedBoostConverterTest;
