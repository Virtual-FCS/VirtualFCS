within VirtualFCS.ComponentTesting;
model SubSystemHydrogenControlTest "Simple model to test the SubSystemHydrogenControl model"
  extends Modelica.Icons.Example;
  SubSystems.Hydrogen.SubSystemHydrogenControl subSystemHydrogenControl annotation (
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 100, f = 0.1, offset = 300)  annotation (
    Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Cosine cosine(amplitude = 15, f = 0.2, offset = 45)  annotation (
    Placement(visible = true, transformation(origin = {-90, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation (
    Placement(visible = true, transformation(origin = {-50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Cosine cosine1(amplitude = 20, f = 0.3, offset = 50, startTime = 2)  annotation (
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(cosine.y, multiplex2.u1[1]) annotation (
    Line(points = {{-78, -10}, {-62, -10}, {-62, -24}}, color = {0, 0, 127}));
  connect(cosine1.y, multiplex2.u2[1]) annotation (
    Line(points = {{-78, -50}, {-62, -50}, {-62, -36}}, color = {0, 0, 127}));
  connect(multiplex2.y[1], subSystemHydrogenControl.pumpSpeed_measured) annotation(
    Line(points = {{-38, -30}, {-32, -30}, {-32, -14}, {-22, -14}}, color = {0, 0, 127}));
  connect(sine.y, subSystemHydrogenControl.stackCurrent) annotation(
    Line(points = {{-58, 30}, {-38, 30}, {-38, 12}, {-22, 12}}, color = {0, 0, 127}));

annotation (experiment(StopTime = 100, Interval = 0.5, Tolerance = 1e-6));
annotation(Documentation(info = "<html><p>This test exercises hydrogen subsystem control with a fuel-cell signal varying sinusoidally at 0.1 Hz (amplitude 100, offset 300). Hydrogen control inputs use cosine signals at 0.2 Hz (amplitude 15, offset 45) and 0.3 Hz (amplitude 20, offset 50), enabled from 2 s.</p></html>"));
end SubSystemHydrogenControlTest;
