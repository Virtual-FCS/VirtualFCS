within VirtualFCS.Fluid;

model MixingVolume "A lumped fixed volume"
  extends Modelica.Fluid.Interfaces.PartialLumpedVolume(
    mXi(each stateSelect = StateSelect.always), 
    U(stateSelect = StateSelect.prefer), 
    medium(h(stateSelect = StateSelect.avoid), T(stateSelect = StateSelect.avoid)), 
    massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    Qb_flow = -LossPower,
    Wb_flow = 0,
    fluidVolume = V,
    mbXi_flow = semiLinear(port_a.m_flow, inStream(port_a.Xi_outflow), port_a.Xi_outflow) + semiLinear(port_b.m_flow, inStream(port_b.Xi_outflow), port_b.Xi_outflow),
    mb_flow = port_a.m_flow + port_b.m_flow,
    Hb_flow = semiLinear(port_a.m_flow, inStream(port_a.h_outflow), port_a.h_outflow) + semiLinear(port_b.m_flow, inStream(port_b.h_outflow), port_b.h_outflow)
    );
  extends Modelica.Fluid.Interfaces.PartialTwoPort(showDesignFlowDirection = false);
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  
  parameter Modelica.Units.SI.Volume V = 1E-3 "Manifold total volume";
  parameter Modelica.Fluid.Types.HydraulicResistance R_flow = 1000 "Resistance to mass flow";

equation
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
    Icon(graphics = {Rectangle( fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Ellipse(origin = {-40, -20}, lineThickness = 1, extent = {{-20, 20}, {20, -20}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Ellipse(origin = {40, -20}, lineThickness = 1, extent = {{-20, 20}, {20, -20}}, startAngle = 90, endAngle = -90, closure = EllipseClosure.None), Line(origin = {0, -20}, points = {{-40, 20}, {40, -20}}, thickness = 1), Line(origin = {0, -20}, points = {{40, 20}, {-40, -20}}, thickness = 1), Line(origin = {0, 21}, points = {{0, -39}, {0, 39}, {0, 39}}, thickness = 1)}),
    Diagram(graphics),
  Documentation(info = "<html><head></head><body>This class implements a fixed mixing volume with two non-directional flow ports and a conditional heat port.<div><br></div><div>The volume does not exchange work, but can exchange heat through the heatPort. The state of the internal holdup is described by the medium variable, whose properties are bound to the port pressure and outflow variables.</div><div><br></div><div>If the heatPort is inactive, the volume will be maintained at the constant temperature given by T; if heatPort is active, the temperature may vary, in particular adiabatically if nothing is connected to the heatPort.</div><div><b><br></b></div><div><b>Note </b>that T is a <i>parameter</i> inherited by ConditionalHeatPort: when the heatPort is active, its value is arbitrary and inconsequential. The temperature of the fluid in the volume is always given by medium.T, not just T.</div><div><br></div><div>A pressure drop is implemented with linear hydraulic resistance R_flow. Note that the outlet flow is not guaranteed to be the same as the inlet, so the average value is used.</div><div>The medium is assumed to be represented by the average of inlet and outlet pressure.</div><h3>Numerical stability note</h3><div>Please note that low values of R_flow can have destabilising numerical effects and induce singularities.</div></body></html>"));
end MixingVolume;
