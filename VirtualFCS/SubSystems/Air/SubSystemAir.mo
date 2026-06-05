within VirtualFCS.SubSystems.Air;

model SubSystemAir "Ssubsystem regulating pressure and flowrate of air to a fuel cell stack"
  outer Modelica.Fluid.System system "System properties";
  replaceable package Medium = Media.CathodeAir;
  import Modelica.Constants.F;
  constant Modelica.Units.SI.MoleFraction xO2 = 0.21 "Standard molar fraction of oxygen in air";
  constant Modelica.Units.SI.MolarMass MM_O2 = Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM "(kg O2 / mol O2) Molar mass molecular oxygen";
  constant Integer n_O2 = 4 "Exchanged electrons per oxygen molecule";
  parameter Integer N_cells = 42 "Number of cells in the stack";
  parameter Real lambda = 3 "Air excess ratio";
  parameter Modelica.Units.SI.AbsolutePressure p_set = 200000 "Target cathodic pressure";
  Modelica.Fluid.Sources.FixedBoundary environment(redeclare package Medium = Medium, nPorts = 2, p = system.p_ambient, T = system.T_ambient) annotation(
    Placement(transformation(origin = {-90, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Fluid.Interfaces.FluidPort_a fromStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_b toStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-20, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent(unit = "A") annotation(
    Placement(transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFlowRate airInflow(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-50, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Pressure pressureSensor(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {30, -60}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Gain current_to_mass_flow(k = N_cells*lambda*MM_O2/n_O2/F/xO2) annotation(
    Placement(transformation(origin = {-80, 70}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Fluid.Valves.ValveCompressible valve(redeclare package Medium = Medium, dp_nominal(displayUnit = "bar") = 1.5e5, m_flow_nominal = 0.3, opening(start = 0), p_nominal = 2.5e5) annotation(
    Placement(transformation(origin = {-30, -80}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  replaceable Fluid.Compressor compressor(redeclare package Medium = Medium, RPM_nom = motor.wNominal) annotation(
    Placement(transformation(origin = {40, 8}, extent = {{-20, 20}, {20, -20}})));
  replaceable Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet motor(IaNominal = 30, Jr = 0.15, Js = 0.29, La(displayUnit = "mH") = 0.0015, Ra(displayUnit = "mOhm") = 0.05, TaNominal = 293.15, TaOperational = 293.15, TaRef = 293.15, VaNominal = 100, wMechanical(displayUnit = "rpm"), wNominal(displayUnit = "rpm") = 125.66370614359174, alpha20a = 0) annotation(
    Placement(transformation(origin = {-10, 8}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.IdealDcDc converter(Td(displayUnit = "ms") = 0.001, Ti(displayUnit = "ms") = 0.001) annotation(
    Placement(transformation(origin = {-10, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID_compressor(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = 2e3, Ti = 0.1, yMax = 300, yMin = 0) annotation(
    Placement(transformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID_valve(controllerType = Modelica.Blocks.Types.SimpleController.PI, yMax = 1, yMin = 0, k = -1e-4, Ti = 2) annotation(
    Placement(transformation(origin = {10, -30}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant pressure_set_point(k = p_set) annotation(
    Placement(transformation(origin = {50, -30}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(valve.port_a, fromStack) annotation(
    Line(points = {{-20, -80}, {100, -80}}, color = {0, 127, 255}));
  connect(stackCurrent, current_to_mass_flow.u) annotation(
    Line(points = {{-110, 70}, {-92, 70}}, color = {0, 0, 127}));
  connect(converter.pin_pMot, motor.pin_ap) annotation(
    Line(points = {{0, 60}, {0, 40}, {-4, 40}, {-4, 18}}, color = {255, 0, 0}));
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
    Line(points = {{-20, 60}, {-20, 40}, {-16, 40}, {-16, 18}}));
  connect(valve.opening, PID_valve.y) annotation(
    Line(points = {{-30, -72}, {-30, -30}, {-1, -30}}, color = {0, 0, 127}));
  connect(pressureSensor.p, PID_valve.u_m) annotation(
    Line(points = {{19, -60}, {10, -60}, {10, -42}}, color = {0, 0, 127}));
  connect(PID_compressor.y, converter.vRef) annotation(
    Line(points = {{-38, 70}, {-22, 70}}, color = {0, 0, 127}));
  connect(motor.flange, compressor.flange_a) annotation(
    Line(points = {{0, 8}, {20, 8}}));
  connect(airInflow.port_b, compressor.port_a) annotation(
    Line(points = {{-40, -10}, {10, -10}, {10, 0}, {20, 0}}, color = {0, 127, 255}));
  connect(compressor.port_b, toStack) annotation(
    Line(points = {{60, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(valve.port_a, pressureSensor.port) annotation(
    Line(points = {{-20, -80}, {30, -80}, {30, -70}}, color = {0, 127, 255}));
  connect(pressure_set_point.y, PID_valve.u_s) annotation(
    Line(points = {{39, -30}, {22, -30}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>This is an example of an air subsystem. Several components can be replaced, but it should be considered more of an inspiration rather than a parent class for any such subsystem, given the large number of possible topologies.<div><br></div><div>The model's core components are a compressor to provide air to the stack, and a valve to regulate the stack's pressure. The compressor is driven by a DC electric motor, whose feed voltage is given by a converter fed by an external voltage source.</div><h3>Control layout</h3><div>The converter is controlled by a PI controller that controls the mass flow through the compressor by manipulating the converter's motor-side voltage. Another PI controller controls stack temperature manipulating the opening of the output valve.</div><div>This is therefore a decoupled layout, with some interaction between the loops since the compressor influences the stack pressure and the valve opening influences the mass flow.</div><h3>Numerical issues</h3><div>Please note that appropriate controllers tuning is necessary for both convergence and performance of the subsystem. The exact tuning values will depend on what kind of stack is connected to the subsystem, in particular its manifold volume and nominal reaction rate.</div><div>Just because the controllers work with one case study is no guarantee they will work, or even converge, in the entire gamut of physically possible conditions.</div><div><br></div></body></html>"));
end SubSystemAir;
