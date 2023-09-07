within VirtualFCS.Vehicles;

model DriveCycle
  import Modelica.Blocks.Tables.Internal;
  ////////////////////// Choose speed_profile  //////////////////////////////////////////////////////
  type speed_profile = enumeration(NEDC "NEDC", WLTC "WLTC", custom "custom") annotation(
    Evaluate = true);
  parameter speed_profile v = VirtualFCS.Vehicles.DriveCycle.speed_profile.custom "Speed profile";
  parameter String fileName = "NoName" "File where matrix is stored" annotation(
    Dialog(loadSelector(filter = "Text files (*.txt);;MATLAB MAT-files (*.mat)", caption = "Open file in which table is present")));
  parameter String tableName = "NoName" "Name of the table";
  // Choice of file path

  function choose_speed_profile
    input speed_profile v;
    input String path;
    output String file;
  algorithm
    if v == VirtualFCS.Vehicles.DriveCycle.speed_profile.NEDC then
      file := Modelica.Utilities.Files.loadResource("modelica://VirtualFCS.Resources.DataDriveCycles/NEDC.txt"); 
    elseif v == VirtualFCS.Vehicles.DriveCycle.speed_profile.WLTC then
      file := Modelica.Utilities.Files.loadResource("modelica://VirtualFCS.Resources.DataDriveCycles/WLTC.mat");
    elseif v == VirtualFCS.Vehicles.DriveCycle.speed_profile.custom then
      file := path;
    end if;
  end choose_speed_profile;

  // Choice of file name

  function speed_profile_name
    input speed_profile v;
    input String table;
    output String name;
  algorithm
    if v == VirtualFCS.Vehicles.DriveCycle.speed_profile.NEDC then
      name := "NEDC";
    elseif v == VirtualFCS.Vehicles.DriveCycle.speed_profile.WLTC then
      name := "WLTC";
    elseif v == VirtualFCS.Vehicles.DriveCycle.speed_profile.custom then
      name := table;
    end if;
  end speed_profile_name;

  // *** INSTANTIATE COMPONENTS *** //
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(extrapolation = Modelica.Blocks.Types.Extrapolation.Periodic, fileName = filepath, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table = fill(0.0, 0, 2), tableName = table_Name, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-1, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  parameter String filepath = choose_speed_profile(v, fileName);
  // Filepath
  parameter String table_Name = speed_profile_name(v, tableName);
  // Filename
equation
  connect(combiTimeTable.y[1], y) annotation(
    Line(points = {{12, 0}, {104, 0}, {104, 0}, {110, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.05), graphics = {Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle( lineColor = {95, 30, 27},fillColor = {190, 60, 55}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(origin = {0, -51}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-74, 0.8}, {68.5, 0.8}, {68.5, 3}, {75.5, -0.5}, {68.5, -4}, {68.5, -1.5}, {-74, -1.5}, {-74, 0.8}, {-74, 0.8}}), Polygon(origin = {-74.3, 21.5}, rotation = 90, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-74, 0.8}, {33.8, 0.8}, {33.8, 3}, {40.8, -0.5}, {33.8, -4}, {33.8, -1.5}, {-74, -1.5}, {-74, 0.8}, {-74, 0.8}}), Polygon(origin = {-2, 4}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-61, -36.4}, {-60.8, -35.5}, {-60.7, -34}, {-60.5, -32}, {-57.6, -10}, {-55.1, 8}, {-53.1, 20}, {-52, 26}, {-51.3, 28}, {-51, 26}, {-50.2, 20}, {-49.4, 12}, {-48.4, 4}, {-47.5, -2}, {-46.2, -6}, {-44, -7.2}, {-41, -4}, {-39.6, 0}, {-37.8, 6}, {-37, 8.5}, {-36.2, 9}, {-35.5, 6}, {-35, 2}, {-34.3, -2}, {-33.5, -6}, {-32.1, -10}, {-30, -12.2}, {-28, -11.7}, {-26.7, -10}, {-24.4, -4}, {-21.8, 6}, {-18.6, 18}, {-16.1, 26}, {-15.4, 28}, {-15, 28.5}, {-14.4, 26}, {-13.6, 20}, {-12, 4}, {-10.3, -12}, {-8.3, -26}, {-4.2, -37}, {4, -40}, {10.2, -37.5}, {13.3, -26}, {15.3, -12}, {16.7, -6}, {17.5, -4.1}, {19.6, -6}, {22.8, -10}, {26, -14}, {30, -15.6}, {34.3, -12}, {36.7, -4}, {39.3, 10}, {41.3, 22}, {43.6, 34}, {44.5, 38}, {45.2, 39.7}, {45.9, 38}, {46.6, 36}, {47.7, 32}, {50.3, 18}, {52.8, 2}, {55.4, -18}, {57.5, -34}, {58.4, -42}, {58.6, -43.6}, {60, -43.2}, {62, -43}, {61.8, -41}, {61.2, -38}, {61, -36}, {60.3, -30}, {55.7, 6}, {52.8, 24}, {50, 36}, {47.8, 42}, {44, 43.3}, {41.2, 38}, {39.8, 32}, {37.2, 18}, {34.1, 0}, {32.1, -8}, {31.5, -10}, {30, -12.2}, {28, -11}, {25, -7.5}, {22.4, -4}, {18, -0.8}, {14.8, -2}, {12.6, -8}, {11.2, -16}, {10.4, -22}, {9.2, -30}, {7.5, -36}, {0, -36}, {-3.8, -30}, {-6.5, -16}, {-10.4, 22}, {-12.2, 30.5}, {-14, 32.4}, {-16, 32.3}, {-19, 28}, {-21.6, 20}, {-24.2, 10}, {-27.4, -2}, {-28.7, -6.5}, {-29.3, -8}, {-30, -6}, {-31.5, 2}, {-33, 10}, {-34.6, 14}, {-37.8, 14}, {-40, 10}, {-41.8, 4}, {-43, 0}, {-43.9, -2.2}, {-44.4, 0}, {-45, 4}, {-46.8, 20}, {-48.4, 30}, {-50, 33.2}, {-52, 33.6}, {-54.3, 30}, {-56.2, 22}, {-58.8, 6}, {-61.3, -12}, {-63.8, -32}, {-64, -34}, {-64.3, -36}, {-63, -36.2}, {-62, -36.3}, {-61, -36.4}}, smooth = Smooth.Bezier)}),
    Documentation(info = "<html><head></head><body><div>The DriveCycle block is designed to replicate the power demand of a vehicle considering a pre-determined drive cycle and vehicle parameters such as weight and frontal area. The generated power profile considers the needs to propel the vehicle plus the aerodynamic drag. The block allows the user to select if regenerative breaking is used or not.</div><div><br></div><div><div>The block enables the user to select from standard testing drive cycles including WLTC Class 1-3 and NEDC. The drive cycles are provided as .mat files in the library directory containing the block.</div></div></body></html>"));
end DriveCycle;
