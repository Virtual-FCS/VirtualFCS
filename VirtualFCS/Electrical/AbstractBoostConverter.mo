within VirtualFCS.Electrical;

partial model AbstractBoostConverter
  extends Modelica.Electrical.PowerConverters.Icons.Converter;
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin1;
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin2;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  
  Modelica.Electrical.Spice3.Basic.K_CoupledInductors L_coupling(k = 0.8) annotation(
    Placement(transformation(origin = {-16, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.L_Inductor inductor_B(L(displayUnit = "uH") = 8.5e-5) annotation(
    Placement(transformation(origin = {-16, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Spice3.Basic.L_Inductor inductor_A(L(displayUnit = "uH") = 8.5e-5) annotation(
    Placement(transformation(origin = {-16, 60}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor_B(R(displayUnit = "mOhm") = 0.004, useHeatPort = useHeatPort) annotation(
    Placement(transformation(origin = {-42, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor_A(R(displayUnit = "mOhm") = 0.004, useHeatPort = useHeatPort) annotation(
    Placement(transformation(origin = {-42, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Semiconductors.Diode diode_A(useHeatPort = useHeatPort)  annotation(
    Placement(transformation(origin = {40, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Semiconductors.Diode diode_B(useHeatPort = useHeatPort)  annotation(
    Placement(transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor current_A annotation(
    Placement(transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor current_B annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Spice3.Basic.C_Capacitor capacitor_in_p(C(displayUnit = "nF") = 1e-9) annotation(
    Placement(transformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.Ground case_in annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.C_Capacitor capacitor_in_n(C(displayUnit = "nF") = 1e-9) annotation(
    Placement(transformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.C_Capacitor capacitor_out_p(C(displayUnit = "nF") = 1e-9) annotation(
    Placement(transformation(origin = {100, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.Ground case_out annotation(
    Placement(transformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Electrical.Spice3.Basic.C_Capacitor capacitor_out_n(C(displayUnit = "nF") = 1e-9) annotation(
    Placement(transformation(origin = {100, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.C_Capacitor C_out(C(displayUnit = "uF") = 8e-5)  annotation(
    Placement(transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  replaceable AbstractCommutator commutator_A(useHeatPort=useHeatPort) constrainedby AbstractCommutator annotation(
    Placement(transformation(origin = {16, 50}, extent = {{-10, -10}, {10, 10}})));
  replaceable AbstractCommutator commutator_B(useHeatPort=useHeatPort) constrainedby AbstractCommutator annotation(
    Placement(transformation(origin = {8, -10}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(inductor_B.ICP, L_coupling.inductiveCouplePin2) annotation(
    Line(points = {{-16, 8}, {-16, 20.4}}, color = {170, 85, 255}));
  connect(inductor_A.ICP, L_coupling.inductiveCouplePin1) annotation(
    Line(points = {{-16, 51.6}, {-16, 39.6}}, color = {170, 85, 255}));
  connect(resistor_A.n, inductor_A.p) annotation(
    Line(points = {{-32, 60}, {-26, 60}}, color = {0, 0, 255}));
  connect(resistor_B.n, inductor_B.p) annotation(
    Line(points = {{-32, 0}, {-26, 0}}, color = {0, 0, 255}));
  connect(dc_n1, dc_n2) annotation(
    Line(points = {{-100, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(diode_A.n, dc_p2) annotation(
    Line(points = {{50, 60}, {100, 60}}, color = {0, 0, 255}));
  connect(dc_p2, diode_B.n) annotation(
    Line(points = {{100, 60}, {66, 60}, {66, 0}, {50, 0}}, color = {0, 0, 255}));
  connect(current_A.p, dc_p1) annotation(
    Line(points = {{-80, 60}, {-100, 60}}, color = {0, 0, 255}));
  connect(dc_n1, capacitor_in_n.n) annotation(
    Line(points = {{-100, -60}, {-100, -40}}, color = {0, 0, 255}));
  connect(capacitor_in_n.p, case_in.p) annotation(
    Line(points = {{-100, -20}, {-100, 0}}, color = {0, 0, 255}));
  connect(case_in.p, capacitor_in_p.n) annotation(
    Line(points = {{-100, 0}, {-100, 20}}, color = {0, 0, 255}));
  connect(capacitor_in_p.p, dc_p1) annotation(
    Line(points = {{-100, 40}, {-100, 60}}, color = {0, 0, 255}));
  connect(dc_p1, current_A.p) annotation(
    Line(points = {{-100, 60}, {-80, 60}}, color = {0, 0, 255}));
  connect(dc_p2, capacitor_out_p.p) annotation(
    Line(points = {{100, 60}, {100, 40}}, color = {0, 0, 255}));
  connect(capacitor_out_p.n, case_out.p) annotation(
    Line(points = {{100, 20}, {100, 0}}, color = {0, 0, 255}));
  connect(case_out.p, capacitor_out_n.p) annotation(
    Line(points = {{100, 0}, {100, -20}}, color = {0, 0, 255}));
  connect(capacitor_out_n.n, dc_n2) annotation(
    Line(points = {{100, -40}, {100, -60}}, color = {0, 0, 255}));
  connect(C_out.n, dc_n2) annotation(
    Line(points = {{80, -10}, {80, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(C_out.p, dc_p2) annotation(
    Line(points = {{80, 10}, {80, 60}, {100, 60}}, color = {0, 0, 255}));
  connect(current_B.p, dc_p1) annotation(
    Line(points = {{-80, 0}, {-88, 0}, {-88, 60}, {-100, 60}}, color = {0, 0, 255}));
  connect(current_B.n, resistor_B.p) annotation(
    Line(points = {{-60, 0}, {-52, 0}}, color = {0, 0, 255}));
  connect(current_A.n, resistor_A.p) annotation(
    Line(points = {{-60, 60}, {-52, 60}}, color = {0, 0, 255}));
  connect(inductor_A.n, commutator_A.p1) annotation(
    Line(points = {{-6, 60}, {6, 60}}, color = {0, 0, 255}));
  connect(commutator_A.p2, diode_A.p) annotation(
    Line(points = {{26, 60}, {30, 60}}, color = {0, 0, 255}));
  connect(commutator_A.n, dc_n2) annotation(
    Line(points = {{16, 40}, {16, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(commutator_B.p2, diode_B.p) annotation(
    Line(points = {{18, 0}, {30, 0}}, color = {0, 0, 255}));
  connect(commutator_B.p1, inductor_B.n) annotation(
    Line(points = {{-2, 0}, {-6, 0}}, color = {0, 0, 255}));
  connect(commutator_B.n, dc_n2) annotation(
    Line(points = {{8, -20}, {8, -60}, {100, -60}}, color = {0, 0, 255}));
  if useHeatPort then
    connect(heatPort, resistor_B.heatPort) annotation(
      Line(points = {{0, -100}, {-42, -100}, {-42, -10}}, color = {191, 0, 0}));
    connect(heatPort, resistor_A.heatPort) annotation(
      Line(points = {{0, -100}, {-56, -100}, {-56, 50}, {-42, 50}}, color = {191, 0, 0}));
    connect(heatPort, diode_B.heatPort) annotation(
      Line(points = {{0, -100}, {40, -100}, {40, -10}}, color = {191, 0, 0}));
    connect(heatPort, diode_A.heatPort) annotation(
      Line(points = {{0, -100}, {54, -100}, {54, 50}, {40, 50}}, color = {191, 0, 0}));
    connect(heatPort, commutator_B.heatPort) annotation(
      Line(points = {{0, -100}, {20, -100}, {20, -10}, {12, -10}}, color = {191, 0, 0}));
    connect(heatPort, commutator_A.heatPort) annotation(
      Line(points = {{0, -100}, {30, -100}, {30, 50}, {20, 50}}, color = {191, 0, 0}));
  else
    LossPower = 0;
  end if;
  connect(diode_B.heatPort, heatPort) annotation(
    Line(points = {{0, -100}, {40, -100}, {40, -10}}, color = {191, 0, 0}));
  connect(commutator_B.heatPort, heatPort) annotation(
    Line(points = {{12, -10}, {20, -10}, {20, -100}, {0, -100}}, color = {191, 0, 0}));

  annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
This is a class representing a generic DC-DC architecture with coupled inductors.<div>The abstract commutators can be specialised to actual switches, allowing study at short time scales, or to averaged components allowing integration within fuel-cell system models.</div><div><br></div><h3>Stability note</h3><div>Consistently with specifications, this model does <i>not</i>&nbsp;have an <b>input capacitor</b>, but this may be necessary to numerically stabilise the model into which this unit is integrated.</div>
<h2>Governing Equations</h2>
<pre>-</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>dc_p1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive DC</td></tr>
<tr><td><code>dc_n1</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative DC</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
<tr><td><code>dc_p2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive DC</td></tr>
<tr><td><code>dc_n2</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative DC</td></tr>
</tbody></table>

</body></html>"));
end AbstractBoostConverter;
