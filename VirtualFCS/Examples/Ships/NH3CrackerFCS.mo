within VirtualFCS.Examples.Ships;

model NH3CrackerFCS
  inner Modelica.Fluid.System system;
  // Medium
  package AmmoniaMedium = VirtualFCS.Media.CrackedAmmonia;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  // Parameters
  parameter Modelica.Units.SI.Pressure P_H2_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_NH3_tank_start = 20e5 "Initial H2 tank pressure";


  Chemical.AmmoniaCracker.AmmoniaCrackerStatic ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium)  annotation(
    Placement(transformation(origin = {59, 57}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Vessels.ClosedVolume ammoniaTank(redeclare package Medium = AmmoniaMedium, nPorts = 1, portsData(each diameter = 0.1), V = 1)  annotation(
    Placement(transformation(origin = {-88, 60}, extent = {{-10, -10}, {10, 10}})));
  Fluid.SimplePump ammoniaPump(redeclare package Medium = AmmoniaMedium)  annotation(
    Placement(transformation(origin = {-56, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Pipes.DynamicPipe NH3Vaporizer(use_HeatTransfer = true, redeclare package Medium = AmmoniaMedium, length = 10, nParallel = 20, diameter = 0.1)  annotation(
    Placement(transformation(origin = {-14, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater1 annotation(
    Placement(transformation(origin = {-28, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogenSink(nPorts = 1, redeclare package Medium = HydrogenMedium, p = 2e6)  annotation(
    Placement(transformation(origin = {44, -30}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Fluid.PSASimple psa(sep_eff = 0.9)  annotation(
    Placement(transformation(origin = {62, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = 2e6) annotation(
    Placement(transformation(origin = {74, -32}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant heat(k = 1000)  annotation(
    Placement(transformation(origin = {-51, 75}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Sources.Constant NH3_mf(k = 1) annotation(
    Placement(transformation(origin = {-67, 41}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage voltageSource(V = 48) annotation(
    Placement(transformation(origin = {-54, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-34, -20}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(heater1.port, NH3Vaporizer.heatPorts[1]) annotation(
    Line(points = {{-18, 56}, {-14, 56}, {-14, 34}}, color = {191, 0, 0}));
  connect(ammoniaTank.ports[1], ammoniaPump.port_a) annotation(
    Line(points = {{-88, 50}, {-88, 22}, {-66, 22}}, color = {0, 127, 255}));
  connect(ammoniaPump.port_b, NH3Vaporizer.port_a) annotation(
    Line(points = {{-46, 30}, {-24, 30}}, color = {0, 127, 255}));
  connect(NH3Vaporizer.port_b, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{-4, 30}, {20, 30}, {20, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(ammoniaCracker.outlet_cracked_gas, psa.feed) annotation(
    Line(points = {{78, 62}, {86, 62}, {86, 14}, {72, 14}}, color = {0, 127, 255}));
  connect(psa.product, hydrogenSink.ports[1]) annotation(
    Line(points = {{52, 12}, {44, 12}, {44, -20}}, color = {0, 127, 255}));
  connect(psa.tail, tailSink.ports[1]) annotation(
    Line(points = {{72, 10}, {74, 10}, {74, -22}}, color = {0, 127, 255}));
  connect(heat.y, heater1.Q_flow) annotation(
    Line(points = {{-44, 76}, {-38, 76}, {-38, 56}}, color = {0, 0, 127}));
  connect(NH3_mf.y, ammoniaPump.u) annotation(
    Line(points = {{-60, 42}, {-56, 42}, {-56, 32}}, color = {0, 0, 127}));
  connect(voltageSource.n, ground.p) annotation(
    Line(points = {{-44, -10}, {-34, -10}}, color = {0, 0, 255}));
  connect(voltageSource.p, ammoniaPump.pin_p) annotation(
    Line(points = {{-64, -10}, {-64, 6}, {-60, 6}, {-60, 12}}, color = {0, 0, 255}));
  connect(voltageSource.n, ammoniaPump.pin_n) annotation(
    Line(points = {{-44, -10}, {-44, 6}, {-50, 6}, {-50, 12}}, color = {0, 0, 255}));
end NH3CrackerFCS;
