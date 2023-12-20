within VirtualFCS.Examples.ElectrochemicalComponents;

model PolarizeFuelCellStack "Generate a polarization curve for a fuel cell stack."
  extends Modelica.Icons.Example;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system(p_ambient(displayUnit = "Pa"))  annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.RampCurrent rampCurrent(I = 300, duration = 500, offset = 1, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrochemical.Hydrogen.FuelCellSystem fuelCellSystem annotation(
    Placement(visible = true, transformation(origin = {0, -2}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
equation
  connect(rampCurrent.p, fuelCellSystem.pin_p) annotation(
    Line(points = {{10, 60}, {12, 60}, {12, 18}, {12, 18}}, color = {0, 0, 255}));
  connect(rampCurrent.n, fuelCellSystem.pin_n) annotation(
    Line(points = {{-10, 60}, {-12, 60}, {-12, 18}, {-10, 18}}, color = {0, 0, 255}));
  annotation(
    Diagram,
    Icon,
    Documentation(info = "<html><head></head><body>This example demonstrates the setup for a fuel cell system to generate a polarization curve. The fuel cell stack is connected to subsystems for hydrogen, air, and cooling. The electrical load is provided by a ramp voltage source that sweeps the current domain over a period of 500 seconds.&nbsp;</body></html>"),
    experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-06, Interval = 1));
end PolarizeFuelCellStack;
