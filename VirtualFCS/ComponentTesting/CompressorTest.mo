within VirtualFCS.ComponentTesting;

model CompressorTest "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable package Medium = Modelica.Media.Air.MoistAir(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
VirtualFCS.Fluid.Compressor compressor annotation(
    Placement(visible = true, transformation(origin = {-2.88658e-15, 2.66454e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
Modelica.Blocks.Sources.Sine sine(amplitude = 10, f = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {-70, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Fluid.Sources.FixedBoundary AirSink(redeclare package Medium = Medium, nPorts = 1, p = 200000) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Fluid.Sources.FixedBoundary AirSink2(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Sources.Sine sine1(amplitude = 0.2, f = 0.01, offset = 1, startTime = 20) annotation(
    Placement(visible = true, transformation(origin = {-70, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
connect(AirSink.ports[1], compressor.Input) annotation(
    Line(points = {{-70, 0}, {-22, 0}}, color = {0, 127, 255}, thickness = 2));
connect(compressor.Output, AirSink2.ports[1]) annotation(
    Line(points = {{22, 0}, {56, 0}}, color = {0, 127, 255}, thickness = 2));
connect(batterySystem.pin_n, compressor.pin_n) annotation(
    Line(points = {{-4, 60}, {-4, 12}}, color = {0, 0, 255}));
connect(batterySystem.pin_p, compressor.pin_p) annotation(
    Line(points = {{4, 60}, {4, 12}}, color = {0, 0, 255}));
connect(sine1.y, compressor.controlInterface) annotation(
    Line(points = {{-58, 34}, {-40, 34}, {-40, 12}, {-22, 12}}, color = {0, 0, 127}));
annotation (
  experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end CompressorTest;
