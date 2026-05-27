within VirtualFCS.Electrochemical.Hydrogen;

model Manifold "Fuel cell manifold"
  extends Modelica.Fluid.Interfaces.PartialLumpedVolume(mXi(each stateSelect = StateSelect.always), U(stateSelect = StateSelect.always), 
    medium(h(stateSelect = StateSelect.avoid), T(stateSelect = StateSelect.avoid)), massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial);
  extends Modelica.Fluid.Interfaces.PartialTwoPort(showDesignFlowDirection=false);
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  
  parameter Modelica.Units.SI.Volume V = 1E-3 "Manifold total volume";
  parameter Real nu[Medium.nX] "Reaction stoichiometric coefficients";
  parameter Modelica.Units.SI.MolarMass MMs[Medium.nX] "Molar masses of components";

  Modelica.Blocks.Interfaces.RealInput r(final quantity="ReactionRate", final unit="mol/s") annotation(
    Placement(transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Units.SI.MassFlowRate productions[Medium.nX] = r * nu .* MMs "Mass production of medium species";
  
equation
  fluidVolume = V;
  mbXi_flow = semiLinear(port_a.m_flow, inStream(port_a.Xi_outflow), port_a.Xi_outflow)
          + semiLinear(port_b.m_flow, inStream(port_b.Xi_outflow), port_b.Xi_outflow)
          + productions[1:Medium.nXi];
  mb_flow = port_a.m_flow + port_b.m_flow + sum(productions);
  
  Wb_flow = 0; // No work exchanged
  Qb_flow = -LossPower;
  Hb_flow = semiLinear(port_a.m_flow, inStream(port_a.h_outflow), port_a.h_outflow)
        + semiLinear(port_b.m_flow, inStream(port_b.h_outflow), port_b.h_outflow);
  
  port_a.p = port_b.p; // No pressure drop
  port_a.p = medium.p;
  
  port_a.Xi_outflow = medium.Xi;
  port_b.Xi_outflow = medium.Xi;
  port_a.h_outflow = medium.h;
  port_b.h_outflow = medium.h;
  port_a.C_outflow = C;
  port_b.C_outflow = C;
  
  T_heatPort = medium.T;

annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Rectangle(origin = {-12, 12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( origin = {-6, 6},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {6, -6}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {12, -12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Line(origin = {13, -8}, points = {{15, 12}, {-15, 12}, {-15, 4}, {15, 4}, {15, -4}, {-15, -4}, {-15, -12}, {15, -12}, {15, -12}, {15, -12}, {15, -20}, {-15, -20}})}),
  Diagram(graphics));
end Manifold;
