within VirtualFCS.Control;

model PurgeValveControl
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Trapezoid setPurgeValveState(amplitude = 0.01, falling = 0.05, period = 40, rising = 0.05, width = 0.350) annotation(
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
    Icon(graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-3, 126}, lineColor = {0, 0, 255}, extent = {{-55, 18}, {55, -18}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>Write some text.</body></html>"));
end PurgeValveControl;
