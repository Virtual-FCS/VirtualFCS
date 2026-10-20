within VirtualFCS.Fluid;

partial model PSAInterface

import Modelica.Media.Interfaces.PartialMedium;
  
  replaceable package Medium_feed = PartialMedium "Medium for inlet" annotation(choicesAllMatching = true);
  replaceable package Medium_product = PartialMedium "Medium for purified gas outlet" annotation(choicesAllMatching = true);
  replaceable package Medium_tail = PartialMedium "Medium for other gases outlet" annotation(choicesAllMatching = true);
  
  Modelica.Fluid.Interfaces.FluidPort_a feed(redeclare final package Medium = Medium_feed) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b product(redeclare final package Medium = Medium_product) annotation(
    Placement(transformation(origin = {100, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b tail(redeclare final package Medium = Medium_tail) annotation(
    Placement(transformation(origin = {100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {20, -100}, extent = {{-10, -10}, {10, 10}})));
  annotation(
    Icon(graphics = {Text(origin = {1, -5}, rotation = 315, textColor = {0, 0, 255}, extent = {{-62, 16}, {62, -16}}, textString = "%name"), Rectangle(extent = {{-40, 90}, {40, -90}}), Text(origin = {-68, -68}, extent = {{0, 26}, {28, 0}}, textString = "feed"), Text(origin = {-16, 72}, extent = {{0, 28}, {32, 0}}, textString = "product"), Text(origin = {4, -92}, extent = {{0, 18}, {30, 0}}, textString = "tail"), Line(origin = {0.34, 54.64}, points = {{-40, 0}, {40, 0}}, pattern = LinePattern.Dash), Line(origin = {0.34, -47.81}, points = {{-40, 0}, {40, 0}}, pattern = LinePattern.Dash), Line(origin = {-30.256, 74.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-18.256, 74.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-6.256, 74.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {5.744, 74.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {17.744, 74.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {29.744, 74.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-30.256, 62.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-18.256, 62.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-6.256, 62.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {5.744, 62.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {17.744, 62.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {29.744, 62.186}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-30.102, -57.814}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-18.102, -57.814}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-6.10204, -57.814}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {5.744, -57.814}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {17.744, -57.814}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {29.744, -57.814}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-30.102, -71.968}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-18.102, -71.968}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {-6.10204, -71.968}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {5.744, -71.968}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {17.744, -71.968}, points = {{3, 3}, {-3, -3}, {-3, -3}}), Line(origin = {29.744, -71.968}, points = {{3, 3}, {-3, -3}, {-3, -3}})}),
  Diagram(graphics),
  Documentation(info = "<html><head></head><body>This is a generic interface for a pressure swing adsorption unit, with an inlet port_a and two outlet ports port_b{1,2}) and 3 mediums (Medium_{1,2,3}).<div> The ports are assigned to different mediums although ideally a single mixture medium could/should be used when extended. This approach is chosen to give flexibility in case e.g. the outlet port needs to be assigned to a single-phase medium for use in downstream models.</div></body></html>"));

end PSAInterface;
