within VirtualFCS.Fluid;

model HumidifierInterface
  
  replaceable package dry_medium = Modelica.Media.Interfaces.PartialMedium "Dry gas (shell side)" annotation(
    choicesAllMatching = true);
  replaceable package wet_medium = Modelica.Media.Interfaces.PartialMedium "Wet side (fiber side)" annotation(
    choicesAllMatching = true);
  
  Modelica.Fluid.Interfaces.FluidPort_a portA_in(replaceable package Medium = wet_medium) annotation(
    Placement(transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a portB_in(replaceable package Medium = dry_medium) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b portA_out(replaceable package Medium = wet_medium) annotation(
    Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b portB_out(replaceable package Medium = dry_medium) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  
equation

annotation(
    Icon(graphics = {Rectangle(fillColor = {189, 189, 189}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}, radius = 30), Rectangle(origin = {-62, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 60}, {6, -60}}), Rectangle(origin = {62, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 60}, {6, -60}}), Line(origin = {0.2, 56}, points = {{-56, 0}, {56, 0}}), Line(origin = {0.2, -56}, points = {{-56, 0}, {56, 0}})}));
annotation(Documentation(info = "<html><p>Interface for humidifier components with separate air-side and hydrogen-side fluid ports.</p></html>"));
end HumidifierInterface;
