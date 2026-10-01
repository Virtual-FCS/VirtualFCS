within VirtualFCS.Fluid;

model MembraneManifold "Manifold with a selective membrane source"
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
  annotation(Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No user-settable parameters are declared.</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>membrane_m_flow</code></td><td>Input</td><td>Real</td><td>kg/s</td><td>Signed mass flow through the membrane; positive into the volume</td></tr>
<tr><td><code>membrane_h_outflow</code></td><td>Input</td><td>Real</td><td>J/kg</td><td>Specific enthalpy carried by membrane mass</td></tr>
<tr><td><code>membrane_Xi</code></td><td>Input</td><td>Real[Medium.nXi]</td><td>1</td><td>Independent composition carried by membrane mass</td></tr></tbody></table><h2>2. Model description</h2><p>This component extends the VirtualFCS fuel-cell <code>Manifold</code> directly. It adds a signed selective membrane source to the manifold's existing mass, species, and enthalpy balances. A positive <code>membrane_m_flow</code> adds mass to the volume and a negative value removes it. The original manifold model is otherwise unchanged.</p><div><br></div><div>The inherited manifold determines port outflow states and provides the existing hydraulic resistance, fluid holdup, and conditional heat port. This component is used as the wet-side and dry-side cell volume in <code>Humidifier</code>, where the membrane inputs are driven by a paired <code>MembraneTransfer</code> instance.</div><h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended <code>Manifold</code> model, with the membrane source terms added to its mass (<code>mb_flow</code>), species (<code>mbXi_flow</code>), and enthalpy (<code>Hb_flow</code>) balances.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching outputs are declared.</td></tr></tbody></table></body></html>"));
end MembraneManifold;
