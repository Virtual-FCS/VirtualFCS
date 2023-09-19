within VirtualFCS.Control;

block PurgeValveControl
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Trapezoid setPurgeValveState(amplitude = 0.0007, falling = 0.05, period = 40, rising = 0.05, width = 0.350) annotation(
    Placement(visible = true, transformation(origin = {-19, 59}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = 1) annotation(
    Placement(visible = true, transformation(origin = {-18, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant closePurgeValve(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-18, -60}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput fuelCellCurrent annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput purgeValveControl annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Abs abs1 annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(setPurgeValveState.y, switch.u1) annotation(
    Line(points = {{-6, 59}, {24, 59}, {24, 8}, {42, 8}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, switch.u2) annotation(
    Line(points = {{-4, 0}, {42, 0}, {42, 0}, {42, 0}}, color = {255, 0, 255}));
  connect(closePurgeValve.y, switch.u3) annotation(
    Line(points = {{-4, -60}, {24, -60}, {24, -8}, {42, -8}, {42, -8}}, color = {0, 0, 127}));
  connect(switch.y, purgeValveControl) annotation(
    Line(points = {{66, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(fuelCellCurrent, abs1.u) annotation(
    Line(points = {{-100, 0}, {-72, 0}, {-72, 0}, {-70, 0}}, color = {0, 0, 127}));
  connect(abs1.y, greaterThreshold.u) annotation(
    Line(points = {{-46, 0}, {-32, 0}, {-32, 0}, {-32, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-3, 126}, textColor = {0, 0, 255}, extent = {{-55, 18}, {55, -18}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><div>
<p><span style=\"font-family: Arial; white-space: normal;\">Control the state of the</span><span style=\"font-size: 12px;\">&nbsp;</span><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><span style=\"font-family: Arial; white-space: normal;\">&nbsp;in a hydrogen fuel cell system</span></p></div><div><b><font face=\"Arial\">Description</font></b></div><div><br></div><font face=\"Arial\">Fuel cell systems often contain a&nbsp;</font><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><font face=\"Arial\">&nbsp;in the <a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen\">Hydrogen SubSystem</a> that is designed to purge impurities from the hydrogen line. There are different strategies for controlling this behaviour. Some systems open the&nbsp;</font><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><font face=\"Arial\">&nbsp;at regular intervals during&nbsp;</font><span style=\"font-family: Arial;\">&nbsp;</span><a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\" style=\"font-family: Arial;\">Fuel Cell Stack</a><font face=\"Arial\">&nbsp;operation. Others employ a charge counting algorithm to open the valve for every X Ah that passes through the</font><span style=\"font-family: Arial;\">&nbsp;</span><a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\" style=\"font-family: Arial;\">Fuel Cell Stack</a><font face=\"Arial\">.&nbsp;</font><div><font face=\"Arial\"><br></font></div><div><font face=\"Arial\">In this implementation, the block first determines if the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a> is on (i.e. abs(i_FC &gt; 1)). If it is not on, then the&nbsp;</font><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><font face=\"Arial\">&nbsp;is closed. If it is on, then the&nbsp;</font><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a><font face=\"Arial\">&nbsp;is opened at regular intervals defined by the setPurgeValveState block. The control signal is then sent to the valve.&nbsp;</font><div><font face=\"Arial\"><br></font></div><div><b><font face=\"Arial\"><br></font></b></div><div><b><font face=\"Arial\">Further update</font></b></div><div><b><font face=\"Arial\"><br></font></b></div><div><font face=\"Arial\">Future development of this block will include alternative algorithms for determining the purging behaviour.&nbsp;</font></div></div></body></html>"));
end PurgeValveControl;
