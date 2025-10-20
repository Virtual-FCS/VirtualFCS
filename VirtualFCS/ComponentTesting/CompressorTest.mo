within VirtualFCS.ComponentTesting;
model CompressorTest "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  replaceable package Medium = VirtualFCS.Media.CathodeAir;
  //replaceable package Medium = Buildings.Media.Air;
  VirtualFCS.Fluid.Compressor compressor(redeclare package Medium = Medium)  annotation (
    Placement(visible = true, transformation(origin = {-2.88658e-15, 2.66454e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary airSource(redeclare package Medium = Medium, nPorts = 1)             annotation (
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary airSink(redeclare package Medium = Medium, nPorts = 1) annotation (
    Placement(transformation(origin = {80, 0}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation (
    Placement(transformation(origin = {0, 70}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Sources.Step step(height = 0.1, offset = 0.01, startTime = 10) annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(airSource.ports[1], compressor.Input) annotation (
    Line(points = {{-70, 0}, {-22, 0}}, color = {0, 127, 255}, thickness = 2));
  connect(compressor.Output, airSink.ports[1]) annotation (
    Line(points = {{22, 0}, {70, 0}}, color = {0, 127, 255}, thickness = 2));
  connect(batterySystem.pin_n, compressor.pin_n) annotation (
    Line(points={{-4.4,60.4},{-4.4,36},{-3.2,36},{-3.2,12}},
                                        color = {0, 0, 255}));
  connect(batterySystem.pin_p, compressor.pin_p) annotation (
    Line(points={{4.4, 60.4}, {4.4, 36}, {4, 36},{4,12}},
                                      color = {0, 0, 255}));
  connect(step.y, compressor.setMassFlow) annotation(
    Line(points = {{-58, 40}, {-40, 40}, {-40, 12}, {-22, 12}}, color = {0, 0, 127}));

annotation (
  experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,80}})));
end CompressorTest;
