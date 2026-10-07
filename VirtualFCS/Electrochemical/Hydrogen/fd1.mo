within VirtualFCS.Electrochemical.Hydrogen;

block fd1
  // Degradation parameters fc
  parameter Real fc_lowP = 1.26e-5/3600;
  // Low power
  parameter Real fc_hiP = 1.03e-5/3600;
  // High power
  parameter Real fc_cylP = 5.93e-7*0.00001;
  // Load cycling
  parameter Real fc_ss = 1.96e-5;
  // Start Stop
  parameter Real fc_nomP = 1.96e-5*0.00001;
  // Nominal operation
  parameter Real del_j0 = 0.99;
  parameter Real j_hiP = 1;
  parameter Real j_lowP = 0.33;
  //parameter Real dt = 1;              // Time step parameter
  // Variables
  Real del_fc, del_lowP, del_hiP, del_cylP, del_ss, del_nomP;
  Real dj_lowP, dj_hiP, dj_cylP;
  Real del_T, del_rh;
  Real del_j;
  Real j;
  Real FCDeg_old(start = 0);
  Real FCDeg(start = 0);
  Integer startStopCounter(start = 0) "Int to count number of start/stops";
  // Logging degradation contributions
  Real int_del_lowP, int_del_hiP, int_del_cylP, int_del_ss, int_del_nomP;
  // Timers
  Real timerLowP, timerHiP, timerCylP;
  Real timeLowP, timeHiP, timeCylP;
  Modelica.Blocks.Interfaces.RealInput J_FC annotation(
    Placement(transformation(extent = {{-12, -12}, {12, 12}}, origin = {-106, -22}), iconTransformation(extent = {{-118, -34}, {-94, -10}})));
  Modelica.Blocks.Interfaces.RealInput T_FC annotation(
    Placement(transformation(extent = {{-12, -12}, {12, 12}}, origin = {-112, 60}), iconTransformation(extent = {{-118, 56}, {-94, 80}})));
  Modelica.Blocks.Interfaces.RealInput RH_ca annotation(
    Placement(transformation(extent = {{-12, -12}, {12, 12}}, origin = {-106, 26}), iconTransformation(extent = {{-118, 14}, {-94, 38}})));
  //  Modelica.Blocks.Interfaces.RealInput V_FC annotation (Placement(transformation(extent={{-12,-12},{12,12}}, origin={-112,-44}), iconTransformation(extent={{-118,
  //-82},{-94,-58}})));
  Modelica.Blocks.Interfaces.RealOutput FCDeg_new annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {100, 0}), iconTransformation(extent = {{94, -10}, {114, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = FCDeg) annotation(
    Placement(transformation(extent = {{48, -10}, {68, 10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = 1e-6) annotation(
    Placement(transformation(extent = {{-36, -10}, {-16, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = j) annotation(
    Placement(transformation(extent = {{-72, -10}, {-52, 10}})));
equation
  j = J_FC;
  del_j = der(j);
  del_T = -(5.390*10^(-4)*T_FC^2) + (0.399*T_FC) - 71.576;
  del_rh = 0.10646*exp(0.028*RH_ca);
// Check if works
//del_rh = 1;
  if j < j_lowP then
// Low power mode
    dj_lowP = -0.176*log(max(j, 1e-6)) + 0.169;
    dj_hiP = 0;
    dj_cylP = 0;
    timerLowP = 1;
    timerHiP = 0;
    timerCylP = 0;
  elseif j > j_hiP then
// High power mode
    dj_lowP = 0;
    dj_hiP = j/j_hiP;
    dj_cylP = 0;
    timerLowP = 0;
    timerHiP = 1;
    timerCylP = 0;
  elseif del_j >= del_j0 then
// Load cycling mode
    dj_lowP = 0;
    dj_hiP = 0;
    dj_cylP = del_j/(2*del_j0);
    timerLowP = 0;
    timerHiP = 0;
    timerCylP = 1;
  elseif j > 1e-6 then
// Nominal operation
    dj_lowP = 0;
    dj_hiP = 0;
    dj_cylP = 0;
    timerLowP = 0;
    timerHiP = 0;
    timerCylP = 0;
  else
// start stop mode
    dj_lowP = 0;
    dj_hiP = 0;
    dj_cylP = 0;
    timerLowP = 0;
    timerHiP = 0;
    timerCylP = 0;
  end if;
  del_lowP = fc_lowP*dj_lowP*del_T*del_rh;
// Low power mode
  del_hiP = fc_hiP*dj_hiP*del_T*del_rh;
// High power mode
  del_cylP = fc_cylP*dj_cylP*del_T*del_rh;
// Load cycling mode
  if (j < j_lowP) or (j > j_hiP) or (del_j > del_j0) then
    del_nomP = 0;
  else
    del_nomP = (((fc_hiP*1) - (fc_lowP*(-0.176*log(j_lowP) + 0.169)))*(j - j_lowP)/(j_hiP - j_lowP)) + (fc_lowP*(-0.176*log(j_lowP) + 0.169));
  end if;
  when greaterThreshold.y and not pre(greaterThreshold.y) then
    startStopCounter = pre(startStopCounter) + 1;
  end when;
  del_fc = del_lowP + del_hiP + del_cylP + del_nomP;
  der(timeLowP) = timerLowP/3600;
  der(timeHiP) = timerHiP/3600;
  der(timeCylP) = timerCylP/3600;
  der(int_del_lowP) = del_lowP;
  der(int_del_hiP) = del_hiP;
  der(int_del_cylP) = del_cylP;
  der(int_del_ss) = del_ss;
  der(int_del_nomP) = del_nomP;
  der(FCDeg_old) = del_fc;
  del_ss = startStopCounter*fc_ss;
  FCDeg = FCDeg_old + del_ss;
  connect(realExpression.y, FCDeg_new) annotation(
    Line(points = {{69, 0}, {100, 0}}, color = {0, 0, 127}));
  connect(realExpression1.y, greaterThreshold.u) annotation(
    Line(points = {{-51, 0}, {-38, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Bitmap(origin = {-23, 5}, extent = {{-97, 89}, {145, -99}}, imageSource = "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")}, Diagram(graphics = {Bitmap(BitmapEncoder.create_png(f.read()))})),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>fc_lowP</code></td><td>Real</td><td>1</td><td>1.26e-5/3600</td><td></td></tr>
<tr><td><code>fc_hiP</code></td><td>Real</td><td>1</td><td>1.03e-5/3600</td><td></td></tr>
<tr><td><code>fc_cylP</code></td><td>Real</td><td>1</td><td>5.93e-7 * 0.00001</td><td></td></tr>
<tr><td><code>fc_ss</code></td><td>Real</td><td>1</td><td>1.96e-5</td><td></td></tr>
<tr><td><code>fc_nomP</code></td><td>Real</td><td>1</td><td>1.96e-5 * 0.00001</td><td></td></tr>
<tr><td><code>del_j0</code></td><td>Real</td><td>1</td><td>0.99</td><td></td></tr>
<tr><td><code>j_hiP</code></td><td>Real</td><td>1</td><td>1</td><td></td></tr>
<tr><td><code>j_lowP</code></td><td>Real</td><td>1</td><td>0.33</td><td></td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>J_FC</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr>
<tr><td><code>T_FC</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr>
<tr><td><code>RH_ca</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><p>Fuel cell degradation block used by the electrochemical subsystem models.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>j = J_FC;
del_j = der(j);
del_T = -(5.390 * 10^(-4) * T_FC^2) + (0.399 * T_FC) - 71.576;
del_rh = 0.10646 * exp(0.028 * RH_ca);
dj_lowP = -0.176 * log(max(j, 1e-6)) + 0.169;
dj_hiP = 0;
dj_cylP = 0;
timerLowP = 1;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>FCDeg_new</code></td><td>Output</td><td>RealOutput</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end fd1;
