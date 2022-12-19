within VirtualFCS.ComponentTesting;

model SubSystemCoolingTEST_v7
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
  Modelica.Fluid.Pipes.DynamicPipe pipeReturn(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 1, redeclare package Medium = Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {34, -32}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setPumpSpeed(y = max(0.3, 1 - subSystemCoolingControl.controlInterface)) annotation(
    Placement(visible = true, transformation(origin = {8, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Cooling.SubSystemCoolingControl subSystemCoolingControl annotation(
    Placement(visible = true, transformation(origin = {-44, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipeSend(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 1, redeclare package Medium = Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {68, 16}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  VirtualFCS.Thermal.HeatSink heatSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Pipes.DynamicPipe pipe1(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 1, redeclare package Medium = Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe2(redeclare package Medium = Medium, diameter = 0.01, length = 50, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, nNodes = 1, nParallel = 5, use_HeatTransfer = true, use_T_start = true) annotation(
    Placement(visible = true, transformation(origin = {110, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {34, 56}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-2, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = temperature2.T) annotation(
    Placement(visible = true, transformation(origin = {-100, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature temperature2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {52, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 1777) annotation(
    Placement(visible = true, transformation(origin = {110, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = 1000, T(start = 673.15)) annotation(
    Placement(visible = true, transformation(origin = {110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(redeclare package Medium = Medium, V = 0.00001)  annotation(
    Placement(visible = true, transformation(origin = {-44, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(setPumpSpeed.y, pumpElectricDC.contol_input) annotation(
    Line(points = {{20, -4}, {30, -4}, {30, 8}, {31, 8}}, color = {0, 0, 127}));
  connect(pumpElectricDC.Output, pipeSend.port_a) annotation(
    Line(points = {{44, 16}, {58, 16}, {58, 16}, {58, 16}}, color = {0, 127, 255}));
  connect(pipeSend.port_b, pipe1.port_a) annotation(
    Line(points = {{78, 16}, {100, 16}}, color = {0, 127, 255}));
  connect(pipe1.port_b, pipe2.port_a) annotation(
    Line(points = {{120, 16}, {134, 16}, {134, -32}, {120, -32}}, color = {0, 127, 255}));
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
  connect(realExpression.y, subSystemCoolingControl.sensorInterface) annotation(
    Line(points = {{-88, 64}, {-66, 64}}, color = {0, 0, 127}));
  connect(temperature2.port, pipeReturn.port_a) annotation(
    Line(points = {{52, -60}, {44, -60}, {44, -32}}, color = {0, 127, 255}));
  connect(pipe2.port_b, pipeReturn.port_a) annotation(
    Line(points = {{100, -32}, {44, -32}}, color = {0, 127, 255}));
  connect(pipe2.heatPorts[1], thermalConductor.port_b) annotation(
    Line(points = {{110, -36}, {110, -48}}, color = {191, 0, 0}));
  connect(thermalConductor.port_a, heatCapacitor.port) annotation(
    Line(points = {{110, -68}, {110, -90}}, color = {191, 0, 0}));
  connect(heatSink.port_b, teeJunctionVolume.port_1) annotation(
    Line(points = {{-30, -32}, {-44, -32}, {-44, -22}}, color = {0, 127, 255}));
  connect(tankCoolant.ports[1], teeJunctionVolume.port_3) annotation(
    Line(points = {{-76, 6}, {-76, -12}, {-54, -12}}, color = {0, 127, 255}));
  connect(teeJunctionVolume.port_2, pumpElectricDC.Input) annotation(
    Line(points = {{-44, -2}, {-44, 16}, {26, 16}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end SubSystemCoolingTEST_v7;
