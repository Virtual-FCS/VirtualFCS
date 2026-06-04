within VirtualFCS.Fluid;

partial model CompressorInterface
  extends Modelica.Fluid.Interfaces.PartialTwoPort(final allowFlowReversal=false, final showDesignFlowDirection=false) annotation(
    IconMap(extent = {{-100, -79}, {100, 121}}),
    DiagramMap(extent = {{-100, -79}, {100, 121}}));
  extends Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPort;
  extends Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;

annotation(
    Icon(graphics = {Polygon(fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-100, -100}, {100, -40}, {100, 40}, {-100, 100}, {-100, -100}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier)}),
    Documentation(info = "<html><head></head><body>This partial class defines the interfaces of a mechanically-driven compressor.<div><br><div>Fluid ports use the same Medium; normally there should not be reverse flow, but it may be modelled in a child class if you are so inclined.<br>Mechanical work is delivered to the compressor via a shaft connected with the <tt>flange</tt>.<br><br></div><div>Heat can be set in different ways depending on the value of <tt>heatport</tt>: the exact mechanisms are set in child classes.</div></div></body></html>"));
end CompressorInterface;
