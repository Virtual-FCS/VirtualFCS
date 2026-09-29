within VirtualFCS.Powertrains;

model PowertrainInterface
  // System
  outer Modelica.Fluid.System system "System properties";
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {42, 96}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(pin_n, ground.p) annotation(
    Line(points = {{-40, 96}, {-40, 98}, {-70, 98}, {-70, 80}}, color = {0, 0, 255}, thickness = 0.75));
annotation(
    Icon(graphics = {Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-16.7, 56.9}, {19.3, 56.9}, {5, 11.8}, {28.4, 11.8}, {-18.7, -56.5}, {-20, -56}, {-5.3, -6}, {-28.5, -6}, {-16.7, 56.9}})}));
end PowertrainInterface;
