within VirtualFCS.SubSystems.Hydrogen;

model SubSystemHydrogen
  outer Modelica.Fluid.System system "System properties";
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2 constrainedby Modelica.Media.Interfaces.PartialPureSubstance;
  parameter Modelica.Units.SI.Area A_tank_H2 = 2 "H2 tank surface area";
  parameter Integer N_cells = 180 "FC stack number of cells";
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_HRB_min = 1e-7 "Minimum volume flow of the Hydrogen Recirculation Blower";
  parameter Real RR = 1.3 "Hydrogen recirculation ratio";
  Modelica.Fluid.Sources.Boundary_pT exhaustHydrogen(redeclare package Medium = Anode_Medium, nPorts = 1, p = system.p_ambient, use_T_in = false) annotation(
    Placement(transformation(origin = {-150, -80}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent(unit = "A") annotation(
    Placement(transformation(origin = {-165, -3.55271e-15}, extent = {{-23, -23}, {23, 23}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {150, -10}, extent = {{-14, 14}, {14, -14}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {150, 10}, extent = {{14, -14}, {-14, 14}}), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b toStack(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {151, 50}, extent = {{-15, -14}, {15, 14}}), iconTransformation(origin = {-54, 119}, extent = {{-18, -19}, {18, 19}})));
  Modelica.Fluid.Interfaces.FluidPort_a fromStack(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {152, -80}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {54, 119}, extent = {{-18, -19}, {18, 19}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = system.T_ambient) annotation(
    Placement(transformation(origin = {-97, 159}, extent = {{17, -17}, {-17, 17}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(transformation(origin = {-66, 106}, extent = {{18, -18}, {-18, 18}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 12) annotation(
    Placement(transformation(origin = {25, 106}, extent = {{24, -14}, {-24, 14}})));
  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl subSystemHydrogenControl(N_cells = N_cells, pressure_H2_set = 2000000, minimumFlow = V_flow_HRB_min, RR = RR) annotation(
    Placement(visible = true, transformation(origin = {-98, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95*A_tank_H2) annotation(
    Placement(transformation(origin = {-125, 107}, extent = {{17, -17}, {-17, 17}}, rotation = -90)));
  Modelica.Fluid.Vessels.ClosedVolume tankHydrogen(redeclare package Medium = Anode_Medium, V = 0.13, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, nPorts = 1, p_start = 35000000, use_HeatTransfer = true, use_portsData = false) annotation(
    Placement(transformation(origin = {-98, 50}, extent = {{-20, 20}, {20, -20}}, rotation = -90)));
  Modelica.Fluid.Sensors.MassFlowRate sen_H2_mflow(redeclare package Medium = Anode_Medium, allowFlowReversal = true) annotation(
    Placement(transformation(origin = {40, -50}, extent = {{13, 14}, {-13, -14}}, rotation = -90)));
  Modelica.Fluid.Valves.ValveLinear valveH2Purge(redeclare package Medium = Anode_Medium, dp_nominal(displayUnit = "Pa") = 10000, m_flow_nominal = 0.01) annotation(
    Placement(transformation(origin = {-36, -80}, extent = {{14, -14}, {-14, 14}})));
  VirtualFCS.Fluid.PressureRegulator pressureRegulator(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {-28, 50}, extent = {{-10, 10}, {10, -10}})));
  Fluid.SimplePump HRB(redeclare package Medium = Anode_Medium, eta = 0.35) annotation(
    Placement(transformation(origin = {40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Fluid.Sensors.Temperature temp_h2_from_stack(redeclare package Medium = Anode_Medium)  annotation(
    Placement(transformation(origin = {102, -54}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(fixedTemperature.port, bodyRadiation.port_b) annotation(
    Line(points = {{-97, 142}, {-97, 132}, {-125, 132}, {-125, 124}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, convection.fluid) annotation(
    Line(points = {{-97, 142}, {-97, 132}, {-66, 132}, {-66, 124}}, color = {191, 0, 0}));
  connect(setConvectiveCoefficient.y, convection.Gc) annotation(
    Line(points = {{-1, 106}, {-48, 106}}, color = {0, 0, 127}));
  connect(tankHydrogen.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{-98, 70}, {-98, 82}, {-125, 82}, {-125, 90}}, color = {191, 0, 0}));
  connect(tankHydrogen.heatPort, convection.solid) annotation(
    Line(points = {{-98, 70}, {-98, 81}, {-66, 81}, {-66, 88}}, color = {191, 0, 0}));
  connect(valveH2Purge.port_b, exhaustHydrogen.ports[1]) annotation(
    Line(points = {{-50, -80}, {-136, -80}}, color = {255, 0, 0}, thickness = 1));
  connect(tankHydrogen.ports[1], pressureRegulator.Input) annotation(
    Line(points = {{-78, 50}, {-38, 50}}, color = {255, 0, 0}, thickness = 1));
  connect(valveH2Purge.opening, subSystemHydrogenControl.purge_set) annotation(
    Line(points = {{-36, -69}, {-36, -12}, {-76, -12}}, color = {0, 0, 127}));
  connect(stackCurrent, subSystemHydrogenControl.stackCurrent) annotation(
    Line(points = {{-165, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(sen_H2_mflow.m_flow, subSystemHydrogenControl.pumpSpeed_measured) annotation(
    Line(points = {{25, -50}, {-132, -50}, {-132, -26}, {-120, -26}}, color = {0, 0, 127}));
  connect(pressureRegulator.setDownstreamPressure, subSystemHydrogenControl.p_h2_set) annotation(
    Line(points = {{-24, 43}, {-24, 2}, {-76, 2}}, color = {0, 0, 127}));
  connect(pressureRegulator.Output, toStack) annotation(
    Line(points = {{-18, 50}, {151, 50}}, color = {255, 0, 0}, thickness = 1));
  connect(fromStack, valveH2Purge.port_a) annotation(
    Line(points = {{152, -80}, {-22, -80}}, color = {255, 0, 0}, thickness = 1));
  connect(sen_H2_mflow.port_a, fromStack) annotation(
    Line(points = {{40, -63}, {40, -80}, {152, -80}}, color = {255, 0, 0}, thickness = 0.75));
  connect(sen_H2_mflow.port_b, HRB.port_a) annotation(
    Line(points = {{40, -37}, {40, -20}}, color = {255, 0, 0}, thickness = 0.75));
  connect(HRB.port_b, toStack) annotation(
    Line(points = {{24, 20}, {24, 50}, {151, 50}}, color = {255, 0, 0}, thickness = 0.75));
  connect(HRB.pin_p, pin_p) annotation(
    Line(points = {{60, -10}, {150, -10}}, color = {0, 0, 255}));
  connect(HRB.pin_n, pin_n) annotation(
    Line(points = {{60, 10}, {150, 10}}, color = {0, 0, 255}));
  connect(subSystemHydrogenControl.pumpSpeed_set, HRB.u) annotation(
    Line(points = {{-76, -26}, {0, -26}, {0, 0}, {22, 0}}, color = {0, 0, 127}));
  connect(temp_h2_from_stack.port, fromStack) annotation(
    Line(points = {{102, -64}, {100, -64}, {100, -80}, {152, -80}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1), graphics = {Text(origin = {-27, 58}, extent = {{-17, 6}, {25, -8}}, textString = "Pressure regulator"), Text(origin = {54, 23}, extent = {{-28, 13}, {42, -15}}, textString = "Hydrogen recirculation blower")}),
    Icon(graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-78, 83}, textColor = {255, 255, 255}, extent = {{30, -23}, {128, -141}}, textString = "H2")}, coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and input-side physical interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>A_tank_H2</code></td><td>Modelica.Units.SI.Area</td><td>m2</td><td>2</td><td>H2 tank surface area</td></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td>180</td><td>FC stack number of cells</td></tr>
<tr><td><code>V_flow_HRB_min</code></td><td>Modelica.Units.SI.VolumeFlowRate</td><td>-</td><td>1e-7</td><td>Minimum volume flow of the Hydrogen Recirculation Blower</td></tr>
<tr><td><code>RR</code></td><td>Real</td><td>1</td><td>1.3</td><td>Hydrogen recirculation ratio</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>stackCurrent</code></td><td>Input</td><td>RealInput</td><td>A</td><td>A</td></tr>
<tr><td><code>pin_p</code></td><td>Input-side interface</td><td>PositivePin</td><td>-</td><td></td></tr>
<tr><td><code>fromStack</code></td><td>Input-side interface</td><td>FluidPort_a</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><p><b>SubSystemHydrogen</b> supplies hydrogen to a fuel-cell anode and manages recirculation, pressure reduction, and purge flow.</p><h3>Composition</h3><p>The assembly contains a 0.13 m3 hydrogen tank, pressure regulator, recirculation blower, purge valve, mass-flow and temperature sensors, and a fixed-temperature tank heat-transfer model. Hydrogen enters the stack through <code>toStack</code> and returns through <code>fromStack</code>; <code>pin_p</code> and <code>pin_n</code> supply the blower and control hardware.</p><h3>Working principle</h3><p>Stack current is converted to hydrogen consumption and passed to <a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl\">SubSystemHydrogenControl</a>. The control block sets feed pressure, recirculation-blower speed, and purge-valve opening. The tank starts at 35 MPa, while exhaust hydrogen is discharged to the system ambient pressure.</p><p>The anode medium, cell count, recirculation ratio, tank area, and minimum blower flow are configurable. Pressure-control tuning and purge settings must be checked for the connected stack.</p><h2>3. Governing equations and references</h2><p>Governing equations are inherited from extended classes or enforced by instantiated components and their connected physical networks.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_n</code></td><td>Output-side interface</td><td>NegativePin</td><td>-</td><td></td></tr>
<tr><td><code>toStack</code></td><td>Output-side interface</td><td>FluidPort_b</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end SubSystemHydrogen;
