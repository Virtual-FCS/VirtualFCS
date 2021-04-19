within VirtualFCS.Fluid;
block PressureRegulator

//*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2;
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces
  Modelica.Fluid.Interfaces.FluidPort_a Input(
    redeclare package Medium = Medium) 
    annotation(
    Placement(visible = true, transformation(origin = {-84, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 
  Modelica.Fluid.Interfaces.FluidPort_b Output(
    redeclare package Medium = Medium) 
    annotation(
    Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Valves
  Modelica.Fluid.Valves.ValveCompressible valveCompressible(
    redeclare package Medium = Medium,
    checkValve = true, 
    dp_nominal(displayUnit = "Pa") = 10000, 
    m_flow_nominal = 0.01, 
    p_nominal = 5 * 101325) 
    annotation(
      Placement(visible = true, transformation(origin = {-35, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
   // Other
  Modelica.Blocks.Interfaces.RealInput setDownstreamPressure 
    annotation(
      Placement(visible = true, transformation(origin = {43, -44}, extent = {{13, -13}, {-13, 13}}, rotation = 0), iconTransformation(origin = {41, 74}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));
   
  Modelica.Fluid.Sensors.Pressure pressure_sensor(
    redeclare package Medium = Medium) 
    annotation(
      Placement(visible = true, transformation(origin = {14, -10}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
   
  Modelica.Blocks.Continuous.LimPID pid(
    Td = 1e-3, 
    k = 1e-6, 
    limitsAtInit = true, 
    yMax = 1, 
    yMin = 0)  
    annotation(
      Placement(visible = true, transformation(origin = {-10, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
//*** DEFINE CONNECTIONS ***//
  connect(valveCompressible.port_b, Output) annotation(
    Line(points = {{-25, 0}, {54, 0}}, color = {0, 127, 255}));
 connect(pressure_sensor.port, valveCompressible.port_b) annotation(
    Line(points = {{14, 0}, {-25, 0}}, color = {0, 127, 255}));
 connect(Input, valveCompressible.port_a) annotation(
    Line(points = {{-84, 0}, {-45, 0}}));
 connect(setDownstreamPressure, pid.u_s) annotation(
    Line(points = {{43, -44}, {2, -44}}, color = {0, 0, 127}));
 connect(pid.u_m, pressure_sensor.p) annotation(
    Line(points = {{-10, -32}, {-10, -10}, {3, -10}}, color = {0, 0, 127}));
 connect(pid.y, valveCompressible.opening) annotation(
    Line(points = {{-21, -44}, {-35, -44}, {-35, -8}}, color = {0, 0, 127}));  protected
 annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Polygon(origin = {-50, 0}, points = {{-10, 40}, {-10, -40}, {50, 0}, {-10, 40}}), Polygon(origin = {50, 0}, points = {{10, 40}, {10, -40}, {-50, 0}, {10, 40}}), Line(origin = {0, 30}, points = {{0, -30}, {0, 30}}), Line(origin = {-80, 0}, points = {{-20, 0}, {20, 0}, {20, 0}}), Line(origin = {80, 0}, points = {{20, 0}, {-20, 0}}), Line(origin = {40, 29}, points = {{-40, 31}, {40, 31}, {40, -31}})}, coordinateSystem(initialScale = 0.1)));
end PressureRegulator;
