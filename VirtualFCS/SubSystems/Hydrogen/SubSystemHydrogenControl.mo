within VirtualFCS.SubSystems.Hydrogen;
model SubSystemHydrogenControl

  import Modelica.Constants.F;

  constant Modelica.Units.SI.MolarMass M_H2 = Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM;

  parameter Modelica.Units.SI.AbsolutePressure pressure_H2_set = 200000 "Set H2 Pressure";
  parameter Real RR = 1.3 "Hydrogen recirculation ratio (recirculated/consumed)";
  parameter Integer N_stack = 180 "Number of cells in stack";
  parameter Modelica.Units.SI.MassFlowRate minimumFlow = 1.22e-05 "minimum hydrogen flow";
  
  VirtualFCS.Control.PurgeValveControl purgeValveControl annotation (
    Placement(transformation(origin = {0, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant setH2Pressure(k = pressure_H2_set) annotation (
    Placement(transformation(origin = {0, 160}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent annotation (
    Placement(visible = true, transformation(origin = {-220, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID pumpSpeedControl_PID(yMin = 0)  annotation(
    Placement(transformation(origin = {0, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput p_h2_set annotation(
    Placement(transformation(origin = {220, 160}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {220, 140}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput purge_set annotation(
    Placement(transformation(origin = {220, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput pumpSpeed_set annotation(
    Placement(transformation(origin = {220, -160}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {220, -140}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Max max annotation(
    Placement(transformation(origin = {-50, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant minFlow(k = minimumFlow)  annotation(
    Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Gain currentToFlow(k = M_H2*RR/F/2*N_stack)  annotation(
    Placement(transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput pumpSpeed_measured annotation(
    Placement(transformation(origin = {-220, -140}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(stackCurrent, purgeValveControl.fuelCellCurrent) annotation(
    Line(points = {{-220, 120}, {-100, 120}, {-100, 60}, {-22, 60}}, color = {0, 0, 127}));
  connect(setH2Pressure.y, p_h2_set) annotation(
    Line(points = {{22, 160}, {220, 160}}, color = {0, 0, 127}));
  connect(pumpSpeedControl_PID.y, pumpSpeed_set) annotation(
    Line(points = {{22, -60}, {160, -60}, {160, -160}, {220, -160}}, color = {0, 0, 127}));
  connect(purgeValveControl.purgeValveControl, purge_set) annotation(
    Line(points = {{22, 60}, {126.5, 60}, {126.5, 0}, {220, 0}}, color = {0, 0, 127}));
  connect(minFlow.y, max.u2) annotation(
    Line(points = {{-98, -80}, {-80.5, -80}, {-80.5, -66}, {-62, -66}}, color = {0, 0, 127}));
  connect(currentToFlow.u, stackCurrent) annotation(
    Line(points = {{-144, -20}, {-160, -20}, {-160, 120}, {-220, 120}}, color = {0, 0, 127}));
  connect(currentToFlow.y, max.u1) annotation(
    Line(points = {{-98, -20}, {-80, -20}, {-80, -54}, {-62, -54}}, color = {0, 0, 127}));
  connect(max.y, pumpSpeedControl_PID.u_s) annotation(
    Line(points = {{-39, -60}, {-24, -60}}, color = {0, 0, 127}));
  connect(pumpSpeed_measured, pumpSpeedControl_PID.u_m) annotation(
    Line(points = {{-220, -140}, {0, -140}, {0, -84}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics={Text(origin = {-9, 240}, textColor = {0, 0, 255}, extent = {{-137, 34}, {137, -34}}, textString = "%name"), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 2, extent = {{-200, 200}, {200, -200}}, radius = 50), Text(  textColor = {255, 0, 0},extent = {{-200, 100}, {200, -100}}, textString = "H₂
Control")}),
    Documentation(info = "<html><head></head><body>The hydrogen sub system control governs the flow and pressure of hydrogen, based on fuel cell current.&nbsp;<br><div><br></div><div><div><br></div><div><b>Description</b></div><div><p class=\"MsoNormal\"><o:p></o:p></p><p class=\"MsoNormal\">The fuel cell interface (output current value) and hydrogen interface (mass flow rate set value) signals are inputs to the&nbsp;<a href=\"modelica://VirtualFCS.Control.PurgeValveControl\">Purge Valve Control</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>&nbsp;blocks. Other inputs include hydrogen feed pressure (from hydrogen tank to the fuel cell) and mass flow rate and are set to a constant value. The output signal is concatenated with three values, (1) Hydrogen Feed Pressure input to&nbsp;<a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>, (2) Control Signal to&nbsp;<a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a>&nbsp;and (3) Set Speed to&nbsp;<a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a>. &nbsp;The&nbsp;<a href=\"modelica://VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>&nbsp;blocks uses&nbsp;<span style=\"font-size: 12px;\">simple PID control to set</span>&nbsp;<a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a><span style=\"font-size: 12px;\">&nbsp;speed as a function of mass flow and</span>,&nbsp;<a href=\"modelica://VirtualFCS.Control.PurgeValveControl\">Purge Valve Control</a>&nbsp;uses logical conditions<span style=\"font-size: 12px;\">&nbsp;to control&nbsp;</span><a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a>.&nbsp;</p><p class=\"MsoNormal\"><b><br></b></p><p class=\"MsoNormal\"><b>List of components</b></p><p class=\"MsoNormal\">The model comprises <a href=\"modelica://VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Control.PurgeValveControl\">Purge Valve Control</a>, <a href=\"modelica://Modelica.Blocks.Routing.DeMultiplex2\">DeMultipex2</a>, <a href=\"modelica://Modelica.Blocks.Routing.Multiplex3\">Multiplex3</a>. The subsystem features multiple interface connections all of them are control port.&nbsp;</p></div></div></body></html>"));
end SubSystemHydrogenControl;
