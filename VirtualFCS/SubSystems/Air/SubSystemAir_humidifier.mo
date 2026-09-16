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
    Placement(transformation(origin = {97, -47}, extent = {{7, -7}, {-7, 7}})));
  Modelica.Blocks.Math.Gain current_to_mass_flow(k = N_cells*lambda*MM_O2/n_O2/F/xO2) annotation(
    Placement(transformation(origin = {-80, 60}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Fluid.Valves.ValveCompressible valve(redeclare package Medium = Medium, dp_nominal(displayUnit = "bar") = 1.5e5, m_flow_nominal = 0.3, opening(start = 0), p_nominal = 2.5e5) annotation(
    Placement(transformation(origin = {-50, -68}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  Modelica.Blocks.Continuous.LimPID PID_valve(controllerType = Modelica.Blocks.Types.SimpleController.PI, yMax = 1, yMin = 0, k = -1e-4, Ti = 2) annotation(
    Placement(transformation(origin = {-30, -30}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant pressure_set_point(k = p_set) annotation(
    Placement(transformation(origin = {10, -30}, extent = {{10, -10}, {-10, 10}})));
  Fluid.Humidifier humidifier(redeclare package dry_medium = Medium, redeclare package wet_medium = Medium) annotation(
    Placement(transformation(origin = {36, -68}, extent = {{20, -20}, {-20, 20}})));
  Fluid.RelativeHumiditySensor phi_to_stack annotation(
    Placement(transformation(origin = {69, -81}, extent = {{-7, -7}, {7, 7}})));
  replaceable Fluid.ElectricCompressor compressor(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-1, 47}, extent = {{-29, -29}, {29, 29}}))) constrainedby Fluid.ElectricCompressorInterface;
equation
  connect(stackCurrent, current_to_mass_flow.u) annotation(
    Line(points = {{-110, 60}, {-92, 60}}, color = {0, 0, 127}));
  connect(environment.ports[1], valve.port_b) annotation(
    Line(points = {{-80, -30}, {-74, -30}, {-74, -68}, {-60, -68}}, color = {0, 127, 255}));
  connect(valve.opening, PID_valve.y) annotation(
    Line(points = {{-50, -60}, {-50, -30}, {-41, -30}}, color = {0, 0, 127}));
  connect(pressureSensor.p, PID_valve.u_m) annotation(
    Line(points = {{89, -47}, {-30, -47}, {-30, -42}}, color = {0, 0, 127}));
  connect(pressure_set_point.y, PID_valve.u_s) annotation(
    Line(points = {{-1, -30}, {-18, -30}}, color = {0, 0, 127}));
  connect(fromStack, humidifier.portB_in) annotation(
    Line(points = {{100, -68}, {56, -68}}));
  connect(humidifier.portB_out, valve.port_a) annotation(
    Line(points = {{16, -68}, {-40, -68}}, color = {0, 127, 255}));
  connect(pressureSensor.port, fromStack) annotation(
    Line(points = {{97, -54}, {97, -65}, {100, -65}, {100, -68}}, color = {0, 127, 255}));
  connect(humidifier.portA_out, toStack) annotation(
    Line(points = {{36, -80}, {36, -92}, {100, -92}}, color = {0, 127, 255}));
  connect(phi_to_stack.port, humidifier.portA_out) annotation(
    Line(points = {{70, -88}, {68, -88}, {68, -92}, {36, -92}, {36, -80}}, color = {0, 127, 255}));
  connect(environment.ports[2], compressor.port_a) annotation(
    Line(points = {{-80, -30}, {-68, -30}, {-68, 20}, {-10, 20}, {-10, 59}, {-7, 59}}, color = {0, 127, 255}));
  connect(compressor.port_b, humidifier.portA_in) annotation(
    Line(points = {{28, 47}, {28, 48}, {36, 48}, {36, -56}}, color = {0, 127, 255}));
  connect(compressor.pin_p, pin_p) annotation(
    Line(points = {{-15, 76}, {0, 76}, {0, 100}}, color = {0, 0, 255}));
  connect(compressor.pin_n, pin_n) annotation(
    Line(points = {{-27, 76}, {-40, 76}, {-40, 100}}, color = {0, 0, 255}));
  connect(current_to_mass_flow.y, compressor.set_mass_flow) annotation(
    Line(points = {{-68, 60}, {-36, 60}, {-36, 62}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>This is an example of an air subsystem with an humidifier, obtained by modification of the simpler SubSystemAir class.<br><div><br></div></body></html>"));
annotation(Documentation(info = "<html><p><b>SubSystemAir_humidifier</b> extends the air supply and pressure-regulation arrangement with humidification of the cathode air stream.</p><h3>Composition and operation</h3><p>The model contains the same compressor, pressure sensor, outlet valve, and PI pressure-control path as <a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">SubSystemAir</a>, with a humidifier placed in the air path. Stack current determines the estimated air-flow demand, the compressor provides air, and the outlet valve regulates pressure toward <code>p_set</code>.</p><p>The fluid medium, cell count, air excess ratio, and target pressure are configurable. Humidifier operation and controller tuning depend on the connected stack and the selected medium.</p></html>"));
end SubSystemAir_humidifier;
