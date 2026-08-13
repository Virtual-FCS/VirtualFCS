within VirtualFCS.Fluid;

partial model PSAInterface

import Modelica.Media.Interfaces.PartialMedium;
  
  replaceable package Medium_1 = PartialMedium "Medium for inlet" annotation(choicesAllMatching = true);
  replaceable package Medium_2 = PartialMedium "Medium for purified gas outlet" annotation(choicesAllMatching = true);
  replaceable package Medium_3 = PartialMedium "Medium for other gases outlet" annotation(choicesAllMatching = true);
  
  Modelica.Fluid.Interfaces.FluidPort_a feed(redeclare final package Medium = Medium_1) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-24, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b product(redeclare final package Medium = Medium_2) annotation(
    Placement(transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b tail(redeclare final package Medium = Medium_3) annotation(
    Placement(transformation(origin = {100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {20, -100}, extent = {{-10, -10}, {10, 10}})));
  annotation(
    Icon(graphics = {Text(origin = {1, 1}, rotation = 315, textColor = {0, 0, 255}, extent = {{-62, 16}, {62, -16}}, textString = "%name"), Text(origin = {-38, -92}, extent = {{0, 26}, {28, 0}}, textString = "1"), Rectangle(extent = {{-40, 90}, {40, -90}}), Text(origin = {-38, -92}, extent = {{0, 26}, {28, 0}}, textString = "1"), Text(origin = {-38, -92}, extent = {{0, 26}, {28, 0}}, textString = "1"), Text(origin = {-14, 66}, extent = {{0, 26}, {28, 0}}, textString = "2"), Text(origin = {6, -92}, extent = {{0, 26}, {28, 0}}, textString = "3")}),
  Diagram(graphics),
  Documentation(info = "<html><head></head><body>This is a generic interface for a pressure swing adsorption unit, with an inlet port_a and two outlet ports port_b{1,2}) and 3 mediums (Medium_{1,2,3}).<div> The ports are assigned to different mediums although ideally a single mixture medium could/should be used when extended. This approach is chosen to give flexibility in case e.g. the outlet port needs to be assigned to a single-phase medium for use in downstream models.</div></body></html>"));

end PSAInterface;
