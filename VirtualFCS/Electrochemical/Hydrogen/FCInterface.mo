within VirtualFCS.Electrochemical.Hydrogen;

partial model FCInterface
  replaceable package Cathode_Medium = Media.CathodeAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Coolant_Medium = Modelica.Media.Incompressible.Examples.Glycol47;
  
  Modelica.Fluid.Interfaces.FluidPort_b anode_out(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a anode_in(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a cathode_in(redeclare package Medium = Cathode_Medium) annotation(
    Placement(transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b cathode_out(redeclare package Medium = Cathode_Medium) annotation(
    Placement(transformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {60, 150}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-60, 150}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(transformation(origin = {0, -150}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a coolant_in(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {-90, -110}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b coolant_out(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {90, -110}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}})));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1), graphics = {Line(origin = {20.1754, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {80, 0}, fillColor = {0, 178, 227}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Line(origin = {40.1315, 2}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {0.219199, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {-40.0001, 1.61404}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {-80, 0}, fillColor = {170, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Text(origin = {10, -54}, lineColor = {255, 0, 0}, extent = {{-11, 6}, {11, -6}}, textString = "K"), Line(origin = {-20.0439, -0.307018}, points = {{0, 80}, {0, -80}, {0, -80}}), Rectangle(origin = {35, 54}, fillColor = {177, 177, 177}, fillPattern = FillPattern.Vertical, extent = {{-95, 26}, {25, -134}}), Text(origin = {-80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "A"), Text(origin = {80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "C")}));
end FCInterface;
