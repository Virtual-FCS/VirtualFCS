within VirtualFCS.SubSystems.Hydrogen;

model SubSystemHydrogen
  // System
  outer Modelica.Fluid.System system "System properties";
  // Medium declaration
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2 constrainedby Modelica.Media.Interfaces.PartialPureSubstance;
  // Parameter definition
  parameter Modelica.Units.SI.Mass m_system_H2 = 61 "H2 system mass";
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.13 "H2 tank volume";
  parameter Modelica.Units.SI.Area A_tank_H2 = 2 "H2 tank surface area";
  parameter Modelica.Units.SI.AbsolutePressure p_tank_H2 = 35000000 "H2 tank initial pressure";
  parameter Integer N_stack = 180 "FC stack number of cells";
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Sources.Boundary_pT exhaustHydrogen(redeclare package Medium = Anode_Medium, T = system.T_start, nPorts = 1, p = system.p_start, use_T_in = false) annotation(
    Placement(transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent(unit="A") annotation(
    Placement(transformation(origin = {-163, 0}, extent = {{-13, -13}, {13, 13}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {150, 10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {150, -10}, extent = {{10, 10}, {-10, -10}}), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_H2ToStack(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {152, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-54, 119}, extent = {{-18, -19}, {18, 19}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_StackToH2(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {150, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {54, 119}, extent = {{-18, -19}, {18, 19}})));
  // Thermal components
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T= system.T_ambient) annotation(
    Placement(visible = true, transformation(origin = {-122, 160}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {-100, 116}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 12) annotation(
    Placement(visible = true, transformation(origin = {-60, 116}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  // Control components
  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl subSystemHydrogenControl(N_stack = N_stack, pressure_H2_set = 200000) annotation(
    Placement(visible = true, transformation(origin = {-98, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95*A_tank_H2) annotation(
    Placement(visible = true, transformation(origin = {-140, 116}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  // Vessels
  Modelica.Fluid.Vessels.ClosedVolume tankHydrogen(redeclare package Medium = Anode_Medium, V = V_tank_H2, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, nPorts = 1, p_start = p_tank_H2, use_HeatTransfer = true, use_portsData = false) annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-14, 14}, {14, -14}}, rotation = -90)));
  // Machines
  VirtualFCS.Fluid.RecirculationBlower recirculationBlower annotation(
    Placement(transformation(origin = {40, 0}, extent = {{20, -20}, {-20, 20}}, rotation = -90)));
  // Sensors
  Modelica.Fluid.Sensors.MassFlowRate sen_H2_mflow(redeclare package Medium = Anode_Medium, allowFlowReversal = true) annotation(
    Placement(transformation(origin = {40, -40}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  // Valves
  Modelica.Fluid.Valves.ValveCompressible valveH2Purge(redeclare package Medium = Anode_Medium, allowFlowReversal = true, checkValve = true, dp_nominal(displayUnit = "Pa") = 10000, m_flow_nominal = 0.01, p_nominal = 2.5*100000) annotation(
    Placement(transformation(origin = {-40, -80}, extent = {{10, -10}, {-10, 10}})));
  // Other
  VirtualFCS.Fluid.PressureRegulator pressureRegulator annotation(
    Placement(transformation(origin = {-28, 60}, extent = {{-10, 10}, {10, -10}})));
equation
//*** DEFINE CONNECTIONS ***//
  connect(fixedTemperature.port, bodyRadiation.port_b) annotation(
    Line(points = {{-122, 150}, {-122, 150}, {-122, 136}, {-140, 136}, {-140, 126}, {-140, 126}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, convection.fluid) annotation(
    Line(points = {{-122, 150}, {-122, 150}, {-122, 136}, {-100, 136}, {-100, 126}, {-100, 126}}, color = {191, 0, 0}));
  connect(setConvectiveCoefficient.y, convection.Gc) annotation(
    Line(points = {{-76.5, 116}, {-88, 116}, {-88, 116}, {-90, 116}}, color = {0, 0, 127}));
  connect(tankHydrogen.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{-120, 74}, {-120, 100}, {-140, 100}, {-140, 106}}, color = {191, 0, 0}));
  connect(tankHydrogen.heatPort, convection.solid) annotation(
    Line(points = {{-120, 74}, {-120, 100}, {-100, 100}, {-100, 106}}, color = {191, 0, 0}));
  connect(valveH2Purge.port_b, exhaustHydrogen.ports[1]) annotation(
    Line(points = {{-50, -80}, {-140, -80}}, color = {255, 0, 0}, thickness = 1));
  connect(recirculationBlower.pin_n, pin_n) annotation(
    Line(points = {{54, -10}, {150, -10}}, color = {0, 0, 255}));
  connect(pin_p, recirculationBlower.pin_p) annotation(
    Line(points = {{150, 10}, {54, 10}}, color = {0, 0, 255}));
  connect(recirculationBlower.Input, sen_H2_mflow.port_b) annotation(
    Line(points = {{40, -18}, {40, -30}}, color = {255, 0, 0}, thickness = 0.75));
  connect(tankHydrogen.ports[1], pressureRegulator.Input) annotation(
    Line(points = {{-106, 60}, {-38, 60}}, color = {255, 0, 0}, thickness = 1));
  connect(valveH2Purge.opening, subSystemHydrogenControl.purge_set) annotation(
    Line(points = {{-40, -72}, {-40, -12}, {-76, -12}}, color = {0, 0, 127}));
  connect(stackCurrent, subSystemHydrogenControl.stackCurrent) annotation(
    Line(points = {{-162, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(sen_H2_mflow.m_flow, subSystemHydrogenControl.pumpSpeed_measured) annotation(
    Line(points = {{29, -40}, {-132, -40}, {-132, -26}, {-120, -26}}, color = {0, 0, 127}));
  connect(pressureRegulator.setDownstreamPressure, subSystemHydrogenControl.p_h2_set) annotation(
    Line(points = {{-24, 52}, {-24, 2}, {-76, 2}}, color = {0, 0, 127}));
  connect(subSystemHydrogenControl.pumpSpeed_set, recirculationBlower.controlInterface) annotation(
    Line(points = {{-76, -26}, {-20, -26}, {-20, -6}, {26, -6}}, color = {0, 0, 127}));
  connect(pressureRegulator.Output, port_H2ToStack) annotation(
    Line(points = {{-18, 60}, {152, 60}}, color = {255, 0, 0}, thickness = 1));
  connect(recirculationBlower.Output, port_H2ToStack) annotation(
    Line(points = {{40, 18}, {40, 60}, {152, 60}}, color = {255, 0, 0}, thickness = 0.75));
  connect(port_StackToH2, valveH2Purge.port_a) annotation(
    Line(points = {{150, -80}, {-30, -80}}, color = {255, 0, 0}, thickness = 1));
  connect(sen_H2_mflow.port_a, port_StackToH2) annotation(
    Line(points = {{40, -50}, {40, -80}, {150, -80}}, color = {255, 0, 0}, thickness = 0.75));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1), graphics = {Text(origin = {-30, 76}, extent = {{-14, 4}, {22, -6}}, textString = "Pressure regulator"), Text(origin = {62, 18}, extent = {{-14, 4}, {22, -6}}, textString = "Recirculation blower")}),
    Icon(graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-78, 83}, textColor = {255, 255, 255}, extent = {{30, -23}, {128, -141}}, textString = "H2")}, coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The hydrogen sub system provides hydrogen to the<a href=\"modelica://\">&nbsp;</a><a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>.&nbsp;<br><div><br></div><div><br></div><div><div><br></div><div><b>References to base model/related packages</b></div><div><p class=\"MsoNormal\"><o:p></o:p></p><p class=\"MsoNormal\"><a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl\">Subsystem Hydrogen Control</a>, <a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>,&nbsp;and <a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a></p><p class=\"MsoNormal\"><br></p>

<p class=\"MsoNormal\"><b>Description</b><o:p></o:p></p>

<p class=\"MsoNormal\">The compressed hydrogen from the hydrogen tank is depressurised to fuel cell operating pressure with the use of pressure regulator. The unreacted hydrogen is reintroduced to the fuel cell inlet using a recirculation blower. A simplified pruge strategy is also introduced. I<span style=\"font-size: 12px;\">f the fuel cell stack is turned on then the purge valve is opened at regular intervals predefined in the setPurgeValveState block.&nbsp;</span></p><div>The fluid ports connect to the hydrogen interfaces on the fuel cell stack, the electrical ports connect to the low-voltage power supply to provide power to the BoP components, and the control interface connects to the&nbsp;<a href=\"modelica://VirtualFCS.Control.FuelCellSystemControl\">Fuel Cell System Control</a>, which controls the&nbsp;<a href=\"modelica://\">Recirculation Blower</a>.</div>

<p class=\"MsoNormal\"><b><br></b></p><p class=\"MsoNormal\"><b>List of components</b></p><p class=\"MsoNormal\">The model comprises a hydrogen tank, <a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>,&nbsp;<a href=\"modelica://\">Recirculation Blower</a>, and a <a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a> linked to a fixed ambient boundary condition. The subsystem features 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port.&nbsp;</p>

<p class=\"MsoNormal\"><o:p>&nbsp;</o:p></p>

<!--EndFragment--></div></div></body></html>"));
end SubSystemHydrogen;
