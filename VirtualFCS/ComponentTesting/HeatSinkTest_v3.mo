within VirtualFCS.ComponentTesting;

model HeatSinkTest_v3 "Multi-way connections of pipes and incompressible medium model"
  extends Modelica.Icons.Example;
  parameter Modelica.Fluid.Types.ModelStructure pipeModelStructure = Modelica.Fluid.Types.ModelStructure.av_vb "Model structure in distributed pipe model";
  //replaceable package Medium = Modelica.Media.Incompressible.Examples.Glycol47 constrainedby Modelica.Media.Interfaces.PartialMedium;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  import Modelica.Fluid.Types.Dynamics;
  parameter Dynamics systemMassDynamics = if Medium.singleState then Dynamics.SteadyState else Dynamics.SteadyStateInitial "Formulation of mass balances";
  Modelica.Fluid.Sources.Boundary_pT source(nPorts = 1, redeclare package Medium = Medium, p = 5.0e5, T = 300) annotation(
    Placement(visible = true, transformation(origin = {46, 0}, extent = {{-98, -6}, {-86, 6}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT sink(nPorts = 1, redeclare package Medium = Medium, T = 300, p = 1.0e5) annotation(
    Placement(visible = true, transformation(origin = {-66, -10}, extent = {{118, 4}, {106, 16}}, rotation = 0)));
  inner Modelica.Fluid.System system(massDynamics = systemMassDynamics, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, use_eps_Re = true) annotation(
    Placement(transformation(extent = {{90, -92}, {110, -72}})));
  
  Modelica.Fluid.Pipes.DynamicPipe pipe8(
    use_T_start = true, 
    length = 10, 
    diameter = 2.5e-2, 
    redeclare package Medium = Medium, 
    modelStructure = pipeModelStructure, 
    use_HeatTransfer = true, 
    redeclare model FlowModel = Modelica.Fluid.Pipes.BaseClasses.FlowModels.TurbulentPipeFlow) 
  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow[pipe8.nNodes] heat8(Q_flow = 16e3*pipe8.dxs) annotation(
    Placement(visible = true, transformation(origin = {14, -42}, extent = {{-20, 0}, {0, 20}}, rotation = 90)));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-24, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {28, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(heat8.port, pipe8.heatPorts) annotation(
    Line(points = {{4, -42}, {3, -42}, {3, -4}, {0, -4}}, color = {191, 0, 0}));
  connect(pipe8.port_a, source.ports[1]) annotation(
    Line(points = {{-10, 0}, {-40, 0}}, color = {0, 127, 255}));
  connect(sink.ports[1], pipe8.port_b) annotation(
    Line(points = {{40, 0}, {10, 0}}, color = {0, 127, 255}));
  connect(temperature.port, pipe8.port_a) annotation(
    Line(points = {{-24, -16}, {-10, -16}, {-10, 0}}, color = {0, 127, 255}));
  connect(temperature1.port, pipe8.port_b) annotation(
    Line(points = {{28, -16}, {10, -16}, {10, 0}}));
  annotation(
    Documentation(info = "<html>
<p>
This example demonstrates two aspects: the treatment of multi-way connections
and the usage of an incompressible medium model.
</p><p>
Eleven pipe models with nNodes=2 each introduce 22 temperature states and 22 pressure states.
When configuring <strong>pipeModelStructure=a_v_b</strong>, the flow models at the pipe ports constitute algebraic loops for the pressures.
A common work-around is to introduce \"mixing volumes\" in critical connections.
</p><p>
Here the problem is treated alternatively with the default <strong>pipeModelStructure=av_vb</strong> of the
<a href=\"modelica://Modelica.Fluid.Pipes.DynamicPipe\">DynamicPipe</a> model.
Each pipe exposes the states of the outer fluid segments to the respective fluid ports.
Consequently the pressures of all connected pipe segments get lumped together into one mass balance spanning the whole connection set.
Overall this treatment as high-index DAE results in the reduction to 9 pressure states, preventing algebraic loops in connections.
This can be studied with a rigorous medium model like <strong>StandardWaterOnePhase</strong>.
</p><p>
The pressure dynamics completely disappears with an incompressible medium model, like the used <strong>Glycol47</strong>.
It appears reasonable to assume steady-state mass balances in this case
(see parameter systemMassDynamics used in system.massDynamics, tab Assumptions).
</p><p>
Note that with the stream concept in the fluid ports, the energy and substance balances of the connected pipe segments remain independent
from each other, despite of pressures being lumped together. The following simulation results can be observed:
</p>
<ol>
<li>The simulation starts with system.T_ambient as initial temperature in all pipes.
    The temperatures upstream or bypassing pipe8 are approaching the value of 26.85 degC from the source, including also pipe9.
    The temperatures downstream of pipe8 take a higher value, depending on the mixing with heated fluid, see e.g. pipe10.</li>
<li>After 50s valve1 fully closes. This causes flow reversal in pipe8. Now heated fluid flows from pipe8 to pipe9.
    Note that the temperature of the connected pipe7 remains unchanged as there is no flow into pipe7.
    The temperature of pipe10 cools down to the source temperature.</li>
<li>After 100s valve2 closes half way, which affects mass flow rates and temperatures.</li>
<li>After 150s valve5 closes half way, which affects mass flow rates and temperatures.</li>
</ol>
<p>
The fluid temperatures in the pipes of interest are exposed through heatPorts.
</p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Examples/IncompressibleFluidNetwork.png\" border=\"1\"
     alt=\"IncompressibleFluidNetwork.png\">
</html>"),
    experiment(StopTime = 200),
    __Dymola_Commands(file = "modelica://Modelica/Resources/Scripts/Dymola/Fluid/IncompressibleFluidNetwork/plotResults.mos" "plotResults"),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {120, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {120, 100}})));
end HeatSinkTest_v3;
