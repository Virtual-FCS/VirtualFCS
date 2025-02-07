within VirtualFCS.ComponentTesting;
model RotaryMachine
  Buildings.Fluid.Movers.SpeedControlled_y mov
    annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(nPorts=1)
    annotation (Placement(transformation(extent={{-78,-8},{-58,12}})));
  Modelica.Fluid.Sources.FixedBoundary boundary1(nPorts=1)
    annotation (Placement(transformation(extent={{64,-8},{44,12}})));
  Modelica.Blocks.Sources.Sine sine(amplitude=750, offset=750)
    annotation (Placement(transformation(extent={{-48,46},{-28,66}})));
equation
  connect(boundary.ports[1], mov.port_a)
    annotation (Line(points={{-58,2},{-12,2}}, color={0,127,255}));
  connect(mov.port_b, boundary1.ports[1])
    annotation (Line(points={{8,2},{44,2}}, color={0,127,255}));
  connect(sine.y, mov.y)
    annotation (Line(points={{-27,56},{-2,56},{-2,14}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RotaryMachine;
