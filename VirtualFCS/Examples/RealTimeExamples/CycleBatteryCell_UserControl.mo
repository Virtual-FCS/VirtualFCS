within VirtualFCS.Examples.RealTimeExamples;

model CycleBatteryCell_UserControl "Example demonstrating real time user controlled galvanostatic operation of a Li-ion battery cell."
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonCell liIonCell(SOC_init = 0.01) annotation(
    Placement(visible = true, transformation(origin = {0, -28}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonCell.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {74, 10}, extent = {{14, -10}, {-14, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonCell.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {75, 40}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS(N_s = 1) annotation(
    Placement(visible = true, transformation(origin = {0.5, 30}, extent = {{-31.5, -21}, {31.5, 21}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * liIonCell.coolingArea) annotation(
    Placement(visible = true, transformation(origin = {-20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-70, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 7.8 * 10 ^ 0.78 * liIonCell.coolingArea) annotation(
    Placement(visible = true, transformation(origin = {75, -70}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
    Placement(visible = true, transformation(origin = {0, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.XInTheLoop.UserInTheLoop.ThrottleKeys throttleKeys annotation(
    Placement(visible = true, transformation(origin = {-78, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = 4.4, uMin = -4.4)  annotation(
    Placement(visible = true, transformation(origin = {-38, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(getSOC_init.y, BMS.SOC_init) annotation(
    Line(points = {{58.5, 40}, {41, 40}, {41, 36}, {24, 36}}, color = {0, 0, 127}));
  connect(BMS.chargeCapacity, getChargeCapacity.y) annotation(
    Line(points = {{24, 24}, {40, 24}, {40, 10}, {59, 10}}, color = {0, 0, 127}));
  connect(ground.p, liIonCell.pin_n) annotation(
    Line(points = {{-60, -50}, {-60, -28}, {-23, -28}}, color = {0, 0, 255}));
  connect(convection.Gc, setConvectiveCoefficient.y) annotation(
    Line(points = {{30, -70}, {58, -70}}, color = {0, 0, 127}));
  connect(fixedTemperature.port, bodyRadiation.port_b) annotation(
    Line(points = {{-60, -88}, {-20, -88}, {-20, -80}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, convection.fluid) annotation(
    Line(points = {{-60, -88}, {20, -88}, {20, -80}}, color = {191, 0, 0}));
  connect(BMS.pin_n_battery, liIonCell.pin_n) annotation(
    Line(points = {{-10, 12}, {-10, 12}, {-10, 0}, {-40, 0}, {-40, -28}, {-22, -28}, {-22, -28}}, color = {0, 0, 255}));
  connect(BMS.pin_p_battery, liIonCell.pin_p) annotation(
    Line(points = {{12, 12}, {10, 12}, {10, 0}, {40, 0}, {40, -28}, {26, -28}, {26, -28}}, color = {0, 0, 255}));
  connect(liIonCell.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{0, -40}, {0, -40}, {0, -50}, {-20, -50}, {-20, -60}, {-20, -60}}, color = {191, 0, 0}));
  connect(liIonCell.heatPort, convection.solid) annotation(
    Line(points = {{0, -40}, {0, -40}, {0, -50}, {20, -50}, {20, -60}, {20, -60}}, color = {191, 0, 0}));
  connect(signalCurrent.p, BMS.pin_n_load) annotation(
    Line(points = {{-10, 72}, {-10, 72}, {-10, 48}, {-10, 48}}, color = {0, 0, 255}));
  connect(signalCurrent.n, BMS.pin_p_load) annotation(
    Line(points = {{10, 72}, {10, 72}, {10, 48}, {12, 48}}, color = {0, 0, 255}));
  connect(throttleKeys.y, limiter.u) annotation(
    Line(points = {{-66, 84}, {-52, 84}, {-52, 84}, {-50, 84}}, color = {0, 0, 127}));
  connect(limiter.y, signalCurrent.i) annotation(
    Line(points = {{-26, 84}, {0, 84}, {0, 84}, {0, 84}}, color = {0, 0, 127}));
  annotation(
    Documentation(info = "<html><head></head><body>This example demonstrates the galvanostatic operation of a Li-ion battery cell in real time over a period of 30 seconds with the current set by the user via the up and down arrows on the keyboard.&nbsp;<div><br></div><div>Requires that the user load the library: Modelica_DeviceDrivers</div></body></html>"),
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 1));
end CycleBatteryCell_UserControl;
