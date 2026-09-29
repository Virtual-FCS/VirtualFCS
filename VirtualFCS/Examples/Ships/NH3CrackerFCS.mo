within VirtualFCS.Examples.Ships;

model NH3CrackerFCS
  inner Modelica.Fluid.System system;
  // Medium
  package AmmoniaMedium = VirtualFCS.Media.CrackedAmmonia;
  package HydrogenMedium = Modelica.Media.IdealGases.SingleGases.H2;
  // Parameters
  parameter Modelica.Units.SI.Pressure P_H2_tank = 20e5 "Initial H2 tank pressure";
  parameter Modelica.Units.SI.Pressure P_NH3_tank_start = 10e5 "Initial H2 tank pressure";
  Chemical.AmmoniaCracker.AmmoniaCrackerStatic ammoniaCracker(redeclare package AmmoniaMedium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {59, 57}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Fluid.Vessels.ClosedVolume ammoniaTank(redeclare package Medium = AmmoniaMedium, nPorts = 1, portsData(each diameter = 0.1), V = 100, p_start = P_NH3_tank_start, T_start = 293.15) annotation(
    Placement(transformation(origin = {-88, 60}, extent = {{-10, -10}, {10, 10}})));
  Fluid.SimplePump ammoniaPump(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {-56, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Pipes.DynamicPipe NH3Vaporizer(use_HeatTransfer = true, redeclare package Medium = AmmoniaMedium, length = 10, nParallel = 20, diameter = 0.1) annotation(
    Placement(transformation(origin = {-14, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heater1(T_ref = 1073.15) annotation(
    Placement(transformation(origin = {-28, 56}, extent = {{-10, -10}, {10, 10}})));
  Fluid.PSASimple psa(sep_eff = 0.9) annotation(
    Placement(transformation(origin = {68, -38}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.FixedBoundary tailSink(redeclare package Medium = AmmoniaMedium, nPorts = 1, p = P_H2_tank) annotation(
    Placement(transformation(origin = {80, -82}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant heat(k = 1000) annotation(
    Placement(transformation(origin = {-51, 75}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Sources.Constant NH3_mf(k = 0.3) annotation(
    Placement(transformation(origin = {-67, 41}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage voltageSource(V = 48) annotation(
    Placement(transformation(origin = {-54, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-34, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m = ammoniaCracker.N) annotation(
    Placement(transformation(origin = {59, 18.6087}, extent = {{-17, -7.3913}, {17, 7.3913}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambient(T = 293.15) annotation(
    Placement(transformation(origin = {50, -11}, extent = {{-7, -7}, {7, 7}})));
  VirtualFCS.Electrochemical.Hydrogen.FuelCells.FuelCellSystem fuelCellSystem(p_tank_H2 = P_H2_tank) annotation(
    Placement(transformation(origin = {-32, -84}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {-30, -52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
    Placement(transformation(origin = {-12, -64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(duration = 20, height = -2.99, offset = 3, startTime = 20) annotation(
    Placement(transformation(origin = {-68, -50}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(heater1.port, NH3Vaporizer.heatPorts[1]) annotation(
    Line(points = {{-18, 56}, {-14, 56}, {-14, 34}}, color = {191, 0, 0}));
  connect(ammoniaTank.ports[1], ammoniaPump.port_a) annotation(
    Line(points = {{-88, 50}, {-88, 22}, {-66, 22}}, color = {0, 127, 255}));
  connect(ammoniaPump.port_b, NH3Vaporizer.port_a) annotation(
    Line(points = {{-46, 30}, {-24, 30}}, color = {0, 127, 255}));
  connect(NH3Vaporizer.port_b, ammoniaCracker.port_a) annotation(
    Line(points = {{-4, 30}, {20, 30}, {20, 62}, {40, 62}}, color = {0, 127, 255}));
  connect(ammoniaCracker.port_b, psa.feed) annotation(
    Line(points = {{78, 62}, {86, 62}, {86, -36}, {78, -36}}, color = {0, 127, 255}));
  connect(psa.tail, tailSink.ports[1]) annotation(
    Line(points = {{78, -40}, {80, -40}, {80, -72}}, color = {0, 127, 255}));
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
  connect(thermalCollector.port_b, ambient.port) annotation(
    Line(points = {{59, 11.2174}, {59, 0.1087}, {57, 0.1087}, {57, -11}}, color = {191, 0, 0}));
  connect(thermalCollector.port_a, ammoniaCracker.heatPorts) annotation(
    Line(points = {{60, 26}, {60, 38}}, color = {191, 0, 0}, thickness = 0.5));
  connect(ground1.p, resistor.n) annotation(
    Line(points = {{-12, -54}, {-12, -53}, {-20, -53}, {-20, -52}}, color = {0, 0, 255}));
  connect(ramp.y, resistor.R) annotation(
    Line(points = {{-57, -50}, {-43.5, -50}, {-43.5, -40}, {-30, -40}}, color = {0, 0, 127}));
  connect(resistor.p, fuelCellSystem.pin_p) annotation(
    Line(points = {{-40, -52}, {-42, -52}, {-42, -68}, {-36, -68}, {-36, -74}}, color = {0, 0, 255}));
  connect(resistor.n, fuelCellSystem.pin_n) annotation(
    Line(points = {{-20, -52}, {-22, -52}, {-22, -68}, {-26, -68}, {-26, -74}}, color = {0, 0, 255}));
  connect(psa.product, fuelCellSystem.toTank) annotation(
    Line(points = {{58, -38}, {30, -38}, {30, -80}, {-22, -80}}, color = {0, 127, 255}));
end NH3CrackerFCS;
