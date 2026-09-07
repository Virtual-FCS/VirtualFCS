within VirtualFCS.Fluid;

model MembraneManifoldV3 "Manifold with a selective membrane source"
  extends VirtualFCS.Electrochemical.Hydrogen.Manifold(
    mbXi_flow = semiLinear(port_a.m_flow, inStream(port_a.Xi_outflow), port_a.Xi_outflow) + semiLinear(port_b.m_flow, inStream(port_b.Xi_outflow), port_b.Xi_outflow) + productions[1:Medium.nXi] + membrane_m_flow*membrane_Xi, 
    mb_flow = port_a.m_flow + port_b.m_flow + sum(productions) + membrane_m_flow,
    Hb_flow = semiLinear(port_a.m_flow, inStream(port_a.h_outflow), port_a.h_outflow) + semiLinear(port_b.m_flow, inStream(port_b.h_outflow), port_b.h_outflow) + membrane_m_flow*membrane_h_outflow);

  input Modelica.Units.SI.MassFlowRate membrane_m_flow
    "Signed mass flow through the membrane; positive into the volume";
  input Modelica.Units.SI.SpecificEnthalpy membrane_h_outflow
    "Specific enthalpy carried by membrane mass";
  input Modelica.Units.SI.MassFraction membrane_Xi[Medium.nXi]
    "Independent composition carried by membrane mass";

equation
  annotation(Documentation(info = "<html><head></head><body>
<h1>Membrane manifold v3</h1>
<p>This component extends the VirtualFCS fuel-cell <code>Manifold</code>
directly. It adds a signed selective membrane source to the manifold's
existing mass, species, and enthalpy balances. A positive
<code>membrane_m_flow</code> adds mass to the volume and a negative value removes
it. The original manifold model is unchanged.</p>
<p>The inherited manifold determines port outflow states and provides the
existing hydraulic resistance, fluid holdup, and conditional heat port.</p>
</body></html>"));
end MembraneManifoldV3;
