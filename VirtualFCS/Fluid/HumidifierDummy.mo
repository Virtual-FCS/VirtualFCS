within VirtualFCS.Fluid;

model HumidifierDummy
  extends VirtualFCS.Fluid.HumidifierInterface(redeclare package wet_medium=wet_medium, redeclare package dry_medium=dry_medium);
  
  replaceable package dry_medium = Modelica.Media.Interfaces.PartialMedium "Dry gas (shell side)" annotation(
    choicesAllMatching = true);
  replaceable package wet_medium = Modelica.Media.Interfaces.PartialMedium "Wet side (fiber side)" annotation(
    choicesAllMatching = true);
  
  Modelica.Units.SI.MassFraction XiA_out[wet_medium.nXi];
  Modelica.Units.SI.MassFraction XiB_out[dry_medium.nXi];
  
equation
  
  // Mass and pressure balances
  portA_out.m_flow + portA_in.m_flow = 0;
  portB_out.m_flow + portB_in.m_flow = 0;
  portA_in.p = portA_out.p;
  portB_in.p = portB_out.p;
// Species balances

  XiA_out[1] = inStream(portA_in.Xi_outflow[1]);
  XiA_out[2] = inStream(portA_in.Xi_outflow[2]);
  
  XiB_out[1] = inStream(portB_in.Xi_outflow[1]);
  XiB_out[2] = inStream(portB_in.Xi_outflow[2]);
    
  
// Assign to ports
  portA_out.h_outflow = inStream(portA_in.h_outflow);
  portA_out.Xi_outflow = XiA_out;
  portB_out.h_outflow = inStream(portB_in.h_outflow);
  portB_out.Xi_outflow = XiB_out;
  portA_in.h_outflow = inStream(portA_out.h_outflow);
  portA_in.Xi_outflow = inStream(portA_out.Xi_outflow);
  portB_in.h_outflow = inStream(portB_out.h_outflow);
  portB_in.Xi_outflow = inStream(portB_out.Xi_outflow);
    
  
end HumidifierDummy;
