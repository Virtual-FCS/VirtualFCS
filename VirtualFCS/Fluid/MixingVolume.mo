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
  Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below. Units are explicit; <code>1</code> denotes a dimensionless quantity.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>V</code></td><td>Modelica.Units.SI.Volume</td><td>m3</td><td>1E-3</td><td>Manifold total volume</td></tr>
<tr><td><code>R_flow</code></td><td>Modelica.Fluid.Types.HydraulicResistance</td><td>-</td><td>1000</td><td>Resistance to mass flow</td></tr></tbody></table><h2>2. Model description</h2>This class implements a fixed mixing volume with two non-directional flow ports and a conditional heat port.<div><br></div><div>The volume does not exchange work, but can exchange heat through the heatPort. The state of the internal holdup is described by the medium variable, whose properties are bound to the port pressure and outflow variables.</div><div><br></div><div>If the heatPort is inactive, the volume will be maintained at the constant temperature given by T; if heatPort is active, the temperature may vary, in particular adiabatically if nothing is connected to the heatPort.</div><div><b><br></b></div><div><b>Note </b>that T is a <i>parameter</i> inherited by ConditionalHeatPort: when the heatPort is active, its value is arbitrary and inconsequential. The temperature of the fluid in the volume is always given by medium.T, not just T.</div><div><br></div><div>A pressure drop is implemented with linear hydraulic resistance R_flow. Note that the outlet flow is not guaranteed to be the same as the inlet, so the average value is used.</div><div>The medium is assumed to be represented by the average of inlet and outlet pressure.</div><h3>Numerical stability note</h3><div>Please note that low values of R_flow can have destabilising numerical effects and induce singularities.</div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>port_a.p - port_b.p = R_flow * (port_a.m_flow-port_b.m_flow)/2 \"Pressure drop proportional to average mass flow\";
medium.p = (port_a.p + port_b.p)/2;
port_a.Xi_outflow = medium.Xi;
port_b.Xi_outflow = medium.Xi;
port_a.h_outflow = medium.h;
port_b.h_outflow = medium.h;
port_a.C_outflow = C;
port_b.C_outflow = C;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end MixingVolume;
