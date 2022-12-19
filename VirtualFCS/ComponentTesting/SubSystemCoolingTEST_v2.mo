within VirtualFCS.ComponentTesting;

model SubSystemCoolingTEST_v2
  extends Modelica.Icons.Example;
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Real m_system_coolant(unit = "kg") = 44 "Coolant system mass";
  //*** INSTANTIATE COMPONENTS ***//
  // System
  inner Modelica.Fluid.System system(T_ambient = 298.15, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial) annotation(
    Placement(visible = true, transformation(origin = {-8, -6},extent = {{-92, -94}, {-72, -74}}, rotation = 0)));
  // Interfaces
  // Vessels
  // Machines
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {34, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Heaters and Coolers
  // Other
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionTankCoolant(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-52, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Fluid.Pipes.DynamicPipe pipeReturn(use_T_start = true, 
    length = 0.2, 
    diameter = 0.01,
    nParallel = 5,
    nNodes = 1,
    redeclare package Medium = Medium, 
    modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, 
    use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {34, -32}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setPumpSpeed(y = max(0.3, 1 - subSystemCoolingControl.controlInterface)) annotation(
    Placement(visible = true, transformation(origin = {8, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Cooling.SubSystemCoolingControl subSystemCoolingControl annotation(
    Placement(visible = true, transformation(origin = {-44, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipeSend(use_T_start = true, 
    length = 0.2, 
    diameter = 0.01,
    nParallel = 5,
    nNodes = 1,
    redeclare package Medium = Medium, 
    modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, 
    use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {68, 16}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  VirtualFCS.Thermal.HeatSink heatSink(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 273.15 + 80)  annotation(
    Placement(visible = true, transformation(origin = {-120, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe1(use_T_start = true, 
    length = 0.2, 
    diameter = 0.01,
    nParallel = 5,
    nNodes = 1,
    redeclare package Medium = Medium, 
    modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, 
    use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe2(use_T_start = true, 
    length = 0.2, 
    diameter = 0.01,
    nParallel = 5,
    nNodes = 1,
    redeclare package Medium = Medium, 
    modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, 
    use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {110, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {34, 56}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, T = Medium.T_default + 100, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-86, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(setPumpSpeed.y, pumpElectricDC.contol_input) annotation(
    Line(points = {{20, -4}, {30, -4}, {30, 8}, {31, 8}}, color = {0, 0, 127}));
  connect(teeJunctionTankCoolant.port_2, pumpElectricDC.Input) annotation(
    Line(points = {{-52, 2}, {-52, 2}, {-52, 16}, {26, 16}, {26, 16}}, color = {0, 127, 255}));
  connect(pumpElectricDC.Output, pipeSend.port_a) annotation(
    Line(points = {{44, 16}, {58, 16}, {58, 16}, {58, 16}}, color = {0, 127, 255}));
  connect(heatSink.port_b, pipeReturn.port_b) annotation(
    Line(points = {{-10, -34}, {24, -34}, {24, -32}}, color = {0, 127, 255}));
  connect(heatSink.port_a, teeJunctionTankCoolant.port_1) annotation(
    Line(points = {{-30, -34}, {-52, -34}, {-52, -18}, {-52, -18}}, color = {0, 127, 255}));
  connect(const.y, subSystemCoolingControl.sensorInterface) annotation(
    Line(points = {{-108, 64}, {-66, 64}}, color = {0, 0, 127}));
  connect(pipeSend.port_b, pipe1.port_a) annotation(
    Line(points = {{78, 16}, {100, 16}}, color = {0, 127, 255}));
  connect(pipeReturn.port_a, pipe2.port_b) annotation(
    Line(points = {{44, -32}, {100, -32}}, color = {0, 127, 255}));
  connect(pipe1.port_b, pipe2.port_a) annotation(
    Line(points = {{120, 16}, {134, 16}, {134, -32}, {120, -32}}, color = {0, 127, 255}));
  connect(batterySystem.pin_n, pumpElectricDC.pin_n) annotation(
    Line(points = {{30, 46}, {30, 35}, {32, 35}, {32, 24}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, pumpElectricDC.pin_p) annotation(
    Line(points = {{38, 46}, {38, 24}}, color = {0, 0, 255}));
  connect(boundary.ports[1], teeJunctionTankCoolant.port_3) annotation(
    Line(points = {{-76, -8}, {-62, -8}}, color = {0, 127, 255}));
  annotation(experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end SubSystemCoolingTEST_v2;
