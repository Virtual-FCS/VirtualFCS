within VirtualFCS.ComponentTesting;
model PreHeaterTest "Simple model to test the PreHeater model"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Thermal.PreHeater preHeater(L_pipe = 100)  annotation (
    Placement(visible = true, transformation(origin = {1.77636e-15, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(replaceable package Medium = Medium, nPorts = 1, p = 101325*5)  annotation (
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(replaceable package Medium = Medium, nPorts = 1, p = 101325*4.7) annotation (
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.9, V_max_bat_pack = 27, V_min_bat_pack = 23, V_nom_bat_pack = 25, m_bat_pack = 1) annotation (
    Placement(visible = true, transformation(origin = {0, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature(replaceable package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature1(replaceable package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {30, -30}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {23, 45}, extent = {{-3, -3}, {3, 3}})));
equation
  connect(boundary.ports[1], preHeater.port_a) annotation (
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 0, 255}, thickness = 1));
  connect(preHeater.port_b, fixedBoundary.ports[1]) annotation (
    Line(points = {{20, 0}, {60, 0}}, color = {255, 0, 0}, thickness = 1));
  connect(batterySystem.pin_p, preHeater.pin_p) annotation (
    Line(points = {{-4, 52}, {-4, 30}, {-10, 30}, {-10, 20}}, color = {0, 0, 255}));
  connect(batterySystem.pin_n, preHeater.pin_n) annotation (
    Line(points = {{4, 52}, {4, 30}, {10, 30}, {10, 20}}, color = {0, 0, 255}));
  connect(temperature.port, preHeater.port_a) annotation (
    Line(points = {{-30, -20}, {-20, -20}, {-20, 0}}));
  connect(temperature1.port, preHeater.port_b) annotation (
    Line(points = {{30, -20}, {20, -20}, {20, 0}}));
  connect(batterySystem.pin_n, ground.p) annotation(
    Line(points = {{4, 52}, {24, 52}, {24, 48}}, color = {0, 0, 255}));

annotation (
  experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
annotation(Documentation(info = "<html><p>This test connects the pre-heater between fluid boundaries at 506625 Pa inlet and 476228 Pa outlet. The pipe length is 100 m and the water medium and 25 V nominal battery use model defaults.</p><p>No explicit flow, fluid temperature, or time-varying excitation is prescribed. The experiment runs from 0 to 600 s with 0.5 s output intervals.</p></html>"));
end PreHeaterTest;
