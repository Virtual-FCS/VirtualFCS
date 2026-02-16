within VirtualFCS.SubSystems.Cooling;

model ThermalManagement
 // System
  outer Modelica.Fluid.System system "System properties";
  // Medium models
  replaceable package H2O_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  //replaceable package H2O_Medium = AixLib.Media.Water;
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
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-52, 10}, {-32, 30}}, rotation = 0)));
  Buildings.Fluid.Sources.Boundary_pT CoolantSource(redeclare package Medium = Cool_Medium, T = T_a2_nominal, nPorts = 1, p(displayUnit = "bar"), use_T_in = false, use_p_in = false) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{140, 10}, {120, 30}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a HotWaterIn(redeclare package Medium = H2O_Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-106, 70}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b HotWaterOut(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {200, 58}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {106, -78}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort THotIn(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {-66, 60}, extent = {{-8, 8}, {8, -8}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort THotOut(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {36, 60}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort TColdOut(redeclare package Medium = Cool_Medium) annotation(
    Placement(transformation(origin = {-68, 20}, extent = {{8, -8}, {-8, 8}})));
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(redeclare package Medium1 = H2O_Medium, redeclare package Medium2 = Cool_Medium, configuration = Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow, dp1_nominal(displayUnit = "Pa") = 0, dp2_nominal(displayUnit = "Pa") = 0, eps_nominal = 0.5, m1_flow_nominal = m1_flow_nominal, m2_flow_nominal = m2_flow_nominal, show_T = true, use_Q_flow_nominal = false, use_dynamicFlowRegime = true) annotation(
    Placement(transformation(origin = {-16, 41}, extent = {{-28, -29}, {28, 29}})));
  Modelica.Blocks.Sources.Constant TElySet(k = 273.15 + 55) annotation(
    Placement(transformation(origin = {178, -42}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = min(max(pi.y, 0.2), 0.5)) annotation(
    Placement(transformation(origin = {116, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Fluid.SimplePump pump_coolant(redeclare package Medium = Cool_Medium) annotation(
    Placement(transformation(origin = {70, 24}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage voltageSource(V = 48) annotation(
    Placement(transformation(origin = {74, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {50, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.PI pi(k = 0.001, T = 1) annotation(
    Placement(transformation(origin = {150, -6}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add error_flow(k2 = -1) annotation(
    Placement(transformation(origin = {179, -5}, extent = {{7, -7}, {-7, 7}}, rotation = -0)));
equation
  connect(TColdOut.port_b, CoolantSink.ports[1]) annotation(
    Line(points = {{-76, 20}, {-100, 20}}, color = {0, 127, 255}));
  connect(THotOut.port_b, HotWaterOut) annotation(
    Line(points = {{44, 60}, {125, 60}, {125, 58}, {200, 58}}, color = {0, 127, 255}));
  connect(hex.port_a1, THotIn.port_b) annotation(
    Line(points = {{-44, 58}, {-58, 58}, {-58, 60.4}}, color = {0, 127, 255}));
  connect(hex.port_b1, THotOut.port_a) annotation(
    Line(points = {{12, 58.4}, {28, 58.4}, {28, 60.4}}, color = {0, 127, 255}));
  connect(hex.port_b2, TColdOut.port_a) annotation(
    Line(points = {{-44, 24}, {-60, 24}, {-60, 19.6}}, color = {0, 127, 255}));
  connect(THotIn.port_a, HotWaterIn) annotation(
    Line(points = {{-74, 60}, {-102, 60}, {-102, 78}, {-100, 78}}, color = {0, 127, 255}));
  connect(pump_coolant.port_a, CoolantSource.ports[1]) annotation(
    Line(points = {{80, 24}, {167, 24}, {167, 20}, {200, 20}}, color = {0, 127, 255}));
  connect(pump_coolant.port_b, hex.port_a2) annotation(
    Line(points = {{60, 32}, {26, 32}, {26, 24}, {12, 24}}, color = {0, 127, 255}));
  connect(voltageSource.n, ground.p) annotation(
    Line(points = {{64, -20}, {50, -20}}, color = {0, 0, 255}));
  connect(voltageSource.n, pump_coolant.pin_n) annotation(
    Line(points = {{64, -20}, {64, -3}, {65, -3}, {65, 14}}, color = {0, 0, 255}));
  connect(voltageSource.p, pump_coolant.pin_p) annotation(
    Line(points = {{84, -20}, {82, -20}, {82, 6}, {75, 6}, {75, 14}}, color = {0, 0, 255}));
  connect(TElySet.y, error_flow.u2) annotation(
    Line(points = {{190, -42}, {194, -42}, {194, -10}, {188, -10}}, color = {0, 0, 127}));
  connect(error_flow.y, pi.u) annotation(
    Line(points = {{172, -4}, {162, -4}, {162, -6}}, color = {0, 0, 127}));
  connect(THotOut.T, error_flow.u1) annotation(
    Line(points = {{36, 68}, {36, 76}, {170, 76}, {170, 42}, {188, 42}, {188, 0}}, color = {0, 0, 127}));
  connect(realExpression.y, pump_coolant.u) annotation(
    Line(points = {{106, -4}, {94, -4}, {94, 34}, {70, 34}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {200, 200}})),
    experiment(Tolerance = 1e-6, StopTime = 100),
    uses(Modelica(version = "4.0.0"), AixLib(version = "1.3.2"), Buildings(version = "11.0.0")),
    Icon(graphics = {Rectangle(origin = {0, -1}, fillColor = {85, 0, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 4, extent = {{-98, 99}, {98, -99}}), Text(origin = {0, 1}, textColor = {255, 255, 255}, extent = {{-76, 65}, {76, -65}}, textString = "Thermal Sub-System")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    version = "1",
    conversion(noneFromVersion = ""));


end ThermalManagement;
