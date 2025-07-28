within VirtualFCS.ComponentTesting;

model ReversiblePotentialTest
  extends Modelica.Icons.Example;
  Electrochemical.Hydrogen.ReversibleVoltage E_rev(useHeatPort = true, N_cell = 1)  annotation(
    Placement(transformation(origin = {0, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {60, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary anode(nPorts = 1, redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2)  annotation(
    Placement(transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary cathode(redeclare package Medium = VirtualFCS.Media.CathodeAir, nPorts = 1, use_T = true, X = {1, 0, 0})  annotation(
    Placement(transformation(origin = {70, 10}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(fixedTemperature.port, E_rev.heatPort) annotation(
    Line(points = {{-20, -30}, {0, -30}, {0, 20}}, color = {191, 0, 0}));
//E_rev.anode.p = 101325;
//E_rev.cathode.p = 101325;
  connect(ground.p, E_rev.n) annotation(
    Line(points = {{60, 40}, {20, 40}}, color = {0, 0, 255}));
  connect(E_rev.anode, anode.ports[1]) annotation(
    Line(points = {{-14, 26}, {-14, 10}, {-60, 10}}, color = {0, 127, 255}));
  connect(E_rev.cathode, cathode.ports[1]) annotation(
    Line(points = {{14, 26}, {14, 10}, {60, 10}}, color = {0, 127, 255}));
end ReversiblePotentialTest;
