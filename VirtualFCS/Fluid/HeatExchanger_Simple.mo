within VirtualFCS.Fluid;

model HeatExchanger_Simple
  extends VirtualFCS.Fluid.HeatExchangerInterface;
  Electrochemical.Hydrogen.Manifold manifold_a(useHeatPort = true, redeclare package Medium = Medium_a)  annotation(
    Placement(transformation(origin = {0, 50}, extent = {{-20, -20}, {20, 20}})));
  VirtualFCS.Electrochemical.Hydrogen.Manifold manifold_b(useHeatPort = true, redeclare package Medium = Medium_b)  annotation(
    Placement(transformation(origin = {0, -50}, extent = {{-20, 20}, {20, -20}}, rotation = -0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 1000)  annotation(
    Placement(transformation( extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant reaction(k = 0)  annotation(
    Placement(transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(manifold_a.heatPort, thermalConductor.port_a) annotation(
    Line(points = {{0, 30}, {-40, 30}, {-40, 0}, {-10, 0}}, color = {191, 0, 0}));
  connect(manifold_b.heatPort, thermalConductor.port_b) annotation(
    Line(points = {{0, -30}, {40, -30}, {40, 0}, {10, 0}}, color = {191, 0, 0}));
  connect(manifold_a.port_b, port_a2) annotation(
    Line(points = {{20, 50}, {100, 50}}, color = {0, 127, 255}));
  connect(manifold_a.port_a, port_a1) annotation(
    Line(points = {{-20, 50}, {-100, 50}}, color = {0, 127, 255}));
  connect(manifold_b.port_a, port_b1) annotation(
    Line(points = {{-20, -50}, {-100, -50}}, color = {0, 127, 255}));
  connect(manifold_b.port_b, port_b2) annotation(
    Line(points = {{20, -50}, {100, -50}}, color = {0, 127, 255}));
  connect(reaction.y, manifold_a.r) annotation(
    Line(points = {{-58, 70}, {0, 70}, {0, 64}}, color = {0, 0, 127}));
  connect(reaction.y, manifold_b.r) annotation(
    Line(points = {{-58, 70}, {-50, 70}, {-50, -80}, {0, -80}, {0, -64}}, color = {0, 0, 127}));
end HeatExchanger_Simple;
