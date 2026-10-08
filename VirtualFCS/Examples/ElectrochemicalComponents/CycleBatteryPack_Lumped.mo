within VirtualFCS.Examples.ElectrochemicalComponents;
model CycleBatteryPack_Lumped "Example demonstrating constant-current constant-voltage cycling of a lumped Li-ion battery pack model."
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Sources.PulseCurrent pulseCurrent(I = 400, offset = -200, period = 7200, width = 50) annotation (
    Placement(visible = true, transformation(origin = {1, 83}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS(N_s = liIonBatteryPack_Lumped.N_s, lowerVoltageLimit = 40, upperVoltageLimit = 54) annotation (
    Placement(visible = true, transformation(origin = {0.5, 30}, extent = {{-31.5, -21}, {31.5, 21}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonBatteryPack_Lumped.SOC_init) annotation (
    Placement(visible = true, transformation(origin = {77, 50}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonBatteryPack_Lumped.C_bat_pack * 3600) annotation (
    Placement(visible = true, transformation(origin = {76, 10}, extent = {{14, -10}, {-14, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation (
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped liIonBatteryPack_Lumped(SOC_init = 0.99) annotation (
    Placement(visible = true, transformation(origin = {0.56663, -25.0444}, extent = {{-18.0666, -10.84}, {18.0666, 12.0444}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-34, -32}, extent = {{-6, -6}, {6, 6}})));
equation
  connect(fixedTemperature.port, liIonBatteryPack_Lumped.heatBoundary) annotation (
    Line(points = {{40, -50}, {6, -50}, {6, -34}, {6, -34}}, color = {191, 0, 0}));
  connect(BMS.pin_n_battery, liIonBatteryPack_Lumped.pin_n) annotation (
    Line(points = {{-10, 12}, {-12, 12}, {-12, -14}, {-10, -14}}, color = {0, 0, 255}));
  connect(BMS.pin_p_battery, liIonBatteryPack_Lumped.pin_p) annotation (
    Line(points = {{12, 12}, {12, 12}, {12, -14}, {12, -14}}, color = {0, 0, 255}));
  connect(BMS.chargeCapacity, getChargeCapacity.y) annotation (
    Line(points = {{24, 24}, {46, 24}, {46, 10}, {60, 10}, {60, 10}}, color = {0, 0, 127}));
  connect(BMS.SOC_init, getSOC_init.y) annotation (
    Line(points = {{24, 36}, {46, 36}, {46, 50}, {60, 50}, {60, 50}}, color = {0, 0, 127}));
  connect(pulseCurrent.n, BMS.pin_n_load) annotation (
    Line(points = {{-14, 84}, {-16, 84}, {-16, 60}, {-10, 60}, {-10, 48}, {-10, 48}}, color = {0, 0, 255}));
  connect(pulseCurrent.p, BMS.pin_p_load) annotation (
    Line(points = {{16, 84}, {18, 84}, {18, 60}, {12, 60}, {12, 48}, {12, 48}}, color = {0, 0, 255}));
  connect(liIonBatteryPack_Lumped.pin_n, ground.p) annotation(
    Line(points = {{-10, -14}, {-34, -14}, {-34, -26}}, color = {0, 0, 255}));
  annotation (
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This example cycles a lumped Li-ion battery pack with a pulse current between -200 A and +200 A over 7200 s. The pack starts at SOC = 0.99 and is evaluated with BMS voltage limits of 40 V and 54 V.</p><p>The lumped formulation represents the summed pack behavior without individual cell states. Use the composite-pack example for cell-level behavior such as cell balancing.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>pulseCurrent</code> (Modelica.Electrical.Analog.Sources.PulseCurrent), <code>BMS</code> (VirtualFCS.Control.BatteryManagementSystem), <code>getSOC_init</code> (Modelica.Blocks.Sources.RealExpression), <code>getChargeCapacity</code> (Modelica.Blocks.Sources.RealExpression), <code>fixedTemperature</code> (Modelica.Thermal.HeatTransfer.Sources.FixedTemperature), <code>liIonBatteryPack_Lumped</code> (VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped), <code>ground</code> (Modelica.Electrical.Analog.Basic.Ground).</p>
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
</html>"),
    experiment(StartTime = 0, StopTime = 7200, Tolerance = 1e-06, Interval = 1));
end CycleBatteryPack_Lumped;
