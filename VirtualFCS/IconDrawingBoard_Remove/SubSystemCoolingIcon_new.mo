within VirtualFCS.IconDrawingBoard_Remove;

model SubSystemCoolingIcon_new
  
equation

  annotation(
    experiment(StopTime = 50),
    __Dymola_Commands(file = "modelica://Modelica/Resources/Scripts/Dymola/Fluid/EmptyTanks/plot level and port.p.mos" "plot level and port.p"),
    Documentation(info = "<html><head></head><body><span style=\"font-family: Arial; font-size: large;\">The SubSystemCooling model provides a template for the construction of a cooling sub-system for the fuel cell stack.&nbsp;</span><br><div><div><span lang=\"NO-BOK\"><font face=\"Arial\" size=\"4\"><br></font></span></div>

<p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\"><b>References to base model/related packages</b><o:p></o:p></font></p><p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\">&nbsp;</font><a href=\"modelica://VirtualFCS.Thermal.HeatSink\" style=\"font-family: Arial; font-size: large;\">Heat Sink</a><span style=\"font-family: Arial; font-size: large;\">,&nbsp;</span><a href=\"modelica://VirtualFCS.Fluid.PumpElectricDC\" style=\"font-family: Arial; font-size: large;\">DC Pump</a><span style=\"font-family: Arial; font-size: large;\">&nbsp;and&nbsp;</span><a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCoolingControl\" style=\"font-family: Arial; font-size: large;\">Cooling Subsystem Control</a><font face=\"Arial\" size=\"4\">&nbsp;</font></p>

<p class=\"MsoNormal\"><span style=\"font-family: Arial; font-size: large;\">&nbsp;</span></p>

<p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\"><b>Description&nbsp;</b></font></p><p class=\"MsoNormal\"><span style=\"font-family: Arial; font-size: large;\">The subsystem features 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports connect to the cooling interfaces on the fuel cell stack, the electrical ports connect to the low-voltage power supply to provide power to the BoP components, and the control interface connects to the FuelCellControlUnit, which controls the pump, pre-heater, and heat sink.</span></p><p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\"><br></font></p><p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\"><b>List of components<o:p></o:p></b></font></p>

<p class=\"MsoNormal\"><o:p><font face=\"Arial\" size=\"4\">The model comprises a <a href=\"modelica://Modelica.Fluid.Vessels.OpenTank\">Coolant Tank</a>, </font><a href=\"modelica://VirtualFCS.Thermal.HeatSink\" style=\"font-family: Arial; font-size: large;\">Heat Sink</a><span style=\"font-family: Arial; font-size: large;\">,&nbsp;</span><a href=\"modelica://VirtualFCS.Fluid.PumpElectricDC\" style=\"font-family: Arial; font-size: large;\">DC Pump</a><span style=\"font-family: Arial; font-size: large;\">&nbsp;and&nbsp;</span><a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCoolingControl\" style=\"font-family: Arial; font-size: large;\">Cooling Subsystem Control</a><font face=\"Arial\" size=\"4\">&nbsp;</font></o:p></p>

<p class=\"MsoNormal\"><o:p><font face=\"Arial\" size=\"4\">&nbsp;</font></o:p></p>

<!--EndFragment--></div></body></html>"),
    Icon(graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {9, -11}, lineColor = {255, 255, 255}, extent = {{-81, 89}, {65, -55}}, textString = "Cool")}, coordinateSystem(initialScale = 0.1)),
    Diagram(graphics = {Text(origin = {35, 0}, extent = {{-19, 4}, {15, -2}}, textString = "Pump")}, coordinateSystem(initialScale = 0.1)));
end SubSystemCoolingIcon_new;
