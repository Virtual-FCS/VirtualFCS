within VirtualFCS.Media;

function Shomate_s "Standard entropy"
  input Modelica.Units.SI.Temperature T;
  input ShomateParameters sh;
  output Modelica.Units.SI.MolarEntropy s;

protected
  Real t;

algorithm
  t := T/1000;
  s := sh.A*log(t) + sh.B*t + sh.C*t^2/2 + sh.D*t^3/3 - sh.E/(2*t^2) + G;

end Shomate_s;
