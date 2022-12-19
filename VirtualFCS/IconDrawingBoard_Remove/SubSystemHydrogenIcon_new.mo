within VirtualFCS.IconDrawingBoard_Remove;

model SubSystemHydrogenIcon_new

equation

  annotation(
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1), graphics = {Text(origin = {-32, 90}, extent = {{-14, 4}, {22, -6}}, textString = "Pressure regulator"), Text(origin = {50, 14}, extent = {{-14, 4}, {22, -6}}, textString = "Recirculation blower")}),
    Icon(graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-78, 83}, textColor = {255, 255, 255}, extent = {{30, -23}, {128, -141}}, textString = "H2"), Text(origin = {-75, 64}, textColor = {255, 255, 255}, extent = {{-19, 10}, {29, -18}}, textString = "Control"), Text(origin = {-74, -57}, textColor = {255, 255, 255}, extent = {{-28, 7}, {36, -11}}, textString = "Sensors")}, coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The hydrogen sub system provides hydrogen to the<a href=\"modelica://\">&nbsp;</a><a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>.&nbsp;<br><div><br></div><div><br></div><div><div><br></div><div><b>References to base model/related packages</b></div><div><p class=\"MsoNormal\"><o:p></o:p></p><p class=\"MsoNormal\"><a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl\">Subsystem Hydrogen Control</a>, <a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>,&nbsp;and <a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a></p><p class=\"MsoNormal\"><br></p>

<p class=\"MsoNormal\"><b>Description</b><o:p></o:p></p>

<p class=\"MsoNormal\">The compressed hydrogen from the hydrogen tank is depressurised to fuel cell operating pressure with the use of pressure regulator. The unreacted hydrogen is reintroduced to the fuel cell inlet using a recirculation blower. A simplified pruge strategy is also introduced. I<span style=\"font-size: 12px;\">f the fuel cell stack is turned on then the purge valve is opened at regular intervals predefined in the setPurgeValveState block.&nbsp;</span></p><div>The fluid ports connect to the hydrogen interfaces on the fuel cell stack, the electrical ports connect to the low-voltage power supply to provide power to the BoP components, and the control interface connects to the&nbsp;<a href=\"modelica://VirtualFCS.Control.FuelCellSystemControl\">Fuel Cell System Control</a>, which controls the&nbsp;<a href=\"modelica://\">Recirculation Blower</a>.</div>

<p class=\"MsoNormal\"><b><br></b></p><p class=\"MsoNormal\"><b>List of components</b></p><p class=\"MsoNormal\">The model comprises a hydrogen tank, <a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>,&nbsp;<a href=\"modelica://\">Recirculation Blower</a>, and a <a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a> linked to a fixed ambient boundary condition. The subsystem features 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port.&nbsp;</p>

<p class=\"MsoNormal\"><o:p>&nbsp;</o:p></p>

<!--EndFragment--></div></div></body></html>"));
end SubSystemHydrogenIcon_new;
