within VirtualFCS.Electrochemical.Hydrogen;

model Manifold "Fuel cell manifold"
  extends Modelica.Fluid.Interfaces.PartialLumpedVolume;
  extends Modelica.Fluid.Interfaces.PartialTwoPort(showDesignFlowDirection=false);
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  
  // extend from interface? In/Out flow, reaction, Thermo flow...? --> Maybe later
  parameter Modelica.Units.SI.Volume V = 1E-3 "Manifold total volume";
  parameter Real nu[Medium.nX] "Reaction stoichiometric coefficients";
  parameter Modelica.Units.SI.MolarMass MMs[Medium.nX] "Molar masses of components";

  Modelica.Blocks.Interfaces.RealInput r(final quantity="ReactionRate", final unit="mol/s") annotation(
    Placement(transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Units.SI.MassFlowRate productions[Medium.nX] "Mass production of medium species";
  
  /* Must implement:
   * Where to get molar masses of components? -> Medium defines these (MMs)
   * Modify balance to implement reaction
   * Define T parameter if constant?
   */
equation
  fluidVolume = V;
  productions = r * nu .* MMs;

  // TODO
  LossPower = 0;
  mbXi_flow = zeros(Medium.nXi); // Material balance; only if nX > 1
  mb_flow = 0;
  Hb_flow = 0;

annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Rectangle(origin = {-12, 12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( origin = {-6, 6},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {6, -6}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {12, -12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Line(origin = {13, -8}, points = {{15, 12}, {-15, 12}, {-15, 4}, {15, 4}, {15, -4}, {-15, -4}, {-15, -12}, {15, -12}, {15, -12}, {15, -12}, {15, -20}, {-15, -20}})}),
  Diagram(graphics));
end Manifold;
