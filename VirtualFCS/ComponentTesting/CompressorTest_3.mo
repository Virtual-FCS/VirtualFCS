within VirtualFCS.ComponentTesting;

model CompressorTest_3 "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325) annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air(reference_X = {0.01, 0.99});
  Modelica.Fluid.Sources.FixedBoundary AirSink(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {-16, 70}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sources.FixedBoundary AirSink2(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Fluid.ThrottleValve throttleValve annotation(
    Placement(transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {54, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temp_out_comp (redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {22, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 100, offset = 0.01, startTime = 10)  annotation(
    Placement(transformation(origin = {-80, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant backPressure(k = 200000)  annotation(
    Placement(transformation(origin = {86, -38}, extent = {{-10, -10}, {10, 10}})));
  Fluid.Compressor_3 compressor annotation(
    Placement(transformation(origin = {-14, 0}, extent = {{-28, -28}, {28, 28}})));
equation
  connect(throttleValve.port_b, AirSink2.ports[1]) annotation(
    Line(points = {{84, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(pressure.port, throttleValve.port_a) annotation(
    Line(points = {{54, -26}, {54, 0}, {64, 0}}, color = {0, 127, 255}));
  connect(compressor.Input, AirSink.ports[1]) annotation(
    Line(points = {{-44, 0}, {-70, 0}}, color = {0, 127, 255}));
  connect(compressor.controlInterface, step.y) annotation(
    Line(points = {{-46, 18}, {-68, 18}, {-68, 36}}, color = {0, 0, 127}));
  connect(compressor.Output, throttleValve.port_a) annotation(
    Line(points = {{16, 0}, {64, 0}}, color = {0, 127, 255}));
  connect(compressor.Output, temp_out_comp.port) annotation(
    Line(points = {{16, 0}, {22, 0}, {22, 10}}, color = {0, 127, 255}));
  connect(compressor.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{-8, 16}, {-12, 16}, {-12, 60}}, color = {0, 0, 255}));
  connect(compressor.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-18, 16}, {-20, 16}, {-20, 60}}, color = {0, 0, 255}));
  connect(backPressure.y, throttleValve.FC_pAirOut_P) annotation(
    Line(points = {{98, -38}, {102, -38}, {102, -20}, {74, -20}, {74, -2}}, color = {0, 0, 127}));
  connect(pressure.p, throttleValve.Measured_inlet_Air_pressure) annotation(
    Line(points = {{44, -36}, {36, -36}, {36, 5.5}, {64, 5.5}, {64, 6}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})));
end CompressorTest_3;
