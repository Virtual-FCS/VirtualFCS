within VirtualFCS.Fluid;

model CompressorSimple
  extends VirtualFCS.Fluid.ElectricCompressorInterface(final useHeatPort = false, redeclare Modelica.Blocks.Interfaces.RealInput set_mass_flow(unit = "kg/s"));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choicesAllMatching = true);
  parameter Modelica.Units.SI.Efficiency eta = 0.8 "Isoentropic efficiency";
  Medium.BaseProperties medium_in, medium_out "Medium properties at inlet and outlet";
  Real k = cp/cv "Heat capacity ratio, measured at inlet";
  Modelica.Units.SI.SpecificHeatCapacity cv = Medium.specificHeatCapacityCv(medium_in.state);
  Modelica.Units.SI.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(medium_in.state);
  Modelica.Units.SI.EnthalpyFlowRate Hin = port_a.m_flow*inStream(port_a.h_outflow);
  Modelica.Units.SI.EnthalpyFlowRate Hout = port_b.m_flow*port_b.h_outflow;
  Modelica.Units.SI.Power power "The power consumed by the Compressor";
equation
  port_a.m_flow = set_mass_flow;
// All compositions equal to upstream
  medium_in.Xi = port_a.Xi_outflow;
// Not supposed to ever be used
  medium_in.Xi = inStream(port_a.Xi_outflow);
  medium_in.Xi = medium_out.Xi;
  medium_out.Xi = port_b.Xi_outflow;
// Bind inlet/outlet pressures
  medium_in.p = port_a.p;
  medium_out.p = port_b.p;
// No-holdup model
  port_a.m_flow + port_b.m_flow = 0;
// Calculate T_in from enthalpy, calculate enthalpy_out
  medium_in.T = Medium.temperature_phX(medium_in.p, inStream(port_a.h_outflow), medium_in.X);
  medium_out.T = Medium.temperature_phX(medium_out.p, port_b.h_outflow, medium_out.X);
  Hin + Hout + power = 0;
// Not supposed to be ever used
  port_a.h_outflow = port_b.h_outflow;
// heatPort not used
  lossPower = 0;
// Power is equal to energy inflow
  power = (pin_p.v - pin_n.v)*(pin_n.i);
  pin_p.i + pin_n.i = 0;
// Relate work to p ratio
  power*eta/port_a.m_flow = k*medium_in.R_s*medium_in.T/(k - 1)*((medium_out.p/medium_in.p)^((k - 1)/k) - 1);
  annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Simplified compressor model for fluid-system studies. The component relates the electrical drive input to fluid pressure rise and flow.</p>
<h2>Governing Equations</h2>
<pre>k = cp/cv;
cv = Medium.specificHeatCapacityCv(medium_in.state);
cp = Medium.specificHeatCapacityCp(medium_in.state);
Hin = port_a.m_flow*inStream(port_a.h_outflow);
Hout = port_b.m_flow*port_b.h_outflow;
port_a.m_flow = set_mass_flow;
medium_in.Xi = port_a.Xi_outflow;
medium_in.Xi = inStream(port_a.Xi_outflow);
medium_in.Xi = medium_out.Xi;
medium_out.Xi = port_b.Xi_outflow;
medium_in.p = port_a.p;
medium_out.p = port_b.p;
port_a.m_flow + port_b.m_flow = 0;
medium_in.T = Medium.temperature_phX(medium_in.p, inStream(port_a.h_outflow), medium_in.X);
medium_out.T = Medium.temperature_phX(medium_out.p, port_b.h_outflow, medium_out.X);
Hin + Hout + power = 0;
port_a.h_outflow = port_b.h_outflow;
lossPower = 0;
power = (pin_p.v - pin_n.v)*(pin_n.i);
pin_p.i + pin_n.i = 0;
power*eta/port_a.m_flow = k*medium_in.R_s*medium_in.T/(k - 1)*((medium_out.p/medium_in.p)^((k - 1)/k) - 1);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>medium_in</code></td><td>Medium properties at inlet and outlet</td></tr>
<tr><td><code>k</code></td><td>Heat capacity ratio, measured at inlet</td></tr>
<tr><td><code>power</code></td><td>The power consumed by the Compressor</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>useHeatPort</code></td><td>Boolean</td><td>1</td><td><code>false</code></td><td>= true, if heatPort is enabled (inherited)</td></tr>
<tr><td><code>T</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Fixed device temperature if useHeatPort = false (inherited)</td></tr>
<tr><td><code>eta</code></td><td>Modelica.Units.SI.Efficiency</td><td>1</td><td><code>0.8</code></td><td>Isoentropic efficiency</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td>Optional port to which dissipated losses are transported in form of heat</td></tr>
<tr><td><code>port_a</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
<tr><td><code>port_b</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td>-</td></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
<tr><td><code>set_mass_flow</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end CompressorSimple;
