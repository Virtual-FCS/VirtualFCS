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
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>eta</code></td><td>SI.Efficiency</td><td>1</td><td>0.8</td><td>Isoentropic efficiency</td></tr></tbody></table><h2>2. Model description</h2><p>Simplified compressor model for fluid-system studies. The component relates the electrical drive input to fluid pressure rise and flow.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>port_a.m_flow = set_mass_flow;
medium_in.Xi = port_a.Xi_outflow;
medium_in.Xi = inStream(port_a.Xi_outflow);
medium_in.Xi = medium_out.Xi;
medium_out.Xi = port_b.Xi_outflow;
medium_in.p = port_a.p;
medium_out.p = port_b.p;
port_a.m_flow + port_b.m_flow = 0;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end CompressorSimple;
