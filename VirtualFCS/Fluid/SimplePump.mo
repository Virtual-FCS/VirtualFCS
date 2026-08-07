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
  power = (u/medium_out.d) * (port_b.p-port_a.p) / eta_is;
  pin_p.i + pin_n.i = 0;

end SimplePump;
