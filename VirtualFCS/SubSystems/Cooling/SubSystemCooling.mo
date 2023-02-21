within VirtualFCS.SubSystems.Cooling;

model SubSystemCooling
  // System
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial) annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  // Parameter definition
  parameter Modelica.Units.SI.Mass m_system_coolant = 44 "Coolant system mass";
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {100, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {50, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {14, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation(
    Placement(visible = true, transformation(origin = {62, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Thermal components
  VirtualFCS.Thermal.HeatSink heatSink(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Control components
  Modelica.Blocks.Sources.RealExpression setPumpSpeed(y = subSystemCoolingControl.controlInterface) annotation(
    Placement(visible = true, transformation(origin = {8, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation(
    Placement(visible = true, transformation(origin = {-114, 64}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Cooling.SubSystemCoolingControl subSystemCoolingControl annotation(
    Placement(visible = true, transformation(origin = {-40, 64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  // Vessels
  Modelica.Fluid.Vessels.OpenTank tankCoolant(redeclare package Medium = Coolant_Medium, crossArea = 0.0314, height = 0.16, level_start = 0.12, nPorts = 1, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, use_HeatTransfer = true, portsData = {Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.1)}, T_start = system.T_start) annotation(
    Placement(visible = true, transformation(origin = {-77, 17}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  // Machines
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC annotation(
    Placement(visible = true, transformation(origin = {32, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Other
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionCoolantTank(redeclare package Medium = Coolant_Medium, V = 0.00001) annotation(
    Placement(visible = true, transformation(origin = {-44, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(heatSink.port_b, teeJunctionCoolantTank.port_1) annotation(
    Line(points = {{-30, -32}, {-44, -32}, {-44, -22}}, color = {0, 0, 255}, thickness = 1.5));
  connect(tankCoolant.ports[1], teeJunctionCoolantTank.port_3) annotation(
    Line(points = {{-76, 6}, {-76, -12}, {-54, -12}}, color = {0, 0, 255}, thickness = 1.5));
  connect(teeJunctionCoolantTank.port_2, pumpElectricDC.Input) annotation(
    Line(points = {{-44, -2}, {-44, 16}, {23, 16}}, color = {0, 0, 255}, thickness = 1.5));
  connect(pin_n, pumpElectricDC.pin_n) annotation(
    Line(points = {{14, 52}, {14, 40}, {29, 40}, {29, 24}}, color = {0, 0, 255}));
  connect(pin_p, pumpElectricDC.pin_p) annotation(
    Line(points = {{50, 52}, {50, 40}, {35, 40}, {35, 24}}, color = {0, 0, 255}));
  connect(setPumpSpeed.y, pumpElectricDC.contol_input) annotation(
    Line(points = {{20, -4}, {30, -4}, {30, 8}}, color = {0, 0, 127}));
  connect(pumpElectricDC.sensors, sensors) annotation(
    Line(points = {{36, 8}, {36, -2}, {62, -2}}, color = {0, 0, 127}, thickness = 0.5));
  connect(port_a, heatSink.port_a) annotation(
    Line(points = {{100, -32}, {-10, -32}}, color = {255, 0, 0}, thickness = 1.5));
  connect(pumpElectricDC.Output, port_b) annotation(
    Line(points = {{42, 16}, {100, 16}}, color = {0, 0, 255}, thickness = 1.5));
  connect(controlInterface, subSystemCoolingControl.sensorInterface) annotation(
    Line(points = {{-114, 64}, {-62, 64}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {9, -11}, lineColor = {255, 255, 255}, extent = {{-81, 89}, {65, -55}}, textString = "Cool")}, coordinateSystem(initialScale = 0.1)),
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(graphics = {Text(origin = {37, 28}, extent = {{-19, 4}, {15, -2}}, textString = "Pump")}));
end SubSystemCooling;
