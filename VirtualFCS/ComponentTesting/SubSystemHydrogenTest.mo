within VirtualFCS.ComponentTesting;

model SubSystemHydrogenTest "Example to evaluate the performance of the hydrogen subsystem."
  extends Modelica.Icons.Example;
  import Modelica.Constants.F;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  Modelica.Blocks.Math.Gain reactionRate(k = subSystemHydrogen.N_cells/2/F) annotation (
    Placement(visible = true, transformation(origin = {-34, 80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  SubSystems.Hydrogen.SubSystemHydrogen subSystemHydrogen(redeclare package Anode_Medium = Anode_Medium)  annotation (
    Placement(transformation(origin = {0,0}, extent = {{-30, -20}, {30, 20}})));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.9, V_max_bat_pack = 34, V_min_bat_pack = 30, V_nom_bat_pack = 32, m_bat_pack = 1) annotation(
    Placement(visible = true, transformation(origin = {1.9984e-15, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Trapezoid trapezoid(amplitude = 750, falling = 50, period = 500, rising = 50, startTime = 100, width = 200, offset = 1)  annotation (
    Placement(visible = true, transformation(origin = {-76, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrochemical.Hydrogen.Manifold manifold(redeclare package Medium = Anode_Medium, nu = {-1}, MMX = {0.002})  annotation(
    Placement(transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-44, -64}, extent = {{-6, -6}, {6, 6}})));
equation
  connect(trapezoid.y, reactionRate.u) annotation(
    Line(points = {{-65, 80}, {-43.6, 80}}, color = {0, 0, 127}));
  connect(reactionRate.y, manifold.r) annotation(
    Line(points = {{-26, 80}, {0, 80}, {0, 68}}, color = {0, 0, 127}));
  connect(trapezoid.y, subSystemHydrogen.stackCurrent) annotation(
    Line(points = {{-64, 80}, {-60, 80}, {-60, 0}, {-32, 0}}, color = {0, 0, 127}));
  connect(manifold.port_a, subSystemHydrogen.toStack) annotation(
    Line(points = {{-10, 60}, {-16, 60}, {-16, 24}}, color = {0, 127, 255}));
  connect(manifold.port_b, subSystemHydrogen.fromStack) annotation(
    Line(points = {{10, 60}, {16, 60}, {16, 24}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-8, -18}, {-8, -40}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{16, -18}, {8, -18}, {8, -40}}, color = {0, 0, 255}));
  connect(batterySystem.pin_n, ground.p) annotation(
    Line(points = {{-8, -40}, {-44, -40}, {-44, -58}}, color = {0, 0, 255}));
  annotation (
    Diagram,
    Icon,
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
This example is intended as a means to evaluate the performance of the hydrogen subsystem both for optimization and troubleshooting purposes.<div><br></div><div><b><br></b></div><div><b>Description</b></div><div><p class=\"MsoNormal\">The model has three parts (1) input (includes fuel cell current and its conversion to hydrogen mass flow rate), (2) hydrogen subsystem (includes hydrogen tank, pressure regulator, recirculation blower, purge valve and control system), and (3) power supply (battery system).&nbsp;</p><p class=\"MsoNormal\"><br></p><p class=\"MsoNormal\"><b>References to base model/related packages<o:p></o:p></b></p><p class=\"MsoNormal\"><span lang=\"NO-BOK\" style=\"mso-ansi-language:NO-BOK\"><o:p>&nbsp;</o:p></span><a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl\">Subsystem Hydrogen Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>,&nbsp;<a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a>&nbsp;and <a href=\"modelica://VirtualFCS.Electrochemical.Battery.BatterySystem\">Battery System</a></p>

<p class=\"MsoListParagraphCxSpMiddle\" style=\"margin-left:108.0pt;mso-add-space:
auto;text-indent:-108.0pt;mso-text-indent-alt:-9.0pt;mso-list:l0 level3 lfo1\"><o:p></o:p></p>

<p class=\"MsoListParagraphCxSpMiddle\" style=\"margin-left:108.0pt;mso-add-space:
auto;text-indent:-108.0pt;mso-text-indent-alt:-9.0pt;mso-list:l0 level3 lfo1\"><o:p></o:p></p>







<p class=\"MsoListParagraphCxSpMiddle\" style=\"margin-left:108.0pt;mso-add-space:
auto;text-indent:-108.0pt;mso-text-indent-alt:-9.0pt;mso-list:l0 level3 lfo1\"><o:p></o:p></p>





<p class=\"MsoListParagraphCxSpLast\" style=\"margin-left:72.0pt;mso-add-space:auto;
text-indent:-18.0pt;mso-list:l0 level2 lfo1\"><o:p></o:p></p>

<!--EndFragment--></div>
<h2>Governing Equations</h2>
<p>The assembly connects <code>system</code> (Modelica.Fluid.System), <code>reactionRate</code> (Modelica.Blocks.Math.Gain), <code>subSystemHydrogen</code> (SubSystems.Hydrogen.SubSystemHydrogen), <code>batterySystem</code> (VirtualFCS.Electrochemical.Battery.BatterySystem), <code>trapezoid</code> (Modelica.Blocks.Sources.Trapezoid), <code>manifold</code> (Electrochemical.Hydrogen.Manifold), <code>ground</code> (Modelica.Electrical.Analog.Basic.Ground).</p>
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

</body></html>"),
    experiment(StartTime = 0, StopTime = 1500, Tolerance = 1e-06, Interval = 0.15));

end SubSystemHydrogenTest;
