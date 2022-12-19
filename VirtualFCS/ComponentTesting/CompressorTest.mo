within VirtualFCS.ComponentTesting;

model CompressorTest "Model to test the compressor component"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Air.MoistAir(Temperature(start = 293.15), AbsolutePressure(start = 101325));
  
VirtualFCS.Fluid.Compressor compressor annotation(
    Placement(visible = true, transformation(origin = {-2.88658e-15, 2.66454e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
Modelica.Blocks.Sources.Sine sine(amplitude = 10, f = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Fluid.Sources.FixedBoundary AirSink(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Fluid.Sources.FixedBoundary AirSink2(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
equation
  connect(sine.y, compressor.controlInterface) annotation(
    Line(points = {{-58, 50}, {-40, 50}, {-40, 12}, {-22, 12}}, color = {0, 0, 127}));
connect(AirSink.ports[1], compressor.Input) annotation(
    Line(points = {{-70, 0}, {-22, 0}}, color = {0, 127, 255}, thickness = 2));
connect(compressor.Output, AirSink2.ports[1]) annotation(
    Line(points = {{22, 0}, {56, 0}}, color = {0, 127, 255}, thickness = 2));
connect(batterySystem.pin_n, compressor.pin_n) annotation(
    Line(points = {{-4, 60}, {-4, 12}}, color = {0, 0, 255}));
connect(batterySystem.pin_p, compressor.pin_p) annotation(
    Line(points = {{4, 60}, {4, 12}}, color = {0, 0, 255}));
annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));

end CompressorTest;