within VirtualFCS.Electrochemical.Hydrogen;

model Electrolyser
  extends VirtualFCS.Electrochemical.Hydrogen.ElyInterface;
  import Modelica.Constants.F "Faraday constant";
  import Modelica.Electrical.Analog.Interfaces.OnePort;
  import SI = Modelica.Units.SI;
  // Parameters
  //inner Real phi = cathode.medium.phi "check mol/mass fraction";
  inner Real phi = 1;
  // ECM
  replaceable VirtualFCS.Electrochemical.Hydrogen.OhmicResistance ohmic "Internal resistance" annotation(
    Placement(visible = true, transformation(origin = {56, 100}, extent = {{-18, 18}, {18, -18}}, rotation = 0))) constrainedby BaseOhmic;
  replaceable VirtualFCS.Electrochemical.Hydrogen.MassTransportLossSimple mass_transport annotation(
    Placement(transformation(origin = {102, 100}, extent = {{-18, 18}, {18, -18}}))) constrainedby BaseMassTransportLoss;
  replaceable Modelica.Electrical.Analog.Sources.ConstantCurrent crossover(I = 0) annotation(
    Placement(transformation(origin = {0, 150}, extent = {{20, -20}, {-20, 20}}, rotation = -0)));
  Modelica.Electrical.Analog.Sensors.MultiSensor multiSensor annotation(
    Placement(transformation(origin = {-100, 120}, extent = {{20, 20}, {-20, -20}}, rotation = 90)));
  inner parameter Integer N_cells = 1 "Number of cells in the stack";
  inner parameter Modelica.Units.SI.Area A_el = 0.0025 "Area of the fuel cell electrode (m^2)";
  // Constants
  //  constant Modelica.Units.SI.SpecificEnergy H2HHV = 142e6 "(J/kg) Hydrogen low heating value";
  // constant Modelica.Units.SI.SpecificEnergy H2LHV = 120e6 "(J/kg) Hydrogen low heating value";
  // constant Real eta_max = 70. "Maximum system efficiency to avoid spurious peak efficiencies due to current step changes";
  constant Modelica.Units.SI.MolarHeatCapacity R = Modelica.Constants.R "Universal gas constant";
  constant Modelica.Units.SI.FaradayConstant F = Modelica.Constants.F "Faraday constant";
  final constant Integer n = 4 "Electrons exchanged in reaction";
  constant SI.MolarMass M_H2 = Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM "Molar mass of hydrogen";
  constant SI.MolarMass M_N2 = Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM "Molar mass of nitrogen";
  constant SI.MolarMass M_O2 = Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM "Molar mass of oxygen";
  constant SI.MolarMass M_H2O = Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM "Molar mass of water";
  // Convenience variables (Used by inner models)
  inner Modelica.Units.SI.AbsolutePressure p_H2(min = 0) = (anode.port_a.p + anode.port_b.p)/2;
  inner Modelica.Units.SI.AbsolutePressure p_O2(min = 0) = (cathode.port_a.p + cathode.port_b.p)/2*cathode.medium.X[Media.CathodeAir.Oxygen];
  inner Modelica.Units.SI.Temperature T_stack = heatPort.T;
  
  // Outputs
  //Real eta_stack_HHV(unit = "100") "Higher heating value efficiency of fuel cell stack";
  //Real eta_stack_LHV(unit = "100") "Lower heating value efficiency of fuel cell stack";
  // Heat capacitor
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = 110, T(start = 293.15, fixed = true)) annotation(
    Placement(visible = true, transformation(origin = {-47, -57}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  // Cathode Manifold
  replaceable VirtualFCS.Electrochemical.Hydrogen.Manifold cathode(redeclare package Medium = Cathode_Medium, MMs = {M_H2}, nu = {2}, useHeatPort = true) annotation(
    Placement(visible = true, transformation(origin = {-96, 0}, extent = {{-26, -26}, {26, 26}}, rotation = -90)));
  // Anode Manifold
  replaceable VirtualFCS.Electrochemical.Hydrogen.Manifold anode(redeclare package Medium = Anode_Medium, MMs = {M_H2O, M_O2, M_N2}, nu = {-2, 1, 0}, useHeatPort = true) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{28, -28}, {-28, 28}}, rotation = 90)));
  VirtualFCS.Electrochemical.Hydrogen.ActivationLossSimple activationLossSimple annotation(
    Placement(visible = true, transformation(origin = {2, 98}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  VirtualFCS.Electrochemical.Hydrogen.VSourceConstant v_source annotation(
    Placement(visible = true, transformation(origin = {-60, 100}, extent = {{-18, -18}, {18, 18}}, rotation = 180)));
protected
  Modelica.Blocks.Math.Gain minus(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-30, 36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain reaction_rate(k = -N_cells/n/F) annotation(
    Placement(visible = true, transformation(origin = {26, 44}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow electricPower annotation(
    Placement(visible = true, transformation(origin = {0, -28}, extent = {{-18, -18}, {18, 18}}, rotation = -90)));
equation
// eta_stack_HHV = min(multiSensor.power/(max((anode_in.m_flow + anode_out.m_flow), 1e-10)*H2HHV)*100, eta_max);
//  eta_stack_LHV = min(multiSensor.power/(max((anode_in.m_flow + anode_out.m_flow), 1e-10)*H2LHV)*100, eta_max);
  connect(mass_transport.n, pin_p) annotation(
    Line(points = {{120, 100}, {120, 150}, {60, 150}}, color = {0, 0, 255}));
  connect(electricPower.port, heatPort) annotation(
    Line(points = {{0, -46}, {0, -150}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{-47, -74}, {0, -74}, {0, -150}}, color = {191, 0, 0}));
  connect(electricPower.Q_flow, minus.y) annotation(
    Line(points = {{0, -10}, {0, 4.5}, {-30, 4.5}, {-30, 25}}, color = {191, 0, 0}));
  connect(multiSensor.nv, pin_n) annotation(
    Line(points = {{-120, 120}, {-130, 120}, {-130, 150}, {-74, 150}}, color = {0, 0, 255}));
  connect(multiSensor.power, minus.u) annotation(
    Line(points = {{-112, 142}, {-112, 146.5}, {-147, 146.5}, {-147, 57}, {-30, 57}, {-30, 48}}, color = {191, 0, 0}));
  connect(pin_n, multiSensor.pc) annotation(
    Line(points = {{-60, 150}, {-100, 150}, {-100, 140}}, color = {0, 0, 255}));
  connect(multiSensor.pv, pin_p) annotation(
    Line(points = {{-80, 120}, {60, 120}, {60, 150}}, color = {0, 0, 255}));
  connect(mass_transport.p, ohmic.n) annotation(
    Line(points = {{84, 100}, {74, 100}}, color = {0, 0, 255}));
  connect(multiSensor.i, reaction_rate.u) annotation(
    Line(points = {{-122, 132}, {-140, 132}, {-140, 80}, {26, 80}, {26, 64}}, color = {0, 0, 127}));
  connect(crossover.p, pin_p) annotation(
    Line(points = {{20, 150}, {60, 150}}, color = {0, 0, 255}));
  connect(pin_n, crossover.n) annotation(
    Line(points = {{-60, 150}, {-20, 150}}, color = {0, 0, 255}));
  connect(anode.port_a, anode.port_b) annotation(
    Line(points = {{100, 28}, {100, -28}}, color = {0, 127, 255}));
  connect(cathode_in, cathode.port_a) annotation(
    Line(points = {{-150, 40}, {-96, 40}, {-96, 26}}));
  connect(cathode.port_b, cathode_out) annotation(
    Line(points = {{-96, -26}, {-96, -40}, {-150, -40}}, color = {0, 127, 255}));
  connect(reaction_rate.y, cathode.r) annotation(
    Line(points = {{26, 26}, {26, 0}, {-78, 0}}, color = {0, 0, 127}));
  connect(reaction_rate.y, anode.r) annotation(
    Line(points = {{26, 26}, {26, 0}, {80, 0}}, color = {0, 0, 127}));
  connect(anode.port_a, anode_in) annotation(
    Line(points = {{100, 28}, {100, 40}, {150, 40}}, color = {0, 127, 255}));
  connect(anode.port_b, anode_out) annotation(
    Line(points = {{100, -28}, {100, -40}, {150, -40}}, color = {0, 127, 255}));
  connect(heatPort, anode.heatPort) annotation(
    Line(points = {{0, -150}, {128, -150}, {128, 0}}, color = {191, 0, 0}));
  connect(heatPort, cathode.heatPort) annotation(
    Line(points = {{0, -150}, {-126, -150}, {-126, 0}, {-122, 0}}, color = {191, 0, 0}));
  connect(activationLossSimple.n, ohmic.p) annotation(
    Line(points = {{20, 98}, {30, 98}, {30, 100}, {38, 100}}, color = {0, 0, 255}));
  connect(multiSensor.nc, v_source.n) annotation(
    Line(points = {{-100, 100}, {-78, 100}}, color = {0, 0, 255}));
  connect(v_source.p, activationLossSimple.p) annotation(
    Line(points = {{-42, 100}, {-29, 100}, {-29, 98}, {-16, 98}}, color = {0, 0, 255}));
  annotation(
    Diagram,
    Documentation(info = "<html><head></head><body>This model describes the dynamic behaviour of a proton exchange membrane fuel cell (PEMFC). The model includes components describing the electrical, fluidic, and thermal properties of the cell.<h1>Electric model</h1><div>The basic electrical performance is modelled after a basic Thévenin circuit, with a constant voltage generator and a simple resistor. This may be sufficient for analyses focusing on mass balances, where voltage behaviour is not important. In the basic version, activation and mass_transport voltage losses are modelled with short circuits (i.e. no losses at all).</div><div>More complex behaviour can be simulated by replacing the v_source, ohmic, activation and mass_transport components with more detailed objects, with the restriction they must inherit from OnePort. While there is no way to enforce this strictly, it would be appropriate to follow the naming convention and e.g. use activation to implement Butler-Volmer kinetics, mass_transport to implement Warburg elements, and so on. More complex setups can be nested defining new classes inheriting from&nbsp;OnePort.</div><div>Other relevant behaviours can be simulated by adding elements in parallel to the circuit. In particular, it is possible to:</div><div><ul><li>Add a capacitor in parallel to activation, to simulate a charge double layer;</li><li>Add a current generator or a resistance between pin_p and pin_n, to simulate crossover current.</li></ul></div><h1>Mass balances</h1><div>The mass balances in anode and cathode are implemented by two Manifolds. Both are fed the reaction rate given by the circuit current, multiplied by the number of cells and divided by 2F.</div><div>Each Manifold is configured with the appropriate stoichiometric coefficients nu and molar masses M, consistently with their medium.</div><div>The default mediums are pure hydrogen on the anode and 3-component moist air on the cathode (oxygen, nitrogen, water). These can be replaced in child classes, in which cases the Manifolds may require adaptation.</div><div><br></div><div>The model can work with flow inversion, but it is recommended to switch it off in the outer system definition as it may mask underlying modelling issues.</div><h1>Thermal balance</h1><div>The heat generated by the reaction is calculated automatically by the Manifolds based on the enthalpies of entering and exiting flows. The heat balance is also fed a negative contribution equal to the stack's power production, as this exported energy will not contribute toward increasing the heat holdup.</div><div>A heat capacitor simulates heat holdup. A thermalConductor connects the stack to its coolant pipe.</div><div>The heat network is connected to a heatPort, which may be connected to other external units such as radiating or convection heat exchange, or to a FixedTemperature if the temperature transients are not of interest.</div><div><b><br></b></div><div><b>NB!</b>&nbsp;If you use a FixedTemperature, remember to still attach a boundary to the coolant outlet, or the simulation will not converge, as the coolant volume will expand with temperature with no volume to do so. The flow will be minimal but not zero.</div><h1>Rainbow and black-sheep elements</h1><div>The replaceable nature of circuit elements and Manifolds makes it possible to simulate more complex stacks. In the default implementation, only one cell is modelled, with the stack voltage being obtained by simply multiplying its voltage by N<sub>cell</sub>; similarly, the manifolds are assumed to have uniform, zero-dimensional compositions.</div><div><b><br></b></div><div><b>Rainbow </b>stacks, i.e. stacks with cells with different properties simulated in parallel, can be implemented by replacing the elements of the model with custom submodels that implement N<sub>cell </sub>elements within themselves, presumably with different parameters. E.g. a ohmic could be replaced by an element containing N<sub>cell</sub> resistors of different value.</div><div>Note that rainbow stacks do not need to be implemented for every aspect at the same time: for example, we may replace activation with an array of Butler-Volmer elements, but leave v_source as a single generator, depending on the purpose of the simulation.</div><div>The arrays of new elements could also require connection with the manifolds, e.g. if an advanced nernst element were to need the composition at anode and cathode; proper connections will have to be devised in that case.</div><div><b><br></b></div><div><b>Black-sheep</b>&nbsp;simulations are similar to rainbow simulations, but only one cell is simulated on its own, whereas the other N<sub>cell</sub>-1 cells are aggregated. This is useful if we want to simulate the effect of a defective cell without increasing excessively the number of equations.</div><h1>Limitations</h1><div>The presence of a lumped heatCapacitor and of a central subtraction of electricPower from the heat balance makes it difficult to implement a rainbow stack with different temperatures for each cell.</div></body></html>"));
end Electrolyser;
