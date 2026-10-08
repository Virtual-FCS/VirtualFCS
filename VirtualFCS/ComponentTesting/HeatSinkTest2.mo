within VirtualFCS.ComponentTesting;
model HeatSinkTest2 "Simple model to test the HeatSink model"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial)  annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.9,
    V_max_bat_pack=61,
    V_min_bat_pack=59,
    V_nom_bat_pack=60,                                                                                                                          m_bat_pack = 1) annotation (
    Placement(visible = true, transformation(origin={20,68},     extent={{-10,-10},
            {10,10}},                                                                             rotation = -180)));
  VirtualFCS.Thermal.HeatSink heatSink annotation (
    Placement(visible = true, transformation(origin = {20, 14}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature temperature1(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {-12, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature2(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {62, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression realExpression(y=273.15 + 80)
                                                               annotation (
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
    amplitude=80,
    rising=130,
    width=20,
    falling=130,
    period=300,
    offset=293.15,
    startTime=0)
    annotation (Placement(transformation(extent={{-134,-6},{-114,14}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid1(
    amplitude=0.2,
    rising=130,
    width=20,
    falling=130,
    period=300,
    offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-134,28},{-114,48}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {42, 52}, extent = {{-4, -4}, {4, 4}})));
equation
  connect(temperature1.port, heatSink.port_a) annotation (
    Line(points = {{-12, -14}, {-12, 0}, {0, 0}}));
  connect(temperature2.port, heatSink.port_b) annotation (
    Line(points = {{62, -14}, {62, 0}, {40, 0}}));
  connect(realExpression.y, heatSink.Set_Point) annotation (Line(points={{85,44},
          {70,44},{70,12.4},{41.6,12.4}}, color={0,0,127}));
  connect(batterySystem.pin_p, heatSink.pin_p) annotation (Line(points={{15.6,58.4},
          {15.6,42},{12,42},{12,34.8}},                  color={0,0,255}));
  connect(heatSink.pin_n, batterySystem.pin_n) annotation (Line(points={{28,34.8},
          {28,58.4},{24.4,58.4}}, color={0,0,255}));
  connect(boundary.ports[1], heatSink.port_a) annotation (Line(points={{-60,14},
          {-14,14},{-14,0},{0,0}}, color={0,127,255}));
  connect(heatSink.port_b, boundary1.ports[1]) annotation (Line(points={{40,0},{
          42,0},{42,-2},{82,-2}}, color={0,127,255}));
  connect(trapezoid.y, boundary.T_in) annotation (Line(points={{-113,4},{-90,4},
          {-90,18},{-82,18}}, color={0,0,127}));
  connect(trapezoid1.y, boundary.m_flow_in)
    annotation (Line(points={{-113,38},{-80,38},{-80,22}}, color={0,0,127}));
  connect(temperature2.T, heatSink.Stack_temperature) annotation (Line(points={
          {55,-24},{48,-24},{48,29.6},{41.6,29.6}}, color={0,0,127}));
  connect(batterySystem.pin_n, ground.p) annotation(
    Line(points = {{24, 58}, {42, 58}, {42, 56}}, color = {0, 0, 255}));

annotation(
    experiment(StopTime = 500, Interval = 0.5, Tolerance = 1e-6),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>This alternative heat-sink test applies periodic trapezoids: coolant temperature varies from 293.15 K to 373.15 K and coolant flow from 0 to 0.2 kg/s. Both signals use 130 s rise/fall times and a 300 s period.</p><p>The battery starts at SOC = 0.9 with 59 V to 61 V limits and 60 V nominal voltage.</p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end HeatSinkTest2;
