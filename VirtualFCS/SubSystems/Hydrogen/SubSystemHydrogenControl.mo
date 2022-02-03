within VirtualFCS.SubSystems.Hydrogen;

class SubSystemHydrogenControl

  parameter Real pressure_H2_set(unit = "Pa") = 200000 "Set H2 Pressure";
  parameter Real massFlow_H2_set(unit = "kg/s") = 1e-2 "Set H2 Recirculation Mass Flow";

  Modelica.Blocks.Routing.Multiplex3 multiplexSignalsH2Subsystem annotation(
    Placement(visible = true, transformation(origin = {124, 40}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getH2MassFlow(y = deMultiplexH2Sensors.y1[1]) annotation(
    Placement(visible = true, transformation(origin = {-81, -62}, extent = {{-23, -16}, {23, 16}}, rotation = 0)));
  VirtualFCS.Control.PurgeValveControl purgeValveControl annotation(
    Placement(visible = true, transformation(origin = {-1, 40}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setH2Pressure(k = pressure_H2_set) annotation(
    Placement(visible = true, transformation(origin = {-1, 113}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  VirtualFCS.Control.PumpSpeedControl pumpSpeedControl annotation(
    Placement(visible = true, transformation(origin = {-3, -44}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setH2MassFlow(k = massFlow_H2_set) annotation(
    Placement(visible = true, transformation(origin = {-86, -14}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface[3] annotation(
    Placement(visible = true, transformation(origin = {210, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput signalInterface_H2[2] annotation(
    Placement(visible = true, transformation(origin = {-218, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-218, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Routing.DeMultiplex2 deMultiplexH2Sensors annotation(
    Placement(visible = true, transformation(origin = {-154, -120}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput signalInterface_FC annotation(
    Placement(visible = true, transformation(origin = {-220, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(pumpSpeedControl.setPumpSpeed, multiplexSignalsH2Subsystem.u3[1]) annotation(
    Line(points = {{31, -44}, {52, -44}, {52, 32}, {66, 32}, {66, 29}, {105, 29}}, color = {0, 0, 127}));
  connect(purgeValveControl.purgeValveControl, multiplexSignalsH2Subsystem.u2[1]) annotation(
    Line(points = {{33, 40}, {105, 40}}, color = {0, 0, 127}));
  connect(getH2MassFlow.y, pumpSpeedControl.getMassFlow) annotation(
    Line(points = {{-56, -62}, {-37, -62}, {-37, -59.5}}, color = {0, 0, 127}));
  connect(setH2Pressure.y, multiplexSignalsH2Subsystem.u1[1]) annotation(
    Line(points = {{15.5, 113}, {52, 113}, {52, 55}, {59.5, 55}, {59.5, 51}, {105, 51}}, color = {0, 0, 127}));
  connect(setH2MassFlow.y, pumpSpeedControl.setMassFlow) annotation(
    Line(points = {{-71, -14}, {-50, -14}, {-50, -28.5}, {-37, -28.5}}, color = {0, 0, 127}));
  connect(multiplexSignalsH2Subsystem.y, controlInterface) annotation(
    Line(points = {{142, 40}, {204, 40}, {204, 40}, {210, 40}}, color = {0, 0, 127}));
  connect(signalInterface_H2, deMultiplexH2Sensors.u) annotation(
    Line(points = {{-218, -120}, {-176, -120}}, color = {0, 0, 127}, thickness = 0.5));
  connect(signalInterface_FC, purgeValveControl.fuelCellCurrent) annotation(
    Line(points = {{-220, 120}, {-102, 120}, {-102, 40}, {-36, 40}, {-36, 40}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin = {-9, 240}, lineColor = {0, 0, 255}, extent = {{-137, 34}, {137, -34}}, textString = "%name")}),
  Documentation(info = "<html><head></head><body>The hydrogen sub system control governs the flow and pressure of hydrogen based on fuel cell current.&nbsp;<br><div><br></div><div><br></div><div><div><br></div><div><b>References to base model/related packages</b></div><div><p class=\"MsoNormal\"><o:p></o:p></p><p class=\"MsoNormal\"><a href=\"modelica://VirtualFCS.Control.PumpSpeedControl\">Pump Speed Control</a>, <a href=\"modelica://VirtualFCS.Control.PurgeValveControl\">Purge Valve Control</a></p><p class=\"MsoNormal\"><br></p><p class=\"MsoNormal\"><b>Description</b><o:p></o:p></p><p class=\"MsoNormal\">The compressed hydrogen from the hydrogen tank is depressurised to fuel cell operating pressure with the use of pressure regulator. The unreacted hydrogen is reintroduced to the fuel cell inlet using a recirculation blower. A simplified pruge strategy is also introduced. I<span style=\"font-size: 12px;\">f the fuel cell stack is turned on then the purge valve is opened at regular intervals predefined in the setPurgeValveState block.&nbsp;</span></p><div>The fluid ports connect to the hydrogen interfaces on the fuel cell stack, the electrical ports connect to the low-voltage power supply to provide power to the BoP components, and the control interface connects to the&nbsp;<a href=\"modelica://VirtualFCS.Control.FuelCellSystemControl\">Fuel Cell System Control</a>, which controls the&nbsp;<a href=\"modelica://\">Recirculation Blower</a>.</div><p class=\"MsoNormal\"><b><br></b></p><p class=\"MsoNormal\"><b>List of components</b></p><p class=\"MsoNormal\">The model comprises a hydrogen tank,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>,&nbsp;<a href=\"modelica://\">Recirculation Blower</a>, and a&nbsp;<a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a>linked to a fixed ambient boundary condition. The subsystem features 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port.&nbsp;</p></div></div></body></html>"));
end SubSystemHydrogenControl;
