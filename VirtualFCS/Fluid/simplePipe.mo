within VirtualFCS.Fluid;

model simplePipe "A simple 0D pipe with mass and heat transfer"
  extends Fluid.PipeInterface;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choicesAllMatching = true);
  outer Modelica.Units.SI.Temperature T_water_in "Input for the simple PipeCoolant";
equation
// Mass balance
  0 = port_a.m_flow + port_b.m_flow;
// No pressure losses
  port_b.p = port_a.p;
// Species transport
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
// Enthalpy update with heat input
  port_b.h_outflow = inStream(port_a.h_outflow) + (if port_a.m_flow > 0 then heat_port.Q_flow/max(port_a.m_flow, 1e-6) else 0);
  port_a.h_outflow = inStream(port_b.h_outflow) + (if port_b.m_flow > 0 then heat_port.Q_flow/max(port_b.m_flow, 1e-6) else 0);
// Estimated heat port temperature from coolant inlet temperature, which defines how much heat is dissipated here
  heat_port.T = T_water_in;
  annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2>Interface is inherited.&nbsp;<br><h2>2. Model description</h2><p>Simple zero-dimensional pipe model with fluid mass and heat transfer between its two fluid ports.</p><p>The heat-port temperature is estimated from the coolant inlet temperature; the low-flow enthalpy expression uses a small numerical flow threshold.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>0 = port_a.m_flow + port_b.m_flow;
port_b.p = port_a.p;
port_b.Xi_outflow = inStream(port_a.Xi_outflow);
port_a.Xi_outflow = inStream(port_b.Xi_outflow);
port_b.h_outflow = inStream(port_a.h_outflow) + (if port_a.m_flow &gt; 0 then heat_port.Q_flow / max(port_a.m_flow, 1e-6) else 0);
port_a.h_outflow = inStream(port_b.h_outflow) + (if port_b.m_flow &gt; 0 then heat_port.Q_flow / max(port_b.m_flow, 1e-6) else 0);
heat_port.T = T_water_in;</pre><h2>4. Outputs</h2><p>Outputs is inherited.&nbsp;</p></body></html>"));
end simplePipe;
