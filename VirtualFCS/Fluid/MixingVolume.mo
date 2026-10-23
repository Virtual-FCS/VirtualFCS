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
  Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
This class implements a fixed mixing volume with two non-directional flow ports and a conditional heat port.<div><br></div><div>The volume does not exchange work, but can exchange heat through the heatPort. The state of the internal holdup is described by the medium variable, whose properties are bound to the port pressure and outflow variables.</div><div><br></div><div>If the heatPort is inactive, the volume will be maintained at the constant temperature given by T; if heatPort is active, the temperature may vary, in particular adiabatically if nothing is connected to the heatPort.</div><div><b><br></b></div><div><b>Note </b>that T is a <i>parameter</i> inherited by ConditionalHeatPort: when the heatPort is active, its value is arbitrary and inconsequential. The temperature of the fluid in the volume is always given by medium.T, not just T.</div><div><br></div><div>A pressure drop is implemented with linear hydraulic resistance R_flow. Note that the outlet flow is not guaranteed to be the same as the inlet, so the average value is used.</div><div>The medium is assumed to be represented by the average of inlet and outlet pressure.</div><h3>Numerical stability note</h3><div>Please note that low values of R_flow can have destabilising numerical effects and induce singularities.</div>
<h2>Governing Equations</h2>
<pre>port_a.p - port_b.p = R_flow * (port_a.m_flow-port_b.m_flow)/2 \"Pressure drop proportional to average mass flow\";
medium.p = (port_a.p + port_b.p)/2;<br></pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>energyDynamics</code></td><td>Modelica.Fluid.Types.Dynamics</td><td>-</td><td><code>system.energyDynamics</code></td><td>Formulation of energy balance (inherited)</td></tr>
<tr><td><code>massDynamics</code></td><td>Modelica.Fluid.Types.Dynamics</td><td>-</td><td><code>Modelica.Fluid.Types.Dynamics.FixedInitial</code></td><td>Formulation of mass balance (inherited)</td></tr>
<tr><td><code>substanceDynamics</code></td><td>Modelica.Fluid.Types.Dynamics</td><td>-</td><td><code>massDynamics</code></td><td>Formulation of substance balance (inherited)</td></tr>
<tr><td><code>traceDynamics</code></td><td>Modelica.Fluid.Types.Dynamics</td><td>-</td><td><code>massDynamics</code></td><td>Formulation of trace substance balance (inherited)</td></tr>
<tr><td><code>p_start</code></td><td>Medium.AbsolutePressure</td><td>Pa</td><td><code>system.p_start</code></td><td>Start value of pressure (inherited)</td></tr>
<tr><td><code>use_T_start</code></td><td>Boolean</td><td>1</td><td><code>true</code></td><td>= true, use T_start, otherwise h_start (inherited)</td></tr>
<tr><td><code>T_start</code></td><td>Medium.Temperature</td><td>K</td><td><code>if use_T_start then system.T_start else Medium.temperature_phX(p_start, h_start, X_start)</code></td><td>Start value of temperature (inherited)</td></tr>
<tr><td><code>h_start</code></td><td>Medium.SpecificEnthalpy</td><td>J/kg</td><td><code>if use_T_start then Medium.specificEnthalpy_pTX(p_start, T_start, X_start) else Medium.h_default</code></td><td>Start value of specific enthalpy (inherited)</td></tr>
<tr><td><code>X_start</code></td><td>Medium.MassFraction[Medium.nX]</td><td>1</td><td><code>Medium.X_default</code></td><td>Start value of mass fractions m_i/m (inherited)</td></tr>
<tr><td><code>C_start</code></td><td>Medium.ExtraProperty[Medium.nC]</td><td>-</td><td><code>Medium.C_default</code></td><td>Start value of trace substances (inherited)</td></tr>
<tr><td><code>allowFlowReversal</code></td><td>Boolean</td><td>1</td><td><code>system.allowFlowReversal</code></td><td>= true to allow flow reversal, false restricts to design direction (port_a -&gt; port_b) (inherited)</td></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
<tr><td><code>V</code></td><td>Modelica.Units.SI.Volume</td><td>m3</td><td><code>1E-3</code></td><td>Manifold total volume</td></tr>
<tr><td><code>R_flow</code></td><td>Modelica.Fluid.Types.HydraulicResistance</td><td>-</td><td><code>1000</code></td><td>Resistance to mass flow</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>fluidVolume</code></td><td>Input signal</td><td>Modelica.Units.SI.Volume</td><td>m3</td><td>Volume</td></tr>
<tr><td><code>port_a</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>Fluid connector a (positive design flow direction is from port_a to port_b)</td></tr>
<tr><td><code>port_b</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Fluid connector b (positive design flow direction is from port_a to port_b)</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
</tbody></table>

</body></html>"));
end MixingVolume;
