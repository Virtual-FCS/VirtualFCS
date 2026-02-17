within VirtualFCS.Fluid;

model simplePipe "A simple 0D pipe with mass and heat transfer"
    extends Fluid.PipeInterface;
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component" annotation(
    choicesAllMatching = true);
    outer Modelica.Units.SI.Temperature T_water_in "Input for the simple PipeCoolant";
    
    equation
 
    // Mass balance
    0 = port_a.m_flow + port_b.m_flow;

    // No pressure losses
    port_b.p = port_a.p;

   
    // Species transport
    port_b.Xi_outflow = inStream(port_a.Xi_outflow);
    port_a.Xi_outflow = inStream(port_b.Xi_outflow);


    // Enthalpy update with heat input
    port_b.h_outflow = inStream(port_a.h_outflow) + (if port_a.m_flow > 0 then heat_port.Q_flow / max(port_a.m_flow, 1e-6) else 0);
    port_a.h_outflow = inStream(port_b.h_outflow) + (if port_b.m_flow > 0 then heat_port.Q_flow / max(port_b.m_flow, 1e-6) else 0);

    // Estimated heat port temperature from coolant inlet temperature, which defines how much heat is dissipated here
    heat_port.T = T_water_in;

end simplePipe;
