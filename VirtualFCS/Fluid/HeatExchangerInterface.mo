within VirtualFCS.Fluid;

partial model HeatExchangerInterface
  // TODO define media & set them for port pairs
  Modelica.Fluid.Interfaces.FluidPort_a port_a2 annotation(
    Placement(transformation(origin = {100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2 annotation(
    Placement(transformation(origin = {-100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1 annotation(
    Placement(transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1 annotation(
    Placement(transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
  annotation(
    Icon(graphics = {Ellipse(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-100, 100}, {100, -100}}), Line(origin = {6, 0}, points = {{-106, 0}, {-66, 0}, {-36, 60}, {24, -60}, {54, 0}, {94, 0}}, thickness = 1)}));
end HeatExchangerInterface;
