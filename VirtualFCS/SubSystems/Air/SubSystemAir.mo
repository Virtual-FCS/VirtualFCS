within VirtualFCS.SubSystems.Air;

model SubSystemAir
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Medium = Modelica.Media.Air.MoistAir(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  // Parameter definition
  parameter Modelica.Units.SI.Mass m_system_air = 61 "Air system mass";
  parameter Real N_FC_stack(unit = "1") = 180 "FC stack number of cells"; 
  Real Power_Compressor_mez(unit = "W") "The power consumed by the Compressor"; 
  Real Power_Compressor_electrical (unit = "W") "The power consumed by the Compressor"; 
  Real Rendement_compressor  "Compressor efficiency"; 
  Real t  "parameter to cimpute efficiency"; 
//*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Sources.FixedBoundary airSink(redeclare package Medium = Medium, nPorts = 2) annotation(
    Placement(visible = true, transformation(origin = {-80.5, -50.5}, extent = {{8.5, -8.5}, {-8.5, 8.5}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {88, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {88, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 121}, extent = {{-20, -19}, {20, 19}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {30, 48}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-4, 48}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput control annotation(
    Placement(visible = true, transformation(origin = {-116, 86}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Control components
  Modelica.Blocks.Routing.Multiplex2 multiplexSensors(n1 = 1, n2 = 1) annotation(
    Placement(visible = true, transformation(origin = {58, -60}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Routing.DeMultiplex2 deMultiplexControl annotation(
    Placement(visible = true, transformation(origin = {-6, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setAirPressure(y = deMultiplexControl.y1[1]) annotation(
    Placement(visible = true, transformation(origin = {-36, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setCompressorSpeed(y = deMultiplexControl.y2[1]) annotation(
    Placement(visible = true, transformation(origin = {-38, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Air.SubSystemAirControl subSystemAirControl(N_FC_stack = N_FC_stack)  annotation(
    Placement(visible = true, transformation(origin = {-45, 79}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  // Machines
  VirtualFCS.Fluid.Compressor compressor annotation(
    Placement(visible = true, transformation(origin = {12, 18}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  // Sensors
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation(
    Placement(visible = true, transformation(origin = {80, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.MassFlowRate sen_Air_mflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-46, 18}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature compressorOutletSensor(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {55, 35}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  // Valves
  VirtualFCS.Fluid.ThrottleValve throttleValve(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {21, -35}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Modelica.Fluid.Sensors.Pressure Inlet_air_pressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {74, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
Power_Compressor_mez = (sen_Air_mflow.m_flow*298.15*1004/(1*0.8))*(((Output.p*0.00001)^0.28)-1);//Input.p*(();
//Power_Compressor_mez = (sen_Air_mflow.m_flow*298.15*1004/(0.9*0.7))*(((Output.p*0.00001)^0.28)-1);//Input.p*(();
 Power_Compressor_electrical = pin_p.i*pin_p.v;
  if Power_Compressor_electrical > 1 then
    t = Power_Compressor_electrical;
    else 
   t = 1; 
   end if;
  
  
  Rendement_compressor = (sen_Air_mflow.m_flow*298.15*1004/(0.9*t))*(((Output.p*0.00001)^0.28)-1);
//*** DEFINE CONNECTIONS ***//
  connect(pin_p, compressor.pin_p) annotation(
    Line(points = {{30, 48}, {15, 48}, {15, 28}}, color = {0, 0, 255}));
  connect(compressor.sen_Air_comp_speed, multiplexSensors.u2[1]) annotation(
    Line(points = {{12, 7}, {12, -8}, {52, -8}, {52, -50}, {53, -50}}, color = {0, 0, 127}));
  connect(airSink.ports[1], sen_Air_mflow.port_a) annotation(
    Line(points = {{-80.5, -42}, {-82, -42}, {-82, 18}, {-56, 18}}, color = {0, 170, 255}, thickness = 1));
  connect(sen_Air_mflow.port_b, compressor.Input) annotation(
    Line(points = {{-36, 18}, {-6, 18}}, color = {0, 170, 255}, thickness = 1));
  connect(compressor.Output, Output) annotation(
    Line(points = {{30, 18}, {88, 18}}, color = {0, 170, 255}, thickness = 1));
  connect(setCompressorSpeed.y, compressor.controlInterface) annotation(
    Line(points = {{-27, 46}, {-20, 46}, {-20, 28}, {-6, 28}}, color = {0, 0, 127}));
  connect(throttleValve.port_a, Input) annotation(
    Line(points = {{36, -35}, {88, -35}}, color = {0, 170, 255}, thickness = 1));
  connect(throttleValve.port_b, airSink.ports[2]) annotation(
    Line(points = {{6, -35}, {-82, -35}, {-82, -42}, {-80.5, -42}}, color = {0, 170, 255}, thickness = 1));
  connect(setAirPressure.y, throttleValve.FC_pAirOut_P) annotation(
    Line(points = {{-25, -94}, {21, -94}, {21, -37}}, color = {0, 0, 127}));
  connect(subSystemAirControl.controlInterface, deMultiplexControl.u) annotation(
    Line(points = {{-30, 80}, {-20, 80}, {-20, 78}, {-18, 78}}, color = {0, 0, 127}, thickness = 0.5));
  connect(pin_n, compressor.pin_n) annotation(
    Line(points = {{-4, 48}, {10, 48}, {10, 28}}, color = {0, 0, 255}));
  connect(sen_Air_mflow.m_flow, multiplexSensors.u1[1]) annotation(
    Line(points = {{-46, 7}, {-46, -15.5}, {-44, -15.5}, {-44, -16}, {64, -16}, {64, -50}, {63, -50}}, color = {0, 0, 127}));
  connect(multiplexSensors.y, sensors) annotation(
    Line(points = {{58, -69}, {58, -86}, {80, -86}}, color = {0, 0, 127}));
  connect(sensors, subSystemAirControl.sensorInterface) annotation(
    Line(points = {{80, -86}, {108, -86}, {108, -108}, {-108, -108}, {-108, 72}, {-62, 72}}, color = {0, 0, 127}, thickness = 0.5));
  connect(control, subSystemAirControl.signalInterfaceFC) annotation(
    Line(points = {{-116, 86}, {-62, 86}}, color = {0, 0, 127}));
  connect(compressorOutletSensor.port, compressor.Output) annotation(
    Line(points = {{56, 28}, {56, 18}, {30, 18}}));
  connect(compressor.Output, Inlet_air_pressure.port) annotation(
    Line(points = {{30, 18}, {40, 18}, {40, 48}, {74, 48}, {74, 60}}, color = {0, 127, 255}));
  connect(Inlet_air_pressure.p, throttleValve.Measured_inlet_Air_pressure) annotation(
    Line(points = {{64, 70}, {44, 70}, {44, -30}, {26, -30}}, color = {0, 0, 127}));
  connect(Inlet_air_pressure.p, throttleValve.Measured_inlet_Air_pressure) annotation(
    Line(points = {{64, 70}, {44, 70}, {44, -26}, {38, -26}}, color = {0, 0, 127}));
protected
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {23, -3}, extent = {{-7, 3}, {29, -3}}, textString = "Air compressor speed")}),
    Documentation(info = "<html><head></head><body>An air sub-system template is provided in the example model SubSystemAir.&nbsp;<div><br></div><div><b>Description</b></div><div><br></div><div>The model consists of an <a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a> and <a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a> connected to a fixed boundary condition reflecting the ambient conditions.&nbsp;</div><div><br></div><div>The subsystem model contains 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the connection to the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>. The electrical ports interface with the low-voltage DC power-supply to power the BoP components (in this case, the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>). The control port provides an interface to the Fuel Cell Control Unit, which controls the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. A&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;is connected downstream from the Fuel Cell Stack to maintain the set pressure in the air line.&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>&nbsp;compares the set value of air mass flow rate with the actual mass flow rate and controls the speed of&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. &nbsp;It also sets the air pressure.</div><div><br></div><div><br></div><div><b>Reference/Base packages</b></div><div><br></div><div><a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;</div><div><br></div><div><b><br></b></div><div><b>Further updates</b></div><div><b><br></b></div><div>Future expansions on the air subsystem will include options for humidification and temperature control.</div></body></html>"));
end SubSystemAir;
