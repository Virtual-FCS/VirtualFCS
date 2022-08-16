class SubSystemAir
  // Other
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Air.MoistAir;
  
  parameter Real m_system_air(unit = "kg") = 61 "Air system mass";
  //*** INSTANTIATE COMPONENTS ***//
  //System
  outer Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-74, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Boundaries and Interfaces
  Modelica.Fluid.Sources.FixedBoundary airSink(redeclare package Medium = Medium, nPorts = 2) annotation(
    Placement(visible = true, transformation(origin = {-80.5, -50.5}, extent = {{8.5, -8.5}, {-8.5, 8.5}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {88, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {88, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 121}, extent = {{-20, -19}, {20, 19}}, rotation = 0)));
  // Machines
  Compressor compressor annotation(
    Placement(visible = true, transformation(origin = {12, 18}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Valves
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {30, 48}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-4, 48}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation(
    Placement(visible = true, transformation(origin = {80, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.MassFlowRate sen_Air_mflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-46, 18}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplexSensors(n1 = 1, n2 = 1) annotation(
    Placement(visible = true, transformation(origin = {58, -60}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Routing.DeMultiplex2 deMultiplexControl annotation(
    Placement(visible = true, transformation(origin = {-6, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setAirPressure(y = deMultiplexControl.y1[1]) annotation(
    Placement(visible = true, transformation(origin = {-36, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setCompressorSpeed(y = deMultiplexControl.y2[1]) annotation(
    Placement(visible = true, transformation(origin = {-38, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThrottleValve throttleValve(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {15, -35}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  SubSystemAirControl subSystemAirControl annotation(
    Placement(visible = true, transformation(origin = {-45, 79}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(pin_n, compressor.pin_n) annotation(
    Line(points = {{-4, 48}, {9, 48}, {9, 28}}, color = {0, 0, 255}));
  connect(pin_p, compressor.pin_p) annotation(
    Line(points = {{30, 48}, {15, 48}, {15, 28}}, color = {0, 0, 255}));
  connect(sen_Air_mflow.m_flow, multiplexSensors.u1[1]) annotation(
    Line(points = {{-46, 7}, {-46, -15.5}, {-44, -15.5}, {-44, -16}, {64, -16}, {64, -50}, {63, -50}}, color = {0, 0, 127}));
  connect(compressor.sen_Air_comp_speed, multiplexSensors.u2[1]) annotation(
    Line(points = {{12, 7}, {12, -8}, {52, -8}, {52, -50}, {53, -50}}, color = {0, 0, 127}));
  connect(multiplexSensors.y, sensors) annotation(
    Line(points = {{58, -69}, {58, -56}, {69, -56}, {69, -86}, {80, -86}}, color = {0, 0, 127}));
  connect(airSink.ports[1], sen_Air_mflow.port_a) annotation(
    Line(points = {{-80.5, -42}, {-82, -42}, {-82, 18}, {-56, 18}}, color = {0, 170, 0}, thickness = 1));
  connect(sen_Air_mflow.port_b, compressor.Input) annotation(
    Line(points = {{-36, 18}, {-6, 18}}, color = {0, 170, 0}, thickness = 1));
  connect(compressor.Output, Output) annotation(
    Line(points = {{30, 18}, {88, 18}}, color = {0, 170, 0}, thickness = 1));
  connect(setCompressorSpeed.y, compressor.controlInterface) annotation(
    Line(points = {{-27, 46}, {-20, 46}, {-20, 28}, {-6, 28}}, color = {0, 0, 127}));
  connect(throttleValve.port_a, Input) annotation(
    Line(points = {{30, -35}, {88, -35}}, color = {0, 170, 0}, thickness = 1));
  connect(throttleValve.port_b, airSink.ports[2]) annotation(
    Line(points = {{0, -35}, {-82, -35}, {-82, -42}, {-80.5, -42}}, color = {0, 170, 0}, thickness = 1));
  connect(setAirPressure.y, throttleValve.FC_pAirOut_P) annotation(
    Line(points = {{-25, -94}, {15, -94}, {15, -37}}, color = {0, 0, 127}));
  connect(subSystemAirControl.sensorInterface, sensors) annotation(
    Line(points = {{-62, 80}, {-110, 80}, {-110, -112}, {110, -112}, {110, -86}, {80, -86}, {80, -86}}, color = {0, 0, 127}, thickness = 0.5));
  connect(subSystemAirControl.controlInterface, deMultiplexControl.u) annotation(
    Line(points = {{-30, 80}, {-20, 80}, {-20, 78}, {-18, 78}}, color = {0, 0, 127}, thickness = 0.5));
protected
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(origin = { -8, 6}, extent = {{-92, 94}, {108, -106}}, imageSource = "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"), Text(origin = {-44, 70}, lineColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    uses(Modelica(version = "4.0.0")),
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {23, -3}, extent = {{-7, 3}, {29, -3}}, textString = "Air compressor speed")}),
    version = "",
  Documentation(info = "<html><head></head><body>An air sub-system template is provided in the example model SubSystemAir.&nbsp;<div><br></div><div><b>Description</b></div><div><br></div><div>The model consists of an <a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a> and <a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a> connected to a fixed boundary condition reflecting the ambient conditions.&nbsp;</div><div><br></div><div>The subsystem model contains 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the connection to the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>. The electrical ports interface with the low-voltage DC power-supply to power the BoP components (in this case, the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>). The control port provides an interface to the Fuel Cell Control Unit, which controls the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. A&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;is connected downstream from the Fuel Cell Stack to maintain the set pressure in the air line.&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>&nbsp;compares the set value of air mass flow rate with the actual mass flow rate and controls the speed of&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. &nbsp;It also sets the air pressure.</div><div><br></div><div><br></div><div><b>Reference/Base packages</b></div><div><br></div><div><a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;</div><div><br></div><div><b><br></b></div><div><b>Further updates</b></div><div><b><br></b></div><div>Future expansions on the air subsystem will include options for humidification and temperature control.</div></body></html>"));
end SubSystemAir;
