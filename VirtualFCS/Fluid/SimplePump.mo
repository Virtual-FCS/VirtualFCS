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
  
  head = (port_b.p - port_a.p)/ Medium.density(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow))) / g_n "Definition of head, with inlet density";

  eta*power = u * head * g_n "Relation between head and power";
  annotation(
    Documentation(info = "<html><head></head><body><p>A bare-bones model for a pump. The input <i>u</i> sets the mass flow directly. The pump must be connected to a DC power supply providing voltage.</p><p>The model has one parameter, efficiency <i>η</i>, which defaults to 100%.</p><p>The pump has no holdup and is meant to be directional, with the higher pressure to be found at <tt>port_b.</tt></p><p><i>Note:</i>&nbsp;this model can be used only with either incompressible media (liquids) or with gases with minimal pressure drop (e.g. fans and blowers). To faithfully model significant pressure drops in gas phase, use a Compressor.</p></body></html>"));
end SimplePump;
