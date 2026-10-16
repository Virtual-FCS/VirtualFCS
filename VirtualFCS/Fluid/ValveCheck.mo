within VirtualFCS.Fluid;

model ValveCheck
extends Modelica.Fluid.Interfaces.PartialTwoPortTransport(allowFlowReversal = false, show_T = false, show_V_flow = false, m_flow_start = 0, dp_start = 0);
    parameter Medium.MassFlowRate m_flow_nominal = 0.05;
    parameter Medium.AbsolutePressure dp_nominal = 3e4;
    parameter Modelica.Units.SI.Pressure dp_smooth = 10;
    Modelica.Units.SI.Pressure dp_forward;
  equation
    dp_forward = smooth(1, noEvent(if dp <= 0 then 0 else if dp < dp_smooth then dp*dp/(2*dp_smooth) else dp - dp_smooth/2));
    m_flow = m_flow_nominal/dp_nominal*dp_forward;
    port_a.h_outflow = inStream(port_b.h_outflow);
    port_b.h_outflow = inStream(port_a.h_outflow);


annotation(
    Documentation(info = "<html><head></head><body>
<h2>1. Parameters and inputs</h2>
<p>The valve inherits its replaceable Medium package and fluid interfaces from Modelica.Fluid.Interfaces.PartialTwoPortTransport.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>m_flow_nominal</code></td><td>Medium.MassFlowRate</td><td>kg/s</td><td>0.05</td><td>Reference flow used with dp_nominal to define forward conductance</td></tr>
<tr><td><code>dp_nominal</code></td><td>Medium.AbsolutePressure</td><td>Pa</td><td>3e4</td><td>Reference pressure difference used to scale forward conductance</td></tr>
<tr><td><code>dp_smooth</code></td><td>Modelica.Units.SI.Pressure</td><td>Pa</td><td>10</td><td>Width of the smooth transition from closed to forward-conducting operation</td></tr>
</tbody></table>
<h3>Inputs and input-side interfaces</h3>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>port_a</code></td><td>Inlet</td><td>FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>Upstream fluid connection; forward flow is from port_a to port_b</td></tr>
</tbody></table>
<p>No signal input or opening command is required. The pressure difference across the fluid ports determines the flow. Use positive m_flow_nominal, dp_nominal, and dp_smooth.</p>
<h2>2. Model description</h2>
<p>ValveCheck is a passive, idealized non-return valve for system-level fluid models. It permits forward flow when the inlet pressure exceeds the outlet pressure and blocks flow when the pressure difference is zero or negative. There is no reverse leakage, fluid storage, actuator dynamics, or opening hysteresis.</p>
<p>The forward characteristic is linear away from zero pressure difference, with a quadratic transition near closure. The transition gives a continuous first derivative at both ends and suppresses state events associated with switching between the flow-law branches. The default inherited setting allowFlowReversal = false is consistent with the one-way characteristic.</p>
<p>The valve transports stream enthalpy without adding heat or shaft work. Composition and trace-substance transport are supplied by the inherited two-port transport equations. This is a conductance model, not a compressible-orifice model with choking or density-dependent flow.</p>
<h2>3. Governing equations and references</h2>
<p>The pressure difference is dp = port_a.p - port_b.p. The effective forward pressure difference and mass flow are:</p>
<pre>dp_forward = 0                              for dp &lt;= 0
dp_forward = dp^2/(2*dp_smooth)              for 0 &lt; dp &lt; dp_smooth
dp_forward = dp - dp_smooth/2               for dp &gt;= dp_smooth
m_flow = (m_flow_nominal/dp_nominal)*dp_forward
port_a.m_flow + port_b.m_flow = 0
port_a.h_outflow = inStream(port_b.h_outflow)
port_b.h_outflow = inStream(port_a.h_outflow)</pre>
<p>The piecewise expression is wrapped in smooth(1, noEvent(...)). The smoothing introduces a pressure offset of dp_smooth/2 in the linear branch; consequently m_flow_nominal is a conductance reference, not the exact flow at dp = dp_nominal. There is no finite pressure threshold: any positive dp produces positive flow.</p>
<p>See <a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPortTransport\">Modelica.Fluid.Interfaces.PartialTwoPortTransport</a> for inherited connector conventions, mass conservation, and species transport.</p>
<h2>4. Outputs</h2>
<p>No signal output connectors are declared. The outlet and diagnostic variables are available for connection or result inspection.</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>port_b</code></td><td>Outlet</td><td>FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Downstream fluid connection</td></tr>
<tr><td><code>m_flow</code></td><td>Monitored variable</td><td>Medium.MassFlowRate</td><td>kg/s</td><td>Inherited mass flow, equal to port_a.m_flow and nonnegative for positive parameter values</td></tr>
<tr><td><code>dp</code></td><td>Monitored variable</td><td>Medium.Pressure</td><td>Pa</td><td>Inherited inlet-to-outlet pressure difference</td></tr>
<tr><td><code>dp_forward</code></td><td>Monitored variable</td><td>Modelica.Units.SI.Pressure</td><td>Pa</td><td>Smoothed, nonnegative pressure difference used in the forward flow law</td></tr>
</tbody></table>
</body></html>"),
    Icon(graphics = {Line(points = {{0, 50}, {0, 0}}), Rectangle(fillPattern = FillPattern.Solid, extent = {{-20, 60}, {20, 50}}), Polygon(fillColor = DynamicSelect({255, 255, 255}, {255, 255, 255}), fillPattern = FillPattern.Solid, points = {{-100, 50}, {100, -50}, {100, 50}, {0, 0}, {-100, -50}, {-100, 50}})}));
end ValveCheck;
