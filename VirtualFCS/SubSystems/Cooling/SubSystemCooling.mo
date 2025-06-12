within VirtualFCS.SubSystems.Cooling;
model SubSystemCooling
  // System
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial) annotation (
    Placement(visible = true, transformation(origin = {110, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Coolant_Medium =
      Modelica.Media.Water.ConstantPropertyLiquidWater                                  constrainedby
    Modelica.Media.Interfaces.PartialMedium;
  // Parameter definition
  parameter Modelica.Units.SI.Mass m_system_coolant = 44 "Coolant system mass";
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Coolant_Medium)                                                                   annotation (
    Placement(visible = true, transformation(origin = {120, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Coolant_Medium)                                                                   annotation (
    Placement(visible = true, transformation(origin = {120, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin = {66, 124}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin = {30, 124}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation (
    Placement(visible = true, transformation(origin = {68, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Thermal components
  VirtualFCS.Thermal.HeatSink heatSink(redeclare package Medium =
        Coolant_Medium)                                                           annotation (
    Placement(visible = true, transformation(origin = {29, -35}, extent = {{-11, -11}, {11, 11}}, rotation = 180)));
  // Control components
  Modelica.Blocks.Sources.RealExpression setPumpSpeed(y=subSystemCoolingControl.controlInterface)   annotation (
    Placement(visible = true, transformation(origin = {26, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation (
    Placement(visible = true, transformation(origin = {-114, -44}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Cooling.SubSystemCoolingControl subSystemCoolingControl annotation (
    Placement(visible = true, transformation(origin = {-1, 77}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  // Vessels
  Modelica.Fluid.Vessels.OpenTank tankCoolant(redeclare package Medium =
        Coolant_Medium,                                                                  crossArea = 0.0314, height = 0.16, level_start = 0.12, nPorts = 1, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, use_HeatTransfer = true, portsData = {Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.1)}, T_start = system.T_start) annotation (
    Placement(visible = true, transformation(origin = {-63, 45}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  // Machines
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC annotation (
    Placement(visible = true, transformation(origin = {50, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Other
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionCoolantTank(redeclare
      package Medium =
        Coolant_Medium,                                                                                       V = 0.00001) annotation (
    Placement(visible = true, transformation(origin = {-39, 23}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Modelica.Fluid.Sensors.Temperature Inlet_Temperature(redeclare package Medium =
        Coolant_Medium)                                                                           annotation (
    Placement(visible = true, transformation(origin = {63, -9}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature Outlet_temperature(redeclare package
      Medium =
        Coolant_Medium)                                                                            annotation (
    Placement(visible = true, transformation(origin = {-2, -5}, extent = {{-6, -5}, {6, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=80 + 273.15)
    annotation (Placement(transformation(extent={{-68,62},{-48,82}})));
  Modelica.Fluid.Sensors.Temperature InletPump_Temperature(redeclare package
      Medium = Coolant_Medium) annotation (Placement(visible=true,
        transformation(
        origin={-1,27},
        extent={{5,-5},{-5,5}},
        rotation=0)));
  Modelica.Fluid.Sensors.Temperature OutletPump_temperature(redeclare package
      Medium = Coolant_Medium) annotation (Placement(visible=true,
        transformation(
        origin={108,27},
        extent={{-6,-5},{6,5}},
        rotation=0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(heatSink.port_b, teeJunctionCoolantTank.port_1) annotation (
    Line(points={{18,-27.3},{18,-27.5},{-39,-27.5},{-39,18}},        color = {0, 0, 255}, thickness = 1.5));
  connect(tankCoolant.ports[1], teeJunctionCoolantTank.port_3) annotation (
    Line(points={{-63,34},{-63,23},{-44,23}},        color = {0, 0, 255}, thickness = 1.5));
  connect(teeJunctionCoolantTank.port_2, pumpElectricDC.Input) annotation (
    Line(points = {{-39, 28}, {-39, 46}, {41, 46}}, color = {0, 0, 255}, thickness = 1.5));
  connect(pin_n, pumpElectricDC.pin_n) annotation (
    Line(points = {{30, 124}, {30, 54}, {47, 54}}, color = {0, 0, 255}));
  connect(pin_p, pumpElectricDC.pin_p) annotation (
    Line(points = {{66, 124}, {66, 54}, {53, 54}}, color = {0, 0, 255}));
  connect(setPumpSpeed.y, pumpElectricDC.contol_input) annotation (
    Line(points = {{37, 26}, {47, 26}, {47, 38}}, color = {0, 0, 127}));
  connect(pumpElectricDC.sensors, sensors) annotation (
    Line(points = {{53, 38}, {53, 26}, {68, 26}}, color = {0, 0, 127}, thickness = 0.5));
  connect(port_a, heatSink.port_a) annotation (
    Line(points={{120,-26},{117,-26},{117,-25},{120.5,-25},{120.5,-27.3},{40,
          -27.3}},                                                                             color = {255, 0, 0}, thickness = 1.5));
  connect(pumpElectricDC.Output, port_b) annotation (
    Line(points = {{59, 46}, {120, 46}}, color = {0, 0, 255}, thickness = 1.5));
  connect(Outlet_temperature.port, heatSink.port_b) annotation (
    Line(points={{-2,-10},{-2,-14.5},{18,-14.5},{18,-27.3}},        color = {0, 127, 255}));
  connect(Inlet_Temperature.port, heatSink.port_a) annotation (
    Line(points={{63,-14},{40,-14},{40,-27.3}},      color = {0, 127, 255}));
  connect(heatSink.pin_n, pin_n) annotation (Line(points={{24.6,-46.44},{24.6,
          -64},{-134,-64},{-134,124},{30,124}}, color={0,0,255}));
  connect(pin_p, heatSink.pin_p) annotation (Line(points={{66,124},{66,126},{
          138,126},{138,-64},{34,-64},{34,-48},{33.4,-48},{33.4,-46.44}}, color
        ={0,0,255}));
  connect(realExpression1.y, subSystemCoolingControl.sensorInterface)
    annotation (Line(points={{-47,72},{-24,72},{-24,85.5},{-19.7,85.5}}, color=
          {0,0,127}));
  connect(InletPump_Temperature.port, pumpElectricDC.Input) annotation (Line(
        points={{-1,22},{-2,22},{-2,18},{10,18},{10,46},{41,46}}, color={0,127,
          255}));
  connect(OutletPump_temperature.port, pumpElectricDC.Output) annotation (Line(
        points={{108,22},{108,20},{88,20},{88,46},{59,46}}, color={0,127,255}));
  connect(controlInterface, subSystemCoolingControl.setPointPump) annotation (
      Line(points={{-114,-44},{-19.7,-44},{-19.7,77.34}},color={0,0,127}));
  connect(realExpression1.y, heatSink.Set_Point) annotation (Line(points={{-47,
          72},{-24,72},{-24,-30},{12,-30},{12,-34.12},{17.12,-34.12}}, color={0,
          0,127}));
  connect(controlInterface, heatSink.Stack_temperature) annotation (Line(points
        ={{-114,-44},{-20,-44},{-20,-40},{12,-40},{12,-43.58},{17.12,-43.58}},
        color={0,0,127}));
  annotation (
    Icon(graphics={  Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {9, -11}, textColor = {255, 255, 255}, extent = {{-81, 89}, {65, -55}}, textString = "Cool")}, coordinateSystem(initialScale = 0.1, extent = {{-100, -100}, {100, 100}})),
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(graphics={  Text(origin = {55, 58}, extent = {{-19, 4}, {15, -2}}, textString = "Pump")}, coordinateSystem(extent = {{-100, 120}, {120, -100}})));
end SubSystemCooling;
