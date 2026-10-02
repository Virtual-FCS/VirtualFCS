within VirtualFCS.Examples.Ships;

model NH3CrackerFCS_5_dyn
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
  parameter Modelica.Units.SI.Temperature T_cool_target = 80 + 273.15 "Target temperature for cracked gas after cooling";
  parameter Modelica.Units.SI.HeatFlowRate Q_cool_max = 1e6 "Maximum cooling duty";
  parameter Real k_cool(unit = "W/K") = 2e3 "Proportional gain of the cooler controller";
  parameter Modelica.Units.SI.Time Ti_cool = 20 "Integral time of the cooler controller";
  parameter Modelica.Units.SI.MassFraction X_start[3] = {0.8, 0.1, 0.1} "Initial mass fractions {NH3, H2, N2}";
  // Cracking an NH3-rich initial inventory doubles its moles; with a closed H2 tank this gas can only escape backwards into the vaporizer
  parameter Modelica.Units.SI.MassFraction X_cracker_start[3] = {0.01, 0.238, 0.752} "Initial mass fractions {NH3, H2, N2} in the cracker (cracked feed)";
  parameter Integer N = 10 "Number of computational segments for ammonia cracker";
  parameter Modelica.Units.SI.Pressure dp_distributor = 0.2e5 "Pressure loss of the cracker inlet distributor at the nominal feed flow";
  parameter Modelica.Units.SI.MassFlowRate m_feed_max = 0.05 "Maximum NH3 feed mass flow rate (cracker design flow)";
  parameter Modelica.Units.SI.MassFlowRate m_feed_start = 0.01 "Initial NH3 feed mass flow rate";
  parameter Modelica.Units.SI.Pressure P_H2_set = 22e5 "H2 tank pressure set-point";
  parameter Real dpdt_set(unit = "Pa/s") = 1e4 "Rate at which the pressure set-point is raised from P_H2_tank to P_H2_set";
  // Plant: dp/dt ~ 1.5e4 Pa/s per kg/s of feed (dominated by the two-phase vaporizer inventory) -> closed-loop time constant ~ 1/(k_feed*1.5e4)
  parameter Real k_feed(unit = "kg/(s.Pa)") = 1e-5 "Proportional gain of the feed controller";
  parameter Modelica.Units.SI.Time Ti_feed = 30 "Integral time of the feed controller";
  parameter Modelica.Units.SI.Time T_filter = 1 "Time constant of the tank pressure measurement filter";
  parameter Modelica.Units.SI.Pressure P_vap_start = P_out_PSA + dp_distributor*m_feed_start/m_feed_max "Initial pressure of the NH3 vaporizer (approx. consistent with m_feed_start)";
  Chemical.AmmoniaCracker.AmmoniaCrackerDyn ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium, constantTemperature = false, dp_small = 1e4, p_start = P_out_PSA, N = N, T_out_target = T_out_target, T_start = T_start, X_start = X_start, dp_inlet_nominal = dp_distributor, m_flow_nominal = m_feed_max, H = 3) annotation(
    Placement(transformation(origin = {51, 69}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Pipes.DynamicPipe NH3Vaporizer(use_HeatTransfer = true, redeclare package Medium = AmmoniaMedium, length = 10, nParallel = 20, diameter = 0.1, m_flow_start = m_feed_start, X_start = X_start, T_start = T_NH3_tank, p_a_start = P_vap_start, p_b_start = P_vap_start, allowFlowReversal = true, useLumpedPressure = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(transformation(origin = {-12, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater1(T_ref = 1173.15) annotation(
    Placement(transformation(origin = {-12, 86}, extent = {{-10, -10}, {10, 10}})));
  Fluid.PSASimple psa(sep_eff = 0.9) annotation(
    Placement(transformation(origin = {56, -58}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = P_out_PSA) annotation(
    Placement(transformation(origin = {74, -88}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant heat(k = 1e4) annotation(
    Placement(transformation(origin = {-45, 87}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, X = X_start, m_flow = 0.3, nPorts = 2, use_m_flow_in = true, T = T_NH3_tank) annotation(
    Placement(transformation(origin = {-44, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_in_cracker(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {16, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_out_cracker(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {76, 32}, extent = {{10, -10}, {-10, 10}})));
  Chemical.AmmoniaCracker.ElectricHeatingDistr electricHeatingDistr(N = N) annotation(
    Placement(transformation(origin = {52, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  Electrochemical.Hydrogen.FuelCells.FuelCellSystem fuelCellSystem(subSystemHydrogen(P_H2_tank_start = P_H2_tank), fuelCell(redeclare Electrochemical.Hydrogen.ECM.ActivationLossSimple activation, anode(R_flow = 10000), cathode(R_flow = 10000), redeclare Electrochemical.Hydrogen.ECM.MassTransportLossSimple mass_transport, redeclare Electrochemical.Hydrogen.ECM.OhmicResistance ohmic, redeclare Electrochemical.Hydrogen.ECM.VSourceNernst v_source), subSystemAir(compressor(K(Ti = 1, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 5), compressor(m_flow(start = 1E-2))))) annotation(
    Placement(transformation(origin = {-42, -82}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {-42, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-24, -62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(duration = 20, height = -0.005, offset = 0.01, startTime = 20) annotation(
    Placement(transformation(origin = {-68, -38}, extent = {{-8, -8}, {8, 8}})));
  // Load following: the NH3 feed is throttled so that the cracker only produces the H2 needed to track the tank pressure set-point
  Modelica.Fluid.Sensors.Pressure p_H2_tank(redeclare package Medium = HydrogenMedium) annotation(
    Placement(transformation(origin = {36, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Ramp p_H2_setpoint(height = P_H2_set - P_H2_tank, duration = max(abs(P_H2_set - P_H2_tank)/dpdt_set, 1e-3), offset = P_H2_tank, startTime = 0) annotation(
    Placement(transformation(origin = {-78, 66}, extent = {{8, -8}, {-8, 8}}, rotation = -0)));
  Modelica.Blocks.Continuous.LimPID feedController(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = k_feed, Ti = Ti_feed, yMax = m_feed_max, yMin = 1e-3, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = m_feed_start) annotation(
    Placement(transformation(origin = {-78, 38}, extent = {{-8, -8}, {8, 8}})));
  // Keeps the fast tank/cracker pressure dynamics out of the feed loop (unfiltered: ~2x more solver steps)
  Modelica.Blocks.Continuous.FirstOrder p_H2_filter(T = T_filter, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = P_H2_tank) annotation(
    Placement(transformation(origin = {-92, -68}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
  // Single node (a_v_b): the cooled volume is the one the PSA sees, so the duty acts directly on the measured temperature
  Modelica.Fluid.Pipes.DynamicPipe cooler(redeclare package Medium = AmmoniaMedium, T_start = T_start, X_start = X_start, allowFlowReversal = true, diameter = 0.1, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, length = 2, m_flow_start = m_feed_start, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, nNodes = 1, nParallel = 5, p_a_start = P_out_PSA, p_b_start = P_out_PSA, useLumpedPressure = false, use_HeatTransfer = true) annotation(
    Placement(transformation(origin = {86, -2}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow cooling annotation(
    Placement(transformation(origin = {54, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant T_cool_setpoint(k = T_cool_target) annotation(
    Placement(transformation(origin = {-12, -6}, extent = {{-6, -6}, {6, 6}})));
  // yMax = 0 makes this a cooler only; feed-forward from the cracker outlet would heat whenever that flow reverses
  Modelica.Blocks.Continuous.LimPID coolController(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = k_cool, Ti = Ti_cool, yMax = 0, yMin = -Q_cool_max, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0) annotation(
    Placement(transformation(origin = {18, -16}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Fluid.Sensors.Temperature temp_in_psa(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {72, -30}, extent = {{10, -10}, {-10, 10}})));
equation
  connect(heater1.port, NH3Vaporizer.heatPorts[1]) annotation(
    Line(points = {{-2, 86}, {-2, 69}, {0, 69}, {0, 58}, {-11, 58}, {-11, 36}, {-12, 36}}, color = {191, 0, 0}));
  connect(NH3Vaporizer.port_b, ammoniaCracker.port_a) annotation(
    Line(points = {{-2, 32}, {16, 32}, {16, 73}, {31, 73}}, color = {0, 127, 255}));
  connect(heat.y, heater1.Q_flow) annotation(
    Line(points = {{-37, 87}, {-29.3, 87}, {-29.3, 85}, {-21.6, 85}}, color = {0, 0, 127}));
  connect(ammonia_source.ports[1], NH3Vaporizer.port_a) annotation(
    Line(points = {{-34, 32}, {-22, 32}}, color = {0, 127, 255}));
  connect(temp_in_cracker.port, ammoniaCracker.port_a) annotation(
    Line(points = {{16, 74}, {16, 73}, {31, 73}}, color = {0, 127, 255}));
  connect(temp_out_cracker.port, ammoniaCracker.port_b) annotation(
    Line(points = {{76, 22}, {76, 18}, {86, 18}, {86, 73}, {71, 73}}, color = {0, 127, 255}));
  connect(temp_out_cracker.T, electricHeatingDistr.T_meas) annotation(
    Line(points = {{69, 32}, {66, 32}, {66, 31}, {61, 31}}, color = {0, 0, 127}));
  connect(electricHeatingDistr.heatPorts, ammoniaCracker.heatPorts) annotation(
    Line(points = {{52, 38}, {52, 45}, {51, 45}, {51, 50}}, color = {191, 0, 0}, thickness = 0.5));
  connect(ground.p, resistor.n) annotation(
    Line(points = {{-24, -52}, {-24, -51}, {-32, -51}, {-32, -50}}, color = {0, 0, 255}));
  connect(ramp.y, resistor.R) annotation(
    Line(points = {{-59, -38}, {-40, -38}}, color = {0, 0, 127}));
  connect(resistor.p, fuelCellSystem.pin_p) annotation(
    Line(points = {{-52, -50}, {-54, -50}, {-54, -66}, {-48, -66}, {-48, -72}}, color = {0, 0, 255}));
  connect(resistor.n, fuelCellSystem.pin_n) annotation(
    Line(points = {{-32, -50}, {-34, -50}, {-34, -66}, {-38, -66}, {-38, -72}}, color = {0, 0, 255}));
  connect(psa.product, fuelCellSystem.toTank) annotation(
    Line(points = {{46, -58}, {36, -58}, {36, -79}, {-31, -79}}, color = {0, 127, 255}));
  connect(psa.product, p_H2_tank.port) annotation(
    Line(points = {{46, -58}, {46, -59}, {36, -59}, {36, -76}}, color = {0, 127, 255}));
  connect(p_H2_setpoint.y, feedController.u_s) annotation(
    Line(points = {{-87, 66}, {-95.5, 66}, {-95.5, 38}, {-88, 38}}, color = {0, 0, 127}));
  connect(p_H2_tank.p, p_H2_filter.u) annotation(
    Line(points = {{25, -86}, {25, -98}, {-92, -98}, {-92, -75}}, color = {0, 0, 127}));
  connect(p_H2_filter.y, feedController.u_m) annotation(
    Line(points = {{-92, -61}, {-92, -18.5}, {-78, -18.5}, {-78, 28}}, color = {0, 0, 127}));
  connect(feedController.y, ammonia_source.m_flow_in) annotation(
    Line(points = {{-69, 38}, {-63.5, 38}, {-63.5, 40}, {-54, 40}}, color = {0, 0, 127}));
  connect(ammoniaCracker.port_b, cooler.port_a) annotation(
    Line(points = {{71, 73}, {71, 72.09}, {85, 72.09}, {85, 11.18}, {80.88, 11.18}, {80.88, 7.18}, {86.76, 7.18}}, color = {0, 127, 255}));
  connect(cooler.port_b, psa.feed) annotation(
    Line(points = {{86, -12}, {86, -56}, {66, -56}}, color = {0, 127, 255}));
  connect(cooling.port, cooler.heatPorts[1]) annotation(
    Line(points = {{64, -2}, {82, -2}}, color = {191, 0, 0}));
  connect(T_cool_setpoint.y, coolController.u_s) annotation(
    Line(points = {{-5, -6}, {2.5, -6}, {2.5, -16}, {8, -16}}, color = {0, 0, 127}));
  connect(temp_in_psa.T, coolController.u_m) annotation(
    Line(points = {{65, -30}, {18, -30}, {18, -26}}, color = {0, 0, 127}));
  connect(coolController.y, cooling.Q_flow) annotation(
    Line(points = {{27, -16}, {34.5, -16}, {34.5, -2}, {44, -2}}, color = {0, 0, 127}));
  connect(temp_in_psa.port, cooler.port_b) annotation(
    Line(points = {{72, -40}, {72, -44}, {86, -44}, {86, -12}}, color = {0, 127, 255}));
  connect(tailSink.ports[1], psa.tail) annotation(
    Line(points = {{74, -78}, {74, -60}, {66, -60}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 10, Interval = 0.5, Tolerance = 1e-06, __Dymola_Algorithm = "Dassl"),
    Diagram);
end NH3CrackerFCS_5_dyn;
