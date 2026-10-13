within VirtualFCS.Fluid;

partial model ElectricCompressorInterface
  extends Modelica.Thermal.HeatTransfer.Interfaces.PartialElementaryConditionalHeatPort(useHeatPort = true) annotation(
    IconMap(extent = {{-26, -79}, {174, 121}}));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choicesAllMatching = true);
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare final package Medium = Medium) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-20, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare final package Medium = Medium) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {60, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-60, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-90, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput set_mass_flow annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}})));
  annotation(
    Diagram(graphics),
    Icon(graphics = {Polygon(origin = {0, -20}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-20, -60}, {100, -20}, {100, 20}, {-20, 60}, {-20, -60}}), Line(origin = {0, -20}, points = {{0, 0}, {80, 0}}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 10, smooth = Smooth.Bezier), Rectangle(origin = {-70, -20}, fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-30, 30}, {30, -30}}), Polygon(origin = {-40, 30}, fillPattern = FillPattern.Solid, points = {{-50, -90}, {-40, -90}, {-36, -74}, {-24, -74}, {-20, -90}, {-10, -90}, {-10, -100}, {-50, -100}, {-50, -90}}), Line(origin = {-30, -20}, points = {{-10, 0}, {10, 0}}, thickness = 2), Rectangle(origin = {-70, 50}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-30, 30}, {30, -30}}), Line(origin = {-70, 50}, points = {{-30, -29}, {30, 29}, {30, 29}}, thickness = 1), Text(origin = {-84, 64}, extent = {{-10, 10}, {10, -10}}, textString = "DC"), Text(origin = {-58, 36}, extent = {{-10, 10}, {10, -10}}, textString = "DC"), Line(origin = {-50, 85}, points = {{0, 5}, {0, -5}}, color = {255, 0, 0}, thickness = 2), Line(origin = {-50, 15}, points = {{0, 5}, {0, -5}}, color = {255, 0, 0}, thickness = 2), Line(origin = {-90, 85}, points = {{0, 5}, {0, -5}}, thickness = 2), Line(origin = {-90, 15}, points = {{0, 5}, {0, -5}}, thickness = 2), Text(origin = {0, -100}, textColor = {0, 0, 255}, extent = {{-40, -10}, {40, 20}}, textString = "%name")}),
  Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
This is an interface for classes combining a mechanical compressor acting on a fluid flow, a DC motor, and a DC/DC converter drawing power from an external source.<div>The unit takes as input a mass flow set point.</div><div>The heatPort can be left disconnected to achieve adiabatic conditions, or set to a specific temperature for isothermal operation.</div>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Optional port to which dissipated losses are transported in form of heat</td></tr>
<tr><td><code>port_a</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
<tr><td><code>port_b</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
<tr><td><code>set_mass_flow</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end ElectricCompressorInterface;
