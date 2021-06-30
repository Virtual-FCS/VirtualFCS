within VirtualFCS.Control;

model FuelCellSystemControl "Implement algorithms for the control of fuel cell systems."
  Modelica.Blocks.Interfaces.RealOutput controlH2Subsystem[3] annotation(
    Placement(visible = true, transformation(origin = {94, 198}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {219, -79}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput sensorH2Subsystem[2] annotation(
    Placement(visible = true, transformation(origin = {-122, 172}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-419, -79}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput sensorAirSubsystem[2] annotation(
    Placement(visible = true, transformation(origin = {-162, -181}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-419, 93}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlAirSubsystem[2] annotation(
    Placement(visible = true, transformation(origin = {120, -178}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(origin = {219, 91}, extent = {{-19, 19}, {19, -19}}, rotation = 0)));
  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl subSystemHydrogenControl annotation(
    Placement(visible = true, transformation(origin = {0, 198}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  VirtualFCS.SubSystems.Air.SubSystemAirControl subSystemAirControl annotation(
    Placement(visible = true, transformation(origin = {1, -175}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput getCurrentFuelCell annotation(
    Placement(visible = true, transformation(origin = {-140, 226}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-422, -200}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(subSystemHydrogenControl.controlInterface, controlH2Subsystem) annotation(
    Line(points = {{42, 198}, {94, 198}}, color = {0, 0, 127}, thickness = 0.5));
  connect(subSystemAirControl.controlInterface, controlAirSubsystem) annotation(
    Line(points = {{42, -175}, {73, -175}, {73, -173}, {112, -173}, {112, -178}, {120, -178}}, color = {0, 0, 127}, thickness = 0.5));
  connect(sensorH2Subsystem, subSystemHydrogenControl.signalInterface_H2) annotation(
    Line(points = {{-122, 172}, {-83, 172}, {-83, 174}, {-44, 174}}, color = {0, 0, 127}, thickness = 0.5));
  connect(sensorAirSubsystem, subSystemAirControl.sensorInterface) annotation(
    Line(points = {{-162, -180}, {-44, -180}, {-44, -174}, {-42, -174}}, color = {0, 0, 127}, thickness = 0.5));
  connect(getCurrentFuelCell, subSystemHydrogenControl.signalInterface_FC) annotation(
    Line(points = {{-140, 226}, {-46, 226}, {-46, 222}, {-44, 222}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -300}, {200, 300}}, initialScale = 0.1), graphics = {Text(origin = {-122, 118}, lineColor = {255, 0, 0}, extent = {{-60, 10}, {60, -10}}, textString = "H2 line control"), Rectangle(origin = {-9, 224}, lineColor = {255, 0, 0}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-189, 72}, {207, -124}}), Rectangle(origin = {-9, -170}, lineColor = {85, 170, 0}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-187, 110}, {205, -130}}), Text(origin = {114, -274}, lineColor = {85, 170, 0}, extent = {{-60, 10}, {60, -10}}, textString = "Air line control"), Rectangle(origin = {-150, -6}, lineColor = {0, 170, 255}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-50, 99}, {348, -49}}), Text(origin = {118, -18}, lineColor = {0, 170, 255}, extent = {{-60, 10}, {64, -12}}, textString = "Cooling management")}),
    Icon(coordinateSystem(extent = {{-200, -300}, {200, 300}}, initialScale = 0.1), graphics = {Rectangle(origin = {-100, 0}, fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-300, 300}, {300, -300}}), Text(origin = {15, -200}, lineColor = {255, 255, 255}, extent = {{-63, 28}, {151, -92}}, textString = "Cooling Control"), Text(origin = {-313, -220}, lineColor = {255, 255, 255}, extent = {{-63, 28}, {111, -60}}, textString = "FC Sensors"), Text(origin = {-319, -60}, lineColor = {255, 255, 255}, extent = {{-63, 28}, {111, -60}}, textString = "H2 Sensors"), Text(origin = {75, -60}, lineColor = {255, 255, 255}, extent = {{-63, 28}, {93, -60}}, textString = "H2 Control"), Text(origin = {67, 112}, lineColor = {255, 255, 255}, extent = {{-63, 28}, {101, -64}}, textString = "Air Control"), Text(origin = {-319, 112}, lineColor = {255, 255, 255}, extent = {{-63, 28}, {119, -62}}, textString = "Air Sensors"), Text(origin = {-195, 410}, lineColor = {0, 0, 255}, extent = {{-55, 18}, {213, -120}}, textString = "%name")}));
end FuelCellSystemControl;
