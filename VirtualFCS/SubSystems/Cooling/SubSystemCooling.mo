within VirtualFCS.SubSystems.Cooling;

model SubSystemCooling
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  //*** INSTANTIATE COMPONENTS ***//
  // System
  inner Modelica.Fluid.System system(T_ambient = 298.15, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(visible = true, transformation(extent = {{-92, -94}, {-72, -74}}, rotation = 0)));
  // Interfaces
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {100, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-59, 119}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {46, 56}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {22, 56}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation(
    Placement(visible = true, transformation(origin = {80, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Vessels
  Modelica.Fluid.Vessels.OpenTank tankCoolant(redeclare package Medium = Coolant_Medium, crossArea = 0.0314, height = 0.160, level_start = 0.12, nPorts = 1, portsData = {Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.1)}) annotation(
    Placement(visible = true, transformation(origin = {-77, 17}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  // Machines
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {34, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Heaters and Coolers
  // Other
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionTankCoolant(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-52, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Fluid.Pipes.DynamicPipe pipeReturn(redeclare package Medium = Coolant_Medium, T_start = system.T_start, diameter = 0.01, length = 0.2, nParallel = 5, p_a_start = 102502, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {34, -32}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation(
    Placement(visible = true, transformation(origin = {-113, 79}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-109, 51}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setPumpSpeed(y = max(0.3, 1 - subSystemCoolingControl.controlInterface)) annotation(
    Placement(visible = true, transformation(origin = {8, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Thermal.HeatSink heatSink(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, -32}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SubSystemCoolingControl subSystemCoolingControl annotation(
    Placement(visible = true, transformation(origin = {-44, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipeSend(redeclare package Medium = Coolant_Medium, T_start = system.T_start, diameter = 0.01, length = 0.2, nParallel = 5, p_a_start = 102502, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {68, 16}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(tankCoolant.ports[1], teeJunctionTankCoolant.port_3) annotation(
    Line(points = {{-77, 6}, {-78, 6}, {-78, -8}, {-62, -8}}, color = {0, 170, 255}, thickness = 1));
  connect(pipeReturn.port_a, Input) annotation(
    Line(points = {{44, -32}, {100, -32}}, color = {0, 170, 255}, thickness = 1));
  connect(pin_n, pumpElectricDC.pin_n) annotation(
    Line(points = {{22, 56}, {22, 24}, {31, 24}}, color = {0, 0, 255}));
  connect(pin_p, pumpElectricDC.pin_p) annotation(
    Line(points = {{46, 56}, {46, 24}, {37, 24}}, color = {0, 0, 255}));
  connect(setPumpSpeed.y, pumpElectricDC.contol_input) annotation(
    Line(points = {{20, -4}, {30, -4}, {30, 8}, {31, 8}}, color = {0, 0, 127}));
  connect(pumpElectricDC.sensors, sensors) annotation(
    Line(points = {{37, 8}, {37, -4}, {80, -4}}, color = {0, 0, 127}, thickness = 0.5));
  connect(teeJunctionTankCoolant.port_2, pumpElectricDC.Input) annotation(
    Line(points = {{-52, 2}, {-52, 2}, {-52, 16}, {26, 16}, {26, 16}}, color = {0, 127, 255}));
  connect(heatSink.port_a, pipeReturn.port_b) annotation(
    Line(points = {{-10, -32}, {24, -32}}, color = {0, 127, 255}));
  connect(heatSink.port_b, teeJunctionTankCoolant.port_1) annotation(
    Line(points = {{-30, -32}, {-52, -32}, {-52, -18}, {-52, -18}}, color = {0, 127, 255}));
  connect(controlInterface, subSystemCoolingControl.sensorInterface) annotation(
    Line(points = {{-112, 80}, {-84, 80}, {-84, 64}, {-66, 64}, {-66, 64}}, color = {0, 0, 127}));
  connect(pumpElectricDC.Output, pipeSend.port_a) annotation(
    Line(points = {{44, 16}, {58, 16}, {58, 16}, {58, 16}}, color = {0, 127, 255}));
  connect(pipeSend.port_b, Output) annotation(
    Line(points = {{78, 16}, {98, 16}, {98, 18}, {100, 18}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 50),
    __Dymola_Commands(file = "modelica://Modelica/Resources/Scripts/Dymola/Fluid/EmptyTanks/plot level and port.p.mos" "plot level and port.p"),
    Documentation(info = "<html><head></head><body>The SubSystemCooling model provides a template for the construction of a cooling sub-system for the fuel cell stack. The model comprises a coolant tank, pre-heater, pump, and heat sink. The subsystem features 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports connect to the cooling interfaces on the fuel cell stack, the electrical ports connect to the low-voltage power supply to provide power to the BoP components, and the control interface connects to the FuelCellControlUnit, which controls the pump, pre-heater, and heat sink.</body></html>"),
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(fillColor = {180, 233, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {9, -11}, extent = {{-81, 89}, {65, -55}}, textString = "Cooling")}, coordinateSystem(initialScale = 0.1)),
    Diagram(graphics = {Text(origin = {35, 0}, extent = {{-19, 4}, {15, -2}}, textString = "Pump")}, coordinateSystem(initialScale = 0.1)));
end SubSystemCooling;
