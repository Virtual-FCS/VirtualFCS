within VirtualFCS.Fluid;

model CompressorSimple

extends VirtualFCS.Fluid.ElectricCompressorInterface(final useHeatPort=false, redeclare Modelica.Blocks.Interfaces.RealInput set_mass_flow(unit="kg/s"));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation (choicesAllMatching = true);
  
  parameter Modelica.Units.SI.Efficiency eta = 0.8 "Isoentropic efficiency";

  Medium.BaseProperties medium_in, medium_out "Medium properties at inlet and outlet";
  
  Real k = cp/cv "Heat capacity ratio, measured at inlet";
  
  Modelica.Units.SI.SpecificHeatCapacity cv = Medium.specificHeatCapacityCv(medium_in.state);
  Modelica.Units.SI.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(medium_in.state);
  
  Modelica.Units.SI.EnthalpyFlowRate Hin = port_a.m_flow * inStream(port_a.h_outflow);
  Modelica.Units.SI.EnthalpyFlowRate Hout = port_b.m_flow * port_b.h_outflow;
  
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
//  LossPower = 0;
  // Power is equal to energy inflow
  power = (pin_p.v - pin_n.v)*(pin_n.i);
  pin_p.i + pin_n.i = 0;
  // Relate work to p ratio
  power*eta/port_a.m_flow = k*medium_in.R_s*medium_in.T/(k - 1)*((medium_out.p/medium_in.p)^((k - 1)/k) - 1);

end CompressorSimple;
