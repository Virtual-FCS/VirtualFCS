within VirtualFCS.ComponentTesting;

model CompressorTest_2 "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air(reference_X = {0.01, 0.99});
  Modelica.Fluid.Sources.FixedBoundary AirSink(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {-16, 70}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Fluid.Compressor_2 compressor(mf_nom = 0.1)  annotation(
    Placement(transformation(origin = {-18, 0}, extent = {{-24, -24}, {24, 24}})));
  Modelica.Fluid.Sources.FixedBoundary AirSink2(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {62, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temp_out_comp (redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {22, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.0001, startTime = 10)  annotation(
    Placement(transformation(origin = {-80, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant backPressure(k = 250000)  annotation(
    Placement(transformation(origin = {88, -38}, extent = {{-10, -10}, {10, 10}})));
  Fluid.ThrottleValve_2 throttleValve(m_flow_nominal = 0.5)  annotation(
    Placement(transformation(origin = {62, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(AirSink.ports[1], compressor.Input) annotation(
    Line(points = {{-70, 0}, {-44, 0}}, color = {0, 127, 255}));
  connect(compressor.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-21.84, 14.4}, {-21.84, 39.4}, {-19.84, 39.4}, {-19.84, 60.4}}, color = {0, 0, 255}));
  connect(compressor.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{-13.2, 14.4}, {-13.2, 38.4}, {-12.2, 38.4}, {-12.2, 60.4}}, color = {0, 0, 255}));
  connect(temp_out_comp.port, compressor.Output) annotation(
    Line(points = {{22, 10}, {8, 10}, {8, 0}}, color = {0, 127, 255}));
  connect(step.y, compressor.controlInterface) annotation(
    Line(points = {{-69, 34}, {-46, 34}, {-46, 14}}, color = {0, 0, 127}));
  connect(compressor.Output, throttleValve.port_a) annotation(
    Line(points = {{8, 0}, {52, 0}}, color = {0, 127, 255}));
  connect(pressure.port, throttleValve.port_a) annotation(
    Line(points = {{62, -32}, {52, -32}, {52, 0}}, color = {0, 127, 255}));
  connect(backPressure.y, throttleValve.FC_pAirOut_P) annotation(
    Line(points = {{100, -38}, {101, -38}, {101, -18}, {62, -18}, {62, -2}}, color = {0, 0, 127}));
  connect(throttleValve.Measured_inlet_Air_pressure, pressure.p) annotation(
    Line(points = {{52, 6}, {40, 6}, {40, -42}, {52, -42}}, color = {0, 0, 127}));
  connect(throttleValve.port_b, AirSink2.ports[1]) annotation(
    Line(points = {{72, 0}, {100, 0}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})));
end CompressorTest_2;
