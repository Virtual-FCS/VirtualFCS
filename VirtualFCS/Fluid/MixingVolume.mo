within VirtualFCS.Fluid;

model MixingVolume "A lumped fixed volume"
  extends Modelica.Fluid.Interfaces.PartialLumpedVolume(mXi(each stateSelect = StateSelect.always), U(stateSelect = StateSelect.prefer), medium(h(stateSelect = StateSelect.avoid), T(stateSelect = StateSelect.avoid)), massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial);
  extends Modelica.Fluid.Interfaces.PartialTwoPort(showDesignFlowDirection = false);
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  parameter Modelica.Units.SI.Volume V = 1E-3 "Manifold total volume";
protected
  Modelica.Units.SI.MassFlowRate m_gen = 0 "Rate of overall mass generation";
  Modelica.Units.SI.MassFlowRate mXi_gen[Medium.nXi] = zeros(Medium.nXi) "Rate of generation of independent species";
public
equation
  fluidVolume = V;
  mbXi_flow = semiLinear(port_a.m_flow, inStream(port_a.Xi_outflow), port_a.Xi_outflow) + semiLinear(port_b.m_flow, inStream(port_b.Xi_outflow), port_b.Xi_outflow) + mXi_gen;
  mb_flow = port_a.m_flow + port_b.m_flow + m_gen;
  Wb_flow = 0 "No work exchanged";
  Qb_flow = -LossPower;
  Hb_flow = semiLinear(port_a.m_flow, inStream(port_a.h_outflow), port_a.h_outflow) + semiLinear(port_b.m_flow, inStream(port_b.h_outflow), port_b.h_outflow);
  port_a.p = port_b.p "No pressure drop";
  port_a.p = medium.p;
  port_a.Xi_outflow = medium.Xi;
  port_b.Xi_outflow = medium.Xi;
  port_a.h_outflow = medium.h;
  port_b.h_outflow = medium.h;
  port_a.C_outflow = C;
  port_b.C_outflow = C;
  T_heatPort = medium.T;
  annotation(
    Icon(graphics = {Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Ellipse(origin = {-40, -20}, lineThickness = 1, extent = {{-20, 20}, {20, -20}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Ellipse(origin = {40, -20}, lineThickness = 1, extent = {{-20, 20}, {20, -20}}, startAngle = 90, endAngle = -90, closure = EllipseClosure.None), Line(origin = {0, -20}, points = {{-40, 20}, {40, -20}}, thickness = 1), Line(origin = {0, -20}, points = {{40, 20}, {-40, -20}}, thickness = 1), Line(origin = {0, 21}, points = {{0, -39}, {0, 39}, {0, 39}}, thickness = 1)}),
    Diagram(graphics));
end MixingVolume;
