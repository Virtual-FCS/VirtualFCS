within VirtualFCS.Chemical.AmmoniaCracker;

model ElectricHeatingDistr
  parameter Integer N = size(heatWeights, 1) "Number of reactor computational segments";
  parameter Boolean useHeatFilter = false "Enable a gradual heater startup";
  parameter Modelica.Units.SI.Time T_heatFilter = 1e-3 "Time constant limiting the heater power rise";
  parameter Real heatWeights[:] = {1.8, 1.5, 1.2, 1.0, 0.9, 0.8, 0.7, 0.6, 0.3, 0.2} "Relative heat distribution weights from inlet to outlet";
  parameter Modelica.Units.SI.Temperature T_out_target = 550 + 273.15 "Target temperature";
  parameter Modelica.Units.SI.HeatFlowRate q_max = 5e4 "Maximum heat flow rate";
  parameter Real k_PI(unit = "W/K") = 1e3 "Proportional gain of the heater PI controller";
  parameter Modelica.Units.SI.Time Ti_PI = 0.5 "Integral time of the heater PI controller";
  parameter Boolean use_Q_ff = false "= true, to add the feed-forward heat flow input Q_ff to the PI output (before the limiter)";
  parameter Boolean use_cascade = false "= true, PI_heater controls the bed-mean temperature and an outer PI corrects its set-point from T_meas" annotation(
    Evaluate = true);
  parameter Real k_out(unit = "1") = 1 "Proportional gain of the outer (outlet temperature) controller" annotation(
    Dialog(enable = use_cascade));
  parameter Modelica.Units.SI.Time Ti_out = 200 "Integral time of the outer (outlet temperature) controller" annotation(
    Dialog(enable = use_cascade));
  parameter Modelica.Units.SI.TemperatureDifference dT_bed_max = 100 "Maximum bed-mean set-point offset from T_out_target" annotation(
    Dialog(enable = use_cascade));
  parameter Modelica.Units.SI.TemperatureDifference dT_bed_start = 0 "Initial bed-mean set-point offset from T_out_target" annotation(
    Dialog(enable = use_cascade));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPorts[N] "Segmented heat input ports" annotation(
    Placement(transformation(origin = {0, -100}, extent = {{-40, -10}, {40, 10}}), iconTransformation(origin = {0, -100}, extent = {{-40, -10}, {40, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow[N] annotation(
    Placement(transformation(origin = {30, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PI_heater(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = k_PI, Ti = Ti_PI, yMax = q_max, yMin = 0, withFeedForward = use_Q_ff, kFF = 1) annotation(
    Placement(transformation(origin = {-8, -8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder heatFilter(T = T_heatFilter, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0) if useHeatFilter annotation(
    Placement(transformation(origin = {8, -8}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Gain heatDistribution[N](k = {heatWeights[i]/sum(heatWeights) for i in 1:N}) if useHeatFilter;
  Modelica.Blocks.Sources.RealExpression temp_cracked_target(y = T_out_target) annotation(
    Placement(transformation(origin = {-46, -8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput T_meas annotation(
    Placement(transformation(origin = {-100, -36}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-94, -30}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput Q_ff(unit = "W") if use_Q_ff "Feed-forward heat flow, e.g. the expected reaction heat demand" annotation(
    Placement(transformation(origin = {-100, 30}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-94, 30}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.RealExpression T_bedMean(y = sum(heatPorts.T)/N) if use_cascade "Mean segment temperature";
  Modelica.Blocks.Continuous.LimPID outerPI(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = k_out, Ti = Ti_out, yMax = dT_bed_max, yMin = -dT_bed_max, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = dT_bed_start) if use_cascade "Outer controller: outlet temperature -> bed-mean set-point offset";
  Modelica.Blocks.Math.Add T_bedSet if use_cascade "Bed-mean temperature set-point";
equation
  connect(Q_ff, PI_heater.u_ff);
  if use_cascade then
    connect(temp_cracked_target.y, outerPI.u_s);
    connect(T_meas, outerPI.u_m);
    connect(temp_cracked_target.y, T_bedSet.u1);
    connect(outerPI.y, T_bedSet.u2);
    connect(T_bedSet.y, PI_heater.u_s);
    connect(T_bedMean.y, PI_heater.u_m);
  else
    connect(temp_cracked_target.y, PI_heater.u_s) annotation(
      Line(points = {{-35, -8}, {-20, -8}}, color = {0, 0, 127}));
    connect(T_meas, PI_heater.u_m) annotation(
      Line(points = {{-100, -36}, {-8, -36}, {-8, -20}}, color = {0, 0, 127}));
  end if;
  if useHeatFilter then
    connect(PI_heater.y, heatFilter.u);
    for i in 1:N loop
      connect(heatFilter.y, heatDistribution[i].u);
      connect(heatDistribution[i].y, prescribedHeatFlow[i].Q_flow);
    end for;
  else
    for i in 1:N loop
      connect(PI_heater.y, prescribedHeatFlow[i].Q_flow);
    end for;
  end if;
  connect(prescribedHeatFlow.port, heatPorts) annotation(
    Line(points = {{40, -10}, {60, -10}, {60, -66}, {0, -66}, {0, -100}}, color = {191, 0, 0}));

annotation(
    Icon(graphics = {Rectangle(fillColor = {215, 230, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Text(extent = {{-100, 100}, {100, 66}}, textString = "%name")}),
    Documentation(info = "<html><head></head><body>
<h2>1. Parameters and inputs</h2>
<p>Parameters configure the heater PI controller, optional feed-forward and cascade control, and optional startup filtering with segment-wise heat distribution. Temperatures are absolute SI temperatures in kelvin, heat flow rates are in watts, and temperature differences are in kelvin.</p>
<h3>Heater sizing and heat distribution</h3>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N</code></td><td>Integer</td><td>1</td><td>size(heatWeights, 1)</td><td>Number of reactor segments and heat ports</td></tr>
<tr><td><code>q_max</code></td><td>SI.HeatFlowRate</td><td>W</td><td>5e4</td><td>Upper limit of the heater PI controller output; with the heat filter enabled this is the total distributed heat-flow command</td></tr>
<tr><td><code>useHeatFilter</code></td><td>Boolean</td><td>-</td><td>false</td><td>Enable the first-order startup filter and normalized segment-wise heat distribution</td></tr>
<tr><td><code>T_heatFilter</code></td><td>SI.Time</td><td>s</td><td>1e-3</td><td>Startup filter time constant; used only when useHeatFilter = true</td></tr>
<tr><td><code>heatWeights[:]</code></td><td>Real</td><td>-</td><td>{1.8, 1.5, 1.2, 1.0, 0.9, 0.8, 0.7, 0.6, 0.3, 0.2}</td><td>Relative segment heat weights from inlet to outlet, normalized by their sum when useHeatFilter = true. Its length must match N in that mode.</td></tr>
<tr><td><code>T_out_target</code></td><td>SI.Temperature</td><td>K</td><td>550 + 273.15</td><td>Temperature set-point; in cascade mode it is the outlet-temperature reference and the base of the bed-mean set-point</td></tr>
</tbody></table>
<h3>PI control and optional modes</h3>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>k_PI</code></td><td>Real</td><td>W/K</td><td>1e3</td><td>Proportional gain of the heater PI controller</td></tr>
<tr><td><code>Ti_PI</code></td><td>SI.Time</td><td>s</td><td>0.5</td><td>Integral time of the heater PI controller</td></tr>
<tr><td><code>use_Q_ff</code></td><td>Boolean</td><td>-</td><td>false</td><td>Enable the conditional feed-forward input Q_ff, added to the PI controller output before its output limits</td></tr>
<tr><td><code>use_cascade</code></td><td>Boolean</td><td>-</td><td>false</td><td>Enable an outer outlet-temperature PI controller that adjusts the inner controller's bed-mean temperature set-point</td></tr>
<tr><td><code>k_out</code></td><td>Real</td><td>1</td><td>1</td><td>Outer controller proportional gain; used only when use_cascade = true</td></tr>
<tr><td><code>Ti_out</code></td><td>SI.Time</td><td>s</td><td>200</td><td>Outer controller integral time; used only when use_cascade = true</td></tr>
<tr><td><code>dT_bed_max</code></td><td>SI.TemperatureDifference</td><td>K</td><td>100</td><td>Symmetric limit on the outer controller's bed-mean set-point offset; used only when use_cascade = true</td></tr>
<tr><td><code>dT_bed_start</code></td><td>SI.TemperatureDifference</td><td>K</td><td>0</td><td>Initial output of the outer controller and initial bed-mean set-point offset; used only when use_cascade = true</td></tr>
</tbody></table>
<h3>Inputs and physical interfaces</h3>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T_meas</code></td><td>Input</td><td>RealInput</td><td>K</td><td>Measured temperature. It is compared directly with T_out_target when cascade control is disabled; when enabled it is the outer outlet-temperature feedback signal.</td></tr>
<tr><td><code>Q_ff</code></td><td>Conditional input</td><td>RealInput</td><td>W</td><td>Optional feed-forward heat-flow demand, available when use_Q_ff = true</td></tr>
<tr><td><code>heatPorts[N]</code></td><td>Thermal interface</td><td>HeatPort_a array</td><td>W, K</td><td>One heat-flow port per reactor segment. Positive prescribed heat flow supplies heat to the connected segment.</td></tr>
</tbody></table>
<h2>2. Model description</h2>
<p>The model regulates electric heat supplied to an ammonia-cracker bed. A bounded PI controller requests non-negative heater power up to q_max. Depending on the selected options, that request can include a feed-forward term, pass through a first-order startup filter, and be distributed across the segment heat ports according to heatWeights.</p>
<p>With use_cascade = false, T_meas closes the heater PI loop directly against T_out_target. With use_cascade = true, an outer PI loop compares T_meas with T_out_target and produces a bounded offset. This offset is added to T_out_target to form the bed-mean temperature set-point. The inner heater PI loop then compares that set-point with the arithmetic mean of heatPorts.T.</p>
<p>When useHeatFilter = true, the heater command is first filtered from an initial output of zero, then multiplied by heatWeights[i]/sum(heatWeights) for each segment. This preserves the total commanded heat flow for weights whose sum is nonzero. When useHeatFilter = false, the filter and distribution gains are absent and the full PI output is connected to every segment port; consequently, the sum of segment heat flows can be N times the controller output. In this mode heatWeights and T_heatFilter do not affect the model.</p>
<h2>3. Governing equations and usage notes</h2>
<pre>0 &lt;= PI_heater.y &lt;= q_max
T_bedMean = sum(heatPorts[i].T for i in 1:N)/N
use_cascade = false: PI_heater set-point = T_out_target, measurement = T_meas
use_cascade = true:  T_bedSet = T_out_target + outerPI.y
                     outerPI: set-point = T_out_target, measurement = T_meas
                     PI_heater: set-point = T_bedSet, measurement = T_bedMean
useHeatFilter = true: Q_segment[i] = heatFilter.y*heatWeights[i]/sum(heatWeights)
useHeatFilter = false: Q_segment[i] = PI_heater.y</pre>
<p>The feed-forward input is enabled independently of cascade mode and is combined by the LimPID block before the heater output limiter. The heat filter and heat distribution are enabled together by useHeatFilter. Ensure that N matches the heatWeights vector length when distribution is enabled, and that the weights have a nonzero sum.</p>
<h2>4. Outputs</h2>
<p>No signal output connectors are declared. Heat is delivered through heatPorts[N]. For monitoring, PI_heater.y is the limited heater command before optional filtering and distribution; when cascade control is enabled, outerPI.y is the bed-mean set-point offset and T_bedMean.y is the mean segment temperature.</p>
</body></html>"));
end ElectricHeatingDistr;
