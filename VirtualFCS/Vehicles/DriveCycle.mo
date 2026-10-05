within VirtualFCS.Vehicles;
model DriveCycle
  extends Modelica.Blocks.Interfaces.SO(y(quantity="Velocity", unit="km/h"));
  import Modelica.Blocks.Sources.CombiTimeTable;
  import Modelica.Utilities.Files.loadResource;

  parameter String cycle = "WLTC3a" "Speed profile" annotation(choices(choice="WLTC1" "Worldwide harmonized Light vehicles Test Cycle - Class 1",
                                                                       choice="WLTC2" "Worldwide harmonized Light vehicles Test Cycle - Class 2",
                                                                       choice="WLTC3a" "Worldwide harmonized Light vehicles Test Cycle - Class 3a",
                                                                       choice="WLTC3b" "Worldwide harmonized Light vehicles Test Cycle - Class 3b",
                                                                       choice="NEDC" "New European Driving Cycle - OBSOLETE!",
                                                                       choice="Custom" "Provide your own cycle and specify custom file and variable name"));
  parameter String custom_fileName = "" "File where custom matrix is stored" annotation (
    Dialog(loadSelector(filter = "Text files (*.txt);Comma-separated values (*.csv);MATLAB MAT-files (*.mat)", caption = "Open file in which the table is present")));
  parameter String custom_tableName = "" "Variable name in the file";
  
protected
  CombiTimeTable table(extrapolation = Modelica.Blocks.Types.Extrapolation.Periodic, 
                       fileName = if cycle == "Custom" then custom_fileName else loadResource("modelica://VirtualFCS.Resources.DataDriveCycles/"+cycle+".mat"), 
                       smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, 
                       tableName = if cycle == "Custom" then custom_tableName else cycle, 
                       tableOnFile = true, timeEvents = Modelica.Blocks.Types.TimeEvents.AtDiscontinuities) annotation (
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));

equation
  connect(table.y[1], y) annotation (
    Line(points={{12.2,0},{104,0},{104,0},{110,0}},        color = {0, 0, 127}));
  annotation (experiment(StopTime = 1800, Interval = 1), 
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.05), graphics={Rectangle( lineColor = {95, 30, 27},fillColor = {190, 60, 55}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(origin = {0, -51}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-74, 0.8}, {68.5, 0.8}, {68.5, 3}, {75.5, -0.5}, {68.5, -4}, {68.5, -1.5}, {-74, -1.5}, {-74, 0.8}, {-74, 0.8}}), Polygon(origin = {-74.3, 21.5}, rotation = 90, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-74, 0.8}, {33.8, 0.8}, {33.8, 3}, {40.8, -0.5}, {33.8, -4}, {33.8, -1.5}, {-74, -1.5}, {-74, 0.8}, {-74, 0.8}}), Polygon(origin = {-2, 4}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-61, -36.4}, {-60.8, -35.5}, {-60.7, -34}, {-60.5, -32}, {-57.6, -10}, {-55.1, 8}, {-53.1, 20}, {-52, 26}, {-51.3, 28}, {-51, 26}, {-50.2, 20}, {-49.4, 12}, {-48.4, 4}, {-47.5, -2}, {-46.2, -6}, {-44, -7.2}, {-41, -4}, {-39.6, 0}, {-37.8, 6}, {-37, 8.5}, {-36.2, 9}, {-35.5, 6}, {-35, 2}, {-34.3, -2}, {-33.5, -6}, {-32.1, -10}, {-30, -12.2}, {-28, -11.7}, {-26.7, -10}, {-24.4, -4}, {-21.8, 6}, {-18.6, 18}, {-16.1, 26}, {-15.4, 28}, {-15, 28.5}, {-14.4, 26}, {-13.6, 20}, {-12, 4}, {-10.3, -12}, {-8.3, -26}, {-4.2, -37}, {4, -40}, {10.2, -37.5}, {13.3, -26}, {15.3, -12}, {16.7, -6}, {17.5, -4.1}, {19.6, -6}, {22.8, -10}, {26, -14}, {30, -15.6}, {34.3, -12}, {36.7, -4}, {39.3, 10}, {41.3, 22}, {43.6, 34}, {44.5, 38}, {45.2, 39.7}, {45.9, 38}, {46.6, 36}, {47.7, 32}, {50.3, 18}, {52.8, 2}, {55.4, -18}, {57.5, -34}, {58.4, -42}, {58.6, -43.6}, {60, -43.2}, {62, -43}, {61.8, -41}, {61.2, -38}, {61, -36}, {60.3, -30}, {55.7, 6}, {52.8, 24}, {50, 36}, {47.8, 42}, {44, 43.3}, {41.2, 38}, {39.8, 32}, {37.2, 18}, {34.1, 0}, {32.1, -8}, {31.5, -10}, {30, -12.2}, {28, -11}, {25, -7.5}, {22.4, -4}, {18, -0.8}, {14.8, -2}, {12.6, -8}, {11.2, -16}, {10.4, -22}, {9.2, -30}, {7.5, -36}, {0, -36}, {-3.8, -30}, {-6.5, -16}, {-10.4, 22}, {-12.2, 30.5}, {-14, 32.4}, {-16, 32.3}, {-19, 28}, {-21.6, 20}, {-24.2, 10}, {-27.4, -2}, {-28.7, -6.5}, {-29.3, -8}, {-30, -6}, {-31.5, 2}, {-33, 10}, {-34.6, 14}, {-37.8, 14}, {-40, 10}, {-41.8, 4}, {-43, 0}, {-43.9, -2.2}, {-44.4, 0}, {-45, 4}, {-46.8, 20}, {-48.4, 30}, {-50, 33.2}, {-52, 33.6}, {-54.3, 30}, {-56.2, 22}, {-58.8, 6}, {-61.3, -12}, {-63.8, -32}, {-64, -34}, {-64.3, -36}, {-63, -36.2}, {-62, -36.3}, {-61, -36.4}}, smooth = Smooth.Bezier)}),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>cycle</code></td><td>String</td><td>-</td><td>\"WLTC3a\"</td><td>Acronym of the driving cycle</td></tr>
<tr><td><code>custom_fileName</code></td><td>String</td><td>-</td><td><br></td><td>Absolute path to the custom cycle file</td></tr>
<tr><td><code>custom_tableName</code></td><td>String</td><td>-</td><td><br></td><td>Data series to extract from the</td></tr></tbody></table><h2>2. Model description</h2><div>The DriveCycle block is designed to read a speed profile from a Matlab/.txt file.</div><div><br></div><div><div>The block enables the user to select from standard testing drive cycles including WLTC Class 1-3 and NEDC. The drive cycles are provided as .mat files in the library directory containing the block.</div></div><h2>3. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>y</code></td><td>Output</td><td>RealOutput</td><td>km/h</td><td>Velocity</td></tr></tbody></table></body></html>"));
end DriveCycle;
