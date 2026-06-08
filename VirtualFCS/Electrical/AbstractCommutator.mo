within VirtualFCS.Electrical;

partial model AbstractCommutator
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort annotation(
    IconMap(extent = {{-73.75, -47.5}, {126.25, 152.5}}),
    DiagramMap(extent = {{-47.5, -47.5}, {152.5, 152.5}}));
  Modelica.Electrical.Analog.Interfaces.PositivePin p1 annotation(
    Placement(transformation(origin = {-100, 100}, extent = {{10, 10}, {-10, -10}}), iconTransformation(origin = {-100, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin p2 annotation(
    Placement(transformation(origin = {100, 100}, extent = {{-10, 10}, {10, -10}}, rotation = -0), iconTransformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n annotation(
    Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
equation
  annotation(
    Icon(graphics = {Line(origin = {0, -100}, rotation = -90, points = {{-98, -34}, {-80, -20}, {-60, -20}, {-60, 0}, {0, 0}}, color = {0, 0, 255}, thickness = 1), Line(origin = {0, 100}, points = {{-100, 0}, {0, 0}, {0, -80}, {-20, -80}, {-20, -100}}, color = {0, 0, 255}, thickness = 1), Line(origin = {22, 80}, points = {{-22, 20}, {78, 20}}, color = {0, 0, 255}, thickness = 1), Line(origin = {20, -10}, points = {{-10, 7.5}, {10, 7.5}}, color = {0, 0, 255}, thickness = 1), Polygon(origin = {20, -10}, lineColor = {0, 0, 255}, lineThickness = 1, points = {{-10, -7}, {10, -7}, {0, 7}, {-10, -7}}), Line(origin = {20, -40}, points = {{-20, 0}, {0, 0}, {0, 23}}, color = {0, 0, 255}, thickness = 1), Line(origin = {20, 20}, points = {{-20, 0}, {0, 0}, {0, -23}}, color = {0, 0, 255}, thickness = 1), Text(textColor = {0, 0, 255}, extent = {{-150, 180}, {150, 130}}, textString = "%name")}),
    Diagram(graphics),
  Documentation(info = "<html><head></head><body>A unit representing a generic implementation of a 3-point commuter for boost converters.<div>The class does not specify anything other than its interface.</div></body></html>"));
end AbstractCommutator;
