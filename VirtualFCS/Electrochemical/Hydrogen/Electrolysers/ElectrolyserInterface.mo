within VirtualFCS.Electrochemical.Hydrogen.Electrolysers;

partial model ElectrolyserInterface
  import Modelica.Media.Interfaces.PartialMedium;

  replaceable package Cathode_Medium = PartialMedium constrainedby PartialMedium;
  replaceable package Anode_Medium = PartialMedium constrainedby PartialMedium;

  Modelica.Fluid.Interfaces.FluidPort_a port_anode_a(redeclare package Medium = Anode_Medium) annotation(

    Placement(transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_anode_b(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_cathode_a(redeclare package Medium = Cathode_Medium) annotation(
    Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_cathode_b(redeclare package Medium = Cathode_Medium) annotation(
    Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {60, 150}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-60, 150}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(transformation(origin = {0, -150}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}})));
  
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1), graphics = {Rectangle(origin = {80, 0}, fillColor = {0, 178, 227}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Rectangle(origin = {-80, 0}, fillColor = {170, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Rectangle(origin = {35, 54}, fillColor = {177, 177, 177}, fillPattern = FillPattern.Vertical, extent = {{-95, 26}, {25, -134}}), Text(origin = {-80, 0}, extent = {{-20, 20}, {20, -20}}, textString = "C"), Text(origin = {80, 0}, extent = {{-20, 20}, {20, -20}}, textString = "A")}),
  Documentation(info = "<html><head></head><body>This is a general interface for electrolyser classes of any technology.<div>Hydrogen is produced on the cathode and oxygen on the anode.</div><div>No hypothesis is made on the directionality of the flow connectors.</div><div><br></div><div>As several technologies such as PEM use feed water as coolant, no separate coolant loop is foreseen; child classes may implement it if required.</div></body></html>"));
end ElectrolyserInterface;
