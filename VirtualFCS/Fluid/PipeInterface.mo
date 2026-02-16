within VirtualFCS.Fluid;

partial model PipeInterface

    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
      choicesAllMatching = true);
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat_port annotation(
    Placement(transformation(origin = {2, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {2, -26}, extent = {{-10, -10}, {10, 10}})));
    annotation(
      Icon(graphics = {Line(origin = {9.23735, 20.3651}, points = {{-50, 0}, {40, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 10), Rectangle(origin = {0, -2}, fillColor = {200, 195, 191}, fillPattern = FillPattern.Solid, extent = {{-88, 14}, {88, -14}})}),
      Documentation(info = "<html><head></head><body>This partial class defines the interfaces of a compressor unit, for flow, power supply (assumed DC), heat exchange (in case of fully isentropic operation,&nbsp;</body></html>"));


end PipeInterface;
