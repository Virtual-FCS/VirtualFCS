within VirtualFCS.Fluid.Examples;

model MultiManifoldTest
  extends Modelica.Icons.Example;
  import Modelica.Constants.F;

  parameter Real lambda = 3 "Reactant excess ratio";
  parameter Modelica.Units.SI.Voltage V_cell = 0.7 "Single-cell voltage";

  Electrochemical.Hydrogen.Manifold cathode(useHeatPort = true, redeclare package Medium = VirtualFCS.Media.MoistAir, nu = {-0.5, 0, 1}, MMX = VirtualFCS.Media.MoistAir.MMX, V = 1E-2, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial)  annotation(
    Placement(transformation(origin = {30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrochemical.Hydrogen.Manifold anode(useHeatPort = true, redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2, nu = {-1}, MMX = {0.002}, V = 1E-2, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial)  annotation(
    Placement(transformation(origin = {-30, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow extractedPower annotation(
    Placement(transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  inner Modelica.Fluid.System system(allowFlowReversal = false)  annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step reactionRate(startTime = 0.5, height = 0.9, offset = 0.1)  annotation(
    Placement(transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T hydrogen(nPorts = 1, redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {-30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T air(nPorts = 1, redeclare package Medium = VirtualFCS.Media.MoistAir, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain anode_gain(k = lambda*0.002) annotation(
    Placement(transformation(origin = {-22, 52}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Math.Gain cathode_gain(k = lambda*0.028/0.2) annotation(
    Placement(transformation(origin = {38, 52}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Fluid.Sources.FixedBoundary anode_outlet(redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2, nPorts = 1)  annotation(
    Placement(transformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary cathode_outlet(redeclare package Medium = VirtualFCS.Media.MoistAir, nPorts = 1)  annotation(
    Placement(transformation(origin = {30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain power_gain(k = -2*F*V_cell) annotation(
    Placement(transformation(origin = {0, 51}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
equation
  connect(anode.heatPort, cathode.heatPort) annotation(
    Line(points = {{-20, -30}, {20, -30}}, color = {191, 0, 0}));
  connect(extractedPower.port, anode.heatPort) annotation(
    Line(points = {{0, 0}, {0, -30}, {-20, -30}}, color = {191, 0, 0}));
  connect(anode.r, reactionRate.y) annotation(
    Line(points = {{-37, -30}, {-50, -30}, {-50, 80}, {-59, 80}}, color = {0, 0, 127}));
  connect(cathode.r, reactionRate.y) annotation(
    Line(points = {{37, -30}, {60, -30}, {60, 80}, {-59, 80}}, color = {0, 0, 127}));
  connect(hydrogen.ports[1], anode.port_a) annotation(
    Line(points = {{-30, 0}, {-30, -20}}, color = {0, 127, 255}));
  connect(air.ports[1], cathode.port_a) annotation(
    Line(points = {{30, 0}, {30, -20}}, color = {0, 127, 255}));
  connect(hydrogen.m_flow_in, anode_gain.y) annotation(
    Line(points = {{-22, 20}, {-22, 45}}, color = {0, 0, 127}));
  connect(air.m_flow_in, cathode_gain.y) annotation(
    Line(points = {{38, 20}, {38, 45}}, color = {0, 0, 127}));
  connect(anode_gain.u, reactionRate.y) annotation(
    Line(points = {{-22, 60}, {-22, 80}, {-59, 80}}, color = {0, 0, 127}));
  connect(cathode_gain.u, reactionRate.y) annotation(
    Line(points = {{38, 60}, {38, 80}, {-59, 80}}, color = {0, 0, 127}));
  connect(cathode.port_b, cathode_outlet.ports[1]) annotation(
    Line(points = {{30, -40}, {30, -60}}, color = {0, 127, 255}));
  connect(anode.port_b, anode_outlet.ports[1]) annotation(
    Line(points = {{-30, -40}, {-30, -60}}, color = {0, 127, 255}));
  connect(extractedPower.Q_flow, power_gain.y) annotation(
    Line(points = {{0, 20}, {0, 44}}, color = {0, 0, 127}));
  connect(power_gain.u, reactionRate.y) annotation(
    Line(points = {{0, 58}, {0, 80}, {-59, 80}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>This test connects anode and cathode manifolds with reaction-derived flows. The reaction rate steps from 0.1 to 1 at 0.5 s; lambda = 3 and cell voltage = 0.7 V determine the resulting flow rates.</p><p>Both manifold volumes are 0.01 m3 and share a heat port. </p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>lambda</code></td><td>Real</td><td>1</td><td><code>3</code></td><td>Reactant excess ratio</td></tr>
<tr><td><code>V_cell</code></td><td>Modelica.Units.SI.Voltage</td><td>V</td><td><code>0.7</code></td><td>Single-cell voltage</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end MultiManifoldTest;
