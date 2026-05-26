within VirtualFCS.SubSystems.Air;

model SubSystemAir
  outer Modelica.Fluid.System system "System properties";
  replaceable package Medium = Media.CathodeAir;

  import Modelica.Constants.F;

  constant Modelica.Units.SI.MoleFraction xO2 = 0.21 "Standard molar fraction of oxygen in air";
  constant Modelica.Units.SI.MolarMass MM_O2 = Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM "(kg O2 / mol O2) Molar mass molecular oxygen";
  constant Integer n_O2 = 4 "(mol é / mol O2)";

  parameter Integer N_cells = 42 "Number of cells in the stack";
  parameter Real lambda = 3 "Air excess ratio";
  parameter Modelica.Units.SI.AbsolutePressure p_set = 200000 "Target cathodic pressure";

  Modelica.Fluid.Sources.FixedBoundary environment(redeclare package Medium = Medium, nPorts = 2) annotation(
    Placement(transformation(origin = {-90, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Fluid.Interfaces.FluidPort_a fromStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_b toStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-20, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent(unit = "A") annotation(
    Placement(transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression setPressure(y = p_set) annotation(
    Placement(transformation(origin = {50, -30}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Fluid.Sensors.MassFlowRate airInflow(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-50, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Pressure inletPressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {66, -60}, extent = {{10, 10}, {-10, -10}})));
  Modelica.Blocks.Math.Gain current_to_mass_flow(k = N_cells*lambda*MM_O2/n_O2/F/xO2) annotation(
    Placement(transformation(origin = {-80, 70}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Fluid.Valves.ValveCompressible valve(redeclare package Medium = Medium, dp_nominal(displayUnit = "bar") = 1.5e5, m_flow_nominal = 0.3, opening(start = 0), p_nominal = 2.5e5) annotation(
    Placement(transformation(origin = {-30, -80}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  replaceable Fluid.Compressor compressor(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {40, 10}, extent = {{-20, 20}, {20, -20}})));
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet motor(IaNominal = 30, Jr = 0.15, Js = 0.29, La(displayUnit = "mH") = 0.0015, Ra = 0.05, TaNominal = 293.15, TaOperational = 293.15, TaRef = 293.15, VaNominal = 100, wMechanical(displayUnit = "rpm"), wNominal(displayUnit = "rpm") = 125.66370614359174, alpha20a = 0) annotation(
    Placement(transformation(origin = {-10, 10}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.IdealDcDc converter(Td(displayUnit = "ms") = 0.001, Ti(displayUnit = "us"))  annotation(
    Placement(transformation(origin = {-10, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID_compressor(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = 1e6, Ti = 2, yMax = 100, yMin = 0) annotation(
    Placement(transformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID_valve(controllerType = Modelica.Blocks.Types.SimpleController.PI, yMax = 1, yMin = 0, k = -1e-4, Ti = 10)  annotation(
    Placement(transformation(origin = {10, -30}, extent = {{10, -10}, {-10, 10}})));
equation
  connect(valve.port_a, fromStack) annotation(
    Line(points = {{-20, -80}, {100, -80}}, color = {0, 127, 255}));
  connect(stackCurrent, current_to_mass_flow.u) annotation(
    Line(points = {{-110, 70}, {-92, 70}}, color = {0, 0, 127}));
  connect(compressor.port_b, toStack) annotation(
    Line(points = {{60, 2}, {100, 2}}, color = {0, 127, 255}));
  connect(compressor.port_a, airInflow.port_b) annotation(
    Line(points = {{20, -10}, {-40, -10}}, color = {0, 127, 255}));
  connect(motor.flange, compressor.flange) annotation(
    Line(points = {{0, 10}, {20, 10}}));
  connect(converter.pin_pMot, motor.pin_ap) annotation(
    Line(points = {{0, 60}, {0, 40}, {-4, 40}, {-4, 20}}, color = {255, 0, 0}));
  connect(pin_p, converter.pin_pBat) annotation(
    Line(points = {{0, 100}, {0, 80}}, color = {255, 0, 0}));
  connect(pin_n, converter.pin_nBat) annotation(
    Line(points = {{-20, 100}, {-20, 80}}));
  connect(environment.ports[1], airInflow.port_a) annotation(
    Line(points = {{-80, -30}, {-74, -30}, {-74, -10}, {-60, -10}}, color = {0, 127, 255}));
  connect(environment.ports[2], valve.port_b) annotation(
    Line(points = {{-80, -30}, {-74, -30}, {-74, -80}, {-40, -80}}, color = {0, 127, 255}));
  connect(current_to_mass_flow.y, PID_compressor.u_s) annotation(
    Line(points = {{-69, 70}, {-62, 70}}, color = {0, 0, 127}));
  connect(airInflow.m_flow, PID_compressor.u_m) annotation(
    Line(points = {{-50, 1}, {-50, 58}}, color = {0, 0, 127}));
  connect(converter.pin_nMot, motor.pin_an) annotation(
    Line(points = {{-20, 60}, {-20, 40}, {-16, 40}, {-16, 20}}));
  connect(inletPressure.port, compressor.port_b) annotation(
    Line(points = {{66, -50}, {66, 2}, {60, 2}}, color = {0, 127, 255}));
  connect(valve.opening, PID_valve.y) annotation(
    Line(points = {{-30, -72}, {-30, -30}, {-1, -30}}, color = {0, 0, 127}));
  connect(inletPressure.p, PID_valve.u_m) annotation(
    Line(points = {{55, -60}, {10, -60}, {10, -42}}, color = {0, 0, 127}));
  connect(setPressure.y, PID_valve.u_s) annotation(
    Line(points = {{39, -30}, {22, -30}}, color = {0, 0, 127}));
  connect(PID_compressor.y, converter.vRef) annotation(
    Line(points = {{-38, 70}, {-22, 70}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>An air sub-system template is provided in the example model SubSystemAir.&nbsp;<div><br></div><div><b>Description</b></div><div><br></div><div>The model consists of an <a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a> and <a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a> connected to a fixed boundary condition reflecting the ambient conditions.&nbsp;</div><div><br></div><div>The subsystem model contains 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the connection to the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>. The electrical ports interface with the low-voltage DC power-supply to power the BoP components (in this case, the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>). The control port provides an interface to the Fuel Cell Control Unit, which controls the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. A&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;is connected downstream from the Fuel Cell Stack to maintain the set pressure in the air line.&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>&nbsp;compares the set value of air mass flow rate with the actual mass flow rate and controls the speed of&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. &nbsp;It also sets the air pressure.</div><div><br></div><div><br></div><div><b>Reference/Base packages</b></div><div><br></div><div><a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;</div><div><br></div><div><b><br></b></div><div><b>Further updates</b></div><div><b><br></b></div><div>Future expansions on the air subsystem will include options for humidification and temperature control.</div></body></html>"));
end SubSystemAir;
