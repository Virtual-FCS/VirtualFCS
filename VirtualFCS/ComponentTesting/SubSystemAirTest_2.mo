within VirtualFCS.ComponentTesting;

model SubSystemAirTest_2
  extends VirtualFCS.ComponentTesting.SubSystemAirTest(redeclare SubSystems.Air.SubSystemAir subSystemAir(redeclare VirtualFCS.Fluid.CompressorSimple compressor(redeclare package Medium = Medium), p_set = 2e5, redeclare VirtualFCS.Fluid.Humidifier humidifier(redeclare package dry_medium = Medium, redeclare package wet_medium = Medium, UA = 0.4, n = 3, nFibers = 7000, m_flow_nom = 0.1, L_fiber = 0.3, dHousing (displayUnit = "mm")= 0.14, V_wet = 0.001, V_dry = 0.003, dFiber_i(displayUnit = "mm"), dFiber_o(displayUnit = "mm") = 0.0011, dp_nominal = 1e4)));
equation

annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Test model for the air subsystem with humidification.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>VirtualFCS.ComponentTesting.SubSystemAirTest</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>42</code></td><td>- (inherited)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end SubSystemAirTest_2;
