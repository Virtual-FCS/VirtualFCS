within VirtualFCS.ComponentTesting;

model CompressorTest_30kW "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(transformation(origin = {140, 82}, extent = {{-10, -10}, {10, 10}})));
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air(reference_X = {0.01, 0.99});
  Modelica.Fluid.Sources.FixedBoundary AirSink(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {-84, -6}, extent = {{-10, -10}, {10, 10}})));
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {0, 58}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sources.FixedBoundary AirSink2(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {160, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {112, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temp_out_comp (redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {72, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 9500, offset = 0.001, startTime = 10)  annotation(
    Placement(transformation(origin = {-74, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant backPressure(k = 400000)  annotation(
    Placement(transformation(origin = {138, -46}, extent = {{-10, -10}, {10, 10}})));
  Fluid.ThrottleValve_2 throttleValve(m_flow_nominal = 0.5)  annotation(
    Placement(transformation(origin = {112, -8}, extent = {{-10, -10}, {10, 10}})));
  Fluid.Compressor_30kW compressor(m_flow_nom = 0.3, T_nominal = 358.15, p_nominal = 3e5)  annotation(
    Placement(transformation(origin = {1, -5}, extent = {{-31, -31}, {31, 31}})));
equation
  connect(pressure.port, throttleValve.port_a) annotation(
    Line(points = {{112, -40}, {102, -40}, {102, -8}}, color = {0, 127, 255}));
  connect(backPressure.y, throttleValve.FC_pAirOut_P) annotation(
    Line(points = {{149, -46}, {150, -46}, {150, -26}, {111, -26}, {111, -10}}, color = {0, 0, 127}));
  connect(throttleValve.Measured_inlet_Air_pressure, pressure.p) annotation(
    Line(points = {{101, -2}, {89, -2}, {89, -50}, {101, -50}}, color = {0, 0, 127}));
  connect(throttleValve.port_b, AirSink2.ports[1]) annotation(
    Line(points = {{122, -8}, {150, -8}}, color = {0, 127, 255}));
  connect(AirSink.ports[1], compressor.Input) annotation(
    Line(points = {{-74, -6}, {-33, -6}, {-33, -5}}, color = {0, 127, 255}));
  connect(step.y, compressor.controlInterface) annotation(
    Line(points = {{-62, 42}, {-48, 42}, {-48, 14}, {-34, 14}}, color = {0, 0, 127}));
  connect(compressor.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-4, 14}, {-4, 48}}, color = {0, 0, 255}));
  connect(compressor.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{8, 14}, {4, 14}, {4, 48}}, color = {0, 0, 255}));
  connect(compressor.Output, throttleValve.port_a) annotation(
    Line(points = {{36, -4}, {82, -4}, {82, -8}, {102, -8}}, color = {0, 127, 255}));
  connect(compressor.Output, temp_out_comp.port) annotation(
    Line(points = {{36, -4}, {72, -4}, {72, 2}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})));
end CompressorTest_30kW;
