within VirtualFCS.Fluid;

model SimplePump "A simple isentropic compressor"
  extends Fluid.PumpInterface(final useHeatPort = false, redeclare Modelica.Blocks.Interfaces.RealInput u(unit = "kg/s"));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choicesAllMatching = true);
  parameter Real eta_is = 0.8 "Isentropic efficiency of the pump";
  Medium.BaseProperties medium_in, medium_out "Medium properties at inlet and outlet";
  Modelica.Units.SI.Power power "The power consumed by the pump";
equation
// All compositions are equal
  medium_in.Xi = port_a.Xi_outflow;
  medium_in.Xi = inStream(port_a.Xi_outflow);
  medium_in.Xi = medium_out.Xi;
  medium_out.Xi = port_b.Xi_outflow;
// Bind inlet/outlet pressures
  medium_in.p = port_a.p;
  medium_out.p = port_b.p;
// No-holdup model
  port_a.m_flow + port_b.m_flow = 0;
  u = port_a.m_flow;
// Calculate T_in from enthalpy
  medium_in.T = Medium.temperature_phX(medium_in.p, inStream(port_a.h_outflow), medium_in.X);
// Assume isothermal pump
  medium_out.T = medium_in.T;
// Not supposed to be ever used
  port_a.h_outflow = Medium.specificEnthalpy_pTX(port_a.p, medium_in.T, medium_in.X);
  port_b.h_outflow = Medium.specificEnthalpy_pTX(port_b.p, medium_out.T, medium_out.X);
// heatPort not used
  LossPower = 0;
// Power is equal volumetric flow times pressure difference
  power = (pin_p.v - pin_n.v)*(pin_p.i);
  power = (u/medium_out.d)*(port_b.p - port_a.p)/eta_is;
  pin_p.i + pin_n.i = 0;
  annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>eta_is</code></td><td>Real</td><td>1</td><td>0.8</td><td>Isentropic efficiency of the pump</td></tr></tbody></table><h2>2. Model description</h2><p>Simplified electrically driven pump with an isentropic efficiency relation between fluid pressure rise, volumetric flow, and electrical power.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>medium_in.Xi = port_a.Xi_outflow;
medium_in.Xi = inStream(port_a.Xi_outflow);
medium_in.Xi = medium_out.Xi;
medium_out.Xi = port_b.Xi_outflow;
medium_in.p = port_a.p;
medium_out.p = port_b.p;
port_a.m_flow + port_b.m_flow = 0;
u = port_a.m_flow;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end SimplePump;
