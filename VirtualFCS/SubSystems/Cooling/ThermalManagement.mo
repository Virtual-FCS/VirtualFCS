within VirtualFCS.SubSystems.Cooling;

model ThermalManagement
  // System
  outer Modelica.Fluid.System system "System properties";
  // Medium models
  replaceable package H2O_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  //replaceable package Cool_Medium = Buildings.Media.Antifreeze.EthyleneGlycolWater(property_T=300, X_a=0.4);
  replaceable package Cool_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 1 "Nominal mass flow rate";
  parameter Modelica.Units.SI.Temperature T_a1_nominal = 25 + 273.15 "Temperature at nominal conditions as port a1";
  parameter Modelica.Units.SI.Temperature T_b1_nominal = 20 + 273.15 "Temperature at nominal conditions as port b1";
  parameter Modelica.Units.SI.Temperature T_a2_nominal = 20 + 273.15 "Temperature at nominal conditions as port a2";
  parameter Modelica.Units.SI.Temperature T_b2_nominal = 25 + 273.15 "Temperature at nominal conditions as port b2";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal = 0.01 "Nominal mass flow rate medium 1";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal = m1_flow_nominal*(T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal) "Nominal mass flow rate medium 2";
  Buildings.Fluid.Sources.Boundary_pT CoolantSink(redeclare package Medium = Cool_Medium, nPorts = 1, p(displayUnit = "Pa"), use_p_in = false) annotation(
    Placement(transformation(origin = {-58, 0}, extent = {{-52, 10}, {-32, 30}})));
  Buildings.Fluid.Sources.Boundary_pT CoolantSource(redeclare package Medium = Cool_Medium, T = T_a2_nominal, nPorts = 1, p(displayUnit = "bar"), use_T_in = false, use_p_in = false) annotation(
    Placement(transformation(origin = {70, 0}, extent = {{140, 10}, {120, 30}})));
  Modelica.Fluid.Interfaces.FluidPort_a HotWaterIn(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-106, 70}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Fluid.Interfaces.FluidPort_b HotWaterOut(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {200, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {106, -78}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort THotIn(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {-66, 60}, extent = {{-8, -8}, {8, 8}}, rotation = -0)));
  Modelica.Fluid.Sensors.TemperatureTwoPort THotOut(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {36, 60}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort TColdOut(redeclare package Medium = Cool_Medium) annotation(
    Placement(transformation(origin = {-68, 20}, extent = {{8, -8}, {-8, 8}})));
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(redeclare package Medium1 = H2O_Medium, redeclare package Medium2 = Cool_Medium, configuration = Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow, dp1_nominal(displayUnit = "Pa") = 0, dp2_nominal(displayUnit = "Pa") = 0, eps_nominal = 0.5, m1_flow_nominal = m1_flow_nominal, m2_flow_nominal = m2_flow_nominal, show_T = true, use_Q_flow_nominal = false, use_dynamicFlowRegime = true) annotation(
    Placement(transformation(origin = {-16, 40}, extent = {{-32, -34}, {32, 34}})));
  Modelica.Blocks.Sources.Constant T_setpoint(k = 273.15 + 55) annotation(
    Placement(transformation(origin = {150, -10}, extent = {{-10, -10}, {10, 10}})));
  Fluid.SimplePump pump_coolant(redeclare package Medium = Cool_Medium) annotation(
    Placement(transformation(origin = {50, 20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage voltageSource(V = 48) annotation(
    Placement(transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {30, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.PI pi(k = 0.001, T = 1) annotation(
    Placement(transformation(origin = {110, 40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add error_flow(k2 = -1) annotation(
    Placement(transformation(origin = {140, 40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 0.5, uMin = 0.2) annotation(
    Placement(transformation(origin = {80, 40}, extent = {{10, -10}, {-10, 10}})));
equation
  connect(TColdOut.port_b, CoolantSink.ports[1]) annotation(
    Line(points = {{-76, 20}, {-90, 20}}, color = {0, 127, 255}));
  connect(THotOut.port_b, HotWaterOut) annotation(
    Line(points = {{44, 60}, {200, 60}}, color = {0, 127, 255}));
  connect(hex.port_a1, THotIn.port_b) annotation(
    Line(points = {{-48, 60}, {-48, 59.6}, {-58, 59.6}, {-58, 60}}, color = {0, 127, 255}));
  connect(hex.port_b1, THotOut.port_a) annotation(
    Line(points = {{16, 60}, {16, 60.4}, {28, 60.4}}, color = {0, 127, 255}));
  connect(hex.port_b2, TColdOut.port_a) annotation(
    Line(points = {{-48, 20}, {-60, 20}, {-60, 19.6}}, color = {0, 127, 255}));
  connect(THotIn.port_a, HotWaterIn) annotation(
    Line(points = {{-74, 60}, {-100, 60}}, color = {0, 127, 255}));
  connect(pump_coolant.port_a, CoolantSource.ports[1]) annotation(
    Line(points = {{60, 20}, {190, 20}}, color = {0, 127, 255}));
  connect(pump_coolant.port_b, hex.port_a2) annotation(
    Line(points = {{40, 28}, {30, 28}, {30, 20}, {16, 20}}, color = {0, 127, 255}));
  connect(voltageSource.n, ground.p) annotation(
    Line(points = {{40, -20}, {30, -20}}, color = {0, 0, 255}));
  connect(voltageSource.n, pump_coolant.pin_n) annotation(
    Line(points = {{40, -20}, {40, -3}, {45, -3}, {45, 10}}, color = {0, 0, 255}));
  connect(voltageSource.p, pump_coolant.pin_p) annotation(
    Line(points = {{60, -20}, {60, -2}, {55.5, -2}, {55.5, 10}, {55, 10}}, color = {0, 0, 255}));
  connect(error_flow.y, pi.u) annotation(
    Line(points = {{129, 40}, {122, 40}}, color = {0, 0, 127}));
  connect(THotOut.T, error_flow.u1) annotation(
    Line(points = {{36, 68}, {36, 76}, {180, 76}, {180, 46}, {152, 46}}, color = {0, 0, 127}));
  connect(pump_coolant.u, limiter.y) annotation(
    Line(points = {{50, 29}, {50, 40}, {69, 40}}, color = {0, 0, 127}));
  connect(pi.y, limiter.u) annotation(
    Line(points = {{99, 40}, {91, 40}}, color = {0, 0, 127}));
  connect(error_flow.u2, T_setpoint.y) annotation(
    Line(points = {{152, 34}, {170, 34}, {170, -10}, {162, -10}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {200, 200}})),
    experiment(Tolerance = 1e-6, StopTime = 100),
    uses(Modelica(version = "4.0.0"), Buildings(version = "11.0.0")),
    Icon(graphics = {Rectangle(origin = {0, -1}, fillColor = {85, 0, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 4, extent = {{-98, 99}, {98, -99}}), Text(origin = {0, 1}, textColor = {255, 255, 255}, extent = {{-76, 65}, {76, -65}}, textString = "Thermal Sub-System")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    version = "1",
    conversion(noneFromVersion = ""));
end ThermalManagement;
