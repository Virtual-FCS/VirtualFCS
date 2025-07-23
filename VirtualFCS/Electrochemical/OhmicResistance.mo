within VirtualFCS.Electrochemical;

model OhmicResistance "Ohmic resistance to proton flow through MEA"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  import Modelica.Math.exp;

  parameter Modelica.Units.SI.Resistance R_ref = 2E-3 "Resistance at temperature T_ref and full humidification";
  parameter Modelica.Units.SI.Temperature T_ref = 330 "Reference temperature";

  Modelica.Units.SI.Resistance R "Actual resistance";
  Modelica.Blocks.Interfaces.RealInput RH annotation(
    Placement(transformation(origin = {-104, 50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  R = R_ref*exp(1/T - 1/T_ref) / RH;
  v = R*i;
  LossPower = v*i;
  annotation(
    Documentation(info = "<html><head></head><body><p>This resistor implements a variable ohmic resistance as typically encountered in PEM fuel cells.</p><p>A reference value is usually provided by the manufacturer for a reference temperature, which is then corrected for temperature and relative humidity.</p><p></p><ul><li>From <a href=\"http://doi.org/10.1149/2.104203jes\">Yadav and Fedkiw</a>, temperature dependence of conductivity follows an Arrhenius relationship;</li><li>From <a href=\"https://doi.org/10.1016/j.electacta.2008.02.074\">Zhang et al.</a>&nbsp;conductivity is closely linear with relative humidity, meaning the actual resistance value is obtained dividing by RH.</li></ul><p>Relative humidity is provided with the custom input connector; temperature with the conditional heat port.</p><p>The default value for resistance <i>R<sub>ref</sub></i> is taken from Yadav and Fedkiw's typical value for Nafion 117 at 330 K, 0.1 S/cm. A thickness of 0.2 mm and and area of 100 cm<sup>2</sup> are then assumed, resulting in 2 m&Omega;.</p>
</body></html>"),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-70, 30}, {70, -30}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-90, 0}, {-70, 0}}, color = {0, 0, 255}), Line(points = {{70, 0}, {90, 0}}, color = {0, 0, 255}), Line(visible = useHeatPort, points = {{0, -100}, {0, -30}}, color = {127, 0, 0}, pattern = LinePattern.Dot), Text(extent = {{-150, 90}, {150, 50}}, textString = "%name", textColor = {0, 0, 255})}));
end OhmicResistance;
