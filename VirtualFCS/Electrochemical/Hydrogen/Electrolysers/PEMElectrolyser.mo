within VirtualFCS.Electrochemical.Hydrogen.Electrolysers;

model PEMElectrolyser
  extends VirtualFCS.Electrochemical.Hydrogen.Electrolysers.ElectrolyserInterface(redeclare package Anode_Medium = Media.CathodeAir, redeclare package Cathode_Medium = Media.WetHydrogen);
  import Modelica.Constants.F "Faraday constant";
  import Modelica.Constants.R "Universal gas constant";
  import SI = Modelica.Units.SI;
  
  final constant Integer n = 2 "Electrons exchanged in reaction";
  parameter Integer N_cells = 42 "Number of cells in the stack";
  parameter Real n_drag = 4 "Electro-osmotic drag coefficient";
  
  inner Modelica.Units.SI.Temperature T_stack = heatPort.T;
  
  replaceable Modelica.Electrical.Analog.Sources.ConstantVoltage voltage_source(V = N_cells*1.5) annotation(
    Placement(transformation(origin = {-40, 100}, extent = {{-20, -20}, {20, 20}}, rotation = -180)));
  replaceable Modelica.Electrical.Analog.Basic.Resistor ohmic(R=N_cells*0.01) "Internal resistance" annotation(
    Placement(transformation(origin = {80, 100}, extent = {{-20, 20}, {20, -20}}))) ;
  replaceable Modelica.Electrical.Analog.Ideal.Short activation annotation(
    Placement(transformation(origin = {20, 100}, extent = {{-20, 20}, {20, -20}})));
  Modelica.Electrical.Analog.Sensors.MultiSensor multiSensor annotation(
    Placement(transformation(origin = {-100, 120}, extent = {{20, -20}, {-20, 20}}, rotation = -90)));

  replaceable Manifold cathode(redeclare package Medium = Cathode_Medium, MMs = Cathode_Medium.MMX, nu = {1, 2*n_drag}, useHeatPort = true, X_start = {0.9, 0.1}) annotation(
    Placement(transformation(origin = {-90, -3.55271e-15}, extent = {{-30, -30}, {30, 30}}, rotation = -90)));
  replaceable Manifold anode(redeclare package Medium = Anode_Medium, MMs = Anode_Medium.MMX, nu = {0.5, 0, -(1 + 2*n_drag)}, useHeatPort = true, X_start = {0, 0, 1}) annotation(
    Placement(transformation(origin = {90, 0}, extent = {{30, -30}, {-30, 30}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(T(start = 293.15, fixed = true), C = 50) annotation(
    Placement(transformation(origin = {-43, -63}, extent = {{-17, -17}, {17, 17}})));

protected
  Modelica.Blocks.Math.Gain reaction_rate(k = N_cells/n/F) annotation(
    Placement(transformation(origin = {-40, 36}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow electricPower annotation(
    Placement(visible = true, transformation(origin = {0, -28}, extent = {{-18, -18}, {18, 18}}, rotation = -90)));
equation
  connect(electricPower.port, heatPort) annotation(
    Line(points = {{0, -46}, {0, -150}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{-43, -80}, {0, -80}, {0, -150}}, color = {191, 0, 0}));
  connect(multiSensor.i, reaction_rate.u) annotation(
    Line(points = {{-122, 108}, {-140, 108}, {-140, 68}, {-40, 68}, {-40, 55}}, color = {0, 0, 127}));
  connect(port_cathode_a, cathode.port_a) annotation(
    Line(points = {{-150, 40}, {-90, 40}, {-90, 30}}));
  connect(reaction_rate.y, cathode.r) annotation(
    Line(points = {{-40, 18}, {-40, 0}, {-69, 0}}, color = {0, 0, 127}));
  connect(reaction_rate.y, anode.r) annotation(
    Line(points = {{-40, 18}, {-40, 0}, {69, 0}}, color = {0, 0, 127}));
  connect(anode.port_a, port_anode_a) annotation(
    Line(points = {{90, 30}, {90, 40}, {150, 40}}, color = {0, 127, 255}));
  connect(heatPort, anode.heatPort) annotation(
    Line(points = {{0, -150}, {120, -150}, {120, 0}}, color = {191, 0, 0}));
  connect(heatPort, cathode.heatPort) annotation(
    Line(points = {{0, -150}, {-120, -150}, {-120, 0}}, color = {191, 0, 0}));
  connect(anode.port_b, port_anode_b) annotation(
    Line(points = {{90, -30}, {90, -40}, {150, -40}}, color = {0, 127, 255}));
  connect(cathode.port_b, port_cathode_b) annotation(
    Line(points = {{-90, -30}, {-90, -40}, {-150, -40}}, color = {0, 127, 255}));
  connect(voltage_source.p, activation.p) annotation(
    Line(points = {{-20, 100}, {0, 100}}, color = {0, 0, 255}));
  connect(multiSensor.pc, voltage_source.n) annotation(
    Line(points = {{-100, 100}, {-60, 100}}, color = {0, 0, 255}));
  connect(pin_n, multiSensor.nc) annotation(
    Line(points = {{-60, 150}, {-100, 150}, {-100, 140}}, color = {0, 0, 255}));
  connect(pin_n, multiSensor.nv) annotation(
    Line(points = {{-60, 150}, {-140, 150}, {-140, 120}, {-120, 120}}, color = {0, 0, 255}));
  connect(multiSensor.power, electricPower.Q_flow) annotation(
    Line(points = {{-112, 98}, {-112, 72}, {0, 72}, {0, -10}}, color = {255, 0, 0}));
  connect(ohmic.n, pin_p) annotation(
    Line(points = {{100, 100}, {100, 150}, {60, 150}}, color = {0, 0, 255}));
  connect(activation.n, ohmic.p) annotation(
    Line(points = {{40, 100}, {60, 100}}, color = {0, 0, 255}));
  connect(pin_p, multiSensor.pv) annotation(
    Line(points = {{60, 150}, {60, 140}, {-80, 140}, {-80, 120}}, color = {0, 0, 255}));
  annotation(
    Diagram,
    Documentation(info = "<html><head></head><body>This model describes the dynamic behaviour of a proton exchange membrane electrolyser (PEMEL). The model includes components describing the electrical, fluidic, and thermal properties of the cell.<h1>Electric model</h1><div>The basic electrical performance is modelled after a basic Thévenin circuit, with a constant voltage generator and a simple resistor. This may be sufficient for analyses focusing on mass balances, where voltage behaviour is not important. In the basic version, activation and mass_transport voltage losses are modelled with short circuits (i.e. no losses at all).</div><div>More complex behaviour can be simulated by replacing the voltage_source, ohmic, activation and mass_transport components with more detailed objects, with the restriction they must inherit from OnePort. While there is no way to enforce this strictly, it would be appropriate to follow the naming convention and e.g. use activation to implement Butler-Volmer kinetics, mass_transport to implement Warburg elements, and so on. More complex setups can be nested defining new classes inheriting from&nbsp;OnePort.</div><div>Other relevant behaviours can be simulated by adding elements in parallel to the circuit. In particular, it is possible to:</div><div><ul><li>Add a capacitor in parallel to activation, to simulate a charge double layer;</li><li>Add a current generator or a resistance between pin_p and pin_n, to simulate crossover current.</li></ul></div><h1>Mass balances</h1><div>The mass balances in anode and cathode are implemented by two Manifolds. Both are fed the reaction rate given by the circuit current, multiplied by the number of cells and divided by nF.</div><div>Each Manifold is configured with the appropriate stoichiometric coefficients nu and molar masses M, consistently with their medium.</div><div>The default mediums are &nbsp;wet hydrogen &nbsp;on the cathode and 3-component moist air on the anode (oxygen, nitrogen, water). These can be replaced in child classes, in which cases the Manifolds may require adaptation.</div><div><br></div><div>The model can work with flow inversion, but it is recommended to switch it off in the outer system definition as it may mask underlying modelling issues.</div><h1>Thermal balance</h1><div>The heat balance is calculated automatically by the Manifolds based on the enthalpies of entering and exiting flows. The heat balance is also fed a contribution equal to the stack's power input, from which the enthalpy balance is subtracted to obtain the rate of heat accumulation; a heat capacitor simulates heat holdup.</div><div>As PEM electrolysers usually exploit the large water flow in the anode as coolant, this class does not implement a separate coolant circuit; if required, it can be implemented either in child classes or externally, connecting a thermal conductor to the heatPort.</div><div>The heatPort may be connected to other external units such as radiating or convection heat exchange, or to a FixedTemperature if the temperature transients are not of interest.</div><h1>Rainbow and black-sheep elements</h1><div>The replaceable nature of circuit elements and Manifolds makes it possible to simulate more complex stacks. In the default implementation, only one cell is modelled, with the stack voltage being obtained by simply multiplying its voltage by N<sub>cells</sub>; similarly, the manifolds are assumed to have uniform, zero-dimensional compositions.</div><div><b><br></b></div><div><b>Rainbow </b>stacks, i.e. stacks with cells with different properties simulated in parallel, can be implemented by replacing the elements of the model with custom submodels that implement N<sub>cells&nbsp;</sub>elements within themselves, presumably with different parameters. E.g. a ohmic could be replaced by an element containing N<sub>cells</sub> resistors of different value.</div><div>Note that rainbow stacks do not need to be implemented for every aspect at the same time: for example, we may replace activation with an array of Butler-Volmer elements, but leave v_source as a single generator, depending on the purpose of the simulation.</div><div>The arrays of new elements could also require connection with the manifolds, e.g. if an advanced Nernst element were to need the composition at anode and cathode; proper connections will have to be devised in that case.</div><div><b><br></b></div><div><b>Black-sheep</b>&nbsp;simulations are similar to rainbow simulations, but only one cell is simulated on its own, whereas the other N<sub>cells</sub>-1 cells are aggregated. This is useful if we want to simulate the effect of one defective cell without increasing excessively the number of equations.</div><h1>Limitations</h1><div>The presence of a lumped heatCapacitor and of a central subtraction of electricPower from the heat balance makes it difficult to implement a rainbow stack with different temperatures for each cell. Such a setup could be be realised setting N<sub>cells</sub>=1 and instantiating one PEMElectrolyser object per cell, connecting them electrically in series, in parallel for cathodes and anodes, and thermally in series with interlaced thermal conductors.</div><div>Such a setup would however rapidly become computationally onerous.</div></body></html>"));
end PEMElectrolyser;
