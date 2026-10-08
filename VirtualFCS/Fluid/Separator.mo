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
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
This unit separates the phases of a condensable medium flow. It can operate at fixed temperature (heatPort=false), adiabatically (heatPort=true) or with heat dissipation models with appropriate units connected to the heat port.<div><br></div><div>Note that all ports have the same pressure, and to achieve physically meaningful results it will most often be necessary to connect them to a valve or other flow resistance unit before flushing to a constant-pressure reservoir.</div><div>Two output signals for level and pressure are provided, since these are the values that typically control the output flows.</div><div><br></div><div>In case of reverse flow, the feed port's (mid_port) height can be adjusted with feedHeight to set whether it will output liquid or gas depending on the liquid level in the separator.</div><div>If the separator runs out of liquid or overflows, the compositions and enthalpy of the liquid viz. the gas outlet will eventually change to the other phase; the transition interval depend on the pipeHeight parameter.</div>
<h2>Governing Equations</h2>
<pre>V_gas = m*medium.beta/medium.d_gas;
V_liq = m*(1 - medium.beta)/medium.d_liq;
level = V_liq/V;
p = medium.p;
port_mid.p = medium.p;
port_top.p = medium.p;
port_bottom.p = medium.p &quot;Hydrostatic head neglected&quot;;
port_top.Xi_outflow = smoothStep(V_gas/V - pipeHeight, medium.X_gas[1:Medium.nXi], medium.X_liq[1:Medium.nXi], pipeHeight);
port_mid.Xi_outflow = smoothStep(V_liq/V - feedHeight, port_top.Xi_outflow, port_bottom.Xi_outflow, pipeHeight);
port_bottom.Xi_outflow = smoothStep(V_liq/V - pipeHeight, medium.X_liq[1:Medium.nXi], medium.X_gas[1:Medium.nXi], pipeHeight);
port_top.h_outflow = smoothStep(V_gas/V - pipeHeight, medium.h_gas, medium.h_liq, pipeHeight);
port_mid.h_outflow = smoothStep(V_liq/V - feedHeight, port_top.h_outflow, port_bottom.h_outflow, pipeHeight);
port_bottom.h_outflow = smoothStep(V_liq/V - pipeHeight, medium.h_liq, medium.h_gas, pipeHeight);
port_top.C_outflow = C;
port_mid.C_outflow = C;
port_bottom.C_outflow = C;
T_heatPort = medium.T;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>V_gas</code></td><td>Gas volume</td></tr>
<tr><td><code>V_liq</code></td><td>Liquid volume</td></tr>
<tr><td><code>port_mid</code></td><td>Two-phase inlet</td></tr>
<tr><td><code>port_top</code></td><td>Gas outlet at the top</td></tr>
<tr><td><code>port_bottom</code></td><td>Liquid outlet at the bottom</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
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
<tr><td><code>V</code></td><td>Modelica.Units.SI.Volume</td><td>m3</td><td><code>1E-3</code></td><td>Separator total volume</td></tr>
<tr><td><code>feedHeight</code></td><td>Real</td><td>1</td><td><code>0.5</code></td><td>Relative vertical placement of feed, used for reverse flow</td></tr>
<tr><td><code>pipeHeight</code></td><td>Real</td><td>1</td><td><code>0.05</code></td><td>Relative width of the inlet/outlet pipes compared to separator height</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>port_mid</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>Two-phase inlet</td></tr>
<tr><td><code>level</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>-</td><td></td></tr>
<tr><td><code>p</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>-</td><td></td></tr>
<tr><td><code>port_top</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Gas outlet at the top</td></tr>
<tr><td><code>port_bottom</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>Liquid outlet at the bottom</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Conditional heat port</td></tr>
<tr><td><code>fluidVolume</code></td><td>Input signal</td><td>Modelica.Units.SI.Volume</td><td>m3</td><td>Volume</td></tr>
</table>
</body>
</html>"));
end Separator;
