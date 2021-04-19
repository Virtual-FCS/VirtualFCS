within VirtualFCS.SubSystems.Cooling;

class SubSystemCoolingControl

  parameter Real temperature_Cooling_set(unit = "K") = 80+273.15 "Set H2 Pressure";

  VirtualFCS.Control.PumpSpeedControl pumpSpeedControl annotation(
    Placement(visible = true, transformation(origin = {-56, -7.10543e-15}, extent = {{-58, -58}, {58, 58}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput sensorInterface annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setCoolingTemperature(k = temperature_Cooling_set) annotation(
    Placement(visible = true, transformation(origin = {-174, 66}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(setCoolingTemperature.y, pumpSpeedControl.setMassFlow) annotation(
    Line(points = {{-159, 66}, {-139.5, 66}, {-139.5, 29}, {-120, 29}}, color = {0, 0, 127}));
  connect(sensorInterface, pumpSpeedControl.getMassFlow) annotation(
    Line(points = {{-220, 0}, {-142, 0}, {-142, -29}, {-120, -29}}, color = {0, 0, 127}));
  connect(pumpSpeedControl.setPumpSpeed, controlInterface) annotation(
    Line(points = {{8, 0}, {202, 0}, {202, 0}, {210, 0}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin = {-7, 242}, lineColor = {0, 0, 255}, extent = {{-103, 34}, {103, -34}}, textString = "%name")}));
end SubSystemCoolingControl;
