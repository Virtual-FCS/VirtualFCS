within VirtualFCS.Electrochemical.Hydrogen;

model Manifold "Fuel cell manifold"
  extends Fluid.MixingVolume(m_gen = sum(productions), mXi_gen = productions[1:Medium.nXi]);
  
  parameter Real nu[Medium.nX] "Reaction stoichiometric coefficients";
  parameter Modelica.Units.SI.MolarMass MMs[Medium.nX] "Molar masses of components";

  Modelica.Blocks.Interfaces.RealInput r(final quantity="ReactionRate", final unit="mol/s") annotation(
    Placement(transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Units.SI.MassFlowRate productions[Medium.nX] = r * nu .* MMs "Mass production of medium species";
  
annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Rectangle(origin = {-12, 12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( origin = {-6, 6},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {6, -6}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {12, -12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Line(origin = {13, -8}, points = {{15, 12}, {-15, 12}, {-15, 4}, {15, 4}, {15, -4}, {-15, -4}, {-15, -12}, {15, -12}, {15, -12}, {15, -12}, {15, -20}, {-15, -20}})}),
  Diagram(graphics));
end Manifold;
