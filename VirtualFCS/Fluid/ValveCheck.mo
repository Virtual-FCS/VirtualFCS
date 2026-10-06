within VirtualFCS.Fluid;

model ValveCheck
extends Modelica.Fluid.Interfaces.PartialTwoPortTransport(allowFlowReversal = false, show_T = false, show_V_flow = false, m_flow_start = 0, dp_start = 0);
    parameter Medium.MassFlowRate m_flow_nominal = 0.05;
    parameter Medium.AbsolutePressure dp_nominal = 3e4;
    parameter Modelica.Units.SI.Pressure dp_smooth = 10;
    Modelica.Units.SI.Pressure dp_forward;
  equation
    dp_forward = smooth(1, noEvent(if dp <= 0 then 0 else if dp < dp_smooth then dp*dp/(2*dp_smooth) else dp - dp_smooth/2));
    m_flow = m_flow_nominal/dp_nominal*dp_forward;
    port_a.h_outflow = inStream(port_b.h_outflow);
    port_b.h_outflow = inStream(port_a.h_outflow);


annotation(
    Icon(graphics = {Line(points = {{0, 50}, {0, 0}}), Rectangle(fillPattern = FillPattern.Solid, extent = {{-20, 60}, {20, 50}}), Polygon(fillColor = DynamicSelect({255, 255, 255}, {255, 255, 255}), fillPattern = FillPattern.Solid, points = {{-100, 50}, {100, -50}, {100, 50}, {0, 0}, {-100, -50}, {-100, 50}})}));
end ValveCheck;
