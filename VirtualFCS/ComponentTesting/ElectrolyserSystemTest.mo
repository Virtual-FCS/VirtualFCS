within VirtualFCS.ComponentTesting;

model ElectrolyserSystemTest

  extends Modelica.Icons.Example;
  VirtualFCS.Electrochemical.Hydrogen.Electrolysers.ElectrolyserSystem electrolyserSystem
    annotation (Placement(transformation(extent={{-22,-22},{22,22}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Electrical.Analog.Sources.StepCurrent stepCurrent(I = 600, offset = 100, startTime = 10)  annotation(
    Placement(transformation(origin = {0, 70}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(stepCurrent.n, electrolyserSystem.pin_n) annotation(
    Line(points = {{-10, 70}, {-10, 20}}, color = {0, 0, 255}));
  connect(stepCurrent.p, electrolyserSystem.pin_p) annotation(
    Line(points = {{10, 70}, {10, 45}, {12, 45}, {12, 20}}, color = {0, 0, 255}));
  annotation (experiment(
      StopTime=20,
      Interval=0.5,
      __Dymola_Algorithm="Dassl"));



end ElectrolyserSystemTest;
