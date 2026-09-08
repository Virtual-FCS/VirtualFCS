within VirtualFCS.ComponentTesting;
model HeatSinkTest "Simple model to test the HeatSink model"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC annotation (
    Placement(visible = true, transformation(origin = {-36, -8.88178e-16}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial)  annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, T = Medium.T_default + 100, nPorts = 1)  annotation (
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1)  annotation (
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.9, V_max_bat_pack = 27, V_min_bat_pack = 23, V_nom_bat_pack = 25, m_bat_pack = 1) annotation (
    Placement(visible = true, transformation(origin = {-36, 40}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 0.14, f = 0.01, offset = 0.15, startTime = 10)  annotation (
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Thermal.HeatSink heatSink annotation (
    Placement(visible = true, transformation(origin = {20, 14}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {-60, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature1(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {-12, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature2(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {62, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression realExpression(y=350) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={96,44})));
equation
  connect(batterySystem.pin_n, pumpElectricDC.pin_n) annotation (
    Line(points={{-40.4,30.4},{-40.4,20},{-40.2,20},{-40.2,11.2}},
                                          color = {0, 0, 255}));
  connect(batterySystem.pin_p, pumpElectricDC.pin_p) annotation (
    Line(points={{-31.6,30.4},{-31.6,20},{-31.8,20},{-31.8,11.2}},
                                          color = {0, 0, 255}));
  connect(boundary.ports[1], pumpElectricDC.Input) annotation (
    Line(points={{-80,0},{-48.6,0}},    color = {255, 0, 0}, thickness = 1));
  connect(sine.y, pumpElectricDC.contol_input) annotation (
    Line(points={{-79,-50},{-40.2,-50},{-40.2,-11.2}},  color = {0, 0, 127}));
  connect(pumpElectricDC.Output, heatSink.port_a) annotation (
    Line(points={{-23.4,0},{0,0}},    color = {255, 0, 0}, thickness = 1));
  connect(heatSink.port_b, fixedBoundary.ports[1]) annotation (
    Line(points = {{40, 0}, {80, 0}}, color = {0, 0, 255}, thickness = 1));
  connect(temperature.port, pumpElectricDC.Input) annotation (
    Line(points={{-60,-14},{-60,0},{-48.6,0}}));
  connect(temperature1.port, heatSink.port_a) annotation (
    Line(points = {{-12, -14}, {-12, 0}, {0, 0}}));
  connect(temperature2.port, heatSink.port_b) annotation (
    Line(points = {{62, -14}, {62, 0}, {40, 0}}));
  connect(realExpression.y, heatSink.Set_Point) annotation (Line(points={{85,44},
          {70,44},{70,12.4},{41.6,12.4}}, color={0,0,127}));
  connect(temperature2.T, heatSink.Stack_temperature) annotation (Line(points={
          {55,-24},{50,-24},{50,29.6},{41.6,29.6}}, color={0,0,127}));
  connect(batterySystem.pin_p, heatSink.pin_p) annotation (Line(points={{-31.6,
          30.4},{-31.6,28},{-6,28},{-6,42},{12,42},{12,34.8}}, color={0,0,255}));
  connect(heatSink.pin_n, pumpElectricDC.pin_n) annotation (Line(points={{28,
          34.8},{-6,34.8},{-6,24},{-40.4,24},{-40.4,20},{-40.2,20},{-40.2,11.2}},
        color={0,0,255}));
annotation (
  experiment(StopTime = 100, Interval = 0.5, Tolerance = 1e-6));
annotation(Documentation(info = "<html><p>Test model for the heat sink.</p></html>"));
end HeatSinkTest;
