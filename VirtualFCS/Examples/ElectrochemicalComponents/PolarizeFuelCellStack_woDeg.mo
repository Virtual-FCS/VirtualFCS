within VirtualFCS.Examples.ElectrochemicalComponents;
model PolarizeFuelCellStack_woDeg "Generate a polarization curve for a fuel cell stack."
  extends Modelica.Icons.Example;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Coolant_Medium =
      Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system(p_ambient(displayUnit = "Pa"))  annotation (
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.RampCurrent rampCurrent(I = 300, duration = 500,
    offset=1,                                                                                     startTime = 1) annotation (
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrochemical.Hydrogen.FuelCellSystem_woDeg fuelCellSystem_woDeg
    annotation (Placement(transformation(extent={{-20,-18},{24,26}})));
equation
  connect(rampCurrent.n, fuelCellSystem_woDeg.pin_n) annotation (Line(points={{
          -10,60},{-14,60},{-14,30},{-9,30},{-9,23.8}}, color={0,0,255}));
  connect(rampCurrent.p, fuelCellSystem_woDeg.pin_p)
    annotation (Line(points={{10,60},{13,60},{13,23.8}}, color={0,0,255}));
  annotation (
    Icon,
    Documentation(info = "<html><head></head><body>This example demonstrates the setup for a fuel cell system to generate a polarization curve. The fuel cell stack is connected to subsystems for hydrogen, air, and cooling. The electrical load is provided by a ramp voltage source that sweeps the current domain over a period of 500 seconds.&nbsp;</body></html>"),
    experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-06, Interval = 1));
end PolarizeFuelCellStack_woDeg;
