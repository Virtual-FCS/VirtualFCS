within VirtualFCS.Fluid;

model RelativeHumiditySensor
  extends Modelica.Fluid.Sensors.BaseClasses.PartialFlowSensor(m_flow_small=1e-9);
  extends Modelica.Icons.RoundSensor;
  Modelica.Blocks.Interfaces.RealOutput Phi(final quantity="RelativeHumidity",
                                               final unit="1")
    "Volume flow rate from port_a to port_b"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
protected
  
  Modelica.Units.SI.MoleFraction phi_a_inflow "Relative humidity of inflowing fluid at port_a";
  Modelica.Units.SI.MoleFraction phi_b_inflow "Relative humidity of inflowing fluid at port_b or phi_a_inflow, if uni-directional flow";
  Modelica.Units.SI.MoleFraction p;
  
  

equation
  if allowFlowReversal then
     phi_a_inflow = Medium.relativeHumidity(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     phi_b_inflow = Medium.relativeHumidity(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow));
     p = Modelica.Fluid.Utilities.regStep(port_a.m_flow, phi_a_inflow, phi_b_inflow, m_flow_small);
  else
     p = Medium.relativeHumidity(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     phi_a_inflow = p;
     phi_b_inflow = p;
  end if;
  Phi = p;
annotation(
    Icon(graphics = {Text(extent = {{160, 120}, {0, 90}}, textString = "Phi")}), Documentation(info="<html>
<p>
This component monitors the relative humidity of the fluid passing its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>

</html>"));
end RelativeHumiditySensor;
