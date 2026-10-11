within VirtualFCS.Control;

model FuelCellSystemController
  Modelica.Blocks.Interfaces.RealOutput setCurrent annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput setPower annotation(
    Placement(transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput fcVoltage annotation(
    Placement(transformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Max max annotation(
    Placement(transformation(origin = {-42, -56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0.1)  annotation(
    Placement(transformation(origin = {-86, -84}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(setPower, division.u1) annotation(
    Line(points = {{-120, 50}, {-50, 50}, {-50, 6}, {-12, 6}}, color = {0, 0, 127}));
  connect(division.y, setCurrent) annotation(
    Line(points = {{12, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(fcVoltage, max.u1) annotation(
    Line(points = {{-120, -50}, {-54, -50}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{-31, -56}, {-28, -56}, {-28, -6}, {-12, -6}}, color = {0, 0, 127}));
  connect(const.y, max.u2) annotation(
    Line(points = {{-74, -84}, {-70, -84}, {-70, -62}, {-54, -62}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 120}, textColor = {0, 0, 255}, extent = {{-140, 20}, {140, -20}}, textString = "%name")}));
end FuelCellSystemController;
