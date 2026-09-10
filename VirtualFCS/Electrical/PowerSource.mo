within VirtualFCS.Electrical;

model PowerSource

  extends Modelica.Electrical.Analog.Interfaces.TwoPin;
  extends Modelica.Electrical.Analog.Icons.VoltageSource;
  Modelica.Blocks.Interfaces.RealInput P annotation(
    Placement(transformation(origin = {-4, -100}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {10, -64}, extent = {{-14, -14}, {14, 14}})));
    
  protected
  Real v "Voltage across component";
  Real i "Current from p to n";

  equation
    // Pin currents
    p.i = i;
    n.i = -i;

    // Constant power relation
    P = v*i;

annotation(Documentation(info = "<html><p>Electrical source component providing a prescribed power input through a voltage and current interface.</p></html>"));
end PowerSource;
