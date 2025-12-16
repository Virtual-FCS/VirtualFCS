within VirtualFCS.SubSystems.Air;

model SubSystemAir_2
  outer Modelica.Fluid.System system "System properties";
  replaceable package Medium = Media.CathodeAir;
  import Modelica.Constants.F;
  constant Modelica.Units.SI.MoleFraction xO2 = 0.21 "Standard molar fraction of oxygen in air";
  constant Modelica.Units.SI.MolarMass MM_air = Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM;
  parameter Real lambda = 3 "Air excess ratio";
  parameter Integer N_cell = 42 "FC stack number of cells";
  parameter Modelica.Units.SI.AbsolutePressure p_set = 200000 "Target cathodic pressure";
  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {-78, 24}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Fluid.Interfaces.FluidPort_a fromStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_b toStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, 24}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {28, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {16, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent(unit = "A") annotation(
    Placement(transformation(origin = {-110, 72}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression setPressure(y = p_set) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Fluid.Sensors.MassFlowRate airInflow(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-50, 24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Pressure inletPressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {80, -20}, extent = {{10, 10}, {-10, -10}})));
  Modelica.Fluid.Sources.FixedBoundary exhaust(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {-70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain current_to_mass_flow(k = lambda*MM_air*N_cell/4/F/xO2) annotation(
    Placement(transformation(origin = {-70, 72}, extent = {{-12, -12}, {12, 12}})));
  replaceable Fluid.SimpleCompressor compressor(redeclare package Medium = Medium) constrainedby Fluid.CompressorInterface annotation(choicesAllMatching = true,
     Placement(transformation(origin = {20, 24}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Add error_flow(k2 = -1) annotation(
    Placement(transformation(origin = {-36, 70}, extent = {{-4, -4}, {4, 4}})));
  replaceable Modelica.Blocks.Continuous.PI PI_compressor(k = 1e6, T = 2) annotation(
    Placement(transformation(origin = {-12, 70}, extent = {{-10, -10}, {10, 10}})))constrainedby Modelica.Blocks.Interfaces.SISO annotation(
     Placement(transformation(origin = {10, 70}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Fluid.Valves.ValveCompressible outletValve(redeclare package Medium = Medium, dp_nominal(displayUnit = "bar") = 1.5e5, m_flow_nominal = 0.1, opening(start = 0), p_nominal = 2.5e5) annotation(
    Placement(transformation(origin = {-30, -40}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  Modelica.Blocks.Math.Add error_pressure(k2 = -1) annotation(
    Placement(transformation(origin = {54, -10}, extent = {{6, -6}, {-6, 6}})));
  replaceable Modelica.Blocks.Continuous.PI PI_valve(T = 10, k = -1e-4) constrainedby Modelica.Blocks.Interfaces.SISO annotation(
     Placement(transformation(origin = {30, -10}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Nonlinear.Limiter valveInputLimiter(uMax = 1, uMin = 0) annotation(
    Placement(transformation(origin = {0, -10}, extent = {{4, -4}, {-4, 4}}, rotation = -0)));
equation
  connect(source.ports[1], airInflow.port_a) annotation(
    Line(points = {{-68, 24}, {-60, 24}}, color = {0, 170, 255}));
  connect(inletPressure.port, toStack) annotation(
    Line(points = {{80, -10}, {80, -12}, {100, -12}, {100, 24}}, color = {0, 127, 255}));
  connect(current_to_mass_flow.y, error_flow.u1) annotation(
    Line(points = {{-57, 72}, {-41, 72}}, color = {0, 0, 127}));
  connect(error_flow.y, PI_compressor.u) annotation(
    Line(points = {{-32, 70}, {-24, 70}}, color = {0, 0, 127}));
  connect(outletValve.port_b, exhaust.ports[1]) annotation(
    Line(points = {{-40, -40}, {-60, -40}}, color = {0, 127, 255}));
  connect(outletValve.port_a, fromStack) annotation(
    Line(points = {{-20, -40}, {100, -40}}, color = {0, 127, 255}));
  connect(PI_valve.u, error_pressure.y) annotation(
    Line(points = {{42, -10}, {47, -10}}, color = {0, 0, 127}));
  connect(inletPressure.p, error_pressure.u2) annotation(
    Line(points = {{69, -20}, {66, -20}, {66, -14}, {62, -14}}, color = {0, 0, 127}));
  connect(setPressure.y, error_pressure.u1) annotation(
    Line(points = {{70, 0}, {66, 0}, {66, -6}, {62, -6}}, color = {0, 0, 127}));
  connect(airInflow.m_flow, error_flow.u2) annotation(
    Line(points = {{-50, 35}, {-50, 68}, {-41, 68}}, color = {0, 0, 127}));
  connect(stackCurrent, current_to_mass_flow.u) annotation(
    Line(points = {{-110, 72}, {-84, 72}}, color = {0, 0, 127}));
  connect(PI_valve.y, valveInputLimiter.u) annotation(
    Line(points = {{19, -10}, {4, -10}}, color = {0, 0, 127}));
  connect(valveInputLimiter.y, outletValve.opening) annotation(
    Line(points = {{-4, -10}, {-30, -10}, {-30, -32}}, color = {0, 0, 127}));
  connect(PI_compressor.y, compressor.set_control) annotation(
    Line(points = {{0, 70}, {2, 70}, {2, 44}, {-2, 44}, {-2, 36}}, color = {0, 0, 127}));
  connect(airInflow.port_b, compressor.port_a) annotation(
    Line(points = {{-40, 24}, {-2, 24}}, color = {0, 127, 255}));
  connect(compressor.port_b, toStack) annotation(
    Line(points = {{42, 24}, {100, 24}}, color = {0, 127, 255}));
  connect(compressor.pin_p, pin_p) annotation(
    Line(points = {{24, 36}, {26, 36}, {26, 98}, {28, 98}, {28, 100}}, color = {0, 0, 255}));
  connect(compressor.pin_n, pin_n) annotation(
    Line(points = {{18, 36}, {18, 67}, {16, 67}, {16, 100}}, color = {0, 0, 255}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>An air sub-system template is provided in the example model SubSystemAir.&nbsp;<div><br></div><div><b>Description</b></div><div><br></div><div>The model consists of an <a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a> and <a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a> connected to a fixed boundary condition reflecting the ambient conditions.&nbsp;</div><div><br></div><div>The subsystem model contains 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the connection to the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>. The electrical ports interface with the low-voltage DC power-supply to power the BoP components (in this case, the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>). The control port provides an interface to the Fuel Cell Control Unit, which controls the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. A&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;is connected downstream from the Fuel Cell Stack to maintain the set pressure in the air line.&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>&nbsp;compares the set value of air mass flow rate with the actual mass flow rate and controls the speed of&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. &nbsp;It also sets the air pressure.</div><div><br></div><div><br></div><div><b>Reference/Base packages</b></div><div><br></div><div><a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;</div><div><br></div><div><b><br></b></div><div><b>Further updates</b></div><div><b><br></b></div><div>Future expansions on the air subsystem will include options for humidification and temperature control.</div></body></html>"));
end SubSystemAir_2;
