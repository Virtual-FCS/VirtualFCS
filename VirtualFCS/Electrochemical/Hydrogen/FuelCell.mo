within VirtualFCS.Electrochemical.Hydrogen;

model FuelCell
  extends VirtualFCS.Electrochemical.Hydrogen.FCInterface;
  
  import Modelica.Constants.F "Faraday constant";
  import Modelica.Electrical.Analog.Interfaces.OnePort;
  import SI = Modelica.Units.SI;
  
  replaceable Modelica.Electrical.Analog.Sources.ConstantVoltage OCV(V = 0.9*N_cell) "Open-circuit voltage" annotation(
    Placement(transformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 180))) constrainedby OnePort;
  replaceable Modelica.Electrical.Analog.Basic.Resistor ohmic(R = N_cell*r/A) "Internal resistance" annotation(
    Placement(transformation(origin = {-10, 110}, extent = {{-10, 10}, {10, -10}}))) constrainedby OnePort;
  replaceable Modelica.Electrical.Analog.Ideal.Short mass_transport annotation(
    Placement(transformation(origin = {70, 110}, extent = {{-10, 10}, {10, -10}}))) constrainedby OnePort;
  replaceable Modelica.Electrical.Analog.Ideal.Short catalysis annotation(
    Placement(transformation(origin = {30, 110}, extent = {{-10, 10}, {10, -10}}))) constrainedby OnePort;

  final constant Integer n = 2 "Electrons exchanged in reaction";
  constant SI.MolarMass M_H2 = Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM "Molar mass of hydrogen";
  constant SI.MolarMass M_N2  = Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM "Molar mass of nitrogen";
  constant SI.MolarMass M_O2  = Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM "Molar mass of oxygen";
  constant SI.MolarMass M_H2O = Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM "Molar mass of water";

  parameter Integer N_cell = 42 "Number of cells in the stack";
  parameter Modelica.Units.SI.Area A = 0.1 "Membrane active area";
  parameter ArealResistivity r = 0.002 "Areal resistivity of the membrane to proton conduction";
  
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = 1000)  annotation(
    Placement(transformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}})));
  replaceable Manifold cathode(redeclare package Medium = Cathode_Medium, useHeatPort = true, nu = {-0.5, 0, 1}, MMs = {M_O2, M_N2, M_H2O}) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  replaceable Manifold anode(useHeatPort = true, nu = {-1}, MMs = {M_H2}, redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.MultiSensor multiSensor annotation(
    Placement(transformation(origin = {-80, 128}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
equation
  connect(mass_transport.n, pin_p) annotation(
    Line(points = {{80, 110}, {100, 110}, {100, 150}, {60, 150}}, color = {0, 0, 255}));
  connect(catalysis.n, mass_transport.p) annotation(
    Line(points = {{40, 110}, {60, 110}}, color = {0, 0, 255}));
  connect(OCV.p, ohmic.p) annotation(
    Line(points = {{-40, 110}, {-20, 110}}, color = {0, 0, 255}));
  connect(anode.port_a, anode_in) annotation(
    Line(points = {{-100, 20}, {-100, 40}, {-150, 40}}, color = {0, 127, 255}));
  connect(anode.port_b, anode_out) annotation(
    Line(points = {{-100, -20}, {-100, -40}, {-150, -40}}, color = {0, 127, 255}));
  connect(cathode.port_a, cathode_in) annotation(
    Line(points = {{80, 20}, {80, 40}, {150, 40}}, color = {0, 127, 255}));
  connect(cathode.port_b, cathode_out) annotation(
    Line(points = {{80, -20}, {80, -40}, {150, -40}}, color = {0, 127, 255}));
  connect(anode.heatPort, heatPort) annotation(
    Line(points = {{-120, 0}, {-120, -140}, {0, -140}, {0, -150}, {0, -150}}, color = {191, 0, 0}));
  connect(cathode.heatPort, heatPort) annotation(
    Line(points = {{100, 0}, {100, -140}, {0, -140}, {0, -152}, {-1, -152}, {-1, -150}, {0, -150}}, color = {191, 0, 0}));
  connect(reaction_rate.y, cathode.r) annotation(
    Line(points = {{20, 39}, {20, 0}, {66, 0}}, color = {0, 0, 127}));
  connect(reaction_rate.y, anode.r) annotation(
    Line(points = {{20, 39}, {20, 0}, {-86, 0}}, color = {0, 0, 127}));
  connect(electricalPowerProduction.port, heatPort) annotation(
    Line(points = {{0, -80}, {0, -150}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{-30, -100}, {0, -100}, {0, -150}}, color = {191, 0, 0}));
  connect(electricalPowerProduction.Q_flow, minus.y) annotation(
    Line(points = {{0, -60}, {0, -41}}, color = {191, 0, 0}));
  connect(multiSensor.nv, pin_n) annotation(
    Line(points = {{-90, 128}, {-90, 150}, {-60, 150}}, color = {0, 0, 255}));
  connect(OCV.n, multiSensor.nc) annotation(
    Line(points = {{-60, 110}, {-80, 110}, {-80, 118}}, color = {0, 0, 255}));
  connect(ohmic.n, catalysis.p) annotation(
    Line(points = {{0, 110}, {20, 110}}, color = {0, 0, 255}));
  connect(multiSensor.i, reaction_rate.u) annotation(
    Line(points = {{-91, 134}, {-100, 134}, {-100, 80}, {20, 80}, {20, 62}}, color = {0, 0, 127}));
  connect(multiSensor.power, minus.u) annotation(
    Line(points = {{-86, 139}, {-120, 139}, {-120, 60}, {0, 60}, {0, -18}}, color = {191, 0, 0}));
  connect(pin_n, multiSensor.pc) annotation(
    Line(points = {{-60, 150}, {-80, 150}, {-80, 138}}, color = {0, 0, 255}));
  connect(multiSensor.pv, pin_p) annotation(
    Line(points = {{-70, 128}, {-40, 128}, {-40, 150}, {60, 150}}, color = {0, 0, 255}));  protected
  Modelica.Blocks.Math.Gain minus(k = -1)  annotation(
    Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain reaction_rate(k = N_cell/n/F)  annotation(
    Placement(transformation(origin = {20, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow electricalPowerProduction annotation(
    Placement(transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  annotation(
    Diagram,
  Documentation(info = "<html><head></head><body>This model describes the dynamic behaviour of a proton exchange membrane fuel cell (PEMFC). The model includes components describing the electrical, fluidic, and thermal properties of the cell.<h1>Electric model</h1><div>The basic electrical performance is modelled after a basic Thévenin circuit, with a constant voltage generator and a simple resistor. This may be sufficient for analyses focusing on mass balances, where voltage behaviour is not important. In the basic version, catalysis and mass_transport voltage losses are modelled with short circuits (i.e. no losses at all).</div><div>More complex behaviour can be simulated by replacing the OCV, ohmic, catalysis and mass_transport components with more detailed objects, with the restriction they must inherit from OnePort. While there is no way to enforce this strictly, it would be appropriate to follow the naming convention and e.g. use catalysis to implement Butler-Volmer kinetics, mass_transport to implement Warburg elements, and so on. More complex setups can be nested defining new classes inheriting from&nbsp;OnePort.</div><div>Other relevant behaviours can be simulated by adding elements in parallel to the circuit. In particular, it is possible to:</div><div><ul><li>Add a capacitor in parallel to catalysis, to simulate a charge double layer;</li><li>Add a current generator or a resistance between pin_p and pin_n, to simulate crossover current.</li></ul></div><h1>Mass balances</h1><div>The mass balances in anode and cathode are implemented by two Manifolds. Both are fed the reaction rate given by the circuit current, multiplied by the number of cells and divided by 2F.</div><div>Each Manifold is configured with the appropriate stoichiometric coefficients nu and molar masses M, consistently with their medium.</div><div>The default mediums are pure hydrogen on the anode and 3-component moist air on the cathode (oxygen, nitrogen, water). These can be replaced in child classes, in which cases the Manifolds may require adaptation.</div><div><br></div><div>The model can work with flow inversion, but it is recommended to switch it off in the outer system definition as it may mask underlying modelling issues.</div><h1>Thermal balance</h1><div>The heat generated by the reaction is calculated automatically by the Manifolds based on the enthalpies of entering and exiting flows. The heat balance is also fed a negative contribution equal to the stack's power production, as this exported energy will not contribute toward increasing the heat holdup.</div><div>Finally, a heat capacitor is added to the network to simulate temperature dynamics. The heat network is connected to a heatPort, which may lead to a cooling circuit model, or to a FixedTemperature if the temperature transients are not of interest.</div><h1>Rainbow and black-sheep elements</h1><div>The replaceable nature of circuit elements and Manifolds makes it possible to simulate more complex stacks. In the default implementation, only one cell is modelled, with the stack voltage being obtained by simply multiplying its voltage by N<sub>cell</sub>; similarly, the manifolds are assumed to have uniform, zero-dimensional compositions.</div><div><b><br></b></div><div><b>Rainbow </b>stacks, i.e. stacks with cells with different properties simulated in parallel, can be implemented by replacing the elements of the model with custom submodels that implement N<sub>cell </sub>elements within themselves, presumably with different parameters. E.g. a ohmic could be replaced by an element containing N<sub>cell</sub> resistors of different value.</div><div>Note that rainbow stacks do not need to be implemented for every aspect at the same time: for example, we may replace catalysis with an array of Butler-Volmer elements, but leave OCV as a single generator, depending on the purpose of the simulation.</div><div>The arrays of new elements could also require connection with the manifolds, e.g. if an advanced OCV element were to need the composition at anode and cathode; proper connections will have to be devised in that case.</div><div><b><br></b></div><div><b>Black-sheep</b>&nbsp;simulations are similar to rainbow simulations, but only one cell is simulated on its own, whereas the other N<sub>cell</sub>-1 cells are aggregated. This is useful if we want to simulate the effect of a defective cell without increasing excessively the number of equations.</div><div><br></div></body></html>"));
end FuelCell;
