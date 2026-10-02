within VirtualFCS.Electrical;

model DCConverter "DC controlled single phase DC/AC converter"
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin1;
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin2;
  extends Modelica.Electrical.PowerConverters.Icons.Converter;
  parameter Modelica.Units.SI.Voltage vDCref = 48 "Reference DC source voltage";
  parameter Modelica.Units.SI.Time Ti = 1E-6 "Internal integration time constant";
  Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage annotation(
    Placement(visible = true, transformation(origin = {-90, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {-90, 44}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(extent = {{-60, 20}, {-40, 40}})));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = 270, origin = {-30, 0})));
  Modelica.Electrical.Analog.Sensors.PowerSensor powerSensor annotation(
    Placement(visible = true, transformation(origin = {80, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1/vDCref/Ti) annotation(
    Placement(visible = true, transformation(extent = {{-18, -50}, {2, -30}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor resistor2(R = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-90, -14}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R = 0.01) annotation(
    Placement(visible = true, transformation(origin = {80, 32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = vDCref) annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Sources.SignalCurrent variableCurrentSource annotation(
    Placement(visible = true, transformation(origin = {80, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
equation
  connect(currentSensor.n, signalVoltage.p) annotation(
    Line(points = {{-90, 34}, {-90, 24}}, color = {0, 0, 255}));
  connect(currentSensor.i, product.u1) annotation(
    Line(points = {{-79, 44}, {-71, 44}, {-71, 36}, {-62, 36}}, color = {0, 0, 127}));
  connect(product.y, feedback.u1) annotation(
    Line(points = {{-39, 30}, {-30, 30}, {-30, 8}}, color = {0, 0, 127}));
  connect(powerSensor.pv, powerSensor.pc) annotation(
    Line(points = {{90, -10}, {90, -10}, {90, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(currentSensor.p, dc_p1) annotation(
    Line(points = {{-90, 54}, {-90, 60}, {-100, 60}}, color = {0, 0, 255}));
  connect(dc_n2, powerSensor.nv) annotation(
    Line(points = {{100, -60}, {90, -60}, {60, -60}, {60, -26}, {60, -10}, {70, -10}}, color = {0, 0, 255}));
  connect(signalVoltage.n, resistor2.p) annotation(
    Line(points = {{-90, 4}, {-90, -4}}, color = {0, 0, 255}));
  connect(dc_p2, resistor.p) annotation(
    Line(points = {{100, 60}, {80, 60}, {80, 42}, {80, 42}}, color = {0, 0, 255}));
  connect(resistor.n, powerSensor.pc) annotation(
    Line(points = {{80, 22}, {80, 22}, {80, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(feedback.y, integrator.u) annotation(
    Line(points = {{-30, -9}, {-30, -40}, {-20, -40}}, color = {0, 0, 127}));
  connect(resistor2.n, dc_n1) annotation(
    Line(points = {{-90, -24}, {-90, -24}, {-90, -60}, {-100, -60}}, color = {0, 0, 255}));
  connect(signalVoltage.v, realExpression.y) annotation(
    Line(points = {{-78, 14}, {-60, 14}, {-60, -69}, {-60, -69}}, color = {0, 0, 127}));
  connect(product.u2, realExpression.y) annotation(
    Line(points = {{-62, 24}, {-68, 24}, {-68, 14}, {-60, 14}, {-60, -69}, {-60, -69}}, color = {0, 0, 127}));
  connect(powerSensor.nc, variableCurrentSource.p) annotation(
    Line(points = {{80, -20}, {80, -20}, {80, -30}, {80, -30}}, color = {0, 0, 255}));
  connect(variableCurrentSource.n, dc_n2) annotation(
    Line(points = {{80, -50}, {80, -50}, {80, -60}, {100, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(integrator.y, variableCurrentSource.i) annotation(
    Line(points = {{3, -40}, {68, -40}, {68, -40}, {68, -40}}, color = {0, 0, 127}));
  connect(powerSensor.power, feedback.u2) annotation(
    Line(points = {{69, 0}, {-22, 0}, {-22, 0}, {-22, 0}}, color = {0, 0, 127}));
  annotation(
    defaultComponentName = "converter",
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Text(lineColor = {0, 0, 255}, extent = {{-100, 40}, {-40, -40}}, textString = "="), Text(lineColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, extent = {{-150, -110}, {-90, -150}}, textString = "vDCRef"), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, extent = {{-80, 90}, {20, 50}}, textString = "hi"), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, extent = {{-40, -50}, {60, -90}}, textString = "lo"), Text(lineColor = {0, 0, 255}, extent = {{40, 40}, {100, -40}}, textString = "=")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>vDCref</code></td><td>SI.Voltage</td><td>V</td><td>48</td><td>Reference DC source voltage</td></tr>
<tr><td><code>Ti</code></td><td>SI.Time</td><td>s</td><td>1E-6</td><td>Internal integration time constant</td></tr></tbody></table><h2>2. Model description</h2>
<p>This is an ideal DC/DC converter with internal resistances.</p>
<p>Input voltage is set programmatically by parameter <tt>vDCref</tt>, but that does not do what you would expect since it does not account for the effect of the internal resistor; input voltage will be different from the reference one. </p>
<p>Input voltage is not set and constant through a simulation, though, since if current changes so does the internal resistance loss on the input side.</p>
<p>The output power sensor does not include the loss from resistor1, making output power a bit lower than measured.</p><h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended model or enforced by instantiated components and their connected physical networks.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end DCConverter;
