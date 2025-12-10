within VirtualFCS.SubSystems.Cooling;

model SubSystemCooling
  parameter Modelica.Units.SI.Temperature T_stack_set = 353 "Target stack temperature";
  parameter Modelica.Units.SI.Temperature T_coolant_set = 333 "Target coolant reservoir temperature";
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  Modelica.Fluid.Interfaces.FluidPort_b to_stack(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {120, -12}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_a from_stack(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {20, -100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {80, -100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackTemperature annotation(
    Placement(transformation(origin = {130, 30}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Vessels.OpenTank coolantReservoir(redeclare package Medium = Coolant_Medium, crossArea = 0.0314, height = 0.16, level_start = 0.12, nPorts = 2, use_HeatTransfer = true, T_start = 323.15, level(start = 0.12, fixed = true), massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, use_portsData = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(transformation(origin = {20, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow coolingRate annotation(
    Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor coolantTemperature annotation(
    Placement(transformation(origin = {-30, 0}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.RealExpression targetStackT(y = T_stack_set) annotation(
    Placement(transformation(origin = {110, 60}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Continuous.LimPID PI_stack(Td = 0, yMin = 0.01, controllerType = Modelica.Blocks.Types.SimpleController.PI, k = -0.1, Ti = 60, yMax = 100, strict = false) annotation(
    Placement(transformation(origin = {82, 60}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Continuous.LimPID P_coolant(controllerType = Modelica.Blocks.Types.SimpleController.P, yMax = 0, yMin = -10000, k = 1000) annotation(
    Placement(transformation(origin = {-60, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression targetReservoirT(y = T_coolant_set) annotation(
    Placement(transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}})));
  replaceable Fluid.SimplePump pump2(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(from_stack, coolantReservoir.ports[1]) annotation(
    Line(points = {{-100, -20}, {20, -20}, {20, 20}}, color = {255, 0, 0}));
  connect(P_coolant.y, coolingRate.Q_flow) annotation(
    Line(points = {{-49, 40}, {-40, 40}}, color = {0, 0, 127}));
  connect(coolantTemperature.T, P_coolant.u_m) annotation(
    Line(points = {{-41, 0}, {-60, 0}, {-60, 28}}, color = {0, 0, 127}));
  connect(PI_stack.u_m, stackTemperature) annotation(
    Line(points = {{82, 48}, {82, 30}, {130, 30}}, color = {0, 0, 127}));
  connect(PI_stack.u_s, targetStackT.y) annotation(
    Line(points = {{94, 60}, {100, 60}}, color = {0, 0, 127}));
  connect(coolingRate.port, coolantReservoir.heatPort) annotation(
    Line(points = {{-20, 40}, {0, 40}}, color = {191, 0, 0}));
  connect(coolantTemperature.port, coolantReservoir.heatPort) annotation(
    Line(points = {{-20, 0}, {-10, 0}, {-10, 40}, {0, 40}}, color = {191, 0, 0}));
  connect(targetReservoirT.y, P_coolant.u_s) annotation(
    Line(points = {{-79, 40}, {-73, 40}}, color = {0, 0, 127}));
  connect(pump2.port_b, to_stack) annotation(
    Line(points = {{60, -12}, {120, -12}}, color = {0, 127, 255}));
  connect(pump2.port_a, coolantReservoir.ports[2]) annotation(
    Line(points = {{40, -20}, {20, -20}, {20, 20}}, color = {0, 127, 255}));
  connect(pump2.pin_n, pin_n) annotation(
    Line(points = {{55, -30}, {55, -100}, {80, -100}}, color = {0, 0, 255}));
  connect(pump2.pin_p, pin_p) annotation(
    Line(points = {{45, -30}, {45, -100}, {20, -100}}, color = {0, 0, 255}));
  connect(PI_stack.y, pump2.u) annotation(
    Line(points = {{72, 60}, {50, 60}, {50, -10}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {9, -11}, textColor = {255, 255, 255}, extent = {{-81, 89}, {65, -55}}, textString = "Cool")}, coordinateSystem(initialScale = 0.1, extent = {{-100, -100}, {100, 100}})),
    experiment(StopTime = 600, Interval = 0.1, Tolerance = 1e-06, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-100, 120}, {120, -100}})));
end SubSystemCooling;
