within VirtualFCS.Electrochemical.Hydrogen;

model Manifold "Fuel cell manifold"
  extends Fluid.MixingVolume(
    mbXi_flow = semiLinear(port_a.m_flow, inStream(port_a.Xi_outflow), port_a.Xi_outflow) + semiLinear(port_b.m_flow, inStream(port_b.Xi_outflow), port_b.Xi_outflow) + productions[1:Medium.nXi],
    mb_flow = port_a.m_flow + port_b.m_flow + sum(productions));
  
  parameter Real nu[Medium.nX] "Reaction stoichiometric coefficients";
  parameter Modelica.Units.SI.MolarMass MMs[Medium.nX] "Molar masses of components";

  Modelica.Blocks.Interfaces.RealInput r(final quantity="ReactionRate", final unit="mol/s") annotation(
    Placement(transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Units.SI.MassFlowRate productions[Medium.nX] = r * nu .* MMs "Mass production of medium species";
  
annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Rectangle(origin = {-12, 12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( origin = {-6, 6},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {6, -6}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {12, -12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Line(origin = {13, -8}, points = {{15, 12}, {-15, 12}, {-15, 4}, {15, 4}, {15, -4}, {-15, -4}, {-15, -12}, {15, -12}, {15, -12}, {15, -12}, {15, -20}, {-15, -20}})}),
  Diagram(graphics),
  Documentation(info = "<html><head></head><body>This is a specialisation of MixingVolume that implements chemical reactions.<div>The rate of reaction [mol/s] is provided by the r input; this modifies the holdup of each species depending on their stoichiometric coefficient nu and molar masses MMs.</div><div><br></div><div><b>Note </b>that there is no enforcement that the stoichiometric coefficients are balanced: if the reaction is not balanced, the Manifold <i>must</i>&nbsp;be either:</div><div><ul><li>Set to zero reaction rate, or</li><li>Have the heatPort deactivated so that temperature is set to parameter T, or</li><li>Be connected through the heatPort to another Manifold with the same reaction rate and whose stoichiometry balances the first one.</li></ul><div>The last case is the one implemented e.g. in fuel cells between anode and cathode.</div></div><div><br></div><div>An unbalanced reaction occuring in isolation is not a physically meaningful model, and will produce nonsensical results, typically with extremely high or low temperatures, often leading to numerical crashes.</div></body></html>"));
end Manifold;
