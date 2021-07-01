within VirtualFCS.Examples.ElectrochemicalComponents;

model CycleBatterPack_Lumped "Example demonstrating constant-current constant-voltage cycling of a lumped Li-ion battery pack model."
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Sources.PulseCurrent pulseCurrent(I = 4.4 * 4, offset = -2.2 * 4, period = 7200, width = 50) annotation(
    Placement(visible = true, transformation(origin = {1, 83}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS(p = liIonBatteryPack_Lumped.p, s = liIonBatteryPack_Lumped.s) annotation(
    Placement(visible = true, transformation(origin = {0.5, 30}, extent = {{-31.5, -21}, {31.5, 21}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonBatteryPack_Lumped.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {77, 50}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonBatteryPack_Lumped.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {76, 10}, extent = {{14, -10}, {-14, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped liIonBatteryPack_Lumped(p = 4, s = 4)  annotation(
    Placement(visible = true, transformation(origin = {0.56663, -25.0444}, extent = {{-18.0666, -10.84}, {18.0666, 12.0444}}, rotation = 0)));
equation
  connect(fixedTemperature.port, liIonBatteryPack_Lumped.heatBoundary) annotation(
    Line(points = {{40, -50}, {6, -50}, {6, -34}, {6, -34}}, color = {191, 0, 0}));
  connect(BMS.pin_n_battery, liIonBatteryPack_Lumped.pin_n) annotation(
    Line(points = {{-10, 12}, {-12, 12}, {-12, -14}, {-10, -14}}, color = {0, 0, 255}));
  connect(BMS.pin_p_battery, liIonBatteryPack_Lumped.pin_p) annotation(
    Line(points = {{12, 12}, {12, 12}, {12, -14}, {12, -14}}, color = {0, 0, 255}));
  connect(BMS.chargeCapacity, getChargeCapacity.y) annotation(
    Line(points = {{24, 24}, {46, 24}, {46, 10}, {60, 10}, {60, 10}}, color = {0, 0, 127}));
  connect(BMS.SOC_init, getSOC_init.y) annotation(
    Line(points = {{24, 36}, {46, 36}, {46, 50}, {60, 50}, {60, 50}}, color = {0, 0, 127}));
  connect(pulseCurrent.n, BMS.pin_n_load) annotation(
    Line(points = {{-14, 84}, {-16, 84}, {-16, 60}, {-10, 60}, {-10, 48}, {-10, 48}}, color = {0, 0, 255}));
  connect(pulseCurrent.p, BMS.pin_p_load) annotation(
    Line(points = {{16, 84}, {18, 84}, {18, 60}, {12, 60}, {12, 48}, {12, 48}}, color = {0, 0, 255}));
annotation(
    Documentation(info = "<html><head></head><body>This example demonstrates a single charge-discharge cycle for a Li-ion battery pack. The battery is charged at 1C to its upper voltage limit and held as the current drops. Likewise, the cell is discharged at 1C until it reaches its lower voltage limit.&nbsp;<div><br></div><div>The pack considered in this example is a lumped model considering the summed performance of all the cells in the pack. For investigations where cell-level resolution is necessary (e.g. cell balancing), please see LiIonBatteryPack_Composite.</div></body></html>"));
end CycleBatterPack_Lumped;
