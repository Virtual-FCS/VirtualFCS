within VirtualFCS.Examples.Ships;

model NH3CrackerFCS_4_dyn
  inner Modelica.Fluid.System system;
  // Medium
  package AmmoniaMedium = Media.CrackedAmmonia;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  // Parameters
  parameter Modelica.Units.SI.Pressure P_H2_tank = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_NH3_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_out_PSA = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Temperature T_out_target = 550 + 273.15 "Target outlet temperature for ammonia cracker";
  parameter Modelica.Units.SI.Temperature T_start = T_out_target "Start temperature for ammonia cracker";
  parameter Modelica.Units.SI.Temperature T_NH3_tank = 20 + 273.15 "Start temperature for ammonia cracker";
  parameter Modelica.Units.SI.MassFraction X_start[3] = {0.8, 0.1, 0.1} "Initial mass fractions {NH3, H2, N2}";
  // Cracking an NH3-rich initial inventory doubles its moles; with a closed H2 tank this gas can only escape backwards into the vaporizer
  parameter Integer N = 10 "Number of computational segments for ammonia cracker";
  parameter Modelica.Units.SI.Pressure dp_distributor = 0.2e5 "Pressure loss of the cracker inlet distributor at the nominal feed flow";
  parameter Modelica.Units.SI.MassFlowRate m_feed_max = 0.1 "Maximum NH3 feed mass flow rate (cracker design flow)";
  parameter Modelica.Units.SI.MassFlowRate m_feed_start = 0.003 "Initial NH3 feed mass flow rate";
  parameter Modelica.Units.SI.Pressure P_H2_set = 22e5 "H2 tank pressure set-point";
  parameter Real dpdt_set(unit = "Pa/s") = 1e4 "Rate at which the pressure set-point is raised from P_H2_tank to P_H2_set";
  // Plant: dp/dt ~ 1.5e4 Pa/s per kg/s of feed (dominated by the two-phase vaporizer inventory) -> closed-loop time constant ~ 1/(k_feed*1.5e4)
  parameter Real k_feed(unit = "kg/(s.Pa)") = 1e-5 "Proportional gain of the feed controller";
  parameter Modelica.Units.SI.Time Ti_feed = 30 "Integral time of the feed controller";
  parameter Modelica.Units.SI.Time T_filter = 1 "Time constant of the tank pressure measurement filter";
  parameter Modelica.Units.SI.Pressure P_vap_start = P_out_PSA + dp_distributor*m_feed_start/m_feed_max "Initial pressure of the NH3 vaporizer (approx. consistent with m_feed_start)";
  Chemical.AmmoniaCracker.AmmoniaCrackerDyn ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium, constantTemperature = false, dp_small = 1e4, p_start = P_out_PSA, N = N, T_out_target = T_out_target, T_start = T_start, X_start = X_start, dp_inlet_nominal = dp_distributor, m_flow_nominal = m_feed_max, H = 3) annotation(
    Placement(transformation(origin = {59, 57}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Pipes.DynamicPipe NH3Vaporizer(use_HeatTransfer = true, redeclare package Medium = AmmoniaMedium, length = 10, nParallel = 20, diameter = 0.1, m_flow_start = m_feed_start, X_start = X_start, T_start = T_NH3_tank, p_a_start = P_vap_start, p_b_start = P_vap_start, allowFlowReversal = true, useLumpedPressure = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(transformation(origin = {-24, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater1(T_ref = 1173.15) annotation(
    Placement(transformation(origin = {-12, 86}, extent = {{-10, -10}, {10, 10}})));
  Fluid.PSASimple psa(sep_eff = 0.9) annotation(
    Placement(transformation(origin = {62, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = P_out_PSA) annotation(
    Placement(transformation(origin = {74, -80}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant heat(k = 5e5) annotation(
    Placement(transformation(origin = {-47, 87}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, X = X_start, m_flow = 0.3, nPorts = 2, use_m_flow_in = true, T = T_NH3_tank) annotation(
    Placement(transformation(origin = {-84, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_in_cracker(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {24, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_out_cracker(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {76, -8}, extent = {{10, -10}, {-10, 10}})));
  Chemical.AmmoniaCracker.ElectricHeatingDistr electricHeatingDistr(N = N) annotation(
    Placement(transformation(origin = {48, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  VirtualFCS.Electrochemical.Hydrogen.FuelCells.FuelCellSystem fuelCellSystem(subSystemHydrogen(P_H2_tank_start = P_H2_tank), fuelCell(redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.ActivationLossSimple activation, anode(R_flow = 10000), cathode(R_flow = 10000), redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.MassTransportLossSimple mass_transport, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.OhmicResistance ohmic, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.VSourceNernst v_source), subSystemAir(compressor(K(Ti = 1, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 5), compressor(m_flow(start = 1E-2))))) annotation(
    Placement(transformation(origin = {-8, -70}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {-6, -38}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {12, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(duration = 20, height = -2.99, offset = 3, startTime = 20) annotation(
    Placement(transformation(origin = {-44, -26}, extent = {{-10, -10}, {10, 10}})));
  // Load following: the NH3 feed is throttled so that the cracker only produces the H2 needed to track the tank pressure set-point
  Modelica.Fluid.Sensors.Pressure p_H2_tank(redeclare package Medium = HydrogenMedium) annotation(
    Placement(transformation(origin = {36, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Ramp p_H2_setpoint(height = P_H2_set - P_H2_tank, duration = max(abs(P_H2_set - P_H2_tank)/dpdt_set, 1e-3), offset = P_H2_tank, startTime = 0) annotation(
    Placement(transformation(origin = {-136, 34}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Blocks.Continuous.LimPID feedController(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = k_feed, Ti = Ti_feed, yMax = m_feed_max, yMin = 0, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = m_feed_start) annotation(
    Placement(transformation(origin = {-110, 34}, extent = {{-8, -8}, {8, 8}})));
  // Keeps the fast tank/cracker pressure dynamics out of the feed loop (unfiltered: ~2x more solver steps)
  Modelica.Blocks.Continuous.FirstOrder p_H2_filter(T = T_filter, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = P_H2_tank) annotation(
    Placement(transformation(origin = {-110, -60}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
equation
  connect(heater1.port, NH3Vaporizer.heatPorts[1]) annotation(
    Line(points = {{-2, 86}, {-2, 69}, {0, 69}, {0, 58}, {-23, 58}, {-23, 36}, {-24, 36}}, color = {191, 0, 0}));
  connect(NH3Vaporizer.port_b, ammoniaCracker.port_a) annotation(
    Line(points = {{-14, 32}, {20, 32}, {20, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(ammoniaCracker.port_b, psa.feed) annotation(
    Line(points = {{78, 62}, {86, 62}, {86, -34}, {72, -34}}, color = {0, 127, 255}));
  connect(psa.tail, tailSink.ports[1]) annotation(
    Line(points = {{72, -38}, {74, -38}, {74, -70}}, color = {0, 127, 255}));
  connect(heat.y, heater1.Q_flow) annotation(
    Line(points = {{-39, 87}, {-29.3, 87}, {-29.3, 85}, {-21.6, 85}}, color = {0, 0, 127}));
  connect(ammonia_source.ports[1], NH3Vaporizer.port_a) annotation(
    Line(points = {{-74, 34}, {-34, 34}, {-34, 32}}, color = {0, 127, 255}));
  connect(temp_in_cracker.port, ammoniaCracker.port_a) annotation(
    Line(points = {{24, 74}, {24, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(temp_out_cracker.port, ammoniaCracker.port_b) annotation(
    Line(points = {{76, -18}, {86, -18}, {86, 62}, {78, 62}}, color = {0, 127, 255}));
  connect(temp_out_cracker.T, electricHeatingDistr.T_meas) annotation(
    Line(points = {{69, -8}, {62, -8}, {62, -7}, {57, -7}}, color = {0, 0, 127}));
  connect(electricHeatingDistr.heatPorts, ammoniaCracker.heatPorts) annotation(
    Line(points = {{48, 0}, {48, 24}, {60, 24}, {60, 38}}, color = {191, 0, 0}, thickness = 0.5));
  connect(ground.p, resistor.n) annotation(
    Line(points = {{12, -40}, {12, -39}, {4, -39}, {4, -38}}, color = {0, 0, 255}));
  connect(ramp.y, resistor.R) annotation(
    Line(points = {{-33, -26}, {-6, -26}}, color = {0, 0, 127}));
  connect(resistor.p, fuelCellSystem.pin_p) annotation(
    Line(points = {{-16, -38}, {-18, -38}, {-18, -54}, {-12, -54}, {-12, -60}}, color = {0, 0, 255}));
  connect(resistor.n, fuelCellSystem.pin_n) annotation(
    Line(points = {{4, -38}, {2, -38}, {2, -54}, {-2, -54}, {-2, -60}}, color = {0, 0, 255}));
  connect(psa.product, fuelCellSystem.toTank) annotation(
    Line(points = {{52, -36}, {36, -36}, {36, -66}, {2, -66}}, color = {0, 127, 255}));
  connect(psa.product, p_H2_tank.port) annotation(
    Line(points = {{52, -36}, {52, -80}, {36, -80}}, color = {0, 127, 255}));
  connect(p_H2_setpoint.y, feedController.u_s) annotation(
    Line(points = {{-127, 34}, {-120, 34}}, color = {0, 0, 127}));
  connect(p_H2_tank.p, p_H2_filter.u) annotation(
    Line(points = {{25, -90}, {25, -120}, {-110, -120}, {-110, -67}}, color = {0, 0, 127}));
  connect(p_H2_filter.y, feedController.u_m) annotation(
    Line(points = {{-110, -53}, {-110, 24}}, color = {0, 0, 127}));
  connect(feedController.y, ammonia_source.m_flow_in) annotation(
    Line(points = {{-101, 34}, {-98, 34}, {-98, 42}, {-94, 42}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 60, Interval = 0.1, Tolerance = 1e-06, __Dymola_Algorithm = "Dassl"),
    Diagram);
end NH3CrackerFCS_4_dyn;
