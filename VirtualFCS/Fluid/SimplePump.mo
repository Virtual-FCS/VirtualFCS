within VirtualFCS.Fluid;

model SimplePump "A simple pump for liquids or gases with small pressure difference"
  extends Fluid.PumpInterface(final useHeatPort = false, redeclare Modelica.Blocks.Interfaces.RealInput u(unit = "kg/s"));
  import Modelica.Constants.g_n;
  parameter Real eta = 1.0 "Pumping efficiency";
  
  Modelica.Units.SI.Length head "The pump head in length of fluid column";
  Modelica.Units.SI.Power power = (pin_p.v - pin_n.v)*(pin_p.i) "The power consumed by the pump";

equation
  port_a.Xi_outflow = inStream(port_b.Xi_outflow) "No change in compositions";
  port_b.Xi_outflow = inStream(port_a.Xi_outflow) "No change in compositions";

  port_a.m_flow + port_b.m_flow = 0 "No mass holdup";
  u = port_a.m_flow "Set mass flow directly";

  port_a.h_outflow = inStream(port_b.h_outflow) + head*g_n;
  port_b.h_outflow = inStream(port_a.h_outflow) + head*g_n;

  LossPower = 0 "heatPort not used";

  pin_p.i + pin_n.i = 0 "No capacitive element";
  
  head = (port_b.p - port_a.p)/ Medium.density(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)) / g_n "Definition of head";

  eta*power = u * head * g_n "Relation between head and power";
  annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>A bare-bones model for a pump. The input <i>u</i> sets the mass flow directly. The pump must be connected to a DC power supply providing voltage.</p><p>The model has one parameter, efficiency <i>η</i>, which defaults to 100%.</p><p>The pump has no holdup and is meant to be directional, with the higher pressure to be found at <tt>port_b.</tt></p><p><i>Note:</i>&nbsp;this model can be used only with either incompressible media (liquids) or with gases with minimal pressure drop (e.g. fans and blowers). To faithfully model significant pressure drops in gas phase, use a Compressor.</p>
<h2>Governing Equations</h2>
<pre>power = (pin_p.v - pin_n.v)*(pin_p.i);
port_a.Xi_outflow = inStream(port_b.Xi_outflow) &quot;No change in compositions&quot;;
port_b.Xi_outflow = inStream(port_a.Xi_outflow) &quot;No change in compositions&quot;;
port_a.m_flow + port_b.m_flow = 0 &quot;No mass holdup&quot;;
u = port_a.m_flow &quot;Set mass flow directly&quot;;
port_a.h_outflow = inStream(port_b.h_outflow) + head*g_n;
port_b.h_outflow = inStream(port_a.h_outflow) + head*g_n;
LossPower = 0 &quot;heatPort not used&quot;;
pin_p.i + pin_n.i = 0 &quot;No capacitive element&quot;;
head = (port_b.p - port_a.p)/ Medium.density(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)) / g_n &quot;Definition of head&quot;;
eta*power = u * head * g_n &quot;Relation between head and power&quot;;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>head</code></td><td>The pump head in length of fluid column</td></tr>
<tr><td><code>power</code></td><td>The power consumed by the pump</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
<tr><td><code>eta</code></td><td>Real</td><td>1</td><td><code>1.0</code></td><td>Pumping efficiency</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
<tr><td><code>u</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td>Control input, can be replaced by whatever the manipulated variable is</td></tr>
<tr><td><code>port_a</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
<tr><td><code>port_b</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
</table>
</body>
</html>"));
end SimplePump;
