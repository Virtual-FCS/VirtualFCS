within VirtualFCS.Control;

model TwoPhasedPWM "Pulse width modulation with two phases"
  extends Modelica.Blocks.Icons.Block;
  
  import Modelica.Constants.pi;

  parameter Modelica.Units.SI.Frequency f=1000 "Switching frequency";
  parameter Modelica.Units.SI.Angle theta=0 "Phase angle of the two signals";
  parameter Modelica.Units.SI.Time startTime=0 "Start time";

  Modelica.Blocks.Interfaces.RealInput D annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.BooleanOutput PWM_1 annotation(
    Placement(transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput PWM_2 annotation(
    Placement(transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.SawTooth sawTooth_1(final period = 1/f, final startTime = startTime)  annotation(
    Placement(transformation(origin = {-30, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.SawTooth sawTooth_2(final period = 1/f, final startTime = startTime+theta/2/pi/f)  annotation(
    Placement(transformation(origin = {-30, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Greater greaterEqual_p annotation(
    Placement(transformation(origin = {50, 50}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 1, uMin = 0) annotation(
    Placement(transformation(origin = {-9, 0}, extent = {{-70, -10}, {-50, 10}})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold(final samplePeriod = 1/f, final startTime = startTime) annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-40, -10}, {-20, 10}})));
  Modelica.Blocks.Logical.Greater greaterEqual_p1 annotation(
    Placement(transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(D, limiter.u) annotation(
    Line(points = {{-120, 0}, {-80, 0}}, color = {0, 0, 127}));
  connect(limiter.y, zeroOrderHold.u) annotation(
    Line(points = {{-58, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(zeroOrderHold.y, greaterEqual_p.u1) annotation(
    Line(points = {{-18, 0}, {0, 0}, {0, 50}, {38, 50}}, color = {0, 0, 127}));
  connect(sawTooth_1.y, greaterEqual_p.u2) annotation(
    Line(points = {{-19, 58}, {38, 58}}, color = {0, 0, 127}));
  connect(zeroOrderHold.y, greaterEqual_p1.u1) annotation(
    Line(points = {{-18, 0}, {0, 0}, {0, -50}, {38, -50}}, color = {0, 0, 127}));
  connect(sawTooth_2.y, greaterEqual_p1.u2) annotation(
    Line(points = {{-19, -58}, {38, -58}}, color = {0, 0, 127}));
  connect(greaterEqual_p.y, PWM_1) annotation(
    Line(points = {{62, 50}, {110, 50}}, color = {255, 0, 255}));
  connect(greaterEqual_p1.y, PWM_2) annotation(
    Line(points = {{62, -50}, {110, -50}}, color = {255, 0, 255}));
annotation(
    Diagram(graphics),
    Icon(graphics = {Line(origin = {2, 52}, points = {{20, -20}, {22, -20}, {24, -20}, {24, 20}, {44, 20}, {44, -20}, {64, -20}, {64, -16}}, color = {255, 0, 255}), Line(origin = {2, 52}, points = {{60, -20}, {62, -20}, {64, -20}, {64, 20}, {84, 20}, {84, -20}, {84, -20}, {88, -20}}, color = {255, 0, 255}), Line(origin = {110, -52}, rotation = 180, points = {{20, -20}, {22, -20}, {24, -20}, {24, 20}, {44, 20}, {44, -20}, {64, -20}, {64, -16}}, color = {255, 0, 255}), Line(origin = {110, -52}, rotation = 180, points = {{60, -20}, {62, -20}, {64, -20}, {64, 20}, {84, 20}, {84, -20}, {84, -20}, {88, -20}}, color = {255, 0, 255})}),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>f</code></td><td>SI.Frequency</td><td>Hz</td><td>1000</td><td>Switching frequency</td></tr>
<tr><td><code>theta</code></td><td>SI.Angle</td><td>rad</td><td>0</td><td>Phase angle of the two signals</td></tr>
<tr><td><code>startTime</code></td><td>SI.Time</td><td>s</td><td>0</td><td>Start time</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>D</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><p>Two-phase pulse-width modulation block for generating complementary switching commands from a duty-cycle request.</p><h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended model or enforced by instantiated components and their connected physical networks.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>PWM_1</code></td><td>Output</td><td>BooleanOutput</td><td>-</td><td></td></tr>
<tr><td><code>PWM_2</code></td><td>Output</td><td>BooleanOutput</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end TwoPhasedPWM;
