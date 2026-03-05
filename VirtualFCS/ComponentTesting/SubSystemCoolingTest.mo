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
end SubSystemCoolingTest;
