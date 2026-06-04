within VirtualFCS.Fluid;

partial model CompressorInterface
  extends Modelica.Fluid.Interfaces.PartialTwoPort(final allowFlowReversal=false, final showDesignFlowDirection=false) annotation(
    IconMap(extent = {{-100, -79}, {100, 121}}),
    DiagramMap(extent = {{-100, -79}, {100, 121}}));
  extends Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPort;
  extends Modelica.Mechanics.Rotational.Interfaces.PartialTwoFlanges;
equation
  connect(flange_a, flange_b) annotation(
    Line(points = {{-100, 0}, {100, 0}}));
  annotation(
    Icon(graphics = {Polygon(fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-100, -100}, {100, -40}, {100, 40}, {-100, 100}, {-100, -100}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier)}),
    Documentation(info = "<html><head></head><body>This partial class defines the interfaces of a mechanically-driven compressor, combining several standard Modelica classes.<div><br><div>Mechanical work is delivered to the compressor via a shaft, which connects&nbsp;<tt>flange_a</tt> and <tt>flange_b</tt> internally; this allows connecting a motor on one flange and a turbine on the other.<br><br></div><div>Heat can be set in different ways depending on the value of <tt>heatport</tt>: the exact mechanisms are set in child classes.</div></div></body></html>"));
end CompressorInterface;
