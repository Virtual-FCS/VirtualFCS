within VirtualFCS.SubSystems.Air;

model SubSystemAir_wHumidifier
  outer Modelica.Fluid.System system "System properties";
  replaceable package Medium = Media.CathodeAir;
  parameter Integer N_cells = N_cells "Number of cells in the stack";
  parameter Real lambda = 3 "Air excess ratio";
  parameter Modelica.Units.SI.AbsolutePressure p_set = 200000 "Target cathodic pressure";
  parameter Real rh_set = 0.07 "Relative humidity setpoint inlet stack";
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {-98, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Fluid.Interfaces.FluidPort_a fromStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, -76}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_b toStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {28, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {16, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent(unit = "A") annotation(
    Placement(transformation(origin = {-110, 72}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFlowRate airInflow(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-72, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Pressure inletPressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {90, 70}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Fluid.Sources.FixedBoundary exhaust(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {-100, -76}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature tempCompressorOut(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {1, 55}, extent = {{-7, -7}, {7, 7}})));
  // Replaceable main components
  replaceable Fluid.SimpleCompressor compressor(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-24, 30}, extent = {{-20, -20}, {20, 20}}))) constrainedby Fluid.CompressorInterface annotation(
     choicesAllMatching = true,
     Placement(transformation(origin = {-24, 30}, extent = {{-20, -20}, {20, 20}})));
  replaceable Modelica.Fluid.Valves.ValveCompressible outletValve(redeclare package Medium = Medium, dp_nominal(displayUnit = "bar") = 1.5e5, m_flow_nominal = 0.3, opening(start = 0), p_nominal = 2.5e5) annotation(
    Placement(transformation(origin = {-62, -76}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  replaceable Fluid.HumidifierDummy humidifier(redeclare package dry_medium = Medium, redeclare package wet_medium = Medium) annotation(
    Placement(transformation(origin = {55, -34}, extent = {{-17, -14}, {17, 14}}))) constrainedby Fluid.HumidifierInterface annotation(
     choicesAllMatching = true,
     Placement(transformation(origin = {55, -34}, extent = {{-17, -14}, {17, 14}})));
  replaceable Modelica.Fluid.Valves.ValveLinear humInletValve(redeclare package Medium = Medium, dp_nominal(displayUnit = "Pa") = 1000, m_flow_nominal = 0.5) annotation(
    Placement(transformation(origin = {-8, -34}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  replaceable Modelica.Fluid.Valves.ValveLinear bypassValve(redeclare package Medium = Medium, dp_nominal(displayUnit = "Pa") = 10000, m_flow_nominal = 0.5) annotation(
    Placement(transformation(origin = {42, 30}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Fluid.Vessels.ClosedVolume mixingVolumeCompOut(redeclare package Medium = Medium, use_portsData = false, V = 0.001, nPorts = 3) annotation(
    Placement(transformation(origin = {14, 36}, extent = {{-6, -6}, {6, 6}})));
  Fluid.RelativeHumiditySensor sensorRHdryOut(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {76, 30}, extent = {{-10, -10}, {10, 10}})));
  Fluid.RelativeHumiditySensor sensorRHdryIn(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {22, -34}, extent = {{-10, -10}, {10, 10}})));
  Fluid.RelativeHumiditySensor sensorRHwetIn(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {80, -76}, extent = {{10, -10}, {-10, 10}})));
  Fluid.RelativeHumiditySensor sensorRHwetOut(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-28, -76}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  replaceable SubSystemAirControl subSystemAirControl(N_cells = N_cells, p_set = p_set, rh_set = rh_set, lambda = lambda) annotation(
    Placement(transformation(origin = {-64, -24}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(source.ports[1], airInflow.port_a) annotation(
    Line(points = {{-88, 30}, {-82, 30}}, color = {0, 170, 255}, thickness = 0.75));
  connect(inletPressure.port, toStack) annotation(
    Line(points = {{90, 60}, {98, 60}, {98, 30}, {100, 30}}, color = {0, 127, 255}, thickness = 0.75));
  connect(outletValve.port_b, exhaust.ports[1]) annotation(
    Line(points = {{-72, -76}, {-90, -76}}, color = {0, 127, 255}, thickness = 0.75));
  connect(airInflow.port_b, compressor.port_a) annotation(
    Line(points = {{-62, 30}, {-46, 30}}, color = {0, 127, 255}, thickness = 0.75));
  connect(compressor.pin_p, pin_p) annotation(
    Line(points = {{-20, 41}, {-20, 75.75}, {28, 75.75}, {28, 100}}, color = {0, 0, 255}, thickness = 0.75));
  connect(compressor.pin_n, pin_n) annotation(
    Line(points = {{-26, 41}, {-26, 81.5}, {16, 81.5}, {16, 100}}, color = {0, 0, 255}, thickness = 0.75));
  connect(tempCompressorOut.port, compressor.port_b) annotation(
    Line(points = {{1, 48}, {1, 30}, {-2, 30}}, color = {0, 127, 255}, thickness = 0.75));
  connect(compressor.port_b, mixingVolumeCompOut.ports[1]) annotation(
    Line(points = {{-2, 30}, {14, 30}}, color = {0, 127, 255}, thickness = 0.75));
  connect(mixingVolumeCompOut.ports[2], bypassValve.port_a) annotation(
    Line(points = {{14, 30}, {32, 30}}, color = {0, 127, 255}, thickness = 0.75));
  connect(humInletValve.port_b, sensorRHdryIn.port_a) annotation(
    Line(points = {{2, -34}, {12, -34}}, color = {0, 127, 255}, thickness = 0.75));
  connect(sensorRHdryIn.port_b, humidifier.portB_in) annotation(
    Line(points = {{32, -34}, {38, -34}}, color = {0, 127, 255}, thickness = 0.75));
  connect(sensorRHdryOut.port_b, toStack) annotation(
    Line(points = {{86, 30}, {100, 30}}, color = {0, 127, 255}, thickness = 0.75));
  connect(bypassValve.port_b, sensorRHdryOut.port_a) annotation(
    Line(points = {{52, 30}, {66, 30}}, color = {0, 127, 255}, thickness = 0.75));
  connect(outletValve.port_a, sensorRHwetOut.port_b) annotation(
    Line(points = {{-52, -76}, {-38, -76}}, color = {0, 127, 255}));
  connect(sensorRHwetIn.port_a, fromStack) annotation(
    Line(points = {{90, -76}, {100, -76}}, color = {0, 127, 255}));
  connect(humInletValve.port_a, mixingVolumeCompOut.ports[3]) annotation(
    Line(points = {{-18, -34}, {-24, -34}, {-24, -10}, {14, -10}, {14, 30}}, color = {0, 127, 255}, thickness = 0.75));
  connect(humidifier.portB_out, sensorRHdryOut.port_a) annotation(
    Line(points = {{72, -34}, {72, 0}, {60, 0}, {60, 30}, {66, 30}}, color = {0, 127, 255}, thickness = 0.75));
  connect(humidifier.portA_in, sensorRHwetIn.port_b) annotation(
    Line(points = {{55, -26}, {55, -18}, {82, -18}, {82, -56}, {62, -56}, {62, -76}, {70, -76}}, color = {0, 127, 255}, thickness = 0.75));
  connect(sensorRHwetOut.port_a, humidifier.portA_out) annotation(
    Line(points = {{-18, -76}, {55, -76}, {55, -42}}, color = {0, 127, 255}, thickness = 0.75));
  connect(stackCurrent, subSystemAirControl.stackCurrent) annotation(
    Line(points = {{-110, 72}, {-88, 72}, {-88, 48}, {-112, 48}, {-112, -10}, {-86, -10}}, color = {0, 0, 127}));
  connect(airInflow.m_flow, subSystemAirControl.airFlowCompressorFeedback) annotation(
    Line(points = {{-72, 42}, {-72, 54}, {-118, 54}, {-118, -18}, {-86, -18}}, color = {0, 0, 127}));
  connect(sensorRHdryOut.Phi, subSystemAirControl.rhToStackFeedback) annotation(
    Line(points = {{76, 42}, {76, 48}, {114, 48}, {114, 8}, {-106, 8}, {-106, -30}, {-86, -30}}, color = {0, 0, 127}));
  connect(inletPressure.p, subSystemAirControl.pressureToStackFeedback) annotation(
    Line(points = {{80, 70}, {74, 70}, {74, 54}, {120, 54}, {120, 2}, {-100, 2}, {-100, -38}, {-86, -38}}, color = {0, 0, 127}));
  connect(subSystemAirControl.setOutletValveOpening, outletValve.opening) annotation(
    Line(points = {{-42, -38}, {-38, -38}, {-38, -58}, {-62, -58}, {-62, -68}}, color = {0, 0, 127}));
  connect(subSystemAirControl.setHumInletValveOpening, humInletValve.opening) annotation(
    Line(points = {{-42, -30}, {-32, -30}, {-32, -50}, {-8, -50}, {-8, -42}}, color = {0, 0, 127}));
  connect(subSystemAirControl.setBypassValveOpening, bypassValve.opening) annotation(
    Line(points = {{-42, -18}, {-30, -18}, {-30, -4}, {26, -4}, {26, 46}, {42, 46}, {42, 38}}, color = {0, 0, 127}));
  connect(subSystemAirControl.setCompressor, compressor.set_control) annotation(
    Line(points = {{-42, -10}, {-38, -10}, {-38, 4}, {-56, 4}, {-56, 42}, {-46, 42}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>An air sub-system template is provided in the example model SubSystemAir.&nbsp;<div><br></div><div><b>Description</b></div><div><br></div><div>  <b>TO BE UPDATED</b>   <div><div>   The model consists of an <a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a> and <a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a> connected to a fixed boundary condition reflecting the ambient conditions.&nbsp;</div><div><br></div><div>The subsystem model contains 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the connection to the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>. The electrical ports interface with the low-voltage DC power-supply to power the BoP components (in this case, the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>). The control port provides an interface to the Fuel Cell Control Unit, which controls the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. A&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;is connected downstream from the Fuel Cell Stack to maintain the set pressure in the air line.&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>&nbsp;compares the set value of air mass flow rate with the actual mass flow rate and controls the speed of&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. &nbsp;It also sets the air pressure.</div><div><br></div><div><br></div><div><b>Reference/Base packages</b></div><div><br></div><div><a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;</div><div><br></div><div><b><br></b></div><div><b>Further updates</b></div><div><b><br></b></div><div>Future expansions on the air subsystem will include options for humidification and temperature control.</div></body></html>"));
end SubSystemAir_wHumidifier;
