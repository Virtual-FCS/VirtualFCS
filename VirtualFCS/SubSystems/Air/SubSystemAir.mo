within VirtualFCS.SubSystems.Air;

model SubSystemAir
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Medium = Media.CathodeAir;

// Parameter definition
  parameter Modelica.Units.SI.Mass m_system_air = 61 "Air system mass";
  parameter Modelica.Units.SI.AbsolutePressure set_air_pressure = 2.4e5 "Set air pressure";
  parameter Integer N_cell = 180 "FC stack number of cells";
  Modelica.Units.SI.Power Power_Compressor_mez "The power consumed by the Compressor";
  Modelica.Units.SI.Power Power_Compressor_electrical "The power consumed by the Compressor";
  Modelica.Units.SI.Efficiency Rendement_compressor "Compressor efficiency";
  Real t "parameter to compute efficiency";
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Sources.FixedBoundary airSource(redeclare package Medium = Medium, nPorts = 2) annotation(
    Placement(transformation(origin = {-90.5, 21.5}, extent = {{8.5, -8.5}, {-8.5, 8.5}}, rotation = 180)));
  Modelica.Fluid.Interfaces.FluidPort_a fromStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {104, -47}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {62, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_b toStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {104, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 121}, extent = {{-20, -19}, {20, 19}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {30, 104}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {10, 104}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent annotation(
    Placement(visible = true, transformation(origin = {-116, 86}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Control components
  Modelica.Blocks.Sources.RealExpression setAirPressure(y = set_air_pressure) annotation(
    Placement(transformation(origin = {-34, -86}, extent = {{-10, -10}, {10, 10}})));
  // Machines
  // Sensors
  Modelica.Fluid.Sensors.MassFlowRate sen_Air_mflow(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-60, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature tempCompressorOut(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {51, 39}, extent = {{-7, -7}, {7, 7}})));
  // Valves
  Modelica.Fluid.Sensors.Pressure Inlet_air_pressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {42, -24}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Fluid.Sensors.Temperature tempCompressorIn(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-41, 45}, extent = {{-7, -7}, {7, 7}})));
  Fluid.ThrottleValve throttleValve(valveDownstream(dp_nominal(displayUnit = "Pa") = 1e4, m_flow_nominal = 0.5), redeclare package Medium = Medium)   annotation(
    Placement(transformation(origin = {6, -46}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Gain Current_to_mass_flow(k = 0.02897*3/(96485*4*0.21)*N_cell) annotation(
    Placement(transformation(origin = {-66, 76}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Continuous.LimPID mass_flow_to_rpm(Td = 1, initType = Modelica.Blocks.Types.Init.InitialOutput, k = compressor.rpm_nom, yMax = compressor.rpm_nom*1.5, yMin = 0) annotation(
    Placement(transformation(origin = {-29, 77}, extent = {{-11, -11}, {11, 11}})));
  replaceable Fluid.Compressor compressor(redeclare package Medium = Medium) constrainedby Fluid.CompressorInterface  annotation(choicesAllMatching = true,
    Placement(transformation(origin = {20, 22}, extent = {{-26, -26}, {26, 26}})));
  Modelica.Blocks.Math.Abs abs annotation(
    Placement(transformation(origin = {-92, 76}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Fluid.Sources.FixedBoundary airSink(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {-88.5, -46.5}, extent = {{8.5, -8.5}, {-8.5, 8.5}}, rotation = 180)));
equation
  Power_Compressor_mez = (sen_Air_mflow.m_flow*298.15*1004/(1*0.8))*(((toStack.p*0.00001)^0.28) - 1);
  Power_Compressor_electrical = pin_p.i*pin_p.v;
  t = max(Power_Compressor_electrical, 1);
  Rendement_compressor = (sen_Air_mflow.m_flow*298.15*1004/(0.9*t))*(((toStack.p*0.00001)^0.28) - 1);
//*** DEFINE CONNECTIONS ***//
  connect(airSource.ports[1], sen_Air_mflow.port_a) annotation(
    Line(points = {{-82, 21.5}, {-83.25, 21.5}, {-83.25, 22}, {-70, 22}}, color = {0, 170, 255}, thickness = 1));
  connect(Inlet_air_pressure.p, throttleValve.Measured_inlet_Air_pressure) annotation(
    Line(points = {{31, -24}, {-17, -24}, {-17, -34}}, color = {0, 0, 127}));
  connect(Current_to_mass_flow.y, mass_flow_to_rpm.u_s) annotation(
    Line(points = {{-53, 76}, {-47.5, 76}, {-47.5, 77}, {-42, 77}}, color = {0, 0, 127}));
  connect(sen_Air_mflow.m_flow, mass_flow_to_rpm.u_m) annotation(
    Line(points = {{-60, 33}, {-60, 58}, {-29, 58}, {-29, 64}}, color = {0, 0, 127}));
  connect(mass_flow_to_rpm.y, compressor.set_control) annotation(
    Line(points = {{-17, 77}, {-17, 38}, {-9, 38}}, color = {0, 0, 127}));
  connect(sen_Air_mflow.port_b, compressor.port_a) annotation(
    Line(points = {{-50, 22}, {-9, 22}}, color = {0, 127, 255}));
  connect(compressor.port_b, tempCompressorOut.port) annotation(
    Line(points = {{49, 22}, {53, 22}, {53, 32}, {51, 32}}, color = {0, 127, 255}));
  connect(compressor.port_a, tempCompressorIn.port) annotation(
    Line(points = {{-9, 22}, {-38.6, 22}, {-38.6, 38}, {-40.6, 38}}, color = {0, 127, 255}));
  connect(compressor.pin_n, pin_n) annotation(
    Line(points = {{16, 38}, {16, 67}, {10, 67}, {10, 104}}, color = {0, 0, 255}));
  connect(pin_p, compressor.pin_p) annotation(
    Line(points = {{30, 104}, {30, 68}, {25, 68}, {25, 38}}, color = {0, 0, 255}));
  connect(setAirPressure.y, throttleValve.FC_pAirOut_P) annotation(
    Line(points = {{-22, -86}, {6, -86}, {6, -48}}, color = {0, 0, 127}));
  connect(stackCurrent, abs.u) annotation(
    Line(points = {{-116, 86}, {-100, 86}, {-100, 76}}, color = {0, 0, 127}));
  connect(abs.y, Current_to_mass_flow.u) annotation(
    Line(points = {{-86, 76}, {-80, 76}}, color = {0, 0, 127}));
  connect(throttleValve.downstream, fromStack) annotation(
    Line(points = {{26, -46}, {104, -46}}, color = {0, 127, 255}));
  connect(throttleValve.upstream, airSink.ports[1]) annotation(
    Line(points = {{-14, -46}, {-14, -46.5}, {-80, -46.5}}, color = {0, 127, 255}));
  connect(Inlet_air_pressure.port, throttleValve.downstream) annotation(
    Line(points = {{42, -34}, {42, -46}, {26, -46}}, color = {0, 127, 255}));
  connect(toStack, compressor.port_b) annotation(
    Line(points = {{104, 22}, {48, 22}}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>An air sub-system template is provided in the example model SubSystemAir.&nbsp;<div><br></div><div><b>Description</b></div><div><br></div><div>The model consists of an <a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a> and <a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a> connected to a fixed boundary condition reflecting the ambient conditions.&nbsp;</div><div><br></div><div>The subsystem model contains 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the connection to the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>. The electrical ports interface with the low-voltage DC power-supply to power the BoP components (in this case, the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>). The control port provides an interface to the Fuel Cell Control Unit, which controls the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. A&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;is connected downstream from the Fuel Cell Stack to maintain the set pressure in the air line.&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>&nbsp;compares the set value of air mass flow rate with the actual mass flow rate and controls the speed of&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. &nbsp;It also sets the air pressure.</div><div><br></div><div><br></div><div><b>Reference/Base packages</b></div><div><br></div><div><a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;</div><div><br></div><div><b><br></b></div><div><b>Further updates</b></div><div><b><br></b></div><div>Future expansions on the air subsystem will include options for humidification and temperature control.</div></body></html>"));
end SubSystemAir;
