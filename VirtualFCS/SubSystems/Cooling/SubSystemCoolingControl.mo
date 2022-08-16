within VirtualFCS.SubSystems.Cooling;

class SubSystemCoolingControl

  parameter Real temperature_Cooling_set(unit = "K") = 353.15 "Set Fuel cell Temperature";

  VirtualFCS.Control.PumpSpeedControl pumpSpeedControl(Td = 1e-3, k = 1e-6)  annotation(
    Placement(visible = true, transformation(origin = {-54, -7.10543e-15}, extent = {{-58, -58}, {58, 58}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput FCTemp annotation(
    Placement(visible = true, transformation(origin = {-222, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-224, 162}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput CoolantFlow annotation(
    Placement(visible = true, transformation(origin = {-222, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-224, -162}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(PumpMassFlowS, pumpSpeedControl.getMassFlow) annotation(
    Line(points = {{-220, -80}, {-142, -80}, {-142, -29}, {-118, -29}}, color = {0, 0, 127}));
  connect(pumpSpeedControl.setPumpSpeed, controlInterface) annotation(
    Line(points = {{10, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(FCTemp, pumpSpeedControl.FCTemp) annotation(
    Line(points = {{-220, 106}, {-171, 106}, {-171, 46}, {-120, 46}}, color = {0, 0, 127}));
  connect(FCTemp, pumpSpeedControl.setValue) annotation(
    Line(points = {{-222, 44}, {-122, 44}, {-122, 46}, {-120, 46}}, color = {0, 0, 127}));
  connect(CoolantFlow, pumpSpeedControl.getValue) annotation(
    Line(points = {{-222, -32}, {-122, -32}, {-122, -30}, {-118, -30}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin = {-7, 242}, lineColor = {0, 0, 255}, extent = {{-103, 34}, {103, -34}}, textString = "%name")}),
  Documentation(info = "<html><head></head><body><p class=\"MsoNormal\" style=\"font-size: 12px;\">Model (components and controls. If package, then what it contains with references)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">What it does<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">References to base model/related packages<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Standard component/protocol (any specific commercial)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Description<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Purpose/where to use<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">List of components<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Assumptions<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Formula<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operation<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Explain with diagram view<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operating range<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Initial/default inputs<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Output-Explain with graph</p></body></html>"));
end SubSystemCoolingControl;
