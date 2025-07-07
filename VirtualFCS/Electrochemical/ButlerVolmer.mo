within VirtualFCS.Electrochemical;

model ButlerVolmer
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  
  parameter Real alpha = 0.3419 "Charge transfer coefficient";
  parameter Integer N = 2 "Number of exchanged electrons";
  parameter Modelica.Units.SI.Area A = 0.1 "Reaction area";
  
  Modelica.Units.SI.Temperature T "Reaction temperature";
  Modelica.Units.SI.CurrentDensity i_exchange "Exchange current density";
  Modelica.Units.SI.Voltage eta "Overvoltage";
  
equation
  i = i_exchange*A * (exp(alpha*N*F*eta/R/T) - exp(-(1-alpha)*N*F*eta/R/T));

annotation(
    Diagram(graphics),
    Icon(graphics = {Line(points = {{-90, 0}, {90, 0}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {-60, 20}}, color = {0, 0, 255}), Line(points = {{-70, 30}, {-70, 10}}, color = {0, 0, 255}), Line(points = {{60, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-50, 0}, {0, 50}, {50, 0}, {0, -50}, {-50, 0}}), Line(origin = {-4, 0}, points = {{-36, 0}, {36, 0}}, color = {0, 0, 255}), Line(origin = {20, 0}, points = {{0, 10}, {12, 0}, {0, -10}}, color = {0, 0, 255}), Text(textColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name")}));
end ButlerVolmer;
