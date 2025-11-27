within VirtualFCS.Fluid;

partial model PumpInterface
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation (choicesAllMatching = true);
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {-30, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {30, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, -100}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Blocks.Interfaces.RealInput u "Control input, can be replaced by whatever the manipulated variable is" annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}})));

annotation(
    Icon(graphics = {Polygon(origin = {0, -70}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-80, -30}, {80, -30}, {40, 30},{-40, 30}, {-80, -30}}), Ellipse(fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-80, 80}, {80, -80}}), Line(origin = {-50, 0}, points = {{-50, 0}, {50, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 10), Line(origin = {48, 80}, points = {{-50, 0}, {40, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 10)}),
    Documentation(info = "<html><head></head><body>This partial class defines the interfaces of a compressor unit, for flow, power supply (assumed DC), heat exchange (in case of fully isentropic operation,&nbsp;</body></html>"));
end PumpInterface;
