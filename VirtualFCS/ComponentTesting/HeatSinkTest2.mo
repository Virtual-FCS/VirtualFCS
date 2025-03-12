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
  Modelica.Fluid.Sensors.Temperature temperature1(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {-12, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature2(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {62, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression realExpression(y=350) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={96,44})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,4},{-60,24}})));
  Modelica.Fluid.Sources.FixedBoundary boundary1(redeclare package Medium = Medium, nPorts=1) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={92,-2})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=90,
    rising=130,
    width=20,
    falling=130,
    period=300,
    offset=293.15,
    startTime=0)
    annotation (Placement(transformation(extent={{-134,-8},{-114,12}})));
  Modelica.Blocks.Sources.Constant const(k=0.2)
    annotation (Placement(transformation(extent={{-136,30},{-116,50}})));
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
  connect(boundary.ports[1], heatSink.port_a) annotation (Line(points={{-60,14},
          {-14,14},{-14,0},{0,0}}, color={0,127,255}));
  connect(heatSink.port_b, boundary1.ports[1]) annotation (Line(points={{40,0},{
          42,0},{42,-2},{82,-2}}, color={0,127,255}));
  connect(trapezoid.y, boundary.T_in) annotation (Line(points={{-113,2},{-90,2},
          {-90,18},{-82,18}}, color={0,0,127}));
  connect(const.y, boundary.m_flow_in)
    annotation (Line(points={{-115,40},{-80,40},{-80,22}}, color={0,0,127}));
annotation (
  experiment(StopTime = 100, Interval = 0.5, Tolerance = 1e-6));
end HeatSinkTest2;
