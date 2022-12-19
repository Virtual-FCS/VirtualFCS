within VirtualFCS.ComponentTesting;

model RecirculationBlowerTest "Model to test the recirculation blower component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15));
  VirtualFCS.Fluid.RecirculationBlower recirculationBlower annotation(
    Placement(visible = true, transformation(origin = {2.66454e-15, -2.66454e-15}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, nPorts = 1, p = 200000)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1, p = 200000)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 10, f = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1.17)  annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(batterySystem.pin_n, recirculationBlower.pin_n) annotation(
    Line(points = {{-4, 60}, {-10, 60}, {-10, 16}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, recirculationBlower.pin_p) annotation(
    Line(points = {{4, 60}, {12, 60}, {12, 16}}, color = {0, 0, 255}));
  connect(boundary.ports[1], recirculationBlower.Input) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 170, 0}, thickness = 2));
  connect(recirculationBlower.Output, fixedBoundary.ports[1]) annotation(
    Line(points = {{20, 0}, {60, 0}}, color = {0, 170, 0}, thickness = 2));
  connect(realExpression.y, recirculationBlower.control) annotation(
    Line(points = {{40, -50}, {-6, -50}, {-6, -16}}, color = {0, 0, 127}));

annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end RecirculationBlowerTest;
