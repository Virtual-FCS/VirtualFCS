within VirtualFCS.Electrical;

model DC_converter "An ideal DC-DC converter"
  parameter Modelica.Units.SI.Time Td = 1e-2 "Dead time";
  parameter Modelica.Units.SI.Time Ti = 1e-6 "Time constant of integral power controller";
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent_FC annotation(
    Placement(visible = true, transformation(origin = {-38, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Sensors.PowerSensor power_FC annotation(
    Placement(transformation(extent = {{40, 70}, {20, 50}})));
  Modelica.Electrical.Analog.Sensors.PowerSensor power_DCbus annotation(
    Placement(transformation(origin = {30, -50}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Continuous.FirstOrder deadTime(k = 1, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0, T = Td) annotation(
    Placement(visible = true, transformation(extent = {{-70, -10}, {-50, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {50, 0})));
  Modelica.Blocks.Continuous.Integrator powerController(initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1/Ti, y_start = 0) annotation(
    Placement(transformation(extent = {{30, 10}, {10, 30}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_nFC annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_pFC annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_nBus annotation(
    Placement(transformation(origin = {-80, -72}, extent = {{-10, 10}, {10, -10}}), iconTransformation(origin = {-100, -100}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_pBus annotation(
    Placement(visible = true, transformation(origin = {80, -72}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(origin = {100, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput I_Ref annotation(
    Placement(visible = true, transformation(extent = {{-138, -20}, {-98, 20}}, rotation = 0), iconTransformation(origin = {115, 1}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent_DCbus annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(signalCurrent_FC.p, power_FC.nc) annotation(
    Line(points = {{-28, 60}, {20, 60}}, color = {0, 0, 255}));
  connect(power_FC.pv, power_FC.pc) annotation(
    Line(points = {{30, 50}, {40, 50}, {40, 60}}, color = {0, 0, 255}));
  connect(power_DCbus.pc, power_DCbus.pv) annotation(
    Line(points = {{20, -50}, {20, -40}, {30, -40}}, color = {0, 0, 255}));
  connect(power_FC.power, feedback.u2) annotation(
    Line(points = {{40, 71}, {40, 78}, {64, 78}, {64, (-0 - 16)}, {58, (-0 - 16)}}, color = {0, 0, 127}));
  connect(power_DCbus.power, feedback.u1) annotation(
    Line(points = {{20, -61}, {20, -68}, {50, -68}, {50, -8}}, color = {0, 0, 127}));
  connect(feedback.y, powerController.u) annotation(
    Line(points = {{50, 9}, {50, 20}, {32, 20}}, color = {0, 0, 127}));
  connect(pin_nFC, signalCurrent_FC.n) annotation(
    Line(points = {{-80, 80}, {-80, 60}, {-48, 60}}, color = {0, 0, 255}));
  connect(pin_pFC, power_FC.pc) annotation(
    Line(points = {{80, 80}, {80, 60}, {40, 60}}, color = {0, 0, 255}));
  connect(pin_nFC, power_FC.nv) annotation(
    Line(points = {{-80, 80}, {30, 80}, {30, 70}}, color = {0, 0, 255}));
  connect(pin_nBus, power_DCbus.nv) annotation(
    Line(points = {{-80, -72}, {30, -72}, {30, -60}}, color = {0, 0, 255}));
  connect(pin_pBus, power_DCbus.nc) annotation(
    Line(points = {{80, -72}, {80, -50}, {40, -50}}, color = {0, 0, 255}));
  connect(I_Ref, deadTime.u) annotation(
    Line(points = {{-118, 0}, {-72, 0}}, color = {0, 0, 127}));
  connect(deadTime.y, signalCurrent_DCbus.i) annotation(
    Line(points = {{-49, 0}, {0, 0}, {0, -28}, {-10, -28}, {-10, -38}}, color = {0, 0, 127}));
  connect(powerController.y, signalCurrent_FC.i) annotation(
    Line(points = {{9, 20}, {-38, 20}, {-38, 48}}, color = {0, 0, 127}));
  connect(signalCurrent_DCbus.p, power_DCbus.pc) annotation(
    Line(points = {{0, -50}, {20, -50}}, color = {0, 0, 255}));
  connect(signalCurrent_DCbus.n, pin_nBus) annotation(
    Line(points = {{-20, -50}, {-80, -50}, {-80, -72}, {-80, -72}}, color = {0, 0, 255}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Line(points = {{100, 100}, {20, 20}}, color = {0, 0, 255}), Line(points = {{-20, -20}, {-100, -100}}, color = {0, 0, 255}), Text(origin = {-2, -142}, textColor = {128, 128, 128}, extent = {{-40, 80}, {40, 60}}, textString = "DC bus"), Text(textColor = {0, 0, 255}, extent = {{-100, 20}, {100, -20}}, textString = "%name"), Text(origin = {0, 146}, textColor = {128, 128, 128}, extent = {{-40, -60}, {40, -80}}, textString = "Fuel cell")}),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>This is a model of an ideal DC-DC inverter based on a power balance achieved by an integral controller.</p>
<p>The setup is similar to the Modelica Standard Library's IdealDcDc, but with the key differences that:</p>
<ul>
<li>This unit is output-current-controlled rather than voltage-controlled, meaning it <em>must</em> be connected to some kind of load in order to compile;</li>
<li>The unit does not have internal grounding in the output, so a ground has to be attached there;</li>
<li>Due to a programming bug (or feature?), setting a positive current reference will result in inverted polarity in the output. This is because the program makes power on both sides equal, but one should be entering and the other exiting.</li>
</ul>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>Td</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>1e-2</code></td><td>Dead time</td></tr>
<tr><td><code>Ti</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>1e-6</code></td><td>Time constant of integral power controller</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>pin_pFC</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td></td></tr>
<tr><td><code>pin_pBus</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td></td></tr>
<tr><td><code>I_Ref</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td></td></tr>
<tr><td><code>pin_nFC</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td></td></tr>
<tr><td><code>pin_nBus</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td></td></tr>
</tbody></table>

</body></html>"));
end DC_converter;
