within VirtualFCS.ComponentTesting;

model SubSystemCoolingTEST_validTempMaintain
  extends Modelica.Icons.Example;
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Real m_system_coolant(unit = "kg") = 44 "Coolant system mass";
  //*** INSTANTIATE COMPONENTS ***//
  // System
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial)  annotation(
    Placement(visible = true, transformation(origin = {-8, -6}, extent = {{-92, -94}, {-72, -74}}, rotation = 0)));
  // Interfaces
  // Vessels
  Modelica.Fluid.Vessels.OpenTank tankCoolant(redeclare package Medium = Medium, crossArea = 0.0314, height = 0.16, level_start = 0.12, nPorts = 1, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, use_HeatTransfer = true, portsData = {Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.1)}, T_start = Modelica.Units.Conversions.from_degC(20)) annotation(
    Placement(visible = true, transformation(origin = {-77, 17}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  // Machines
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {34, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Heaters and Coolers
  // Other
  Modelica.Fluid.Pipes.DynamicPipe pipeReturn(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 2, redeclare package Medium = Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {34, -32}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setPumpSpeed(y = max(0.005, 1 - subSystemCoolingControl.controlInterface)) annotation(
    Placement(visible = true, transformation(origin = {8, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Cooling.SubSystemCoolingControl subSystemCoolingControl annotation(
    Placement(visible = true, transformation(origin = {-44, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipeSend(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 2, redeclare package Medium = Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {68, 16}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  VirtualFCS.Thermal.HeatSink heatSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Pipes.DynamicPipe pipe2(redeclare package Medium = Medium, diameter = 0.003, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, nNodes = 2, nParallel = 500, use_HeatTransfer = true, use_T_start = true) annotation(
    Placement(visible = true, transformation(origin = {96, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {34, 56}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {52, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(redeclare package Medium = Medium, V = 0.00001)  annotation(
    Placement(visible = true, transformation(origin = {-44, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 10000) annotation(
    Placement(visible = true, transformation(origin = {132, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = 40*11, T(fixed = true, start = 293.15))  annotation(
    Placement(visible = true, transformation(origin = {164, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(visible = true, transformation(origin = {142, 36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = {64, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1000)  annotation(
    Placement(visible = true, transformation(origin = {102, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
//*** DEFINE CONNECTIONS ***//
  connect(setPumpSpeed.y, pumpElectricDC.contol_input) annotation(
    Line(points = {{20, -4}, {30, -4}, {30, 8}, {31, 8}}, color = {0, 0, 127}));
  connect(pumpElectricDC.Output, pipeSend.port_a) annotation(
    Line(points = {{44, 16}, {58, 16}, {58, 16}, {58, 16}}, color = {0, 127, 255}));
  connect(batterySystem.pin_n, pumpElectricDC.pin_n) annotation(
    Line(points = {{30, 46}, {30, 35}, {32, 35}, {32, 24}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, pumpElectricDC.pin_p) annotation(
    Line(points = {{38, 46}, {38, 24}}, color = {0, 0, 255}));
  connect(pipeReturn.port_b, heatSink.port_a) annotation(
    Line(points = {{24, -32}, {-10, -32}}, color = {0, 127, 255}));
  connect(temperature.port, heatSink.port_b) annotation(
    Line(points = {{-40, -60}, {-30, -60}, {-30, -32}}, color = {0, 127, 255}));
  connect(temperature1.port, heatSink.port_a) annotation(
    Line(points = {{-2, -60}, {-10, -60}, {-10, -32}}, color = {0, 127, 255}));
  connect(temperature2.port, pipeReturn.port_a) annotation(
    Line(points = {{52, -60}, {44, -60}, {44, -32}}, color = {0, 127, 255}));
  connect(heatSink.port_b, teeJunctionVolume.port_1) annotation(
    Line(points = {{-30, -32}, {-44, -32}, {-44, -22}}, color = {0, 127, 255}));
  connect(tankCoolant.ports[1], teeJunctionVolume.port_3) annotation(
    Line(points = {{-76, 6}, {-76, -12}, {-54, -12}}, color = {0, 127, 255}));
  connect(teeJunctionVolume.port_2, pumpElectricDC.Input) annotation(
    Line(points = {{-44, -2}, {-44, 16}, {26, 16}}, color = {0, 127, 255}));
  connect(pipe2.heatPorts[1], thermalConductor.port_b) annotation(
    Line(points = {{100.4, -2.1}, {122, -2.1}, {122, -2}}, color = {191, 0, 0}));
  connect(pipe2.port_b, pipeReturn.port_a) annotation(
    Line(points = {{96, -12}, {96, -32}, {44, -32}}, color = {0, 127, 255}));
  connect(pipeSend.port_b, pipe2.port_a) annotation(
    Line(points = {{78, 16}, {96, 16}, {96, 8}}, color = {0, 127, 255}));
  connect(thermalConductor.port_a, heatCapacitor.port) annotation(
    Line(points = {{142, -2}, {174, -2}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow.port, thermalConductor.port_a) annotation(
    Line(points = {{142, 26}, {142, -2}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, temperatureSensor.port) annotation(
    Line(points = {{174, -2}, {188, -2}, {188, 100}, {74, 100}}, color = {191, 0, 0}));
  connect(temperatureSensor.T, subSystemCoolingControl.sensorInterface) annotation(
    Line(points = {{54, 100}, {-86, 100}, {-86, 64}, {-66, 64}}, color = {0, 0, 127}));
  connect(realExpression.y, prescribedHeatFlow.Q_flow) annotation(
    Line(points = {{114, 56}, {142, 56}, {142, 46}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end SubSystemCoolingTEST_validTempMaintain;
