within VirtualFCS.SubSystems.Air;

model SubSystemAir "Subsystem regulating pressure and flowrate of air to a fuel cell stack"
  outer Modelica.Fluid.System system "System properties";
  replaceable package Medium = Media.MoistAir;
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
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_b toStack(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 120}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-40, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent(unit = "A") annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Pressure pressureSensor(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {90, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.Blocks.Math.Gain current_to_mass_flow(k = N_cells*lambda*MM_O2/n_O2/F/xO2) annotation(
    Placement(transformation(origin = {-80, 60}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Fluid.Valves.ValveLinear valve(redeclare package Medium = Medium, dp_nominal(displayUnit = "bar") = 1.5e5, m_flow_nominal = 0.3, opening(start = 0)) annotation(
    Placement(transformation(origin = {-50, -60}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  Modelica.Blocks.Continuous.LimPID PID_valve(controllerType = Modelica.Blocks.Types.SimpleController.PI, yMax = 1, yMin = 0, k = -1e-4, Ti = 2) annotation(
    Placement(transformation(origin = {-26, -36}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant pressure_set_point(k = p_set) annotation(
    Placement(transformation(origin = {6, -36}, extent = {{10, -10}, {-10, 10}})));
  replaceable Fluid.ElectricCompressor compressor(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {2, 44}, extent = {{-30, -30}, {30, 30}})), choicesAllMatching = true) constrainedby Fluid.ElectricCompressorInterface;
  Modelica.Fluid.Sensors.Temperature tempCompressorOut(redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {52, 67}, extent = {{-10, -9}, {10, 9}})));
  replaceable Fluid.NonHumidifier humidifier(redeclare package dry_medium = Medium, redeclare package wet_medium = Medium) annotation(
    Placement(transformation(origin = {50, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  VirtualFCS.Fluid.RelativeHumiditySensor phi_dry_in annotation(
    Placement(transformation(origin = {59, 29}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  VirtualFCS.Fluid.RelativeHumiditySensor phi_wet_in annotation(
    Placement(transformation(origin = {69, 9}, extent = {{-7, -7}, {7, 7}})));
  VirtualFCS.Fluid.RelativeHumiditySensor phi_dry_out annotation(
    Placement(transformation(origin = {59, -31}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  VirtualFCS.Fluid.RelativeHumiditySensor phi_wet_out annotation(
    Placement(transformation(origin = {29, 9}, extent = {{-7, -7}, {7, 7}})));
equation
  connect(stackCurrent, current_to_mass_flow.u) annotation(
    Line(points = {{-110, 60}, {-92, 60}}, color = {0, 0, 127}));
  connect(environment.ports[1], valve.port_b) annotation(
    Line(points = {{-80, -30}, {-74, -30}, {-74, -60}, {-60, -60}}, color = {0, 127, 255}, thickness = 0.75));
  connect(valve.opening, PID_valve.y) annotation(
    Line(points = {{-50, -52}, {-50, -36}, {-37, -36}}, color = {0, 0, 127}, thickness = 0.75));
  connect(current_to_mass_flow.y, compressor.set_mass_flow) annotation(
    Line(points = {{-69, 60}, {-34, 60}}, color = {0, 0, 127}));
  connect(environment.ports[2], compressor.port_a) annotation(
    Line(points = {{-80, -30}, {-52, -30}, {-52, 10}, {-8, 10}, {-8, 56}, {-4, 56}}, color = {0, 127, 255}));
  connect(tempCompressorOut.port, compressor.port_b) annotation(
    Line(points = {{52, 58}, {50, 58}, {50, 44}, {32, 44}}, color = {0, 127, 255}));
  connect(compressor.pin_p, pin_p) annotation(
    Line(points = {{-12, 74}, {0, 74}, {0, 100}}, color = {0, 0, 255}));
  connect(compressor.pin_n, pin_n) annotation(
    Line(points = {{-24, 74}, {-40, 74}, {-40, 100}}, color = {0, 0, 255}));
  connect(pressure_set_point.y, PID_valve.u_s) annotation(
    Line(points = {{-5, -36}, {-14, -36}}, color = {0, 0, 127}, thickness = 0.75));
  connect(humidifier.portA_in, fromStack) annotation(
    Line(points = {{62, 0}, {100, 0}}, color = {0, 127, 255}, thickness = 0.75));
  connect(humidifier.portA_out, valve.port_a) annotation(
    Line(points = {{38, 0}, {30, 0}, {30, -60}, {-40, -60}}, color = {0, 127, 255}, thickness = 0.75));
  connect(humidifier.portB_out, toStack) annotation(
    Line(points = {{50, -20}, {50, -60}, {100, -60}}, color = {0, 127, 255}, thickness = 0.75));
  connect(humidifier.portB_in, phi_dry_in.port) annotation(
    Line(points = {{50, 20}, {50, 29}, {52, 29}}, color = {0, 127, 255}, thickness = 0.75));
  connect(pressureSensor.port, fromStack) annotation(
    Line(points = {{90, 20}, {90, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(phi_dry_out.port, humidifier.portB_out) annotation(
    Line(points = {{52, -31}, {50, -31}, {50, -21}}, color = {0, 127, 255}));
  connect(humidifier.portA_in, phi_wet_in.port) annotation(
    Line(points = {{61.6, 0}, {69.6, 0}, {69.6, 2}}, color = {0, 127, 255}));
  connect(humidifier.portA_out, phi_wet_out.port) annotation(
    Line(points = {{38, 0}, {30, 0}, {30, 2}}, color = {0, 127, 255}));
  connect(pressureSensor.p, PID_valve.u_m) annotation(
    Line(points = {{102, 30}, {120, 30}, {120, -80}, {-26, -80}, {-26, -48}}, color = {0, 0, 127}));
  connect(compressor.port_b, humidifier.portB_in) annotation(
    Line(points = {{32, 44}, {50, 44}, {50, 20}}, color = {0, 127, 255}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1)), 
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p><b>SubSystemAir</b> supplies cathode air to a fuel-cell stack and regulates the stack-side pressure.</p><h3>Composition</h3><p>The subsystem contains an electric compressor, a pressure sensor, an outlet valve, a pressure set-point source, and PI control. The compressor is powered through the electrical pins; its outlet feeds the stack through <code>toStack</code>, while <code>fromStack</code> returns the cathode flow to the environment.</p><h3>Working principle</h3><p>The stack-current input is converted to an estimated air mass-flow demand using the cell count and air excess ratio <code>lambda</code>. Compressor control supplies the required flow, while the valve and pressure controller regulate the cathode pressure toward <code>p_set</code>. The environment boundary uses the global system ambient pressure and temperature.</p><p>The compressor and valve are replaceable. Controller gains and nominal flow values are tuned for a particular stack and should be checked when changing stack size, manifold volume, or operating conditions.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>system</code> (Modelica.Fluid.System), <code>environment</code> (Modelica.Fluid.Sources.FixedBoundary), <code>pressureSensor</code> (Modelica.Fluid.Sensors.Pressure), <code>current_to_mass_flow</code> (Modelica.Blocks.Math.Gain), <code>valve</code> (Modelica.Fluid.Valves.ValveLinear), <code>PID_valve</code> (Modelica.Blocks.Continuous.LimPID), <code>pressure_set_point</code> (Modelica.Blocks.Sources.Constant), <code>compressor</code> (Fluid.ElectricCompressor), <code>tempCompressorOut</code> (Modelica.Fluid.Sensors.Temperature), <code>humidifier</code> (Fluid.NonHumidifier), <code>phi_dry_in</code> (VirtualFCS.Fluid.RelativeHumiditySensor), <code>phi_wet_in</code> (VirtualFCS.Fluid.RelativeHumiditySensor), <code>phi_dry_out</code> (VirtualFCS.Fluid.RelativeHumiditySensor), <code>phi_wet_out</code> (VirtualFCS.Fluid.RelativeHumiditySensor).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>42</code></td><td>Number of cells in the stack</td></tr>
<tr><td><code>lambda</code></td><td>Real</td><td>1</td><td><code>3</code></td><td>Air excess ratio</td></tr>
<tr><td><code>p_set</code></td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td><code>200000</code></td><td>Target cathodic pressure</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>fromStack</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td></td></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>stackCurrent</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>A</td><td>A</td></tr>
<tr><td><code>toStack</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td></td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
</table>
</body>
</html>"));


end SubSystemAir;
