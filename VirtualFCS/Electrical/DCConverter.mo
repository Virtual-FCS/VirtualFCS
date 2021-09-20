within VirtualFCS.Electrical;

model DCConverter "DC controlled single phase DC/AC converter"
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin1;
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin2;
  // extends .PhotoVoltaics.Icons.Converter;
  parameter Modelica.SIunits.Voltage vDCref = 48 "Reference DC source voltage";
  parameter Modelica.SIunits.Time Ti = 1E-6 "Internal integration time constant";
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
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / vDCref / Ti) annotation(
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
    Line(points = {{-30, -8}, {-30, -40}, {-20, -40}}, color = {0, 0, 127}));
  connect(resistor2.n, dc_n1) annotation(
    Line(points = {{-90, -24}, {-90, -24}, {-90, -60}, {-100, -60}}, color = {0, 0, 255}));
  connect(signalVoltage.v, realExpression.y) annotation(
    Line(points = {{-78, 14}, {-60, 14}, {-60, -68}, {-60, -68}}, color = {0, 0, 127}));
  connect(product.u2, realExpression.y) annotation(
    Line(points = {{-62, 24}, {-68, 24}, {-68, 14}, {-60, 14}, {-60, -68}, {-60, -68}}, color = {0, 0, 127}));
  connect(powerSensor.nc, variableCurrentSource.p) annotation(
    Line(points = {{80, -20}, {80, -20}, {80, -30}, {80, -30}}, color = {0, 0, 255}));
  connect(variableCurrentSource.n, dc_n2) annotation(
    Line(points = {{80, -50}, {80, -50}, {80, -60}, {100, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(integrator.y, variableCurrentSource.i) annotation(
    Line(points = {{4, -40}, {68, -40}, {68, -40}, {68, -40}}, color = {0, 0, 127}));
  connect(powerSensor.power, feedback.u2) annotation(
    Line(points = {{70, 0}, {-22, 0}, {-22, 0}, {-22, 0}}, color = {0, 0, 127}));
  annotation(
    defaultComponentName = "converter",
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Text(lineColor = {0, 0, 255}, extent = {{-100, 40}, {-40, -40}}, textString = "="), Text(lineColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, extent = {{-150, -110}, {-90, -150}}, textString = "vDCRef"), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, extent = {{-80, 90}, {20, 50}}, textString = "hi"), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, extent = {{-40, -50}, {60, -90}}, textString = "lo"), Text(lineColor = {0, 0, 255}, extent = {{40, 40}, {100, -40}}, textString = "=")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html>
<p>This is an ideal DC/DC converter.</p>
<p>
The DC/DC converter is characterized by:
</p> 
<ul>
<li>Losses are not considered</li> 
<li>The AC output current is determined based on power balance, calculating with instantaneous values: 
    <code>vDC1*iDC1 + vDC2*iDC2 = 0<code></li>
<li>The DC input voltage <code>vDCRef</code> is applied to the DC side 1 without limitations</li>
<li>The phase angle input <code>phi</code> influences the AC reactive power based on the following figure,
    where underlined voltages and currents represent complex phasors</li>
</ul>
</html>"));
end DCConverter;
