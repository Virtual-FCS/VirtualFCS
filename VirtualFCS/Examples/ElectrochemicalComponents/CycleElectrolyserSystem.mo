within VirtualFCS.Examples.ElectrochemicalComponents;

model CycleElectrolyserSystem
 extends Modelica.Icons.Example;
  VirtualFCS.Electrochemical.Hydrogen.Electrolysers.ElectrolyserSystem electrolyserSystem
    annotation (Placement(transformation(extent={{-22,-22},{22,22}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Electrical.Analog.Sources.TrapezoidCurrent trapezoidCurrent(
    I= 600,
    rising=100,
    width=400,
    falling=100,
    period=800,
    nperiod=-1,
    startTime=50)
    annotation (Placement(transformation(extent = {{10, 50}, {-10, 70}})));
equation
 connect(trapezoidCurrent.n, electrolyserSystem.pin_n) annotation(
    Line(points = {{-10, 60}, {-14, 60}, {-14, 26}, {-11, 26}, {-11, 19.8}}, color = {0, 0, 255}));
 connect(trapezoidCurrent.p, electrolyserSystem.pin_p) annotation(
    Line(points = {{10, 60}, {14, 60}, {14, 28}, {11, 28}, {11, 19.8}}, color = {0, 0, 255}));
  annotation (experiment(
      StopTime=650,
      Interval=0.5,
      __Dymola_Algorithm="Dassl"));


annotation(Documentation(info = "<html><p>This example drives the electrolyser with a trapezoidal current demand. The current starts at 0 A, rises to 600 A from 50 s over 100 s, remains at that level for the 400 s pulse width, and then falls according to the 800 s period.</p><p>Fluid operating boundaries are inherited from the connected system components.</p></html>"));
end CycleElectrolyserSystem;
