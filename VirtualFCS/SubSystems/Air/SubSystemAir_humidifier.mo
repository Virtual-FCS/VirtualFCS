within VirtualFCS.SubSystems.Air;

model SubSystemAir_humidifier "Subsystem regulating pressure and flowrate of air to a fuel cell stack, with humidification"
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
    Placement(transformation(origin = {100, -68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_b toStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, -92}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-40, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent(unit = "A") annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Pressure pressureSensor(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {97, -37}, extent = {{7, -7}, {-7, 7}})));
  Modelica.Blocks.Math.Gain current_to_mass_flow(k = N_cells*lambda*MM_O2/n_O2/F/xO2) annotation(
    Placement(transformation(origin = {-80, 60}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Fluid.Valves.ValveCompressible valve(redeclare package Medium = Medium, dp_nominal(displayUnit = "bar") = 1.5e5, m_flow_nominal = 0.3, opening(start = 0), p_nominal = 2.5e5) annotation(
    Placement(transformation(origin = {-50, -68}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  Modelica.Blocks.Continuous.LimPID PID_valve(controllerType = Modelica.Blocks.Types.SimpleController.PI, yMax = 1, yMin = 0, k = -1e-4, Ti = 2) annotation(
    Placement(transformation(origin = {-30, -30}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant pressure_set_point(k = p_set) annotation(
    Placement(transformation(origin = {10, -30}, extent = {{10, -10}, {-10, 10}})));
  Fluid.RelativeHumiditySensor phi_to_stack annotation(
    Placement(transformation(origin = {13, -89}, extent = {{-7, -7}, {7, 7}})));
  replaceable Fluid.ElectricCompressor compressor(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-1, 47}, extent = {{-29, -29}, {29, 29}}))) constrainedby Fluid.ElectricCompressorInterface;
  Fluid.HumidifierV3 humidifierV3(redeclare package dry_medium = Medium, redeclare package wet_medium = Medium, UA = 0.4, n = 2, nFibers = 1000, m_flow_nom = 0.1, L_fiber = 0.3, dHousing (displayUnit = "mm")= 0.14, V_wet = 0.001, V_dry = 0.003, dFiber_i(displayUnit = "mm"), dFiber_o(displayUnit = "mm") = 0.0011, dp_nominal = 1500)  annotation(
    Placement(transformation(origin = {48, -68}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  VirtualFCS.Fluid.RelativeHumiditySensor phi_from_stack annotation(
    Placement(transformation(origin = {71, -49}, extent = {{-7, -7}, {7, 7}})));
  VirtualFCS.Fluid.RelativeHumiditySensor phi_from_compr annotation(
    Placement(transformation(origin = {35, -19}, extent = {{-7, -7}, {7, 7}})));
  VirtualFCS.Fluid.RelativeHumiditySensor phi_to_valve annotation(
    Placement(transformation(origin = {17, -55}, extent = {{-7, -7}, {7, 7}})));
equation
  connect(stackCurrent, current_to_mass_flow.u) annotation(
    Line(points = {{-110, 60}, {-92, 60}}, color = {0, 0, 127}));
  connect(environment.ports[1], valve.port_b) annotation(
    Line(points = {{-80, -30}, {-74, -30}, {-74, -68}, {-60, -68}}, color = {0, 127, 255}));
  connect(valve.opening, PID_valve.y) annotation(
    Line(points = {{-50, -60}, {-50, -30}, {-41, -30}}, color = {0, 0, 127}));
  connect(pressure_set_point.y, PID_valve.u_s) annotation(
    Line(points = {{-1, -30}, {-18, -30}}, color = {0, 0, 127}));
  connect(pressureSensor.port, fromStack) annotation(
    Line(points = {{97, -44}, {97, -65}, {100, -65}, {100, -68}}, color = {0, 127, 255}, thickness = 0.75));
  connect(environment.ports[2], compressor.port_a) annotation(
    Line(points = {{-80, -30}, {-68, -30}, {-68, 20}, {-10, 20}, {-10, 59}, {-7, 59}}, color = {0, 127, 255}));
  connect(compressor.pin_p, pin_p) annotation(
    Line(points = {{-15, 76}, {0, 76}, {0, 100}}, color = {0, 0, 255}));
  connect(compressor.pin_n, pin_n) annotation(
    Line(points = {{-27, 76}, {-40, 76}, {-40, 100}}, color = {0, 0, 255}));
  connect(current_to_mass_flow.y, compressor.set_mass_flow) annotation(
    Line(points = {{-68, 60}, {-36, 60}, {-36, 62}}, color = {0, 0, 127}));
  connect(pressureSensor.p, PID_valve.u_m) annotation(
    Line(points = {{90, -36}, {26, -36}, {26, -50}, {-30, -50}, {-30, -42}}, color = {0, 0, 127}));
  connect(compressor.port_b, humidifierV3.portB_in) annotation(
    Line(points = {{28, 48}, {48, 48}, {48, -48}}, color = {0, 127, 255}));
  connect(humidifierV3.portB_out, toStack) annotation(
    Line(points = {{48, -88}, {48, -92}, {100, -92}}, color = {0, 127, 255}));
  connect(humidifierV3.portA_in, fromStack) annotation(
    Line(points = {{60, -68}, {100, -68}}, color = {0, 127, 255}));
  connect(humidifierV3.portA_out, valve.port_a) annotation(
    Line(points = {{36, -68}, {-40, -68}}, color = {0, 127, 255}));
  connect(phi_to_stack.port, humidifierV3.portB_out) annotation(
    Line(points = {{14, -96}, {48, -96}, {48, -88}}, color = {0, 127, 255}));
  connect(humidifierV3.portA_in, phi_from_stack.port) annotation(
    Line(points = {{60, -68}, {72, -68}, {72, -56}}, color = {0, 127, 255}));
  connect(humidifierV3.portB_in, phi_from_compr.port) annotation(
    Line(points = {{48, -48}, {48, -26}, {36, -26}}, color = {0, 127, 255}));
  connect(phi_to_valve.port, humidifierV3.portA_out) annotation(
    Line(points = {{18, -62}, {18, -68}, {36, -68}}, color = {0, 127, 255}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>This is an example of an air subsystem with an humidifier, obtained by modification of the simpler SubSystemAir class.<br><div><br></div></body></html>"));
end SubSystemAir_humidifier;
