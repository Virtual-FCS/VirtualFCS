within VirtualFCS.Electrical;

model ChopperStepUpDown "Step up/down chopper"
  extends Modelica.Electrical.PowerConverters.Icons.Converter;
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin1;
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin2;
  extends Modelica.Electrical.PowerConverters.Interfaces.Enable.Enable1;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(final T = 293.15);
  
  parameter Modelica.Units.SI.Resistance RonTransistor = 1e-05 "Transistor closed resistance";
  parameter Modelica.Units.SI.Conductance GoffTransistor = 1e-05 "Transistor opened conductance";
  parameter Modelica.Units.SI.Inductance L = 25e-3 "Charging inductance";
  parameter Modelica.Units.SI.Voltage VkneeTransistor = 0 "Transistor threshold voltage";
  parameter Modelica.Units.SI.Resistance RonDiode(final min = 0) = 1e-05 "Closed diode resistance";
  parameter Modelica.Units.SI.Conductance GoffDiode(final min = 0) = 1e-05 "Opened diode conductance";
  parameter Modelica.Units.SI.Voltage VkneeDiode(final min = 0) = 0 "Diode forward threshold voltage";
  
  Modelica.Electrical.Analog.Basic.Inductor inductor(i(fixed = true, start = 0), L = L) annotation(
    Placement(transformation(origin = {-10, -22}, extent = {{-30, 0}, {-10, 20}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealGTOThyristor transistor(
    Ron = RonTransistor, 
    Goff = GoffTransistor, 
    Vknee = VkneeTransistor,
    useHeatPort=useHeatPort) "Switching transistor" annotation(
    Placement(transformation(origin = {-70, 60}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));
  Modelica.Electrical.Analog.Ideal.IdealDiode diode(
    Ron = RonDiode,
    Goff = GoffDiode, 
    Vknee = VkneeDiode, 
    useHeatPort=useHeatPort) "Free wheeling diode" annotation(
    Placement(transformation(origin = {50, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));

equation
  if not useHeatPort then
    LossPower = diode.LossPower + transistor.LossPower;
  end if;
  connect(dc_p1, transistor.p) annotation(
    Line(points = {{-100, 60}, {-80, 60}}, color = {0, 0, 255}));
  connect(transistor.n, diode.n) annotation(
    Line(points = {{-60, 60}, {40, 60}}, color = {0, 0, 255}));
  connect(transistor.n, inductor.p) annotation(
    Line(points = {{-60, 60}, {0, 60}, {0, 8}}, color = {0, 0, 255}));
  connect(diode.heatPort, heatPort) annotation(
    Line(points = {{0, -100}, {0, -72}, {50, -72}, {50, 50}}, color = {191, 0, 0}));
  connect(inductor.n, dc_n1) annotation(
    Line(points = {{0, -12}, {0, -60}, {-100, -60}}, color = {0, 0, 255}));
  connect(transistor.fire, andCondition_p.y) annotation(
    Line(points = {{-60, 48}, {-60, -68}}, color = {255, 0, 255}));
  connect(heatPort, transistor.heatPort) annotation(
    Line(points = {{0, -100}, {0, -72}, {-40, -72}, {-40, 77}, {-70, 77}, {-70, 70}}, color = {191, 0, 0}));
  connect(dc_p2, diode.p) annotation(
    Line(points = {{100, 60}, {60, 60}}, color = {0, 0, 255}));
  connect(dc_n2, inductor.n) annotation(
    Line(points = {{100, -60}, {0, -60}, {0, -12}}, color = {0, 0, 255}));
  annotation(
    Icon(graphics = {Rectangle(origin = {-3, 9}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-71, 45}, {71, -45}}), Line(origin = {-4.23913, 2.44565}, points = {{-30, 20}, {-30, 0}}, color = {255, 0, 255}), Polygon(origin = {34, 12}, rotation = 90, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, 10}, {10, -10}, {30, -10}, {20, 10}}), Line(origin = {34.1195, 12.3913}, rotation = 90, points = {{10, 10}, {30, 10}}, color = {0, 0, 255}), Line(origin = {-4.07609, 2.44565}, points = {{-60, 30}, {-40, 30}}, color = {0, 0, 255}), Line(origin = {-4.40217, 2.77174}, points = {{-60, -30}, {42, -30}, {42, -30}, {42, -30}, {42, -30}, {64, -30}}, color = {0, 0, 255}), Ellipse(origin = {-4, 2}, lineColor = {0, 0, 255}, extent = {{-62, 32}, {-58, 28}}), Ellipse(origin = {-4, 2}, lineColor = {0, 0, 255}, extent = {{-62, -28}, {-58, -32}}), Ellipse(origin = {-18, 2}, lineColor = {0, 0, 255}, extent = {{18, -28}, {22, -32}}), Ellipse(origin = {2, 2}, lineColor = {0, 0, 255}, extent = {{58, -28}, {62, -32}}), Ellipse(origin = {4, 2}, lineColor = {0, 0, 255}, extent = {{58, 32}, {62, 28}}), Ellipse(origin = {-18, 2}, lineColor = {0, 0, 255}, extent = {{18, 32}, {22, 28}}), Ellipse(origin = {-4, 2}, lineColor = {0, 0, 255}, extent = {{-44, 40}, {-16, 12}}), Line(origin = {-4.23913, 2.44565}, points = {{-40, 20}, {-20, 20}}, color = {0, 0, 255}), Line(origin = {-4.07609, 2.44565}, points = {{-40, 30}, {-30, 20}, {-20, 30}}, color = {0, 0, 255}), Polygon(origin = {-4, 2}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{-20, 30}, {-26, 26}, {-24, 24}, {-20, 30}}), Line(origin = {6.20281, -0.725352}, points = {{-4.20278, 32.8123}, {-4.20278, 18.8123}, {-2.20278, 18.8123}, {-0.202782, 16.8123}, {-0.202782, 14.8123}, {-0.202782, 12.8123}, {-2.20278, 10.8123}, {-4.20278, 10.8123}, {-4.20278, 6.81235}, {-2.20278, 6.81235}, {-0.202782, 4.81235}, {-0.202782, 0.812348}, {-2.20278, -1.18765}, {-4.20278, -1.18765}, {-4.20278, -5.18765}, {-2.20278, -5.18765}, {-0.202782, -7.18765}, {-0.202782, -11.1877}, {-2.20278, -13.1877}, {-4.20278, -13.1877}, {-4.20278, -23.1877}, {-4.20278, -23.1877}, {-4.20278, -27.1877}}, color = {0, 0, 255}), Line(origin = {0.08696, 2.1196}, points = {{-20, 30}, {44, 30}, {44, 30}, {62, 30}}, color = {0, 0, 255})}),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>This is a conventional step up/down chopper (buck-boost converter) model. It consists of a transistor, and inductance and free wheeling diode.</p>
<p>Class made after the examples in <tt>Modelica.Electrical.PowerConverters.DCDC</tt>.</p>
<p>Note that a plain buck-boost would invert voltage, and not be consistent with the output pin interface; therefore there is an internal inversion.</p>
<h2>Governing Equations</h2>
<pre>if not useHeatPort then LossPower = diode.LossPower + transistor.LossPower;
end if;<br></pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>transistor</code></td><td>Switching transistor</td></tr>
<tr><td><code>diode</code></td><td>Free wheeling diode</td></tr>
</tbody></table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useConstantEnable</code></td><td>Boolean</td><td>1</td><td><code>true</code></td><td>Disable boolean input and use constantEnable, if true (inherited)</td></tr>
<tr><td><code>constantEnable</code></td><td>Boolean</td><td>1</td><td><code>true</code></td><td>Constant enabling of firing signals (inherited)</td></tr>
<tr><td><code>m</code></td><td>Integer</td><td>1</td><td><code>3</code></td><td>Number of phases (inherited)</td></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
<tr><td><code>RonTransistor</code></td><td>Modelica.Units.SI.Resistance</td><td>Ohm</td><td><code>1e-05</code></td><td>Transistor closed resistance</td></tr>
<tr><td><code>GoffTransistor</code></td><td>Modelica.Units.SI.Conductance</td><td>S</td><td><code>1e-05</code></td><td>Transistor opened conductance</td></tr>
<tr><td><code>L</code></td><td>Modelica.Units.SI.Inductance</td><td>H</td><td><code>25e-3</code></td><td>Charging inductance</td></tr>
<tr><td><code>VkneeTransistor</code></td><td>Modelica.Units.SI.Voltage</td><td>V</td><td><code>0</code></td><td>Transistor threshold voltage</td></tr>
<tr><td><code>RonDiode</code></td><td>Modelica.Units.SI.Resistance</td><td>Ohm</td><td><code>1e-05</code></td><td>Closed diode resistance</td></tr>
<tr><td><code>GoffDiode</code></td><td>Modelica.Units.SI.Conductance</td><td>S</td><td><code>1e-05</code></td><td>Opened diode conductance</td></tr>
<tr><td><code>VkneeDiode</code></td><td>Modelica.Units.SI.Voltage</td><td>V</td><td><code>0</code></td><td>Diode forward threshold voltage</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>dc_p1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive DC</td></tr>
<tr><td><code>dc_n1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative DC</td></tr>
<tr><td><code>dc_p2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive DC</td></tr>
<tr><td><code>dc_n2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative DC</td></tr>
<tr><td><code>enable</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.BooleanInput</td><td>-</td><td>Enables fire and notFire</td></tr>
<tr><td><code>fire_p</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.BooleanInput</td><td>-</td><td>Firing signal of positive potential transistor</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
</tbody></table>

</body></html>"));
end ChopperStepUpDown;
