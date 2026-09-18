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
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>currentThreshold</code></td><td>Modelica.Units.SI.Current</td><td>A</td><td>1</td><td>Minimal current to activate purge control</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>fuelCellCurrent</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><div>
<p><span style=\"&quot;font-family:\" arial;=\"\" white-space:=\"\" normal;&quot;=\"\">Control the state of the</span><span style=\"&quot;font-size:\" 12px;&quot;=\"\">&nbsp;</span><a href=\"&quot;modelica://Modelica.Fluid.Valves.ValveCompressible&quot;\">Purge Valve</a><span style=\"&quot;font-family:\" arial;=\"\" white-space:=\"\" normal;&quot;=\"\">&nbsp;in a hydrogen fuel cell system</span></p></div><div><b><font face=\"&quot;Arial&quot;\">Description</font></b></div><div><br></div><font face=\"&quot;Arial&quot;\">Fuel cell systems often contain a&nbsp;</font><a href=\"&quot;modelica://Modelica.Fluid.Valves.ValveCompressible&quot;\">Purge Valve</a><font face=\"&quot;Arial&quot;\">&nbsp;in the <a href=\"&quot;modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen&quot;\">Hydrogen SubSystem</a> that is designed to purge impurities from the hydrogen line. There are different strategies for controlling this behaviour. Some systems open the&nbsp;</font><a href=\"&quot;modelica://Modelica.Fluid.Valves.ValveCompressible&quot;\">Purge Valve</a><font face=\"&quot;Arial&quot;\">&nbsp;at regular intervals during&nbsp;</font><span style=\"&quot;font-family:\" arial;&quot;=\"\">&nbsp;</span><a href=\"&quot;modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCell&quot;\" style=\"&quot;font-family:\" arial;&quot;=\"\">Fuel Cell Stack</a><font face=\"&quot;Arial&quot;\">&nbsp;operation. Others employ a charge counting algorithm to open the valve for every X Ah that passes through the</font><span style=\"&quot;font-family:\" arial;&quot;=\"\">&nbsp;</span><a href=\"&quot;modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCell&quot;\" style=\"&quot;font-family:\" arial;&quot;=\"\">Fuel Cell Stack</a><font face=\"&quot;Arial&quot;\">.&nbsp;</font><div><font face=\"&quot;Arial&quot;\"><br></font></div><div><font face=\"&quot;Arial&quot;\">In this implementation, the block first determines if the <a href=\"&quot;modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCell&quot;\">Fuel Cell Stack</a> is on (i.e. abs(i_FC &gt; 1)). If it is not on, then the&nbsp;</font><a href=\"&quot;modelica://Modelica.Fluid.Valves.ValveCompressible&quot;\">Purge Valve</a><font face=\"&quot;Arial&quot;\">&nbsp;is closed. If it is on, then the&nbsp;</font><a href=\"&quot;modelica://Modelica.Fluid.Valves.ValveCompressible&quot;\">Purge Valve</a><font face=\"&quot;Arial&quot;\">&nbsp;is opened at regular intervals defined by the setPurgeValveState block. The control signal is then sent to the valve.&nbsp;</font><div><font face=\"&quot;Arial&quot;\"><br></font></div><div><b><font face=\"&quot;Arial&quot;\"><br></font></b></div><div><b><font face=\"&quot;Arial&quot;\">Further update</font></b></div><div><b><font face=\"&quot;Arial&quot;\"><br></font></b></div><div><font face=\"&quot;Arial&quot;\">Future development of this block will include alternative algorithms for determining the purging behaviour.&nbsp;</font></div></div><h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended model or enforced by instantiated components and their connected physical networks.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>purgeValveControl</code></td><td>Output</td><td>RealOutput</td><td>-</td><td></td></tr></tbody></table></body></html>"),
  Diagram(graphics));
end PurgeValveControl;
