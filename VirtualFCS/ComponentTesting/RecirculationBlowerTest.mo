within VirtualFCS.ComponentTesting;

model RecirculationBlowerTest "Model to test the recirculation blower component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15), AbsolutePressure(start = 300000));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, nPorts = 1, p = 200000)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 0.2, f = 0.01, offset = 1, startTime = 20)  annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1.17) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Fluid.RecirculationBlower recirculationBlower annotation(
    Placement(visible = true, transformation(origin = {1.77636e-15, -1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(boundary.ports[1], recirculationBlower.Input) annotation(
    Line(points = {{-60, 0}, {-18, 0}}, color = {0, 127, 255}));
  connect(fixedBoundary.ports[1], recirculationBlower.Output) annotation(
    Line(points = {{60, 0}, {18, 0}}, color = {0, 127, 255}));
  connect(sine.y, recirculationBlower.controlInterface) annotation(
    Line(points = {{-38, -50}, {-6, -50}, {-6, -14}}, color = {0, 0, 127}));
  connect(batterySystem.pin_n, recirculationBlower.pin_n) annotation(
    Line(points = {{-4, 60}, {-4, 40}, {-10, 40}, {-10, 14}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, recirculationBlower.pin_p) annotation(
    Line(points = {{4, 60}, {4, 40}, {10, 40}, {10, 14}}, color = {0, 0, 255}));
  annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end RecirculationBlowerTest;
