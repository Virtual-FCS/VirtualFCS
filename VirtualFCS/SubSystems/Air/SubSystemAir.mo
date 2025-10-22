within VirtualFCS.SubSystems.Air;

model SubSystemAir
  outer Modelica.Fluid.System system "System properties";
  replaceable package Medium = VirtualFCS.Media.CathodeAir;
  
  import Modelica.Constants.F;
  constant Modelica.Units.SI.MoleFraction xO2 = 0.21 "Standard molar fraction of oxygen in air";
  constant Modelica.Units.SI.MolarMass MM_air = Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM;

  parameter Real lambda = 3 "Air excess ratio";
  parameter Integer N_stack = 42 "FC stack number of cells";
  parameter Modelica.Units.SI.AbsolutePressure p_set = 200000 "Target cathodic pressure";

  Modelica.Fluid.Sources.FixedBoundary source(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Fluid.Interfaces.FluidPort_a fromStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_b toStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {20, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-20, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent(unit = "A") annotation(
    Placement(transformation(origin = {-116, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression setAirPressure(y = p_set) annotation(
    Placement(transformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFlowRate airInflow(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));
  VirtualFCS.Fluid.ThrottleValve throttleValve(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {0, -40}, extent = {{20, -20}, {-20, 20}})));
  Modelica.Fluid.Sensors.Pressure inletPressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {70, -10}, extent = {{10, 10}, {-10, -10}})));
  Modelica.Blocks.Continuous.LimPID PID(yMin = 0)  annotation(
    Placement(transformation(origin = {-30, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary exhaust(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {-70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain current_to_mass_flow(k = lambda*MM_air*N_stack/4/F/xO2)  annotation(
    Placement(transformation(origin = {-70, 70}, extent = {{-12, -12}, {12, 12}})));
  Fluid.SimpleCompressor simpleCompressor(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {20, 24}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(source.ports[1], airInflow.port_a) annotation(
    Line(points = {{-60, 40}, {-40, 40}}, color = {0, 170, 255}, thickness = 1));
  connect(inletPressure.p, throttleValve.Measured_inlet_Air_pressure) annotation(
    Line(points = {{59, -10}, {40.5, -10}, {40.5, -28}, {22, -28}}, color = {0, 0, 127}));
  connect(airInflow.m_flow, PID.u_m) annotation(
    Line(points = {{-30, 51}, {-30, 58}}, color = {0, 0, 127}));
  connect(current_to_mass_flow.u, stackCurrent) annotation(
    Line(points = {{-84, 70}, {-90, 70}, {-90, 0}, {-116, 0}}, color = {0, 0, 127}));
  connect(current_to_mass_flow.y, PID.u_s) annotation(
    Line(points = {{-57, 70}, {-42, 70}}, color = {0, 0, 127}));
  connect(setAirPressure.y, throttleValve.FC_pAirOut_P) annotation(
    Line(points = {{-18, -70}, {0, -70}, {0, -42}}, color = {0, 0, 127}));
  connect(throttleValve.upstream, fromStack) annotation(
    Line(points = {{20, -40}, {100, -40}}, color = {0, 127, 255}));
  connect(throttleValve.downstream, exhaust.ports[1]) annotation(
    Line(points = {{-20, -40}, {-60, -40}}, color = {0, 127, 255}));
  connect(inletPressure.port, toStack) annotation(
    Line(points = {{70, 0}, {100, 0}, {100, 32}}, color = {0, 127, 255}));
  connect(airInflow.port_b, simpleCompressor.port_a) annotation(
    Line(points = {{-20, 40}, {0, 40}}, color = {0, 127, 255}));
  connect(simpleCompressor.port_b, toStack) annotation(
    Line(points = {{40, 32}, {100, 32}}, color = {0, 127, 255}));
  connect(pin_n, simpleCompressor.pin_n) annotation(
    Line(points = {{-20, 100}, {-12, 100}, {-12, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(pin_p, simpleCompressor.pin_p) annotation(
    Line(points = {{20, 100}, {-6, 100}, {-6, 30}, {0, 30}}, color = {0, 0, 255}));
  connect(PID.y, simpleCompressor.u) annotation(
    Line(points = {{-18, 70}, {20, 70}, {20, 38}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>An air sub-system template is provided in the example model SubSystemAir.&nbsp;<div><br></div><div><b>Description</b></div><div><br></div><div>The model consists of an <a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a> and <a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a> connected to a fixed boundary condition reflecting the ambient conditions.&nbsp;</div><div><br></div><div>The subsystem model contains 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the connection to the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>. The electrical ports interface with the low-voltage DC power-supply to power the BoP components (in this case, the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>). The control port provides an interface to the Fuel Cell Control Unit, which controls the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. A&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;is connected downstream from the Fuel Cell Stack to maintain the set pressure in the air line.&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>&nbsp;compares the set value of air mass flow rate with the actual mass flow rate and controls the speed of&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. &nbsp;It also sets the air pressure.</div><div><br></div><div><br></div><div><b>Reference/Base packages</b></div><div><br></div><div><a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;</div><div><br></div><div><b><br></b></div><div><b>Further updates</b></div><div><b><br></b></div><div>Future expansions on the air subsystem will include options for humidification and temperature control.</div></body></html>"));
end SubSystemAir;
