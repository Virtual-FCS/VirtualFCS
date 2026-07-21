within VirtualFCS.Fluid;

model HeatExchanger_Simple
  extends VirtualFCS.Fluid.HeatExchangerInterface;
  Fluid.MixingVolume mixvol_a(useHeatPort = true, redeclare package Medium = Medium_a)  annotation(
    Placement(transformation(origin = {0, 50}, extent = {{-20, -20}, {20, 20}})));
  Fluid.MixingVolume mixvol_b(useHeatPort = true, redeclare package Medium = Medium_b)  annotation(
    Placement(transformation(origin = {0, -50}, extent = {{-20, 20}, {20, -20}}, rotation = -0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 1000)  annotation(
    Placement(transformation( extent = {{-10, -10}, {10, 10}})));
equation
  connect(mixvol_a.heatPort, thermalConductor.port_a) annotation(
    Line(points = {{0, 30}, {-40, 30}, {-40, 0}, {-10, 0}}, color = {191, 0, 0}));
  connect(mixvol_b.heatPort, thermalConductor.port_b) annotation(
    Line(points = {{0, -30}, {40, -30}, {40, 0}, {10, 0}}, color = {191, 0, 0}));
  connect(mixvol_a.port_b, port_a2) annotation(
    Line(points = {{20, 50}, {100, 50}}, color = {0, 127, 255}));
  connect(mixvol_a.port_a, port_a1) annotation(
    Line(points = {{-20, 50}, {-100, 50}}, color = {0, 127, 255}));
  connect(mixvol_b.port_a, port_b1) annotation(
    Line(points = {{-20, -50}, {-100, -50}}, color = {0, 127, 255}));
  connect(mixvol_b.port_b, port_b2) annotation(
    Line(points = {{20, -50}, {100, -50}}, color = {0, 127, 255}));
end HeatExchanger_Simple;
