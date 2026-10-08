within VirtualFCS.ComponentTesting;

model SubSystemCoolingTest "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  SubSystems.Cooling.SubSystemCooling subSystemCooling(redeclare package Coolant_Medium = Medium, PI_stack(Ti = 5)) annotation(
    Placement(transformation(origin = {0, -20}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage V_source(V = 24) annotation(
    Placement(transformation(origin = {0, -60}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatInflow annotation(
    Placement(transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_sensor annotation(
    Placement(transformation(origin = {-30, 60}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-40, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Pipes.DynamicPipe pipe(length = 1, diameter = 0.01, use_HeatTransfer = true, redeclare package Medium = Medium, T_start = 363.15, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, m_flow_start = 0.1) annotation(
    Placement(transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step heatInput(height = 6000, startTime = 10)  annotation(
    Placement(transformation(origin = {-86, 10}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(V_source.p, subSystemCooling.pin_p) annotation(
    Line(points = {{10, -60}, {10, -38}}, color = {0, 0, 255}));
  connect(V_source.n, subSystemCooling.pin_n) annotation(
    Line(points = {{-10, -60}, {-10, -38}}, color = {0, 0, 255}));
  connect(subSystemCooling.stackTemperature, T_sensor.T) annotation(
    Line(points = {{-22, -10}, {-60, -10}, {-60, 60}, {-41, 60}}, color = {0, 0, 127}));
  connect(ground.p, V_source.n) annotation(
    Line(points = {{-40, -60}, {-10, -60}}, color = {0, 0, 255}));
  connect(heatInflow.port, pipe.heatPorts[1]) annotation(
    Line(points = {{-20, 80}, {0, 80}, {0, 44}}, color = {191, 0, 0}));
  connect(pipe.port_a, subSystemCooling.to_stack) annotation(
    Line(points = {{-10, 40}, {-12, 40}, {-12, 4}}, color = {0, 127, 255}));
  connect(subSystemCooling.from_stack, pipe.port_b) annotation(
    Line(points = {{12, 4}, {12, 40}, {10, 40}}, color = {0, 127, 255}));
  connect(T_sensor.port, pipe.heatPorts[2]) annotation(
    Line(points = {{-20, 60}, {0, 60}, {0, 44}}, color = {191, 0, 0}));
  connect(heatInput.y, heatInflow.Q_flow) annotation(
    Line(points = {{-74, 10}, {-70, 10}, {-70, 80}, {-40, 80}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 20, Interval = 0.5, Tolerance = 1e-06, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This test steps the applied heat flow from 0 W to 6000 W at 10 s. The coolant system starts at 300 K and 101325 Pa with 0.1 kg/s flow; the pipe starts at 363.15 K and uses 1 m length and 0.01 m diameter.</p><p>The electrical supply is 24 V and the stack PI controller has Ti = 5. </p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>system</code> (Modelica.Fluid.System), <code>subSystemCooling</code> (SubSystems.Cooling.SubSystemCooling), <code>V_source</code> (Modelica.Electrical.Analog.Sources.ConstantVoltage), <code>heatInflow</code> (Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow), <code>T_sensor</code> (Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor), <code>ground</code> (Modelica.Electrical.Analog.Basic.Ground), <code>pipe</code> (Modelica.Fluid.Pipes.DynamicPipe), <code>heatInput</code> (Modelica.Blocks.Sources.Step).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end SubSystemCoolingTest;
