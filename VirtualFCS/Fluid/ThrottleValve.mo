within VirtualFCS.Fluid;
model ThrottleValve
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Air.MoistAir;

//*** INSTANTIATE COMPONENTS ***//
  // Interfaces
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium)  
    annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium)  
    annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Valves
  Modelica.Fluid.Valves.ValveCompressible valveDownstream(
    redeclare package Medium = Medium, 
    dp_nominal(displayUnit = "Pa") = 10000, 
    m_flow_nominal = 0.01, opening(start = 0), 
    p_nominal = 5 * 101325) 
    annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
    // Other
  Modelica.Blocks.Sources.Constant constant3(
    k = 1) 
    annotation(
    Placement(visible = true, transformation(origin = {49.5, 72.5}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 180)));
  
  Modelica.Blocks.Continuous.LimPID pid(
    k = 1e-3, 
    limitsAtInit = true, 
    yMax = 1, 
    yMin = 0, 
    y_start = 0.99) 
    annotation(
    Placement(visible = true, transformation(origin = {-30, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Fluid.Sensors.Pressure pressureGageDownstream(
    redeclare package Medium = Medium) 
    annotation(
    Placement(visible = true, transformation(origin = {-24, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Math.Add add(
    k1 = -1) 
    annotation(
    Placement(visible = true, transformation(origin = {0, 36}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput FC_pAirOut_P annotation(
    Placement(visible = true, transformation(origin = {-81, 69}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {0, -14}, extent = {{-13, -13}, {13, 13}}, rotation = 90)));
  outer Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-80, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(add.y, valveDownstream.opening) annotation(
    Line(points = {{0, 26}, {0, 26}, {0, 8}, {0, 8}}, color = {0, 0, 127}));
  connect(pid.y, add.u1) annotation(
    Line(points = {{-18, 70}, {-6, 70}, {-6, 48}, {-6, 48}}, color = {0, 0, 127}));
  connect(constant3.y, add.u2) annotation(
    Line(points = {{41, 72.5}, {6, 72.5}, {6, 48}}, color = {0, 0, 127}));
  connect(pressureGageDownstream.port, valveDownstream.port_a) annotation(
    Line(points = {{-24, 10}, {-10, 10}, {-10, 0}, {-10, 0}}, color = {0, 127, 255}));
  connect(port_a, valveDownstream.port_a) annotation(
    Line(points = {{-100, 0}, {-10, 0}, {-10, 0}, {-10, 0}}));
  connect(valveDownstream.port_b, port_b) annotation(
    Line(points = {{10, 0}, {100, 0}, {100, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(pid.u_m, pressureGageDownstream.p) annotation(
    Line(points = {{-30, 58}, {-48, 58}, {-48, 20}, {-34, 20}, {-34, 20}}, color = {0, 0, 127}));
  connect(FC_pAirOut_P, pid.u_s) annotation(
    Line(points = {{-80, 70}, {-42, 70}, {-42, 70}, {-42, 70}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Polygon(origin = {-50, 0}, fillColor = {211, 211, 211}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-50, 60}, {-50, -60}, {50, 0}, {-50, 60}, {-50, 60}}), Polygon(origin = {50, 0}, rotation = 180, fillColor = {211, 211, 211}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-50, 60}, {-50, -60}, {50, 0}, {-50, 60}, {-50, 60}})}, coordinateSystem(initialScale = 0.1)));
end ThrottleValve;
