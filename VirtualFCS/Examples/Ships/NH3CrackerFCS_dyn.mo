within VirtualFCS.Examples.Ships;

model NH3CrackerFCS_dyn
  inner Modelica.Fluid.System system;
  // Medium
  package AmmoniaMedium = Media.CrackedAmmonia;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  // Parameters
  parameter Modelica.Units.SI.Pressure P_H2_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_NH3_tank_start = 10e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_out_PSA = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Temperature T_out_target = 550 + 273.15 "Target outlet temperature for ammonia cracker";
  parameter Modelica.Units.SI.Temperature T_start = T_out_target "Start temperature for ammonia cracker";
  parameter Modelica.Units.SI.Temperature T_NH3_tank = 20 + 273.15 "Start temperature for ammonia cracker";
  parameter Modelica.Units.SI.MassFraction X_start[3] = {0.998, 0.001, 0.001} "Initial mass fractions {NH3, H2, N2}";
  parameter Integer N = 10 "Number of computational segments for ammonia cracker";
  parameter Modelica.Units.SI.Pressure P_feed_start = P_out_PSA "Initial pressure of the NH3 feed line and cracker inlet. The feed is ~99.8% NH3 by mass with trace non-condensable H2/N2 at T_NH3_tank; because H2/N2 can never dissolve into the liquid (see AmmoniaMedium.invertedKs), the mixture's bubble-point pressure at that temperature is fixed by phase equilibrium (Raoult's law, slightly above the pure-NH3 saturation pressure since the non-condensables dilute the vapour). This value is that equilibrium pressure, confirmed by simulation: the model converges to it regardless of what p_start/p_a_start/p_b_start guesses are supplied, so guessing a different value (e.g. the unrelated downstream P_out_PSA) leaves the cracker's first segment badly mismatched with the feed and causes a large reversed inrush flow";
  Chemical.AmmoniaCracker.AmmoniaCrackerDyn ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium, constantTemperature = false, dp_small = 1e4, p_start = P_out_PSA, N = N, T_out_target = T_out_target, T_start = T_start, X_start = X_start) annotation(
    Placement(transformation(origin = {59, 57}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Pipes.DynamicPipe NH3Vaporizer(use_HeatTransfer = true, redeclare package Medium = AmmoniaMedium, length = 10, nParallel = 20, diameter = 0.1, m_flow_start = 0.3, X_start = X_start, p_a_start = P_feed_start, p_b_start = P_feed_start) annotation(
    Placement(transformation(origin = {-8, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater1(T_ref = 1173.15) annotation(
    Placement(transformation(origin = {-12, 86}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogenSink(nPorts = 1, redeclare package Medium = HydrogenMedium, p = P_out_PSA) annotation(
    Placement(transformation(origin = {44, -78}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Fluid.PSASimple psa(sep_eff = 0.9) annotation(
    Placement(transformation(origin = {62, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = P_out_PSA) annotation(
    Placement(transformation(origin = {74, -80}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant heat(k = 1e4) annotation(
    Placement(transformation(origin = {-47, 87}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Fluid.Sensors.Temperature temp_in_cracker(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {24, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_out_cracker(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {76, -8}, extent = {{10, -10}, {-10, 10}})));
  Chemical.AmmoniaCracker.ElectricHeatingDistr electricHeatingDistr annotation(
    Placement(transformation(origin = {48, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  Modelica.Fluid.Vessels.ClosedVolume ammoniaTank(redeclare package Medium = AmmoniaMedium, T_start = 293.15, V = 100, nPorts = 1, p_start = P_NH3_tank_start, portsData(each diameter = 0.1)) annotation(
    Placement(transformation(origin = {-88, 62}, extent = {{-10, -10}, {10, 10}})));
  VirtualFCS.Fluid.SimplePump ammoniaPump(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {-56, 24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant NH3_mf(k = 0.3) annotation(
    Placement(transformation(origin = {-67, 43}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage voltageSource(V = 48) annotation(
    Placement(transformation(origin = {-54, -8}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
equation
  connect(heater1.port, NH3Vaporizer.heatPorts[1]) annotation(
    Line(points = {{-2, 86}, {-2, 69}, {0, 69}, {0, 58}, {-9, 58}, {-9, 38}, {-8.5, 38}, {-8.5, 36}, {-8, 36}}, color = {191, 0, 0}));
  connect(NH3Vaporizer.port_b, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{2, 32}, {20, 32}, {20, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(ammoniaCracker.outlet_cracked_gas, psa.feed) annotation(
    Line(points = {{78, 62}, {86, 62}, {86, -34}, {72, -34}}, color = {0, 127, 255}));
  connect(psa.product, hydrogenSink.ports[1]) annotation(
    Line(points = {{52, -36}, {44, -36}, {44, -68}}, color = {0, 127, 255}));
  connect(psa.tail, tailSink.ports[1]) annotation(
    Line(points = {{72, -38}, {74, -38}, {74, -70}}, color = {0, 127, 255}));
  connect(heat.y, heater1.Q_flow) annotation(
    Line(points = {{-39, 87}, {-29.3, 87}, {-29.3, 85}, {-21.6, 85}}, color = {0, 0, 127}));
  connect(temp_in_cracker.port, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{24, 74}, {24, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(temp_out_cracker.port, ammoniaCracker.outlet_cracked_gas) annotation(
    Line(points = {{76, -18}, {86, -18}, {86, 62}, {78, 62}}, color = {0, 127, 255}));
  connect(temp_out_cracker.T, electricHeatingDistr.T_meas) annotation(
    Line(points = {{69, -8}, {62, -8}, {62, -7}, {57, -7}}, color = {0, 0, 127}));
  connect(electricHeatingDistr.heatPorts, ammoniaCracker.heatPorts) annotation(
    Line(points = {{48, 0}, {48, 24}, {60, 24}, {60, 38}}, color = {191, 0, 0}, thickness = 0.5));
  connect(ammoniaTank.ports[1], ammoniaPump.port_a) annotation(
    Line(points = {{-88, 52}, {-88, 24}, {-66, 24}}, color = {0, 127, 255}));
  connect(NH3_mf.y, ammoniaPump.u) annotation(
    Line(points = {{-59.3, 43}, {-56.3, 43}, {-56.3, 33}}, color = {0, 0, 127}));
  connect(voltageSource.p, ammoniaPump.pin_p) annotation(
    Line(points = {{-64, -8}, {-64, 8}, {-61, 8}, {-61, 14}}, color = {0, 0, 255}));
  connect(voltageSource.n, ammoniaPump.pin_n) annotation(
    Line(points = {{-44, -8}, {-44, 8}, {-51, 8}, {-51, 14}}, color = {0, 0, 255}));
  connect(ammoniaPump.port_b, NH3Vaporizer.port_a) annotation(
    Line(points = {{-46, 32}, {-18, 32}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 1, Interval = 0.01, Tolerance = 1e-06, __Dymola_Algorithm = "Dassl"));
end NH3CrackerFCS_dyn;
