within VirtualFCS.Examples.ElectrochemicalComponents;
model PolarizeFuelCellStack_woDeg
  "Generate a polarization curve for a fuel cell stack."
  extends Modelica.Icons.Example;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Coolant_Medium =
      Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system(p_ambient(displayUnit = "Pa"))  annotation (
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrochemical.Hydrogen.FuelCellSystem_woDeg fuelCellSystem_woDeg
    annotation (Placement(transformation(extent={{-22,-18},{22,26}})));
  Modelica.Electrical.Analog.Sources.TrapezoidCurrent trapezoidCurrent(
    I=300,
    rising=50,
    width=1500,
    falling=50,
    period=2000,
    nperiod=-1,
    offset=0,
    startTime=50) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={2,70})));
equation
  connect(fuelCellSystem_woDeg.pin_n, trapezoidCurrent.n) annotation (Line(
        points={{-11,23.8},{-10,23.8},{-10,56},{-12,56},{-12,70},{-8,70}},color
        ={0,0,255}));
  connect(fuelCellSystem_woDeg.pin_p, trapezoidCurrent.p) annotation (Line(
        points={{11,23.8},{11,56},{16,56},{16,70},{12,70}}, color={0,0,255}));
  annotation (
    Icon,
    Documentation(info = "<html><head></head><body>This example demonstrates the setup for a fuel cell system to generate a polarization curve. The fuel cell stack is connected to subsystems for hydrogen, air, and cooling. The electrical load is provided by a ramp voltage source that sweeps the current domain over a period of 500 seconds.&nbsp;</body></html>"),
    experiment(
      StopTime=2000,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end PolarizeFuelCellStack_woDeg;
