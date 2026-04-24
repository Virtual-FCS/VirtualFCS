within VirtualFCS.Electrical;

model AveragedCommutator
  extends VirtualFCS.Electrical.AbstractCommutator;
  Modelica.Blocks.Interfaces.RealInput D(min=0, max=1) "Duty ratio" annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}})));
equation
  p1.v - n.v = (1-D)*(p2.v - n.v);
  p1.i+p2.i+n.i = 0;
  p2.i = -D*p1.i;
  LossPower = 0;
end AveragedCommutator;
