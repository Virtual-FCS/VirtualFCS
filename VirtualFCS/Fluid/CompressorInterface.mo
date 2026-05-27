within VirtualFCS.Fluid;

partial model CompressorInterface
  extends Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPort;
  
  import Modelica.Media.Interfaces.PartialMedium;
  
  replaceable package Medium = PartialMedium "Medium in the component" constrainedby PartialMedium annotation (choicesAllMatching = true);
  Modelica.Fluid.Interfaces.FluidPort_a inlet(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {-100, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b outlet(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));

annotation(
    Icon(graphics = {Polygon(fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-100, -100}, {100, -40}, {100, 40}, {-100, 100}, {-100, -100}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier)}),
    Documentation(info = "<html><head></head><body>This partial class defines the interfaces of a mechanically-driven compressor.<div><br><div>Fluid ports use the same Medium; normally there should not be reverse flow, but it may be modelled in a child class if you are so inclined.<br>Mechanical work is delivered to the compressor via a shaft connected with the <tt>flange</tt>.<br><br></div><div>Heat can be set in different ways depending on the value of <tt>heatport</tt>: the exact mechanisms are set in child classes.</div></div></body></html>"));
end CompressorInterface;
