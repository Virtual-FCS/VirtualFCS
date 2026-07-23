within VirtualFCS.Fluid;

partial model HeatExchangerInterface
  import Modelica.Media.Interfaces.PartialMedium;
  
  replaceable package Medium_1 = PartialMedium "Medium for exchanged side 1" annotation(choicesAllMatching = true);
  replaceable package Medium_2 = PartialMedium "Medium for exchanged side 2" annotation(choicesAllMatching = true);
  
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare final package Medium = Medium_1) annotation(
    Placement(transformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare final package Medium = Medium_1) annotation(
    Placement(transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare final package Medium = Medium_2) annotation(
    Placement(transformation(origin = {-100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare final package Medium = Medium_2) annotation(
    Placement(transformation(origin = {100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
  annotation(
    Icon(graphics = {Ellipse(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-100, 100}, {100, -100}}), Line(points = {{-100, 0}, {-40, 0}, {-20, 40}, {22, -40}, {40, 0}, {100, 0}}, thickness = 3), Text(origin = {-80, -80}, rotation = -45, textColor = {0, 0, 255}, extent = {{-60, 20}, {60, -20}}, textString = "%name"), Text(origin = {-100, 0}, extent = {{0, 40}, {40, 0}}, textString = "1"), Text(origin = {100, 0}, extent = {{-40, 0}, {0, -40}}, textString = "1"), Text(origin = {0, -100}, extent = {{-40, 40}, {0, 0}}, textString = "2"), Text(origin = {0, 100}, extent = {{0, 0}, {40, -40}}, textString = "2")}),
  Diagram(graphics));
end HeatExchangerInterface;
