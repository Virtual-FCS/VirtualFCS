within VirtualFCS.ComponentTesting;
model HeatSinkTest2 "Simple model to test the HeatSink model"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial)  annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.9, V_max_bat_pack = 27, V_min_bat_pack = 23, V_nom_bat_pack = 25, m_bat_pack = 1) annotation (
    Placement(visible = true, transformation(origin={20,68},     extent={{-10,-10},
            {10,10}},                                                                             rotation = -180)));
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
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-124,22},{-104,42}})));
equation
  connect(temperature1.port, heatSink.port_a) annotation (
    Line(points = {{-12, -14}, {-12, 0}, {0, 0}}));
  connect(temperature2.port, heatSink.port_b) annotation (
    Line(points = {{62, -14}, {62, 0}, {40, 0}}));
  connect(realExpression.y, heatSink.Set_Point) annotation (Line(points={{85,44},
          {70,44},{70,12.4},{41.6,12.4}}, color={0,0,127}));
  connect(temperature2.T, heatSink.Stack_temperature) annotation (Line(points={
          {55,-24},{50,-24},{50,29.6},{41.6,29.6}}, color={0,0,127}));
  connect(batterySystem.pin_p, heatSink.pin_p) annotation (Line(points={{15.6,58.4},
          {15.6,42},{12,42},{12,34.8}},                  color={0,0,255}));
  connect(heatSink.pin_n, batterySystem.pin_n) annotation (Line(points={{28,34.8},
          {28,58.4},{24.4,58.4}}, color={0,0,255}));
annotation (
  experiment(StopTime = 100, Interval = 0.5, Tolerance = 1e-6));
end HeatSinkTest2;
