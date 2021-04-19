within VirtualFCS.SubSystems.Air;

class SubSystemAir
  // Other
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Air.MoistAir;
  //*** INSTANTIATE COMPONENTS ***//
  //System
  outer Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-74, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Boundaries and Interfaces
  Modelica.Fluid.Sources.FixedBoundary airSink(redeclare package Medium = Medium, nPorts = 2) annotation(
    Placement(visible = true, transformation(origin = {-80.5, -50.5}, extent = {{8.5, -8.5}, {-8.5, 8.5}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {88, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {88, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Machines
  VirtualFCS.Fluid.Compressor compressor annotation(
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
  VirtualFCS.Fluid.ThrottleValve throttleValve(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {15, -35}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  VirtualFCS.SubSystems.Air.SubSystemAirControl subSystemAirControl annotation(
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
    Icon(graphics = {Rectangle(fillColor = {197, 224, 180}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-44, 70}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {23, -3}, extent = {{-7, 3}, {29, -3}}, textString = "Air compressor speed")}),
    version = "");
end SubSystemAir;
