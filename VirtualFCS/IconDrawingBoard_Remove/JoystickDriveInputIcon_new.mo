within VirtualFCS.IconDrawingBoard_Remove;

model JoystickDriveInputIcon_new
  
equation
  
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-6, Interval = 0.1),
    Icon(graphics = {Text(origin = {-5, 123}, textColor = {0, 0, 255}, extent = {{-121, 23}, {121, -23}}, textString = "%name"), Rectangle( lineColor = {95, 30, 27}, fillColor = {190, 60, 55}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Ellipse(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-49.5, 49.5}, {49.5, -49.5}}), Ellipse(fillColor = {190, 60, 55}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-39, 39}, {39, -39}}), Polygon(origin = {0, 29}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-5.1, 13}, {5.1, 13}, {9.9, -20}, {-9.9, -20}, {-5.1, 13}}), Polygon(origin = {25, -10}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-8, 12.85}, {15, -2}, {11, -11.8}, {-15, -3.9}, {-8, 12.85}}), Polygon(origin = {-26, -10}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-13, -1.4}, {8, 12.4}, {14, -4.4}, {-8, -11.1}, {-13, -1.4}}), Ellipse(fillColor = {190, 60, 55}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-19.5, 19.5}, {19.5, -19.5}}), Ellipse(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.4, 14.4}, {14.4, -14.4}}), Ellipse(fillColor = {190, 60, 55}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-6.5, 6.5}, {6.5, -6.5}})}, coordinateSystem(initialScale = 0.1)));
end JoystickDriveInputIcon_new;
