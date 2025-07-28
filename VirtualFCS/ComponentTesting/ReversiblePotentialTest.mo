within VirtualFCS.ComponentTesting;

model ReversiblePotentialTest
  extends Modelica.Icons.Example;
  Electrochemical.Hydrogen.ReversibleVoltage E_rev(useHeatPort = true)  annotation(
    Placement(transformation(origin = {0, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 343.15)  annotation(
    Placement(transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T anode(nPorts = 1, redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2)  annotation(
    Placement(transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T cathode(redeclare package Medium = VirtualFCS.Media.CathodeAir, nPorts = 1)  annotation(
    Placement(transformation(origin = {70, 10}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(fixedTemperature.port, E_rev.heatPort) annotation(
    Line(points = {{-20, -30}, {0, -30}, {0, 20}}, color = {191, 0, 0}));
  connect(cathode.ports[1], E_rev.cathode) annotation(
    Line(points = {{60, 10}, {14, 10}, {14, 26}}, color = {0, 127, 255}));
  connect(anode.ports[1], E_rev.anode) annotation(
    Line(points = {{-60, 10}, {-14, 10}, {-14, 26}}, color = {0, 127, 255}));
end ReversiblePotentialTest;
