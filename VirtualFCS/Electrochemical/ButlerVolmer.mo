within VirtualFCS.Electrochemical;

model ButlerVolmer
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  
  parameter Real alpha = 0.3419 "Charge transfer coefficient";
  parameter Integer N = 2 "Number of exchanged electrons";
  parameter Modelica.Units.SI.CurrentDensity i_0 "Exchange current, assumed constant";
  
equation
  i = i_0 * (exp(alpha*N*F*v/R/T_heatPort) - exp(-(1-alpha)*N*F*v/R/T_heatPort));
  LossPower = v*i;

annotation(
    Diagram(graphics),
    Icon(graphics = {Line(points = {{-90, 0}, {90, 0}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {-60, 20}}, color = {0, 0, 255}), Line(points = {{-70, 30}, {-70, 10}}, color = {0, 0, 255}), Line(points = {{60, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-50, 0}, {0, 50}, {50, 0}, {0, -50}, {-50, 0}}), Line(origin = {-4, 0}, points = {{-36, 0}, {36, 0}}, color = {0, 0, 255}), Line(origin = {20, 0}, points = {{0, 10}, {12, 0}, {0, -10}}, color = {0, 0, 255}), Text(textColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name")}));
annotation(Documentation(info = "<html><p>Butler-Volmer electrochemical reaction model relating activation overpotential to current density.</p></html>"));
end ButlerVolmer;
