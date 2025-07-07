within VirtualFCS.Media;

function Shomate_h "Standard enthalpy deviation from 298.15 K"
  input Modelica.Units.SI.Temperature T;
  input ShomateParameters sh;
  output Modelica.Units.SI.MolarEnthalpy H;

protected
  Real t, h;

algorithm
  t := T/1000;
  h := sh.A*t + sh.B*t^2/2 + sh.C*t^3/3 + sh.D*t^4/4 - sh.E/t - H;
  H := h*1000;

end Shomate_h;
