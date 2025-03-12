within VirtualFCS.SubSystems.Cooling;
model SubSystemCoolingControl
  parameter Modelica.Units.SI.Temperature temperature_Cooling_set = 80 +273.15 "Set Fuel cell water flow rate";


  VirtualFCS.Control.PumpSpeedControlCooling pumpSpeedControlCooling                                                                                      annotation (
    Placement(visible = true, transformation(origin={2,-38},  extent={{-38,-38},
            {38,38}},                                                                          rotation = 0)));
  Modelica.Blocks.Sources.Constant temperature_Cooling(k=
        temperature_Cooling_set)                                                    annotation (
    Placement(visible = true, transformation(origin={-166,120},    extent={{-16,-16},
            {16,16}},                                                                               rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput sensorInterface annotation (
    Placement(visible = true, transformation(origin={-229,-57},  extent={{-29,-29},
            {29,29}},                                                                             rotation = 0), iconTransformation(origin={-220,100},  extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation (
    Placement(visible = true, transformation(origin={219,-39},   extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {218, -160}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Setpoint_Temperature annotation (
    Placement(visible = true, transformation(origin={200,120},    extent={{-32,-32},
            {32,32}},                                                                              rotation = 0), iconTransformation(origin = {218, 130}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput setPointPump
    annotation (Placement(transformation(extent={{-240,-16},{-200,24}})));
equation
  connect(sensorInterface, pumpSpeedControlCooling.getTStack)
    annotation (Line(points={{-229,-57},{-39.8,-57}}, color={0,0,127}));
  connect(Setpoint_Temperature,temperature_Cooling. y) annotation (
    Line(points={{200,120},{-148.4,120}},                 color = {0, 0, 127}));
  connect(controlInterface, controlInterface)
    annotation (Line(points={{219,-39},{219,-39}}, color={0,0,127}));
  connect(pumpSpeedControlCooling.setPumpSpeed, controlInterface) annotation (
      Line(points={{43.8,-38},{131.4,-38},{131.4,-39},{219,-39}}, color={0,0,
          127}));
  connect(setPointPump, pumpSpeedControlCooling.setTStack) annotation (Line(
        points={{-220,4},{-50,4},{-50,-19},{-39.8,-19}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics={  Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin={0,218},     textColor={0,0,255},     extent={{-200,60},
              {200,-60}},
          textString="Subsystem Cooling Control")}),
    Documentation(info = "<html><head></head><body><p class=\"MsoNormal\" style=\"font-size: 12px;\">Model (components and controls. If package, then what it contains with references)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">What it does<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">References to base model/related packages<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Standard component/protocol (any specific commercial)<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><span lang=\"NO-BOK\">&nbsp;</span></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Description<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Purpose/where to use<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">List of components<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Assumptions<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Formula<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\"><o:p>&nbsp;</o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operation<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Explain with diagram view<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Operating range<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Initial/default inputs<o:p></o:p></p><p class=\"MsoNormal\" style=\"font-size: 12px;\">Output-Explain with graph</p></body></html>"));
end SubSystemCoolingControl;
