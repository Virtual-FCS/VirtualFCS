within VirtualFCS.Examples.ElectrochemicalComponents;

model CycleBatteryPack_Composite "Example demonstrating constant-current constant-voltage cycling of a composite Li-ion battery pack model."
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Sources.PulseCurrent pulseCurrent(I = 6.6, offset = -3.3, period = 7200, width = 50) annotation(
    Placement(visible = true, transformation(origin = {1, 83}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS(N_s = liIonBatteryPack_Composite.s, lowerVoltageLimit = liIonBatteryPack_Composite.s * 3) annotation(
    Placement(visible = true, transformation(origin = {0.5, 30}, extent = {{-31.5, -21}, {31.5, 21}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonBatteryPack_Composite.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {77, 50}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonBatteryPack_Composite.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {76, 10}, extent = {{14, -10}, {-14, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Composite liIonBatteryPack_Composite(p = 3, s = 3)  annotation(
    Placement(visible = true, transformation(origin = {1.17517, -22.1168}, extent = {{-16.6752, -10.0051}, {16.6752, 11.1168}}, rotation = 0)));
equation
  connect(BMS.chargeCapacity, getChargeCapacity.y) annotation(
    Line(points = {{24, 24}, {46, 24}, {46, 10}, {60, 10}, {60, 10}}, color = {0, 0, 127}));
  connect(BMS.SOC_init, getSOC_init.y) annotation(
    Line(points = {{24, 36}, {46, 36}, {46, 50}, {60, 50}, {60, 50}}, color = {0, 0, 127}));
  connect(pulseCurrent.n, BMS.pin_n_load) annotation(
    Line(points = {{-14, 84}, {-16, 84}, {-16, 60}, {-10, 60}, {-10, 48}, {-10, 48}}, color = {0, 0, 255}));
  connect(pulseCurrent.p, BMS.pin_p_load) annotation(
    Line(points = {{16, 84}, {18, 84}, {18, 60}, {12, 60}, {12, 48}, {12, 48}}, color = {0, 0, 255}));
  connect(liIonBatteryPack_Composite.pin_p, BMS.pin_p_battery) annotation(
    Line(points = {{12, -12}, {12, -12}, {12, 12}, {12, 12}}, color = {0, 0, 255}));
  connect(liIonBatteryPack_Composite.pin_n, BMS.pin_n_battery) annotation(
    Line(points = {{-8, -12}, {-10, -12}, {-10, 12}, {-10, 12}}, color = {0, 0, 255}));
  connect(fixedTemperature.port, liIonBatteryPack_Composite.heatBoundary) annotation(
    Line(points = {{40, -50}, {6, -50}, {6, -30}, {6, -30}, {6, -30}}, color = {191, 0, 0}));
  annotation(
    Documentation(info = "<html><head></head><body>This example demonstrates a single charge-discharge cycle for a Li-ion battery pack using the <a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Composite\">LiIonBatteryPack_Composite</a> class. The example is set up to contain nine lithium-ion batteries, with three parallel sets of three batteries in series. The battery pack is charged at 1C to its upper voltage limit and held as the current drops. Likewise, the cell is discharged at 1C until it reaches its lower voltage limit.&nbsp;<div><br></div><div>The pack considered in this example is a composite model with a separate instance of <a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonCell\">LiIonCell</a> for each cell in the pack. For investigations where cell-level resolution is not necessary and faster runtime required, please see <a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped\">LiIonBatteryPack_Lumped</a>.</div></body></html>"),
    experiment(StartTime = 0, StopTime = 7200, Tolerance = 1e-06, Interval = 1));
end CycleBatteryPack_Composite;
