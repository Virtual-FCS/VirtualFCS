within VirtualFCS.Electrochemical.Hydrogen;

model Manifold "Fuel cell manifold"
  extends Modelica.Fluid.Interfaces.PartialLumpedVolume(mXi(each stateSelect = StateSelect.always), U(stateSelect = StateSelect.prefer), 
    medium(h(stateSelect = StateSelect.avoid), T(stateSelect = StateSelect.avoid)), massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial);
  extends Modelica.Fluid.Interfaces.PartialTwoPort(showDesignFlowDirection=false);
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  
  parameter Modelica.Units.SI.Volume V = 1E-3 "Manifold total volume";
  parameter Real nu[Medium.nX] = zeros(Medium.nX) "Reaction stoichiometric coefficients";
  parameter Modelica.Units.SI.MolarMass MMs[Medium.nX] = zeros(Medium.nX) "Molar masses of components";
  parameter Modelica.Fluid.Types.HydraulicResistance R_flow = 1000 "Resistance to mass flow";

  Modelica.Blocks.Interfaces.RealInput r(final quantity="ReactionRate", final unit="mol/s") annotation(
    Placement(transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Units.SI.MassFlowRate productions[Medium.nX] = r * nu .* MMs "Mass production of medium species";
  
equation
  fluidVolume = V;
  mbXi_flow = semiLinear(port_a.m_flow, inStream(port_a.Xi_outflow), port_a.Xi_outflow)
          + semiLinear(port_b.m_flow, inStream(port_b.Xi_outflow), port_b.Xi_outflow)
          + productions[1:Medium.nXi];
  mb_flow = port_a.m_flow + port_b.m_flow + sum(productions);
  
  Wb_flow = 0 "No work exchanged";
  Qb_flow = -LossPower;
  Hb_flow = semiLinear(port_a.m_flow, inStream(port_a.h_outflow), port_a.h_outflow)
        + semiLinear(port_b.m_flow, inStream(port_b.h_outflow), port_b.h_outflow);
  
  port_a.p - port_b.p = R_flow * (port_a.m_flow-port_b.m_flow)/2 "Pressure drop proportional to average mass flow";
  medium.p = (port_a.p + port_b.p)/2;

  
  port_a.Xi_outflow = medium.Xi;
  port_b.Xi_outflow = medium.Xi;
  port_a.h_outflow = medium.h;
  port_b.h_outflow = medium.h;
  port_a.C_outflow = C;
  port_b.C_outflow = C;
  
  T_heatPort = medium.T;

annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Rectangle(origin = {-12, 12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( origin = {-6, 6},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {6, -6}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Rectangle(origin = {12, -12}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Line(origin = {13, -8}, points = {{15, 12}, {-15, 12}, {-15, 4}, {15, 4}, {15, -4}, {-15, -4}, {-15, -12}, {15, -12}, {15, -12}, {15, -12}, {15, -20}, {-15, -20}})}),
  Diagram(graphics),
  Documentation(info = "<html><head></head><body>This class implements a finite volume of fluid that may be subject to a reaction.<div>It is similar to a CSTR (Continuously Stirred Tank Reactor), meaning it has only one representative temperature, pressure, and composition.</div><div><br></div><div>Manifold may misbehave if the reaction is not self-contained within it, as is the case when it is modelling e.g. a fuel cell cathode side. The reaction only removes matter, not energy - this is the task of the heatPort, which then must be connected to e.g. another Manifold for the anode side to make the energy balance work.</div><div><br></div><div>The molar masses of inputs are necessary only to multiply with stoichiometric coefficients, and if no reaction is foreseen they can be ignored; PartialMedium does not provide a generic way to return the molar mass of each substance, only the average one of the entire mixture.</div><div>It would be possible to use only one set of mass stoichiometric coefficients = nu .* MMs, but this was judged to hamper human readability.</div><div><br></div><div>A pressure drop is implemented with linear hydraulic resistance R_flow. Note that the outlet flow is not guaranteed to be the same as the inlet, so the average value is used.</div><div>The medium is assumed to be represented by the average of inlet and outlet pressure.</div><div><br></div><h3>Numerical stability note</h3><div>Please note that low values of R_flow can have destabilising numerical effects and induce singularities.</div></body></html>"));
end Manifold;
