within VirtualFCS.Media;

function Shomate_Cp "Molar heat capacity"
  input Modelica.Units.SI.Temperature T;
  input ShomateParameters sh;
  output Modelica.Units.SI.MolarHeatCapacity cp;
  
protected
  Real t;

algorithm
  t := T/1000;
  cp := sh.A + sh.B*t + sh.C*t^2 + sh.D*t^3 + sh.E/t^2;

end Shomate_Cp;
