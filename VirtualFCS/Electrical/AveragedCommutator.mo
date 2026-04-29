within VirtualFCS.Electrical;

model AveragedCommutator
  extends VirtualFCS.Electrical.AbstractCommutator;
  Modelica.Blocks.Interfaces.RealInput D(min=0, max=1) "Duty ratio" annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}})));
equation
  p1.v - n.v = (1 - D)*(p2.v - n.v);
  p1.i + p2.i + n.i = 0;
// Charge balance
  n.i = -D*p1.i;
// Current fraction going straight back to source
  LossPower = 0;
  annotation(
    Documentation(info = "<html><head></head><body>An averaged commutator for boost converters. The unit is implemented completely in code.<div>The equations state that, given an input duty ratio <i>D</i>:</div><div><ul><li>The input voltage is <i>(1-D)</i> times the output voltage;</li><li>The sum of entering currents is zero;</li><li>The current exiting from the negative pin is <i>D</i> times the input positive pin;</li><li>No power dissipation occurs.</li></ul></div></body></html>"));end AveragedCommutator;
