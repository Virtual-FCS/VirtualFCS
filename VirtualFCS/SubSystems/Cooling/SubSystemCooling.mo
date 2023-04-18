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
    Placement(visible = true, transformation(origin = {100, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {50, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {14, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation(
    Placement(visible = true, transformation(origin = {62, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Thermal components
  VirtualFCS.Thermal.HeatSink heatSink(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Control components
  Modelica.Blocks.Sources.RealExpression setPumpSpeed(y = subSystemCoolingControl.controlInterface) annotation(
    Placement(visible = true, transformation(origin = {8, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation(
    Placement(visible = true, transformation(origin = {-114, -56}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Modelica.Fluid.Sensors.Temperature Inlet_Temperature(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {15, -39}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature Outlet_temperature(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-76, -39}, extent = {{-6, -5}, {6, 5}}, rotation = 0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(heatSink.port_b, teeJunctionCoolantTank.port_1) annotation(
    Line(points = {{-30, -55}, {-30, -27.5}, {-44, -27.5}, {-44, -22}}, color = {0, 0, 255}, thickness = 1.5));
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
    Line(points = {{100, -56}, {45, -56}, {45, -55}, {-10, -55}}, color = {255, 0, 0}, thickness = 1.5));
  connect(pumpElectricDC.Output, port_b) annotation(
    Line(points = {{42, 16}, {100, 16}}, color = {0, 0, 255}, thickness = 1.5));
  connect(heatSink.Set_Point, subSystemCoolingControl.Setpoint_Temperature) annotation(
    Line(points = {{-9, -66}, {122, -66}, {122, 78}, {-20, 78}}, color = {0, 0, 127}));
  connect(heatSink.Stack_temperature, controlInterface) annotation(
    Line(points = {{-114, -56}, {-62, -56}, {-62, -71}, {-9, -71}}, color = {0, 0, 127}));
  connect(sensors[1], subSystemCoolingControl.sensorInterface) annotation(
    Line(points = {{62, -2}, {70, -2}, {70, -14}, {-26, -14}, {-26, 36}, {-70, 36}, {-70, 64}, {-62, 64}}, color = {0, 0, 127}));
  connect(controlInterface, heatSink.Stack_temperature) annotation(
    Line(points = {{-114, -42}, {-32, -42}, {-32, -46}, {-10, -46}}, color = {0, 0, 127}));
  connect(heatSink.Set_Point, subSystemCoolingControl.Setpoint_Temperature) annotation(
    Line(points = {{-10, -42}, {122, -42}, {122, 78}, {-20, 78}}, color = {0, 0, 127}));
  connect(Outlet_temperature.port, heatSink.port_b) annotation(
    Line(points = {{-76, -44}, {-30, -44}, {-30, -55}}, color = {0, 127, 255}));
  connect(Inlet_Temperature.port, heatSink.port_a) annotation(
    Line(points = {{15, -44}, {-10, -44}, {-10, -55}}, color = {0, 127, 255}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {9, -11}, textColor = {255, 255, 255}, extent = {{-81, 89}, {65, -55}}, textString = "Cool")}, coordinateSystem(initialScale = 0.1)),
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(graphics = {Text(origin = {37, 28}, extent = {{-19, 4}, {15, -2}}, textString = "Pump")}));
end SubSystemCooling;
