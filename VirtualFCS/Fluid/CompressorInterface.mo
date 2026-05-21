within VirtualFCS.Fluid;

partial model CompressorInterface
  extends Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPort;
  
  import Modelica.Media.Interfaces.PartialMedium;
  
  replaceable package Medium = PartialMedium "Medium in the component" constrainedby PartialMedium annotation (choicesAllMatching = true);
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {-100, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));

annotation(
    Icon(graphics = {Polygon(fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-100, -80}, {100, -40}, {100, 40}, {-100, 80}, {-100, -80}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier)}),
    Documentation(info = "<html><head></head><body>This partial class defines the interfaces of a compressor unit, for flow, power supply (assumed DC), heat exchange (in case of fully isentropic operation,&nbsp;</body></html>"));
end CompressorInterface;
