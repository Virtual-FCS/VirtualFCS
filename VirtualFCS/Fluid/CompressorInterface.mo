within VirtualFCS.Fluid;

partial model CompressorInterface
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation (choicesAllMatching = true);
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {-30, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {30, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Blocks.Interfaces.RealInput u "Control input, can be replaced by whatever the manipulated variable is" annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}})));

annotation(
    Icon(graphics = {Polygon(fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-100, -80}, {100, -40}, {100, 40}, {-100, 80}, {-100, -80}})}),
    Documentation(info = "<html><head></head><body>This partial class defines the interfaces of a compressor unit, for flow, power supply (assumed DC), heat exchange (in case of fully isentropic operation,&nbsp;</body></html>"));
end CompressorInterface;
