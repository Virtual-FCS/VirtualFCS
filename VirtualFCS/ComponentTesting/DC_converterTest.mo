within VirtualFCS.ComponentTesting;
model DC_converterTest "Simple model to test the DC_converter"
  extends Modelica.Icons.Example;
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation (
    Placement(visible = true, transformation(origin = {0, 50}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem1 annotation (
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrical.DC_converter dC_converter annotation (
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 100)  annotation (
    Placement(visible = true, transformation(origin = {42, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-38, 0}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
equation
  connect(batterySystem.pin_n, dC_converter.pin_nFC) annotation (
    Line(points={{-4.4,40.4},{-10,40.4},{-10,10}},  color = {0, 0, 255}));
  connect(batterySystem.pin_p, dC_converter.pin_pFC) annotation (
    Line(points={{4.4,40.4},{10,40.4},{10,10}},  color = {0, 0, 255}));
  connect(batterySystem1.pin_n, dC_converter.pin_nBus) annotation (
    Line(points={{-4.4,-40.4},{-10,-40.4},{-10,-10}},  color = {0, 0, 255}));
  connect(batterySystem1.pin_p, dC_converter.pin_pBus) annotation (
    Line(points={{4.4,-40.4},{10,-40.4},{10,-10}},  color = {0, 0, 255}));
  connect(realExpression.y, dC_converter.I_Ref) annotation (
    Line(points={{31,0},{22,0},{22,0.1},{11.5,0.1}},
                                      color = {0, 0, 127}));
  connect(batterySystem.pin_n, ground.p) annotation(
    Line(points = {{-4, 40}, {-18, 40}, {-18, 0}, {-30, 0}}, color = {0, 0, 255}));
  connect(batterySystem1.pin_n, ground.p) annotation(
    Line(points = {{-4, -40}, {-18, -40}, {-18, 0}, {-30, 0}}, color = {0, 0, 255}));
  annotation (
    experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-6, Interval = 1));
annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This test applies a constant 100 A current reference to the DC converter while two default battery systems are connected to its DC sides.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>batterySystem</code> (VirtualFCS.Electrochemical.Battery.BatterySystem), <code>batterySystem1</code> (VirtualFCS.Electrochemical.Battery.BatterySystem), <code>dC_converter</code> (VirtualFCS.Electrical.DC_converter), <code>system</code> (Modelica.Fluid.System), <code>realExpression</code> (Modelica.Blocks.Sources.RealExpression), <code>ground</code> (Modelica.Electrical.Analog.Basic.Ground).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end DC_converterTest;
