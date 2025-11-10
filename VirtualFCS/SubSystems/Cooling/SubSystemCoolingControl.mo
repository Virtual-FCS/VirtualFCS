within VirtualFCS.SubSystems.Cooling;

model SubSystemCoolingControl
  parameter Modelica.Units.SI.Temperature temperature_Cooling_set = 80 + 273.15 "Set Fuel cell Temperature";
  Modelica.Blocks.Interfaces.RealInput sensorInterface annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setCoolingTemperature(k = temperature_Cooling_set) annotation(
    Placement(visible = true, transformation(origin = {-174, 140}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Control.PumpSpeedControlCooling pumpSpeedControlCooling(Td = 0.1,Ti = 1, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-52, -52}, {52, 52}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1)  annotation(
    Placement(visible = true, transformation(origin = {74, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 0.075) annotation(
    Placement(visible = true, transformation(origin = {108, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(setCoolingTemperature.y, pumpSpeedControlCooling.setMassFlow) annotation(
    Line(points = {{-158, 140}, {-108, 140}, {-108, 26}, {-57, 26}}, color = {0, 0, 127}));
  connect(realExpression.y, add.u1) annotation(
    Line(points = {{85, 46}, {90, 46}, {90, 12}, {98, 12}}, color = {0, 0, 127}));
  connect(pumpSpeedControlCooling.setPumpSpeed, add.u2) annotation(
    Line(points = {{57.2, 0}, {97.2, 0}}, color = {0, 0, 127}));
  connect(add.y, max.u1) annotation(
    Line(points = {{121, 6}, {138, 6}}, color = {0, 0, 127}));
  connect(realExpression1.y, max.u2) annotation(
    Line(points = {{119, -30}, {127, -30}, {127, -6}, {138, -6}}, color = {0, 0, 127}));
  connect(sensorInterface, pumpSpeedControlCooling.getMassFlow) annotation(
    Line(points = {{-220, 0}, {-108, 0}, {-108, -26}, {-58, -26}}, color = {0, 0, 127}));
  connect(max.y, controlInterface) annotation(
    Line(points = {{162, 0}, {210, 0}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin = {-7, 242}, textColor = {0, 0, 255}, extent = {{-103, 34}, {103, -34}}, textString = "%name")}),
    Documentation(info = "<html><head></head><body><p class=\"MsoNormal\" style=\"font-size: 12px;\">Model (components and controls. If package, then what it contains with references)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">What it does<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">References to base model/related packages<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Standard component/protocol (any specific commercial)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Description<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Purpose/where to use<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">List of components<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Assumptions<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Formula<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operation<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Explain with diagram view<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operating range<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Initial/default inputs<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Output-Explain with graph</p></body></html>"));
end SubSystemCoolingControl;
