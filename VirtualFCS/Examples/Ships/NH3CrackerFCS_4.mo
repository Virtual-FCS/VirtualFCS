within VirtualFCS.Examples.Ships;

model NH3CrackerFCS_4
  inner Modelica.Fluid.System system;
  // Medium
  package AmmoniaMedium = Media.CrackedAmmonia;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  // Parameters
  parameter Modelica.Units.SI.Pressure P_H2_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_NH3_tank_start = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_out_PSA = 20e5 "Initial H2 tank pressure";
  Chemical.AmmoniaCracker.AmmoniaCrackerStatic ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {59, 57}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Pipes.DynamicPipe NH3Vaporizer(use_HeatTransfer = true, redeclare package Medium = AmmoniaMedium, length = 10, nParallel = 20, diameter = 0.1, m_flow_start = 0.3) annotation(
    Placement(transformation(origin = {-14, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater1(T_ref = 1173.15)  annotation(
    Placement(transformation(origin = {-28, 56}, extent = {{-10, -10}, {10, 10}})));
  Fluid.PSASimple psa(sep_eff = 0.9) annotation(
    Placement(transformation(origin = {62, -36}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = P_out_PSA) annotation(
    Placement(transformation(origin = {74, -80}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant heat(k = 5e5) annotation(
    Placement(transformation(origin = {-51, 75}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, X = {0.8, 0.1, 0.1}, m_flow = 0.3, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(transformation(origin = {-74, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_in_cracker(redeclare package Medium = AmmoniaMedium)  annotation(
    Placement(transformation(origin = {24, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m = ammoniaCracker.N) annotation(
    Placement(transformation(origin = {59, 16.6087}, extent = {{-17, -7.3913}, {17, 7.3913}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambient(T = 293.15) annotation(
    Placement(transformation(origin = {56, -13}, extent = {{-7, -7}, {7, 7}})));
  Electrochemical.Hydrogen.FuelCells.FuelCellSystem fuelCellSystem(p_tank_H2 = P_out_PSA)  annotation(
    Placement(transformation(origin = {-10, -60}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {-8, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {10, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(duration = 20, height = -2.99, offset = 3, startTime = 20) annotation(
    Placement(transformation(origin = {-46, -16}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(heater1.port, NH3Vaporizer.heatPorts[1]) annotation(
    Line(points = {{-18, 56}, {-14, 56}, {-14, 34}}, color = {191, 0, 0}));
  connect(NH3Vaporizer.port_b, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{-4, 30}, {20, 30}, {20, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(ammoniaCracker.outlet_cracked_gas, psa.feed) annotation(
    Line(points = {{78, 62}, {86, 62}, {86, -34}, {72, -34}}, color = {0, 127, 255}));
  connect(psa.tail, tailSink.ports[1]) annotation(
    Line(points = {{72, -38}, {74, -38}, {74, -70}}, color = {0, 127, 255}));
  connect(heat.y, heater1.Q_flow) annotation(
    Line(points = {{-44, 76}, {-38, 76}, {-38, 56}}, color = {0, 0, 127}));
  connect(ammonia_source.ports[1], NH3Vaporizer.port_a) annotation(
    Line(points = {{-64, 32}, {-24, 32}, {-24, 30}}, color = {0, 127, 255}));
  connect(temp_in_cracker.port, ammoniaCracker.inlet_nh3_feed) annotation(
    Line(points = {{24, 74}, {24, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(thermalCollector.port_b, ambient.port) annotation(
    Line(points = {{59, 9.21739}, {59, 1.71739}, {63, 1.71739}, {63, -12.7826}}, color = {191, 0, 0}));
  connect(thermalCollector.port_a, ammoniaCracker.heatPorts) annotation(
    Line(points = {{60, 24}, {60, 38}}, color = {191, 0, 0}, thickness = 0.5));
  connect(ground.p, resistor.n) annotation(
    Line(points = {{10, -30}, {10, -29}, {2, -29}, {2, -28}}, color = {0, 0, 255}));
  connect(ramp.y, resistor.R) annotation(
    Line(points = {{-35, -16}, {-8, -16}}, color = {0, 0, 127}));
  connect(fuelCellSystem.toTank, psa.product) annotation(
    Line(points = {{1, -57}, {22, -57}, {22, -36}, {52, -36}}, color = {0, 127, 255}));
  connect(resistor.p, fuelCellSystem.pin_p) annotation(
    Line(points = {{-18, -28}, {-20, -28}, {-20, -44}, {-14, -44}, {-14, -50}}, color = {0, 0, 255}));
  connect(resistor.n, fuelCellSystem.pin_n) annotation(
    Line(points = {{2, -28}, {0, -28}, {0, -44}, {-4, -44}, {-4, -50}}, color = {0, 0, 255}));
end NH3CrackerFCS_4;
