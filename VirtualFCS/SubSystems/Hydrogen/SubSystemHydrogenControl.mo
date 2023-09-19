within VirtualFCS.SubSystems.Hydrogen;

model SubSystemHydrogenControl
  parameter Modelica.Units.SI.Pressure pressure_H2_set = 200000 "Set H2 Pressure";
  //parameter Modelica.Units.SI.MassFlowRate massFlow_H2_set = 1e-2 "Set H2 Recirculation Mass Flow";
  parameter Real N_FC_stack(unit = "1") = 180 "FC stack number of cells";
  Modelica.Blocks.Routing.Multiplex3 multiplexSignalsH2Subsystem annotation(
    Placement(visible = true, transformation(origin = {124, 40}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getH2MassFlow(y = deMultiplexH2Sensors.y1[1]) annotation(
    Placement(visible = true, transformation(origin = {-81, -60}, extent = {{-23, -16}, {23, 16}}, rotation = 0)));
  VirtualFCS.Control.PurgeValveControl purgeValveControl annotation(
    Placement(visible = true, transformation(origin = {-1, 40}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setH2Pressure(k = pressure_H2_set) annotation(
    Placement(visible = true, transformation(origin = {-1, 113}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  VirtualFCS.Control.PumpSpeedControl pumpSpeedControl(Td = 1, k = 10)  annotation(
    Placement(visible = true, transformation(origin = {-3, -44}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface[3] annotation(
    Placement(visible = true, transformation(origin = {210, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput signalInterface_H2[2] annotation(
    Placement(visible = true, transformation(origin = {-218, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-218, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Routing.DeMultiplex2 deMultiplexH2Sensors annotation(
    Placement(visible = true, transformation(origin = {-154, -120}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput signalInterface_FC annotation(
    Placement(visible = true, transformation(origin = {-220, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setH2MassFlow(y = max(signalInterface_FC*(0.002016*1.3/(96485*2)*N_FC_stack), 1.22e-05))  annotation(
    Placement(visible = true, transformation(origin = {-81, -28}, extent = {{-23, -16}, {23, 16}}, rotation = 0)));
equation
  connect(pumpSpeedControl.setPumpSpeed, multiplexSignalsH2Subsystem.u3[1]) annotation(
    Line(points = {{31, -44}, {52, -44}, {52, 32}, {66, 32}, {66, 29}, {105, 29}}, color = {0, 0, 127}));
  connect(purgeValveControl.purgeValveControl, multiplexSignalsH2Subsystem.u2[1]) annotation(
    Line(points = {{33, 40}, {105, 40}}, color = {0, 0, 127}));
  connect(getH2MassFlow.y, pumpSpeedControl.getMassFlow) annotation(
    Line(points = {{-56, -60}, {-37, -60}, {-37, -59.5}}, color = {0, 0, 127}));
  connect(setH2Pressure.y, multiplexSignalsH2Subsystem.u1[1]) annotation(
    Line(points = {{15.5, 113}, {52, 113}, {52, 55}, {59.5, 55}, {59.5, 51}, {105, 51}}, color = {0, 0, 127}));
  connect(multiplexSignalsH2Subsystem.y, controlInterface) annotation(
    Line(points = {{142, 40}, {204, 40}, {204, 40}, {210, 40}}, color = {0, 0, 127}));
  connect(signalInterface_H2, deMultiplexH2Sensors.u) annotation(
    Line(points = {{-218, -120}, {-176, -120}}, color = {0, 0, 127}, thickness = 0.5));
  connect(signalInterface_FC, purgeValveControl.fuelCellCurrent) annotation(
    Line(points = {{-220, 120}, {-102, 120}, {-102, 40}, {-36, 40}, {-36, 40}}, color = {0, 0, 127}));
  connect(setH2MassFlow.y, pumpSpeedControl.setMassFlow) annotation(
    Line(points = {{-56, -28}, {-38, -28}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin = {-9, 240}, textColor = {0, 0, 255}, extent = {{-137, 34}, {137, -34}}, textString = "%name")}),
    Documentation(info = "<html><head></head><body>The hydrogen sub system control governs the flow and pressure of hydrogen, based on fuel cell current.&nbsp;<br><div><br></div><div><div><br></div><div><b>Description</b></div><div><p class=\"MsoNormal\"><o:p></o:p></p><p class=\"MsoNormal\">The fuel cell interface (output current value) and hydrogen interface (mass flow rate set value) signals are inputs to the&nbsp;<a href=\"modelica://VirtualFCS.Control.PurgeValveControl\">Purge Valve Control</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>&nbsp;blocks. Other inputs include hydrogen feed pressure (from hydrogen tank to the fuel cell) and mass flow rate and are set to a constant value. The output signal is concatenated with three values, (1) Hydrogen Feed Pressure input to&nbsp;<a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>, (2) Control Signal to&nbsp;<a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a>&nbsp;and (3) Set Speed to&nbsp;<a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a>. &nbsp;The&nbsp;<a href=\"modelica://VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>&nbsp;blocks uses&nbsp;<span style=\"font-size: 12px;\">simple PID control to set</span>&nbsp;<a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a><span style=\"font-size: 12px;\">&nbsp;speed as a function of mass flow and</span>,&nbsp;<a href=\"modelica://VirtualFCS.Control.PurgeValveControl\">Purge Valve Control</a>&nbsp;uses logical conditions<span style=\"font-size: 12px;\">&nbsp;to control&nbsp;</span><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a>.&nbsp;</p><p class=\"MsoNormal\"><b><br></b></p><p class=\"MsoNormal\"><b>List of components</b></p><p class=\"MsoNormal\">The model comprises <a href=\"modelica://VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Control.PurgeValveControl\">Purge Valve Control</a>, <a href=\"modelica://Modelica.Blocks.Routing.DeMultiplex2\">DeMultipex2</a>, <a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Multiplex3</a>. The subsystem features multiple interface connections all of them are control port.&nbsp;</p></div></div></body></html>"));
end SubSystemHydrogenControl;
