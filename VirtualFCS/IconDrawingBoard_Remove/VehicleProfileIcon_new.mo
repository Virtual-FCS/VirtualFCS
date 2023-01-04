within VirtualFCS.IconDrawingBoard_Remove;

model VehicleProfileIcon_new "Calculates the driving power for a vehicle that corresponds to a given speed profile."
equation

  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.05), graphics = {Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle( lineColor = {60, 0, 40}, fillColor = {120, 0, 80}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(origin = {0, 6}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, lineThickness = 1.5, points = {{-66.6, -14}, {-66.6, -10}, {-66.6, -4}, {-66.6, 0}, {-66.6, 2}, {-66, 3.4}, {-64, 5.9}, {-60, 10}, {-56, 14}, {-52, 18}, {-48, 22}, {-46, 24}, {-44, 25.6}, {-42, 26.4}, {-40, 27}, {-38, 27.2}, {-34, 27.2}, {-28, 27.2}, {-18, 27.2}, {-8, 27.2}, {2, 27.2}, {6, 27.2}, {8, 27.2}, {10, 27}, {12, 26.2}, {14, 25.1}, {15, 24.1}, {16, 23.2}, {18, 21.3}, {22, 17.5}, {26, 13.5}, {30, 9.5}, {32, 7.4}, {34, 5.5}, {35, 4.4}, {36, 3.8}, {37, 3.4}, {38, 3.2}, {42, 3.2}, {48, 3.2}, {50, 3.2}, {52, 3.2}, {54, 3}, {56, 2.4}, {58, 1.6}, {60, 0.3}, {62, -1.5}, {63, -2.5}, {64, -4}, {65.2, -6}, {65.9, -8}, {66.5, -12}, {66.5, -18}, {66.5, -22}, {65.8, -24}, {64, -26}, {62, -27}, {58, -27.1}, {42, -27.1}, {20, -27.1}, {4, -27.1}, {-16, -27.1}, {-38, -27.1}, {-50, -27.1}, {-54, -27.1}, {-56, -27.1}, {-58, -26.6}, {-60, -25.9}, {-61, -25.3}, {-62, -24.6}, {-63, -23.7}, {-64, -22.6}, {-65, -21.2}, {-66, -19}, {-66.3, -18}, {-66.6, -16}, {-66.6, -15}, {-66.6, -14}}, smooth = Smooth.Bezier), Ellipse(origin = {-36.4, -21}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-16.5, 16.5}, {16.5, -16.5}}), Ellipse(origin = {-36.4, -21}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12, 12}, {12, -12}}), Rectangle(origin = {-29, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{9.2, -9.9}, {-9.2, 8.1}}), Polygon(origin = {-51, 17}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-7, -7.9}, {9, 8}, {9, -7.9}, {-7, -7.9}}), Polygon(origin = {-40, 23}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-2.5, 1.5}, {-2, 2}, {-1, 2.8}, {0, 3.6}, {1, 4.1}, {3, 4.1}, {3, -3}, {-4, -3}, {-4, -1}, {-2.5, 1.5}}, smooth = Smooth.Bezier), Rectangle(origin = {-40, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, -9.9}, {4, 4}}), Rectangle(origin = {-4.7, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{12, -9.9}, {-9.2, 8.1}}), Ellipse(origin = {36.2, -21}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-16.5, 16.5}, {16.5, -16.5}}), Ellipse(origin = {36.2, -21}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12, 12}, {12, -12}}), Polygon(origin = {5, 17}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{22.5, -7.9}, {6.5, 8}, {6.5, -7.9}, {22.5, -7.9}}), Rectangle(origin = {8, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, -9.9}, {4, 4}}), Polygon(origin = {7, 22}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-3, 5}, {0, 5.1}, {1, 5}, {2, 4.8}, {3, 4.4}, {4, 3.6}, {5, 2.6}, {5, -6}, {-5, -6}, {-3, 5}}, smooth = Smooth.Bezier) }),
    Documentation(info = "<html><head></head><body><div>The VehicleProfile block is designed to replicate the power demand of a vehicle considering a pre-determined drive cycle and vehicle parameters such as weight and frontal area. The generated power profile considers the needs to propel the vehicle plus the aerodynamic drag. The block allows the user to select if regenerative breaking is used or not.</div><div><br></div><div><div>The block enables the user to select from standard testing drive cycles including WLTC Class 1-3 and NEDC. The drive cycles are provided as .mat files in the library directory containing the block.</div></div></body></html>"));
end VehicleProfileIcon_new;
