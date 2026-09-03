within VirtualFCS.Fluid;

model MembraneMixingVolume "Lumped volume with a selective membrane mass source"
  extends Modelica.Fluid.Interfaces.PartialLumpedVolume(
    mXi(each stateSelect = StateSelect.always),
    U(stateSelect = StateSelect.prefer),
    medium(h(stateSelect = StateSelect.avoid), T(stateSelect = StateSelect.avoid)),
    massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    Qb_flow = -LossPower,
    Wb_flow = 0,
    mbXi_flow = semiLinear(port_a.m_flow, inStream(port_a.Xi_outflow), port_a.Xi_outflow) + semiLinear(port_b.m_flow, inStream(port_b.Xi_outflow), port_b.Xi_outflow) + membrane_m_flow*membrane_Xi,
    mb_flow = port_a.m_flow + port_b.m_flow + membrane_m_flow,
    Hb_flow = semiLinear(port_a.m_flow, inStream(port_a.h_outflow), port_a.h_outflow)
      + semiLinear(port_b.m_flow, inStream(port_b.h_outflow), port_b.h_outflow)
      + membrane_m_flow*membrane_h_outflow,
    fluidVolume = V);
  extends Modelica.Fluid.Interfaces.PartialTwoPort(showDesignFlowDirection = false);
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  
  parameter Modelica.Units.SI.Volume V = 1E-3 "Volume";
  parameter Modelica.Fluid.Types.HydraulicResistance R_flow = 1000
    "Resistance to flow between the ports";
  input Modelica.Units.SI.MassFlowRate membrane_m_flow
    "Mass flow entering the volume through the membrane";
  input Modelica.Units.SI.SpecificEnthalpy membrane_h_outflow
    "Specific enthalpy of membrane-transferred mass";
  input Modelica.Units.SI.MassFraction membrane_Xi[Medium.nXi]
    "Independent mass fractions of membrane-transferred mass";

equation
  port_a.p - port_b.p = R_flow*(port_a.m_flow - port_b.m_flow)/2;
  medium.p = (port_a.p + port_b.p)/2;
  port_a.Xi_outflow = medium.Xi;
  port_b.Xi_outflow = medium.Xi;
  port_a.h_outflow = medium.h;
  port_b.h_outflow = medium.h;
  port_a.C_outflow = C;
  port_b.C_outflow = C;
  T_heatPort = medium.T;
annotation(Documentation(info = "<html><head></head><body>
<h1>Membrane mixing volume</h1>
<p>This component is a fixed, lumped fluid volume based on
<code>Modelica.Fluid.Interfaces.PartialLumpedVolume</code>. It is intended for
discretised mass exchangers such as <code>HumidifierV2</code>.</p>
<p>In addition to the two fluid ports, the volume has an internal selective
membrane source. A positive <code>membrane_m_flow</code> adds mass to the
volume; a negative value removes mass. The supplied mass carries
<code>membrane_h_outflow</code> and the independent composition
<code>membrane_Xi</code>. These terms participate directly in the volume mass,
species, and enthalpy balances.</p>
<h2>Fluid behaviour</h2>
<p>The volume state determines both port outflow enthalpies and compositions.
No outlet stream variables are prescribed by the enclosing exchanger. A
linear resistance relates the port pressure difference to the difference
between the two port mass flows. The heat port is conditional and exposes the
internal medium temperature.</p>
<h2>Important assumptions</h2>
<ul>
<li>The membrane source composition uses the medium's independent mass
fractions. The dependent species is represented by the remaining mass
fraction.</li>
<li>The component uses fixed-initial volume dynamics, consistent with the
library's <code>MixingVolume</code>.</li>
<li>Use a physically meaningful positive volume and flow resistance. Very low
resistance values can destabilise fluid networks.</li>
</ul>
</body></html>"));
end MembraneMixingVolume;
