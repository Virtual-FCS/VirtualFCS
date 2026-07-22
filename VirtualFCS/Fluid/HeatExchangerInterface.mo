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
    Icon(graphics = {Ellipse(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-100, 100}, {100, -100}}), Line(origin = {6, 0}, points = {{-106, 0}, {-66, 0}, {-36, 60}, {24, -60}, {54, 0}, {94, 0}}, thickness = 3), Text(extent={{-150,-100},{150,-150}}, textColor={0,0,255}, textString="%name")}));
    
        
end HeatExchangerInterface;
