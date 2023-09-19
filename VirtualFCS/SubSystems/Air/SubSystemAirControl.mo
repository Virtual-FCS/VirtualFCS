within VirtualFCS.SubSystems.Air;

block SubSystemAirControl
  parameter Modelica.Units.SI.Pressure pressure_Air_set = 150000 "Set air Pressure";
 // parameter Modelica.Units.SI.MassFlowRate massFlow_Air_set = 4e-3 "Set air Recirculation Mass Flow";
  parameter Real N_FC_stack(unit = "1") = 455 "FC stack number of cells";
  VirtualFCS.Control.PumpSpeedControl pumpSpeedControl annotation(
    Placement(visible = true, transformation(origin = {0, -7.10543e-15}, extent = {{-58, -58}, {58, 58}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setAirPressure(k = pressure_Air_set) annotation(
    Placement(visible = true, transformation(origin = {1, 145}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation(
    Placement(visible = true, transformation(origin = {116, 10}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface[2] annotation(
    Placement(visible = true, transformation(origin = {210, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {212, -2}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput sensorInterface[2] annotation(
    Placement(visible = true, transformation(origin = {-220, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Routing.DeMultiplex2 deMultiplexAirSensors annotation(
    Placement(visible = true, transformation(origin = {-138, -120}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getAirMassFlow(y = deMultiplexAirSensors.y1[1]) annotation(
    Placement(visible = true, transformation(origin = {-119, -30}, extent = {{-23, -16}, {23, 16}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput signalInterfaceFC annotation(
    Placement(visible = true, transformation(origin = {-220, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setAirMassFlow(y = max(signalInterfaceFC*(0.02897*2/(96485*4*0.21)*N_FC_stack), 1e-3)) annotation(
    Placement(visible = true, transformation(origin = {-119, 30}, extent = {{-23, -16}, {23, 16}}, rotation = 0)));
equation
  connect(setAirPressure.y, multiplex2.u1[1]) annotation(
    Line(points = {{18, 146}, {94, 146}, {94, 21}}, color = {0, 0, 127}));
  connect(pumpSpeedControl.setPumpSpeed, multiplex2.u2[1]) annotation(
    Line(points = {{64, 0}, {92, 0}, {92, -1}, {94, -1}}, color = {0, 0, 127}));
  connect(multiplex2.y, controlInterface) annotation(
    Line(points = {{136, 10}, {210, 10}}, color = {0, 0, 127}));
  connect(sensorInterface, deMultiplexAirSensors.u) annotation(
    Line(points = {{-220, -120}, {-164, -120}}, color = {0, 0, 127}));
  connect(getAirMassFlow.y, pumpSpeedControl.getMassFlow) annotation(
    Line(points = {{-94, -30}, {-64, -30}}, color = {0, 0, 127}));
  connect(setAirMassFlow.y, pumpSpeedControl.setMassFlow) annotation(
    Line(points = {{-94, 30}, {-64, 30}, {-64, 28}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin = {-25, 244}, textColor = {0, 0, 255}, extent = {{-53, 28}, {91, -54}}, textString = "%name")}),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">The air sub system control governs the flow and pressure of air, based on fuel cell current.&nbsp;</span><br style=\"font-size: 12px;\"><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><br></div><div><b>Description</b></div><div><p class=\"MsoNormal\"><o:p></o:p></p><p class=\"MsoNormal\">The sensor interface (mass flow rate set value) signals are inputs to the&nbsp;<a href=\"modelica:///VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>&nbsp;block. Other inputs include air feed pressure (from air tank to the fuel cell) and mass flow rate and are set to a constant value. The output signal is concatenated with two values, (1) Air Feed Pressure input to&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\" style=\"font-size: medium;\">Throttle Valve</a>, and (2) Set Speed to&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\" style=\"font-size: medium;\">Air Compressor</a>. The&nbsp;<a href=\"modelica:///VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>&nbsp;blocks uses&nbsp;simple PID control to set&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\" style=\"font-size: medium;\">Air Compressor</a>&nbsp;speed as a function of mass flow.&nbsp;</p><p class=\"MsoNormal\"><b><br></b></p><p class=\"MsoNormal\"><b>List of components</b></p><p class=\"MsoNormal\">The model comprises <a href=\"modelica:///VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>,&nbsp;<a href=\"modelica:///Modelica.Blocks.Routing.DeMultiplex2\">DeMultipex2</a>,&nbsp;<a href=\"modelica:///Modelica.Blocks.Routing.Multiplex3\">Multiplex3</a>. The subsystem features multiple interface connections all of them are control port.&nbsp;</p></div></div></body></html>"));
end SubSystemAirControl;
