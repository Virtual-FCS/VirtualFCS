within VirtualFCS.Electrical;
model DC_DC_Converter "DC controlled single phase DC/AC converter"
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin1;
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin2;
  parameter Modelica.Units.SI.Voltage VRef = 48 "Reference DC source voltage";
  parameter Modelica.Units.SI.Time Ti = 1E-6 "Internal integration time constant";
  Modelica.Blocks.Interfaces.RealInput vDCRef(final unit = "V") "DC voltage" annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -120}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -120})));
  Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-90, 0})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = 270, origin = {-90, 36})));
  Modelica.Blocks.Math.Product product annotation (
    Placement(transformation(extent = {{-60, 20}, {-40, 40}})));
  Modelica.Blocks.Math.Feedback feedback annotation (
    Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = 270, origin = {-30, 0})));
  Modelica.Electrical.Analog.Sources.SignalCurrent variableCurrentSource annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {80, -40})));
  Modelica.Electrical.Analog.Sensors.PowerSensor powerSensor annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {80, -10})));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / VRef / Ti) annotation (
    Placement(visible = true, transformation(extent = {{-2, -50}, {18, -30}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(final k = -1) annotation (
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {0, 0})));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R = 0.001) annotation (
    Placement(visible = true, transformation(origin = {-90, -32}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Basic.Resistor resistor1(R = 0.001) annotation (
    Placement(visible = true, transformation(origin = {80, 36}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
equation
  connect(currentSensor.n, signalVoltage.p) annotation (
    Line(points = {{-90, 26}, {-90, 26}, {-90, 10}}, color = {0, 0, 255}));
  connect(signalVoltage.v, vDCRef) annotation (
    Line(points = {{-83, 0}, {-70, 0}, {-70, -80}, {-60, -80}, {-60, -120}}, color = {0, 0, 127}));
  connect(currentSensor.i, product.u1) annotation (
    Line(points = {{-80, 36}, {-80, 36}, {-70, 36}, {-62, 36}}, color = {0, 0, 127}));
  connect(vDCRef, product.u2) annotation (
    Line(points = {{-60, -120}, {-60, -120}, {-60, -88}, {-60, -94}, {-60, -80}, {-70, -80}, {-70, 24}, {-62, 24}}, color = {0, 0, 127}));
  connect(product.y, feedback.u1) annotation (
    Line(points = {{-39, 30}, {-30, 30}, {-30, 8}}, color = {0, 0, 127}));
  connect(feedback.y, integrator.u) annotation (
    Line(points = {{-30, -9}, {-30, -40}, {-4, -40}}, color = {0, 0, 127}));
  connect(gain.y, feedback.u2) annotation (
    Line(points = {{-11, 1.33227e-15}, {-21, 1.33227e-15}, {-21, 0}, {-10, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(powerSensor.nc, variableCurrentSource.n) annotation (
    Line(points = {{80, -20}, {80, -30}}, color = {0, 0, 255}));
  connect(integrator.y, variableCurrentSource.i) annotation (
    Line(points = {{19, -40}, {73, -40}}, color = {0, 0, 127}));
  connect(powerSensor.pv, powerSensor.pc) annotation (
    Line(points = {{90, -10}, {90, -10}, {90, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(currentSensor.p, dc_p1) annotation (
    Line(points = {{-90, 46}, {-90, 46}, {-90, 60}, {-100, 60}}, color = {0, 0, 255}));
  connect(variableCurrentSource.p, dc_n2) annotation (
    Line(points = {{80, -50}, {80, -50}, {80, -58}, {80, -58}, {80, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(dc_n2, powerSensor.nv) annotation (
    Line(points = {{100, -60}, {90, -60}, {60, -60}, {60, -26}, {60, -10}, {70, -10}}, color = {0, 0, 255}));
  connect(signalVoltage.n, resistor.p) annotation (
    Line(points = {{-90, -10}, {-90, -10}, {-90, -22}, {-90, -22}}, color = {0, 0, 255}));
  connect(resistor.n, dc_n1) annotation (
    Line(points = {{-90, -42}, {-90, -42}, {-90, -60}, {-100, -60}, {-100, -60}}, color = {0, 0, 255}));
  connect(powerSensor.pc, resistor1.n) annotation (
    Line(points = {{80, 0}, {80, 0}, {80, 26}, {80, 26}}, color = {0, 0, 255}));
  connect(resistor1.p, dc_p2) annotation (
    Line(points = {{80, 46}, {80, 46}, {80, 58}, {100, 58}, {100, 60}}, color = {0, 0, 255}));
  connect(powerSensor.power, gain.u) annotation(
    Line(points = {{70, 0}, {12, 0}}, color = {0, 0, 127}));
  annotation (
    defaultComponentName = "converter",
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={  Text(lineColor = {0, 0, 255}, extent = {{-100, 40}, {-40, -40}}, textString = "="), Text(lineColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, extent = {{-150, -110}, {-90, -150}}, textString = "vDCRef"), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, extent = {{-80, 90}, {20, 50}}, textString = "Low"), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, extent = {{-40, -50}, {60, -90}}, textString = "High"), Text(lineColor = {0, 0, 255}, extent = {{40, 40}, {100, -40}}, textString = "="), Rectangle(origin = {-87, 79}, extent = {{-13, 21}, {187, -179}}), Line(origin = {0.792902, 1.64825}, points = {{-100.793, -101.648}, {99.2071, 98.3518}, {99.2071, 44.3518}})}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html>
<p>This is an ideal DC/DC converter with internal resistances which however do not influence its efficiency (mostly used to estimate heat generation).</p>
<p>Input voltage is set programmatically by an input <tt>vDCRef</tt>, but that does not do what you would expect since it does not account for the effect of the internal resistor; input voltage will be different from the reference one.</p>
<p>There is a <tt>VRef</tt> parameter that does nothing related to reference value of voltage.</p>
<p>The -1 gain is a kludge to fix sign issues. It could just as well have been implemented by flipping the current generator, or making the <tt>feedback</tt> difference element into a sum.</p>
<p>The output power sensor does not include the loss from resistor1, making output power a bit lower than measured.</p>
</html>"));
end DC_DC_Converter;
