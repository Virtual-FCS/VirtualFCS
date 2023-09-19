within VirtualFCS.SubSystems.Cooling;

model SubSystemCoolingControl
   parameter Modelica.Units.SI.Temperature temperature_Cooling_set = 80 +273.15 "Set Fuel cell water flow rate";
  
  Modelica.Blocks.Interfaces.RealInput sensorInterface annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation(
    Placement(visible = true, transformation(origin = {215, -1}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {218, -160}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  VirtualFCS.Control.PumpSpeedControlCooling pumpSpeedControlCooling(Td = 0.1,Ti = 1, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-52, -52}, {52, 52}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Setpoint_Temperature annotation(
    Placement(visible = true, transformation(origin = {200, 128}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {218, 130}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant temperature_Cooling(k = temperature_Cooling_set) annotation(
    Placement(visible = true, transformation(origin = {-150, 134}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = 0.0012) annotation(
    Placement(visible = true, transformation(origin = {-148, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(sensorInterface, pumpSpeedControlCooling.getMassFlow) annotation(
    Line(points = {{-220, 0}, {-108, 0}, {-108, -26}, {-58, -26}}, color = {0, 0, 127}));
  connect(Setpoint_Temperature, temperature_Cooling.y) annotation(
    Line(points = {{200, 128}, {-135, 128}, {-135, 134}}, color = {0, 0, 127}));
  connect(realExpression2.y, pumpSpeedControlCooling.setMassFlow) annotation(
    Line(points = {{-136, 54}, {-96, 54}, {-96, 26}, {-58, 26}}, color = {0, 0, 127}));
  connect(pumpSpeedControlCooling.setPumpSpeed, controlInterface) annotation(
    Line(points = {{58, 0}, {216, 0}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin = {-7, 242}, textColor = {0, 0, 255}, extent = {{-103, 34}, {103, -34}}, textString = "%name")}),
    Documentation(info = "<html><head></head><body><p class=\"MsoNormal\" style=\"font-size: 12px;\">Model (components and controls. If package, then what it contains with references)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">What it does<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">References to base model/related packages<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Standard component/protocol (any specific commercial)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Description<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Purpose/where to use<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">List of components<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Assumptions<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Formula<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operation<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Explain with diagram view<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operating range<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Initial/default inputs<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Output-Explain with graph</p></body></html>"));
end SubSystemCoolingControl;
