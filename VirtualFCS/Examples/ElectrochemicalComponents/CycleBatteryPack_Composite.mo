within VirtualFCS.Examples.ElectrochemicalComponents;

model CycleBatteryPack_Composite "Example demonstrating constant-current constant-voltage cycling of a composite Li-ion battery pack model."
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Sources.PulseCurrent pulseCurrent(I = 4.4 * liIonBatteryPack_Composite.p, offset = -2.2 * 4 * liIonBatteryPack_Composite.p, period = 7200, width = 50) annotation(
    Placement(visible = true, transformation(origin = {0, 80}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS(p = liIonBatteryPack_Composite.p, s = liIonBatteryPack_Composite.s) annotation(
    Placement(visible = true, transformation(origin = {0.5, 30}, extent = {{-31.5, -21}, {31.5, 21}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonBatteryPack_Composite.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {77, 50}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonBatteryPack_Composite.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {76, 10}, extent = {{14, -10}, {-14, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Composite liIonBatteryPack_Composite(p = 4, s = 4)  annotation(
    Placement(visible = true, transformation(origin = {0.962102, -23.3081}, extent = {{-18.4621, -11.0773}, {18.4621, 12.3081}}, rotation = 0)));
equation
  connect(BMS.chargeCapacity, getChargeCapacity.y) annotation(
    Line(points = {{24, 24}, {48, 24}, {48, 10}, {60, 10}, {60, 10}}, color = {0, 0, 127}));
  connect(BMS.SOC_init, getSOC_init.y) annotation(
    Line(points = {{24, 36}, {48, 36}, {48, 50}, {60, 50}, {60, 50}}, color = {0, 0, 127}));
  connect(pulseCurrent.p, BMS.pin_n_load) annotation(
    Line(points = {{-18, 80}, {-18, 80}, {-18, 60}, {-10, 60}, {-10, 48}, {-10, 48}}, color = {0, 0, 255}));
  connect(pulseCurrent.n, BMS.pin_p_load) annotation(
    Line(points = {{18, 80}, {18, 80}, {18, 60}, {10, 60}, {10, 48}, {12, 48}}, color = {0, 0, 255}));
  connect(BMS.pin_n_battery, liIonBatteryPack_Composite.pin_n) annotation(
    Line(points = {{-10, 12}, {-10, 12}, {-10, -12}, {-10, -12}, {-10, -12}}, color = {0, 0, 255}));
  connect(BMS.pin_p_battery, liIonBatteryPack_Composite.pin_p) annotation(
    Line(points = {{12, 12}, {12, 12}, {12, -12}, {12, -12}}, color = {0, 0, 255}));
  connect(fixedTemperature.port, liIonBatteryPack_Composite.heatBoundary) annotation(
    Line(points = {{40, -50}, {8, -50}, {8, -32}, {8, -32}}, color = {191, 0, 0}));
  annotation(
    Documentation(info = "<html><head></head><body>This example demonstrates a single charge-discharge cycle for a Li-ion battery pack. The battery is charged at 1C to its upper voltage limit and held as the current drops. Likewise, the cell is discharged at 1C until it reaches its lower voltage limit.&nbsp;<div><br></div><div>The pack considered in this example is a composite model featuring encompassing individual models for the cells it contains. This is advantageous for potentially investigating cell-resolve topics (e.g. cell balancing), but can lead to very large systems of equations. For a more efficient battery pack model, please see LiIonBatteryPack_Lumped.</div></body></html>"));
end CycleBatteryPack_Composite;
