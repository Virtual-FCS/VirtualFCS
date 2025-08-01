within VirtualFCS.Electrochemical.Hydrogen;

model MassTransportLoss
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  import Modelica.Math.log;
  import Modelica.Constants.R;
  import Modelica.Constants.F;
  
  constant Integer N = 2 "Number of electrons in reaction";
  parameter Modelica.Units.SI.Current i_limit "Limiting current";
  
equation
  v = R*T/(N*F) * log(i_limit/(i_limit-i));
  LossPower = v*i;

annotation(
    Diagram(graphics),
    Icon(graphics = {Line(points = {{-90, 0}, {-40, 0}}, color = {0, 0, 255}), Line(points = {{40, 0}, {90, 0}}, color = {0, 0, 255}), Ellipse(lineColor = {0, 0, 255},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-40, 40}, {40, -40}}), Line(origin = {40, 0}, points = {{0, 40}, {0, -40}, {0, -40}, {0, -40}}, color = {0, 0, 255}), Bitmap(extent = {{-78, 0}, {-78, 0}}), Text(extent = {{-150, 90}, {150, 50}}, textString = "%name", textColor = {0, 0, 255})}),
  Documentation(info = "<html><head></head><body>Mass transport loss implemented as loss of reversible potential.<div>This formulation has the advantage of requiring only one parameter, but it is far steeper than real concentration overpotential, since most of it is due to the reduction of the exchange current density in the catalyst loss term.</div><div>Also, different parts of the CL will have different thickness and thereby different limiting currents, effectively \"diffusing\" the effect which will not be as sudden.</div></body></html>"));
end MassTransportLoss;
