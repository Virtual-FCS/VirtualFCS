within VirtualFCS.ComponentTesting;

model DC_converterTEST
  extends Modelica.Icons.Example;
  Electrical.DC_converter dC_converter annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {0, 42}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Electrochemical.Battery.BatterySystem batterySystem1 annotation(
    Placement(visible = true, transformation(origin = {0, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 100)  annotation(
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(batterySystem.pin_n, dC_converter.pin_nFC) annotation(
    Line(points = {{-4, 32}, {-10, 32}, {-10, 10}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, dC_converter.pin_pFC) annotation(
    Line(points = {{4, 32}, {10, 32}, {10, 10}}, color = {0, 0, 255}));
  connect(batterySystem1.pin_n, dC_converter.pin_nBus) annotation(
    Line(points = {{-4, -34}, {-10, -34}, {-10, -10}}, color = {0, 0, 255}));
  connect(batterySystem1.pin_p, dC_converter.pin_pBus) annotation(
    Line(points = {{4, -34}, {10, -34}, {10, -10}}, color = {0, 0, 255}));
  connect(dC_converter.I_Ref, realExpression.y) annotation(
    Line(points = {{12, 0}, {28, 0}}, color = {0, 0, 127}));
  annotation(experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-6, Interval = 1));
end DC_converterTEST;
