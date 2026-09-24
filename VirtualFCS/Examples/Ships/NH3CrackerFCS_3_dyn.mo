within VirtualFCS.Examples.Ships;

model NH3CrackerFCS_3_dyn
  inner Modelica.Fluid.System system;
  // Medium
  package AmmoniaMedium = Media.CrackedAmmonia;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  // Parameters
  parameter Modelica.Units.SI.Pressure P_H2_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_NH3_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_out_PSA = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Temperature T_out_target = 550 +273.15 "Target outlet temperature for ammonia cracker";
  parameter Modelica.Units.SI.Temperature T_start = T_out_target "Start temperature for ammonia cracker";
  parameter Modelica.Units.SI.Temperature T_NH3_tank = 20 + 273.15 "Start temperature for ammonia cracker";

  parameter Modelica.Units.SI.MassFraction X_start[3] = {0.998, 0.001, 0.001} "Initial mass fractions {NH3, H2, N2}";
 
  parameter Integer N = 10 "Number of computational segments for ammonia cracker";

  Chemical.AmmoniaCracker.AmmoniaCrackerDyn ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium, constantTemperature = false, dp_small = 100, p_start = P_out_PSA, N = N, T_out_target = T_out_target, T_start = T_start, X_start = X_start) annotation(
    Placement(transformation(origin = {59, 57}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Pipes.DynamicPipe NH3Vaporizer(use_HeatTransfer = true, redeclare package Medium = AmmoniaMedium, length = 10, nParallel = 20, diameter = 0.1, m_flow_start = 0.3, X_start = X_start) annotation(
    Placement(transformation(origin = {-24, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater1(T_ref = 1173.15)  annotation(
    Placement(transformation(origin = {-12, 86}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogenSink(nPorts = 1, redeclare package Medium = HydrogenMedium, p = P_out_PSA) annotation(
    Placement(transformation(origin = {44, -78}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Fluid.PSASimple psa(sep_eff = 0.9) annotation(
    Placement(transformation(origin = {62, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = P_out_PSA) annotation(
    Placement(transformation(origin = {74, -80}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant heat(k = 5e3) annotation(
    Placement(transformation(origin = {-47, 87}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, X = X_start, m_flow = 0.3, nPorts = 2, use_m_flow_in = false, T = T_NH3_tank) annotation(
    Placement(transformation(origin = {-84, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_in_cracker(redeclare package Medium = AmmoniaMedium)  annotation(
    Placement(transformation(origin = {24, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_out_cracker(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {76, -8}, extent = {{10, -10}, {-10, 10}})));
  Chemical.AmmoniaCracker.ElectricHeatingDistr electricHeatingDistr annotation(
    Placement(transformation(origin = {48, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
equation
  connect(heater1.port, NH3Vaporizer.heatPorts[1]) annotation(
    Line(points = {{-2, 86}, {-2, 69}, {0, 69}, {0, 58}, {-23, 58}, {-23, 36}, {-24, 36}}, color = {191, 0, 0}));
  connect(NH3Vaporizer.port_b, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{-14, 32}, {20, 32}, {20, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(ammoniaCracker.outlet_cracked_gas, psa.feed) annotation(
    Line(points = {{78, 62}, {86, 62}, {86, -34}, {72, -34}}, color = {0, 127, 255}));
  connect(psa.product, hydrogenSink.ports[1]) annotation(
    Line(points = {{52, -36}, {44, -36}, {44, -68}}, color = {0, 127, 255}));
  connect(psa.tail, tailSink.ports[1]) annotation(
    Line(points = {{72, -38}, {74, -38}, {74, -70}}, color = {0, 127, 255}));
  connect(heat.y, heater1.Q_flow) annotation(
    Line(points = {{-39, 87}, {-29.3, 87}, {-29.3, 85}, {-21.6, 85}}, color = {0, 0, 127}));
  connect(ammonia_source.ports[1], NH3Vaporizer.port_a) annotation(
    Line(points = {{-74, 34}, {-34, 34}, {-34, 32}}, color = {0, 127, 255}));
  connect(temp_in_cracker.port, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{24, 74}, {24, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(temp_out_cracker.port, ammoniaCracker.outlet_cracked_gas) annotation(
    Line(points = {{76, -18}, {86, -18}, {86, 62}, {78, 62}}, color = {0, 127, 255}));
  connect(temp_out_cracker.T, electricHeatingDistr.T_meas) annotation(
    Line(points = {{69, -8}, {62, -8}, {62, -7}, {57, -7}}, color = {0, 0, 127}));
  connect(electricHeatingDistr.heatPorts, ammoniaCracker.heatPorts) annotation(
    Line(points = {{48, 0}, {48, 24}, {60, 24}, {60, 38}}, color = {191, 0, 0}, thickness = 0.5));
annotation(
    experiment(StopTime = 1, Interval = 0.01, Tolerance = 1e-06, __Dymola_Algorithm = "Dassl"));
end NH3CrackerFCS_3_dyn;
