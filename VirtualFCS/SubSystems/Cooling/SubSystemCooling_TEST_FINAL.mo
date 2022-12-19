within VirtualFCS.SubSystems.Cooling;

model SubSystemCooling_TEST_FINAL
  // System
  
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Real m_system_coolant(unit = "kg") = 44 "Coolant system mass";
  //*** INSTANTIATE COMPONENTS ***//
  // System
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
  Modelica.Fluid.Vessels.OpenTank tankCoolant(redeclare package Medium = Coolant_Medium, crossArea = 0.0314, height = 0.16, level_start = 0.12, nPorts = 1, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, use_HeatTransfer = true, portsData = {Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.1)}, T_start = Modelica.Units.Conversions.from_degC(20)) annotation(
    Placement(visible = true, transformation(origin = {-77, 17}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  // Machines
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {34, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Heaters and Coolers
  
  // Other
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionTankCoolant(redeclare package Medium = Coolant_Medium, V = 0.00001) annotation(
    Placement(visible = true, transformation(origin = {-52, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  
  
  Modelica.Fluid.Pipes.DynamicPipe pipeReturn(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 2, redeclare package Medium = Coolant_Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {34, -32}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setPumpSpeed(y = max(0.005, 1 - subSystemCoolingControl.controlInterface)) annotation(
    Placement(visible = true, transformation(origin = {8, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SubSystemCoolingControl subSystemCoolingControl annotation(
    Placement(visible = true, transformation(origin = {-44, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipeSend(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 2, redeclare package Medium = Coolant_Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {68, 16}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  VirtualFCS.Thermal.HeatSink heatSink(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial)  annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(visible = true, transformation(origin = {176, 38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1000) annotation(
    Placement(visible = true, transformation(origin = {136, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 10000) annotation(
    Placement(visible = true, transformation(origin = {166, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = {98, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = 40*11, T(fixed = true, start = 293.15)) annotation(
    Placement(visible = true, transformation(origin = {198, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Fluid.Pipes.DynamicPipe pipe2(redeclare package Medium = Coolant_Medium, diameter = 0.003, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, nNodes = 2, nParallel = 500, use_HeatTransfer = true, use_T_start = true) annotation(
    Placement(visible = true, transformation(origin = {124, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
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
  connect(pumpElectricDC.Output, pipeSend.port_a) annotation(
    Line(points = {{44, 16}, {58, 16}, {58, 16}, {58, 16}}, color = {0, 127, 255}));
  connect(pipeSend.port_b, Output) annotation(
    Line(points = {{78, 16}, {98, 16}, {98, 18}, {100, 18}}, color = {0, 127, 255}));
  connect(heatSink.port_b, pipeReturn.port_b) annotation(
    Line(points = {{-10, -34}, {24, -34}, {24, -32}}, color = {0, 127, 255}));
  connect(heatSink.port_a, teeJunctionTankCoolant.port_1) annotation(
    Line(points = {{-30, -34}, {-52, -34}, {-52, -18}, {-52, -18}}, color = {0, 127, 255}));
  connect(thermalConductor.port_a, heatCapacitor.port) annotation(
    Line(points = {{176, 0}, {208, 0}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow.port, thermalConductor.port_a) annotation(
    Line(points = {{176, 28}, {176, 0}}, color = {191, 0, 0}));
  connect(realExpression.y, prescribedHeatFlow.Q_flow) annotation(
    Line(points = {{148, 58}, {176, 58}, {176, 48}}, color = {0, 0, 127}));
  connect(heatCapacitor.port, temperatureSensor.port) annotation(
    Line(points = {{208, 0}, {208, 102}, {108, 102}}, color = {191, 0, 0}));
  connect(temperatureSensor.T, subSystemCoolingControl.sensorInterface) annotation(
    Line(points = {{88, 102}, {-90, 102}, {-90, 64}, {-66, 64}}, color = {0, 0, 127}));
  connect(pipe2.port_b, Input) annotation(
    Line(points = {{124, -10}, {100, -10}, {100, -32}}, color = {0, 127, 255}));
  connect(thermalConductor.port_b, pipe2.heatPorts[1]) annotation(
    Line(points = {{156, 0}, {128, 0}}, color = {191, 0, 0}));
  connect(pipe2.port_a, Output) annotation(
    Line(points = {{124, 10}, {124, 18}, {100, 18}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 50),
    __Dymola_Commands(file = "modelica://Modelica/Resources/Scripts/Dymola/Fluid/EmptyTanks/plot level and port.p.mos" "plot level and port.p"),
    Documentation(info = "<html><head></head><body><span style=\"font-family: Arial; font-size: large;\">The SubSystemCooling model provides a template for the construction of a cooling sub-system for the fuel cell stack.&nbsp;</span><br><div><div><span lang=\"NO-BOK\"><font face=\"Arial\" size=\"4\"><br></font></span></div>

<p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\"><b>References to base model/related packages</b><o:p></o:p></font></p><p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\">&nbsp;</font><a href=\"modelica://VirtualFCS.Thermal.HeatSink\" style=\"font-family: Arial; font-size: large;\">Heat Sink</a><span style=\"font-family: Arial; font-size: large;\">,&nbsp;</span><a href=\"modelica://VirtualFCS.Fluid.PumpElectricDC\" style=\"font-family: Arial; font-size: large;\">DC Pump</a><span style=\"font-family: Arial; font-size: large;\">&nbsp;and&nbsp;</span><a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCoolingControl\" style=\"font-family: Arial; font-size: large;\">Cooling Subsystem Control</a><font face=\"Arial\" size=\"4\">&nbsp;</font></p>

<p class=\"MsoNormal\"><span style=\"font-family: Arial; font-size: large;\">&nbsp;</span></p>

<p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\"><b>Description&nbsp;</b></font></p><p class=\"MsoNormal\"><span style=\"font-family: Arial; font-size: large;\">The subsystem features 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports connect to the cooling interfaces on the fuel cell stack, the electrical ports connect to the low-voltage power supply to provide power to the BoP components, and the control interface connects to the FuelCellControlUnit, which controls the pump, pre-heater, and heat sink.</span></p><p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\"><br></font></p><p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\"><b>List of components<o:p></o:p></b></font></p>

<p class=\"MsoNormal\"><o:p><font face=\"Arial\" size=\"4\">The model comprises a <a href=\"modelica://Modelica.Fluid.Vessels.OpenTank\">Coolant Tank</a>, </font><a href=\"modelica://VirtualFCS.Thermal.HeatSink\" style=\"font-family: Arial; font-size: large;\">Heat Sink</a><span style=\"font-family: Arial; font-size: large;\">,&nbsp;</span><a href=\"modelica://VirtualFCS.Fluid.PumpElectricDC\" style=\"font-family: Arial; font-size: large;\">DC Pump</a><span style=\"font-family: Arial; font-size: large;\">&nbsp;and&nbsp;</span><a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCoolingControl\" style=\"font-family: Arial; font-size: large;\">Cooling Subsystem Control</a><font face=\"Arial\" size=\"4\">&nbsp;</font></o:p></p>

<p class=\"MsoNormal\"><o:p><font face=\"Arial\" size=\"4\">&nbsp;</font></o:p></p>

<!--EndFragment--></div></body></html>"),
    Icon(graphics = {Bitmap(origin = {-6, 20}, extent = {{-94, 80}, {106, -120}}, imageSource = "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"), Text(origin = {9, -11}, textColor = {255, 255, 255}, extent = {{-81, 89}, {65, -55}}, textString = "Cool")}, coordinateSystem(initialScale = 0.1)),
    Diagram(graphics = {Text(origin = {35, 0}, extent = {{-19, 4}, {15, -2}}, textString = "Pump")}, coordinateSystem(initialScale = 0.1)));
end SubSystemCooling_TEST_FINAL;
