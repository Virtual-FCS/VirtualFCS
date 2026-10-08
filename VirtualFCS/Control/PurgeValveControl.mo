within VirtualFCS.Control;

block PurgeValveControl

  parameter Modelica.Units.SI.Current currentThreshold = 1 "Minimal current to activate purge control";

  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // FIXME this 0.0007 is a magic number - why not 1, with a shorter period?
  // FIXME Also, why trapezoidal instead of a simple step?
  // FIXME Also, why exactly this timing?
  Modelica.Blocks.Sources.Trapezoid setPurgeValveState(amplitude = 0.0007, falling = 0.05, period = 40, rising = 0.05, width = 0.350) annotation(
    Placement(transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterThreshold threshold(threshold = currentThreshold) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant closePurgeValve(k = 0) annotation(
    Placement(transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput fuelCellCurrent annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput purgeValveControl annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(setPurgeValveState.y, switch.u1) annotation(
    Line(points = {{11, 50}, {24, 50}, {24, 8}, {42, 8}}, color = {0, 0, 127}));
  connect(threshold.y, switch.u2) annotation(
    Line(points = {{11, 0}, {42, 0}}, color = {255, 0, 255}));
  connect(closePurgeValve.y, switch.u3) annotation(
    Line(points = {{11, -50}, {24, -50}, {24, -8}, {42, -8}}, color = {0, 0, 127}));
  connect(switch.y, purgeValveControl) annotation(
    Line(points = {{65, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(fuelCellCurrent, threshold.u) annotation(
    Line(points = {{-120, 0}, {-12, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-3, 126}, textColor = {0, 0, 255}, extent = {{-55, 18}, {55, -18}}, textString = "%name"), Line(origin = {0, -10}, points = {{0, -50}, {0, 50}}, color = {0, 0, 255}, thickness = 1), Line(origin = {0, 39.65}, points = {{-40, -20}, {0, 20}, {40, -20}, {40, -20}}, color = {0, 0, 255}, thickness = 1)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<div>
<p><span style=\"font-family:\" arial;=\"\" white-space:=\"\" normal;&quot;=\"\">Control the state of the</span><span style=\"font-size:\" 12px;&quot;=\"\">&nbsp;</span><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><span style=\"font-family:\" arial;=\"\" white-space:=\"\" normal;&quot;=\"\">&nbsp;in a hydrogen fuel cell system</span></p></div><div><b><font face=\"Arial\">Description</font></b></div><div><br></div><font face=\"Arial\">Fuel cell systems often contain a&nbsp;</font><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><font face=\"Arial\">&nbsp;in the <a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen\">Hydrogen SubSystem</a> that is designed to purge impurities from the hydrogen line. There are different strategies for controlling this behaviour. Some systems open the&nbsp;</font><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><font face=\"Arial\">&nbsp;at regular intervals during&nbsp;</font><span style=\"font-family:\" arial;&quot;=\"\">&nbsp;</span><a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCell\" style=\"font-family:\" arial;&quot;=\"\">Fuel Cell Stack</a><font face=\"Arial\">&nbsp;operation. Others employ a charge counting algorithm to open the valve for every X Ah that passes through the</font><span style=\"font-family:\" arial;&quot;=\"\">&nbsp;</span><a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCell\" style=\"font-family:\" arial;&quot;=\"\">Fuel Cell Stack</a><font face=\"Arial\">.&nbsp;</font><div><font face=\"Arial\"><br></font></div><div><font face=\"Arial\">In this implementation, the block first determines if the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCell\">Fuel Cell Stack</a> is on (i.e. abs(i_FC &gt; 1)). If it is not on, then the&nbsp;</font><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><font face=\"Arial\">&nbsp;is closed. If it is on, then the&nbsp;</font><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><font face=\"Arial\">&nbsp;is opened at regular intervals defined by the setPurgeValveState block. The control signal is then sent to the valve.&nbsp;</font><div><font face=\"Arial\"><br></font></div><div><b><font face=\"Arial\"><br></font></b></div><div><b><font face=\"Arial\">Further update</font></b></div><div><b><font face=\"Arial\"><br></font></b></div><div><font face=\"Arial\">Future development of this block will include alternative algorithms for determining the purging behaviour.&nbsp;</font></div></div>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>currentThreshold</code></td><td>Modelica.Units.SI.Current</td><td>A</td><td><code>1</code></td><td>Minimal current to activate purge control</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>fuelCellCurrent</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td></td></tr>
<tr><td><code>purgeValveControl</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>-</td><td></td></tr>
</tbody></table>

</body></html>"),
  Diagram(graphics));
end PurgeValveControl;
