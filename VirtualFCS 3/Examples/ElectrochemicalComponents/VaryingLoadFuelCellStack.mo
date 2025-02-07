within VirtualFCS.Examples.ElectrochemicalComponents;
model VaryingLoadFuelCellStack
  inner Modelica.Fluid.System system(p_ambient(displayUnit="Pa"))    annotation (
    Placement(visible = true, transformation(origin={-90,-90},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Hydrogen.FuelCellSystem
                                          fuelCellSystem annotation (
    Placement(visible = true, transformation(                  extent={{-22,-24},
            {22,20}},                                                                           rotation = 0)));
  Modelica.Electrical.Analog.Sources.TrapezoidCurrent trapezoidCurrent(
    I=280,
    rising=2000,
    width=100,
    falling=500,
    period=2800,
    nperiod=-1,
    offset=0,
    startTime=1)
    annotation (Placement(transformation(extent={{8,42},{-12,62}})));

equation

  connect(trapezoidCurrent.n, fuelCellSystem.pin_n) annotation (Line(points={{-12,52},
          {-14,52},{-14,24},{-11,24},{-11,17.8}},     color={0,0,255}));
  connect(trapezoidCurrent.p, fuelCellSystem.pin_p)
    annotation (Line(points={{8,52},{11,52},{11,17.8}},  color={0,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StartTime = 0, StopTime = 5600, Tolerance = 1e-06, Interval = 1));
end VaryingLoadFuelCellStack;
