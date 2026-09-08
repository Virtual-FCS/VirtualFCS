within VirtualFCS.SubSystems.Cooling;

model SubSystemCooling
  parameter Modelica.Units.SI.Temperature T_stack_set = 353 "Target stack temperature";
  parameter Modelica.Units.SI.Temperature T_coolant_set = 300 "Target coolant reservoir temperature";
  parameter Modelica.Units.SI.Length tank_height = 0.5 "Height of the cooling tank";
  parameter Modelica.Units.SI.Length tank_diameter = 0.2 "Height of the cooling tank";
  parameter Real tank_fill_fraction = 0.8 "Fraction of coolant in the tank";
  parameter Modelica.Units.SI.Area tank_csa = Modelica.Constants.pi * (tank_diameter/2)^2 "Tank cross section area";
  
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  Modelica.Fluid.Interfaces.FluidPort_b to_stack(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {122, -54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_a from_stack(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {-100, -62}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {20, -100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {80, -100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackTemperature annotation(
    Placement(transformation(origin = {130, -12}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Vessels.OpenTank coolantReservoir(redeclare package Medium = Coolant_Medium, crossArea = tank_csa, height = tank_height, level_start = tank_height*tank_fill_fraction, nPorts = 2, use_HeatTransfer = true, T_start = 323.15, level(start = tank_height*tank_fill_fraction, fixed = true), massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, use_portsData = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(transformation(origin = {20, -2}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow coolingRate annotation(
    Placement(transformation(origin = {-30, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempCoolantIn annotation(
    Placement(transformation(origin = {-30, -42}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.RealExpression targetStackT(y = T_stack_set) annotation(
    Placement(transformation(origin = {110, 18}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Continuous.LimPID PI_stack(Td = 0, yMin = 0.01, controllerType = Modelica.Blocks.Types.SimpleController.PI, k = -10, Ti = 60, yMax = 1.2, strict = false) annotation(
    Placement(transformation(origin = {82, 18}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Continuous.LimPID P_coolant(controllerType = Modelica.Blocks.Types.SimpleController.P, yMax = 0, yMin = -1000000, k = 100000) annotation(
    Placement(transformation(origin = {-60, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression targetReservoirT(y = T_coolant_set) annotation(
    Placement(transformation(origin = {-90, -2}, extent = {{-10, -10}, {10, 10}})));
  replaceable Fluid.SimplePump pump2(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {50, -62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature tempCoolantOut(redeclare package Medium = Coolant_Medium)  annotation(
    Placement(transformation(origin = {-48, -84}, extent = {{-10, 10}, {10, -10}})));
equation
  connect(from_stack, coolantReservoir.ports[1]) annotation(
    Line(points = {{-100, -62}, {14, -62}, {14, -22}, {20, -22}}, color = {255, 0, 0}));
  connect(P_coolant.y, coolingRate.Q_flow) annotation(
    Line(points = {{-49, -2}, {-40, -2}}, color = {0, 0, 127}));
  connect(tempCoolantIn.T, P_coolant.u_m) annotation(
    Line(points = {{-41, -42}, {-60, -42}, {-60, -14}}, color = {0, 0, 127}));
  connect(PI_stack.u_m, stackTemperature) annotation(
    Line(points = {{82, 6}, {82, -12}, {130, -12}}, color = {0, 0, 127}));
  connect(PI_stack.u_s, targetStackT.y) annotation(
    Line(points = {{94, 18}, {100, 18}}, color = {0, 0, 127}));
  connect(coolingRate.port, coolantReservoir.heatPort) annotation(
    Line(points = {{-20, -2}, {0, -2}}, color = {191, 0, 0}));
  connect(tempCoolantIn.port, coolantReservoir.heatPort) annotation(
    Line(points = {{-20, -42}, {-10, -42}, {-10, -2}, {0, -2}}, color = {191, 0, 0}));
  connect(targetReservoirT.y, P_coolant.u_s) annotation(
    Line(points = {{-79, -2}, {-73, -2}}, color = {0, 0, 127}));
  connect(pump2.port_b, to_stack) annotation(
    Line(points = {{60, -54}, {122, -54}}, color = {0, 127, 255}));
  connect(pump2.port_a, coolantReservoir.ports[2]) annotation(
    Line(points = {{40, -62}, {26, -62}, {26, -22}, {20, -22}}, color = {0, 127, 255}));
  connect(pump2.pin_n, pin_n) annotation(
    Line(points = {{55, -72}, {55, -100}, {80, -100}}, color = {0, 0, 255}));
  connect(pump2.pin_p, pin_p) annotation(
    Line(points = {{45, -72}, {45, -100}, {20, -100}}, color = {0, 0, 255}));
  connect(PI_stack.y, pump2.u) annotation(
    Line(points = {{71, 18}, {49, 18}, {49, -52}}, color = {0, 0, 127}));
  connect(tempCoolantOut.port, from_stack) annotation(
    Line(points = {{-48, -74}, {-48, -62}, {-100, -62}}, color = {0, 127, 255}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {9, -11}, textColor = {255, 255, 255}, extent = {{-81, 89}, {65, -55}}, textString = "Cool")}, coordinateSystem(initialScale = 0.1, extent = {{-100, -100}, {100, 100}})),
    experiment(StopTime = 600, Interval = 0.1, Tolerance = 1e-06, StartTime = 0),
    Diagram(coordinateSystem(extent = {{-100, 120}, {120, -100}})));
annotation(Documentation(info = "<html><p>Cooling subsystem for circulating coolant through the fuel-cell stack and regulating the coolant temperature.</p></html>"));
end SubSystemCooling;
