within VirtualFCS.Thermal;
model PreHeater
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  //*** DECLARE PARAMETERS ***//
  parameter Modelica.Units.SI.Resistance R_eq = 1.75 "Equivalent Resistance";
  parameter Modelica.Units.SI.Diameter D_pipe = 0.015 "Pipe Diameter";
  parameter Modelica.Units.SI.Length L_pipe = 1 "Pipe Length";
  parameter Integer N_pipe = 10 "Number of Parallel Pipes";
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Fluid.Pipes.DynamicPipe pipe(redeclare package Medium = Medium, diameter = D_pipe, length = L_pipe, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, nParallel = N_pipe, p_a_start = 102502, use_HeatTransfer = true) annotation (
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin = {80, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{40, 90}, {60, 110}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin = {-80, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-60, 90}, {-40, 110}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 1777) annotation (
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = 100) annotation (
    Placement(visible = true, transformation(origin = {0, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R = R_eq) annotation (
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation (
    Placement(visible = true, transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  prescribedHeatFlow.Q_flow = R1.LossPower;
  connect(port_a, pipe.port_a) annotation (
    Line(points = {{-100, 0}, {-91, 0}, {-91, -80}, {-10, -80}}, color = {0, 0, 255}, thickness = 1));
  connect(pipe.port_b, port_b) annotation (
    Line(points = {{10, -80}, {91, -80}, {91, 0}, {100, 0}}, color = {255, 0, 0}, thickness = 1));
  connect(thermalConductor.port_b, pipe.heatPorts[1]) annotation (
    Line(points={{0,-60},{0,-60},{0,-75.6},{0.1,-75.6}},    color = {191, 0, 0}));
  connect(heatCapacitor.port, thermalConductor.port_a) annotation (
    Line(points = {{0, -22}, {0, -22}, {0, -40}, {0, -40}}, color = {191, 0, 0}));
  connect(pin_p, R1.p) annotation (
    Line(points = {{-80, 102}, {-80, 60}, {-10, 60}}, color = {0, 0, 255}));
  connect(R1.n, pin_n) annotation (
    Line(points = {{10, 60}, {80, 60}, {80, 100}}, color = {0, 0, 255}));
  connect(prescribedHeatFlow.port, heatCapacitor.port) annotation (
    Line(points = {{-40, -20}, {0, -20}, {0, -22}, {0, -22}}, color = {191, 0, 0}));
  annotation (
    Icon(graphics={  Line(origin = {29, 31.44}, points = {{-79, 68.562}, {-79, -71.438}, {-69, 8.56202}, {-59, -71.438}, {-49, 8.56202}, {-39, -71.438}, {-29, 8.56202}, {-19, -71.438}, {-9, 8.56202}, {1, -71.438}, {11, 8.56202}, {21, -71.438}, {21, 70.562}, {23, 72.562}}, color = {255, 0, 0}, thickness = 1.5), Line(origin = {-0.67, 27.14}, points = {{-98.9689, -27.1425}, {99.0311, -27.1425}, {101.031, -27.1425}}, color = {0, 85, 255}, thickness = 2)}),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>R_eq</code></td><td>SI.Resistance</td><td>Ohm</td><td>1.75</td><td>Equivalent Resistance</td></tr>
<tr><td><code>D_pipe</code></td><td>SI.Diameter</td><td>-</td><td>0.015</td><td>Pipe Diameter</td></tr>
<tr><td><code>L_pipe</code></td><td>SI.Length</td><td>m</td><td>1</td><td>Pipe Length</td></tr>
<tr><td><code>N_pipe</code></td><td>Integer</td><td>1</td><td>10</td><td>Number of Parallel Pipes</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>port_a</code></td><td>Input-side interface</td><td>FluidPort_a</td><td>-</td><td></td></tr>
<tr><td><code>pin_p</code></td><td>Input-side interface</td><td>PositivePin</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2>
<p>The <b>PreHeater</b> models an electrically heated fluid pipe. The electrical power dissipated by the internal resistor <code>R1</code> is transferred to the pipe through a thermal conductor and heat capacity.</p>
<h3>Implementation notes</h3>
<p>The heater heat flow equals the resistor loss power, <code>Q_flow = R_eq*I^2</code>. The internal pipe start pressure is fixed at <b>102502 Pa</b>, the thermal conductance at <b>1777 W/K</b>, and the thermal capacity at <b>100 J/K</b>. These values are implementation constants rather than user parameters.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>prescribedHeatFlow.Q_flow = R1.LossPower;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>port_b</code></td><td>Output-side interface</td><td>FluidPort_b</td><td>-</td><td></td></tr>
<tr><td><code>pin_n</code></td><td>Output-side interface</td><td>NegativePin</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end PreHeater;
