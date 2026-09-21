within VirtualFCS.Fluid;

model Separator "A lumped fixed-volume gas/liquid separator"
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  extends Modelica.Fluid.Interfaces.PartialLumpedVolume(redeclare replaceable package Medium = Media.MoistAir constrainedby Media.PartialCondensingMixture, mXi(each stateSelect = StateSelect.always), U(stateSelect = StateSelect.prefer), medium(h(stateSelect = StateSelect.avoid), T(stateSelect = StateSelect.avoid)), massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, Qb_flow = -LossPower, Wb_flow = 0, fluidVolume = V, mb_flow = port_mid.m_flow + port_top.m_flow + port_bottom.m_flow, mbXi_flow = semiLinear(port_mid.m_flow, inStream(port_mid.Xi_outflow), port_mid.Xi_outflow) + semiLinear(port_top.m_flow, inStream(port_top.Xi_outflow), port_top.Xi_outflow) + semiLinear(port_bottom.m_flow, inStream(port_bottom.Xi_outflow), port_bottom.Xi_outflow), Hb_flow = semiLinear(port_mid.m_flow, inStream(port_mid.h_outflow), port_mid.h_outflow) + semiLinear(port_top.m_flow, inStream(port_top.h_outflow), port_top.h_outflow) + semiLinear(port_bottom.m_flow, inStream(port_bottom.h_outflow), port_bottom.h_outflow));
  import Modelica.Media.Common.smoothStep;
  parameter Modelica.Units.SI.Volume V = 1E-3 "Separator total volume";
  Modelica.Units.SI.Volume V_gas(min = 0, max = V) = m*medium.beta/medium.d_gas "Gas volume";
  Modelica.Units.SI.Volume V_liq(min = 0, max = V, start = 0.5*V) = m*(1 - medium.beta)/medium.d_liq "Liquid volume";
  Modelica.Blocks.Interfaces.RealOutput level = V_liq/V annotation(
    Placement(transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput p = medium.p annotation(
    Placement(transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_mid(redeclare package Medium = Medium) "Two-phase inlet" annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_top(redeclare package Medium = Medium) "Gas outlet at the top" annotation(
    Placement(transformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bottom(redeclare package Medium = Medium) "Liquid outlet at the bottom" annotation(
    Placement(transformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  parameter Real feedHeight(min = 0, max = 1) = 0.5 "Relative vertical placement of feed, used for reverse flow";
  parameter Real pipeHeight(min = 0) = 0.05 "Relative width of the inlet/outlet pipes compared to separator height";
equation
  port_mid.p = medium.p;
  port_top.p = medium.p;
  port_bottom.p = medium.p "Hydrostatic head neglected";
  port_top.Xi_outflow = smoothStep(V_gas/V - pipeHeight, medium.X_gas[1:Medium.nXi], medium.X_liq[1:Medium.nXi], pipeHeight);
  port_mid.Xi_outflow = smoothStep(V_liq/V - feedHeight, port_top.Xi_outflow, port_bottom.Xi_outflow, pipeHeight);
  port_bottom.Xi_outflow = smoothStep(V_liq/V - pipeHeight, medium.X_liq[1:Medium.nXi], medium.X_gas[1:Medium.nXi], pipeHeight);
  port_top.h_outflow = smoothStep(V_gas/V - pipeHeight, medium.h_gas, medium.h_liq, pipeHeight);
  port_mid.h_outflow = smoothStep(V_liq/V - feedHeight, port_top.h_outflow, port_bottom.h_outflow, pipeHeight);
  port_bottom.h_outflow = smoothStep(V_liq/V - pipeHeight, medium.h_liq, medium.h_gas, pipeHeight);
// Not used, but must be specified.
  port_top.C_outflow = C;
  port_mid.C_outflow = C;
  port_bottom.C_outflow = C;
  T_heatPort = medium.T;
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-60, 100}, {60, -100}}, radius = 50), Line(origin = {0, -20}, points = {{-60, 0}, {60, 0}}, thickness = 1), Text(textColor = {0, 0, 255}, extent = {{-100, 160}, {100, 120}}, textString = "%name"), Polygon(origin = {30, -10}, lineThickness = 1, points = {{-10, 10}, {0, -10}, {10, 10}, {-10, 10}, {-10, 10}}), Line(origin = {20, -52}, points = {{-20, 20}, {20, -20}, {20, -20}}, thickness = 0.5), Line(origin = {0, -52}, points = {{-20, 20}, {20, -20}, {20, -20}}, thickness = 0.5), Line(origin = {-20, -52}, points = {{-20, 20}, {20, -20}, {20, -20}}, thickness = 0.5), Text(origin = {82, -34}, textColor = {0, 0, 255}, extent = {{-20, 10}, {20, -10}}, textString = "Level", horizontalAlignment = TextAlignment.Left), Text(origin = {70, 70}, textColor = {0, 0, 255}, extent = {{-10, 10}, {10, -10}}, textString = "p", textStyle = {TextStyle.Italic})}),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>V</code></td><td>SI.Volume</td><td>m3</td><td>1E-3</td><td>Separator total volume</td></tr>
<tr><td><code>feedHeight</code></td><td>Real</td><td>1</td><td>0, max=1) = 0.5</td><td>Relative vertical placement of feed, used for reverse flow</td></tr>
<tr><td><code>pipeHeight</code></td><td>Real</td><td>1</td><td>0) = 0.05</td><td>Relative width of the inlet/outlet pipes compared to separator height</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>port_mid</code></td><td>Input-side interface</td><td>FluidPort_a</td><td>-</td><td>Two-phase inlet</td></tr></tbody></table><h2>2. Model description</h2>This unit separates the phases of a condensable medium flow. It can operate at fixed temperature (heatPort=false), adiabatically (heatPort=true) or with heat dissipation models with appropriate units connected to the heat port.<div><br></div><div>Note that all ports have the same pressure, and to achieve physically meaningful results it will most often be necessary to connect them to a valve or other flow resistance unit before flushing to a constant-pressure reservoir.</div><div>Two output signals for level and pressure are provided, since these are the values that typically control the output flows.</div><div><br></div><div>In case of reverse flow, the feed port's (mid_port) height can be adjusted with feedHeight to set whether it will output liquid or gas depending on the liquid level in the separator.</div><div>If the separator runs out of liquid or overflows, the compositions and enthalpy of the liquid viz. the gas outlet will eventually change to the other phase; the transition interval depend on the pipeHeight parameter.</div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>port_mid.p    = medium.p;
port_top.p    = medium.p;
port_bottom.p = medium.p \"Hydrostatic head neglected\";
port_top.Xi_outflow    = smoothStep(V_gas/V-pipeHeight, medium.X_gas[1:Medium.nXi], medium.X_liq[1:Medium.nXi], pipeHeight);
port_mid.Xi_outflow    = smoothStep(V_liq/V-feedHeight, port_top.Xi_outflow, port_bottom.Xi_outflow, pipeHeight);
port_bottom.Xi_outflow = smoothStep(V_liq/V-pipeHeight, medium.X_liq[1:Medium.nXi], medium.X_gas[1:Medium.nXi], pipeHeight);
port_top.h_outflow    = smoothStep(V_gas/V-pipeHeight, medium.h_gas, medium.h_liq, pipeHeight);
port_mid.h_outflow    = smoothStep(V_liq/V-feedHeight, port_top.h_outflow, port_bottom.h_outflow, pipeHeight);</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>level</code></td><td>Output</td><td>RealOutput</td><td>-</td><td></td></tr>
<tr><td><code>p</code></td><td>Output</td><td>RealOutput</td><td>-</td><td></td></tr>
<tr><td><code>port_top</code></td><td>Output-side interface</td><td>FluidPort_b</td><td>-</td><td>Gas outlet at the top</td></tr>
<tr><td><code>port_bottom</code></td><td>Output-side interface</td><td>FluidPort_b</td><td>-</td><td>Liquid outlet at the bottom</td></tr></tbody></table></body></html>"));
end Separator;
