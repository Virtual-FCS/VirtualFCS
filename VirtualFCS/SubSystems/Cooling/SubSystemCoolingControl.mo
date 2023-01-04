within VirtualFCS.SubSystems.Cooling;

model SubSystemCoolingControl
  parameter Real temperature_Cooling_set(unit = "K") = 80 + 273.15 "Set Fuel cell Temperature";
  Modelica.Blocks.Interfaces.RealInput sensorInterface annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setCoolingTemperature(k = temperature_Cooling_set) annotation(
    Placement(visible = true, transformation(origin = {-174, 140}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Control.PumpSpeedControlCooling pumpSpeedControlCooling(Td = 0.1,Ti = 1, k = 1)  annotation(
    Placement(visible = true, transformation(origin = {0, 114}, extent = {{-52, -52}, {52, 52}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-106, 74}, extent = {{-14, 14}, {14, -14}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(pre_y_start = true, uHigh = temperature_Cooling_set - 5, uLow = temperature_Cooling_set - 15)  annotation(
    Placement(visible = true, transformation(origin = {-154, 74}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {150, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {110, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1)  annotation(
    Placement(visible = true, transformation(origin = {74, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 0.075) annotation(
    Placement(visible = true, transformation(origin = {108, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {152, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis1(pre_y_start = true, uHigh = temperature_Cooling_set - 5, uLow = temperature_Cooling_set - 15) annotation(
    Placement(visible = true, transformation(origin = {104, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = 0.01) annotation(
    Placement(visible = true, transformation(origin = {104, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(setCoolingTemperature.y, pumpSpeedControlCooling.setMassFlow) annotation(
    Line(points = {{-158, 140}, {-58, 140}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch1.u2) annotation(
    Line(points = {{-138, 74}, {-123, 74}}, color = {255, 0, 255}));
  connect(hysteresis.u, sensorInterface) annotation(
    Line(points = {{-170, 74}, {-188, 74}, {-188, 0}, {-220, 0}}, color = {0, 0, 127}));
  connect(switch1.y, pumpSpeedControlCooling.getMassFlow) annotation(
    Line(points = {{-91, 74}, {-76, 74}, {-76, 88}, {-58, 88}}, color = {0, 0, 127}));
  connect(sensorInterface, switch1.u1) annotation(
    Line(points = {{-220, 0}, {-132, 0}, {-132, 62}, {-122, 62}}, color = {0, 0, 127}));
  connect(setCoolingTemperature.y, switch1.u3) annotation(
    Line(points = {{-158, 140}, {-132, 140}, {-132, 86}, {-122, 86}}, color = {0, 0, 127}));
  connect(realExpression.y, add.u1) annotation(
    Line(points = {{85, 160}, {90, 160}, {90, 126}, {98, 126}}, color = {0, 0, 127}));
  connect(pumpSpeedControlCooling.setPumpSpeed, add.u2) annotation(
    Line(points = {{58, 114}, {98, 114}}, color = {0, 0, 127}));
  connect(add.y, max.u1) annotation(
    Line(points = {{121, 120}, {127, 120}, {127, 104}, {137, 104}}, color = {0, 0, 127}));
  connect(realExpression1.y, max.u2) annotation(
    Line(points = {{119, 84}, {127, 84}, {127, 92}, {137, 92}}, color = {0, 0, 127}));
  connect(hysteresis1.y, switch.u2) annotation(
    Line(points = {{119.4, 0}, {134.4, 0}}, color = {255, 0, 255}));
  connect(sensorInterface, hysteresis1.u) annotation(
    Line(points = {{-220, 0}, {87, 0}}, color = {0, 0, 127}));
  connect(max.y, switch.u1) annotation(
    Line(points = {{161, 98}, {173, 98}, {173, 40}, {125, 40}, {125, 12}, {135, 12}}, color = {0, 0, 127}));
  connect(realExpression2.y, switch.u3) annotation(
    Line(points = {{115, -48}, {125, -48}, {125, -12}, {135, -12}}, color = {0, 0, 127}));
  connect(switch.y, controlInterface) annotation(
    Line(points = {{168, 0}, {210, 0}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin = {-7, 242}, textColor = {0, 0, 255}, extent = {{-103, 34}, {103, -34}}, textString = "%name")}),
    Documentation(info = "<html><head></head><body><p class=\"MsoNormal\" style=\"font-size: 12px;\">Model (components and controls. If package, then what it contains with references)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">What it does<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">References to base model/related packages<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Standard component/protocol (any specific commercial)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Description<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Purpose/where to use<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">List of components<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Assumptions<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Formula<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operation<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Explain with diagram view<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operating range<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Initial/default inputs<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Output-Explain with graph</p></body></html>"));
end SubSystemCoolingControl;
