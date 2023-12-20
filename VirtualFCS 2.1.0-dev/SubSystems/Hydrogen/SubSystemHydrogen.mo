within VirtualFCS.SubSystems.Hydrogen;

model SubSystemHydrogen
  // System
  outer Modelica.Fluid.System system "System properties";
  // Medium declaration
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start)) constrainedby Modelica.Media.Interfaces.PartialSimpleIdealGasMedium;
  // Parameter definition
  parameter Modelica.Units.SI.Mass m_system_H2 = 61 "H2 system mass";
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.13 "H2 tank volume";
  parameter Modelica.Units.SI.Area A_tank_H2 = 2 "H2 tank surface area";
  parameter Modelica.Units.SI.Pressure p_tank_H2 = 35000000 "H2 tank initial pressure";
  parameter Real N_FC_stack(unit = "1") = 180 "FC stack number of cells";
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Sources.Boundary_pT exhaustHydrogen(redeclare package Medium = Anode_Medium, T = system.T_start, nPorts = 1, p = system.p_start, use_T_in = false) annotation(
    Placement(visible = true, transformation(origin = {-120, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput control annotation(
    Placement(visible = true, transformation(origin = {-163, 0}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-16, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-15, -11}, extent = {{11, 11}, {-11, -11}}, rotation = 0), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation(
    Placement(visible = true, transformation(origin = {160, -21}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_H2ToStack(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {78, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-54, 119}, extent = {{-18, -19}, {18, 19}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_StackToH2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {78, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {54, 119}, extent = {{-18, -19}, {18, 19}}, rotation = 0)));
  // Thermal components
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T (displayUnit = "K")= system.T_start) annotation(
    Placement(visible = true, transformation(origin = {-122, 160}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {-100, 116}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 12) annotation(
    Placement(visible = true, transformation(origin = {-60, 116}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  // Control components
  Modelica.Blocks.Routing.Multiplex2 multiplex(n1 = 1, n2 = 1) annotation(
    Placement(visible = true, transformation(origin = {112, -21}, extent = {{-8, 8}, {8, -8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setH2Pressure(y = controlSignals.y1[1]) annotation(
    Placement(visible = true, transformation(origin = {-38, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setPurgeValveState(y = controlSignals.y2[1]) annotation(
    Placement(visible = true, transformation(origin = {-62, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setBlowerSpeed(y = controlSignals.y3[1]) annotation(
    Placement(visible = true, transformation(origin = {72, -6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl subSystemHydrogenControl(N_FC_stack = N_FC_stack, pressure_H2_set = 200000) annotation(
    Placement(visible = true, transformation(origin = {-98, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Routing.DeMultiplex3 controlSignals annotation(
    Placement(visible = true, transformation(origin = {-56, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95*A_tank_H2) annotation(
    Placement(visible = true, transformation(origin = {-140, 116}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  // Vessels
  Modelica.Fluid.Vessels.ClosedVolume tankHydrogen(redeclare package Medium = Anode_Medium, T_start = system.T_start, V = V_tank_H2, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, nPorts = 1, p_start = p_tank_H2, use_HeatTransfer = true, use_portsData = false) annotation(
    Placement(visible = true, transformation(origin = {-122, 74}, extent = {{-14, 14}, {14, -14}}, rotation = -90)));
  // Machines
  VirtualFCS.Fluid.RecirculationBlower recirculationBlower annotation(
    Placement(visible = true, transformation(origin = {26, -8.88178e-16}, extent = {{-18, -18}, {18, 18}}, rotation = 90)));
  // Sensors
  Modelica.Fluid.Sensors.Pressure sensorPressureTank(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-68, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Pressure sensorPressureHydrogenLine(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {2, 42}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sensors.MassFlowRate sen_H2_mflow(redeclare package Medium = Anode_Medium, allowFlowReversal = true) annotation(
    Placement(visible = true, transformation(origin = {26, -42}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  // Valves
  Modelica.Fluid.Valves.ValveCompressible valveH2Purge(redeclare package Medium = Anode_Medium, allowFlowReversal = true, checkValve = true, dp_nominal(displayUnit = "Pa") = 10000, m_flow_nominal = 0.01, p_nominal = 2.5*100000) annotation(
    Placement(visible = true, transformation(origin = {-40, -76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Other
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {26, -76}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {26, 74}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  VirtualFCS.Fluid.PressureRegulator pressureRegulator annotation(
    Placement(visible = true, transformation(origin = {-30, 74}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(sensors, multiplex.y) annotation(
    Line(points = {{160, -21}, {121, -21}}, color = {0, 0, 127}));
  connect(control, subSystemHydrogenControl.signalInterface_FC) annotation(
    Line(points = {{-163, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(subSystemHydrogenControl.controlInterface, controlSignals.u) annotation(
    Line(points = {{-76, -12}, {-68, -12}, {-68, -12}, {-68, -12}}, color = {0, 0, 127}, thickness = 0.5));
  connect(sensors, subSystemHydrogenControl.signalInterface_H2) annotation(
    Line(points = {{160, -21}, {162, -21}, {162, -112}, {-160, -112}, {-160, -24}, {-120, -24}}, color = {0, 0, 127}, thickness = 0.5));
  connect(fixedTemperature.port, bodyRadiation.port_b) annotation(
    Line(points = {{-122, 150}, {-122, 150}, {-122, 136}, {-140, 136}, {-140, 126}, {-140, 126}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, convection.fluid) annotation(
    Line(points = {{-122, 150}, {-122, 150}, {-122, 136}, {-100, 136}, {-100, 126}, {-100, 126}}, color = {191, 0, 0}));
  connect(setConvectiveCoefficient.y, convection.Gc) annotation(
    Line(points = {{-76, 116}, {-88, 116}, {-88, 116}, {-90, 116}}, color = {0, 0, 127}));
  connect(tankHydrogen.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{-122, 88}, {-122, 100}, {-140, 100}, {-140, 106}}, color = {191, 0, 0}));
  connect(tankHydrogen.heatPort, convection.solid) annotation(
    Line(points = {{-122, 88}, {-122, 100}, {-100, 100}, {-100, 106}}, color = {191, 0, 0}));
  connect(teeJunctionIdeal2.port_3, sen_H2_mflow.port_a) annotation(
    Line(points = {{26, -66}, {26, -52}}, color = {0, 170, 0}, thickness = 1));
  connect(sen_H2_mflow.m_flow, multiplex.u1[1]) annotation(
    Line(points = {{38, -42}, {82, -42}, {82, -26}, {102, -26}}, color = {0, 0, 127}));
  connect(teeJunctionIdeal2.port_2, valveH2Purge.port_a) annotation(
    Line(points = {{16, -76}, {-30, -76}}, color = {0, 170, 0}, thickness = 1));
  connect(setPurgeValveState.y, valveH2Purge.opening) annotation(
    Line(points = {{-50, -50}, {-40, -50}, {-40, -68}}, color = {0, 0, 127}));
  connect(valveH2Purge.port_b, exhaustHydrogen.ports[1]) annotation(
    Line(points = {{-50, -76}, {-110, -76}}, color = {0, 170, 0}, thickness = 1));
  connect(teeJunctionIdeal.port_2, port_H2ToStack) annotation(
    Line(points = {{36, 74}, {78, 74}}, color = {0, 170, 0}, thickness = 1));
  connect(teeJunctionIdeal2.port_1, port_StackToH2) annotation(
    Line(points = {{36, -76}, {78, -76}}, color = {0, 170, 0}, thickness = 1));
  connect(recirculationBlower.pin_n, pin_n) annotation(
    Line(points = {{14, -10}, {-14, -10}}, color = {0, 0, 255}));
  connect(pin_p, recirculationBlower.pin_p) annotation(
    Line(points = {{-16, 8}, {14, 8}, {14, 10}}, color = {0, 0, 255}));
  connect(recirculationBlower.Input, sen_H2_mflow.port_b) annotation(
    Line(points = {{26, -16}, {26, -32}}, color = {0, 170, 0}, thickness = 1));
  connect(teeJunctionIdeal.port_3, recirculationBlower.Output) annotation(
    Line(points = {{26, 64}, {26, 16}}, color = {0, 170, 0}, thickness = 1));
  connect(setBlowerSpeed.y, recirculationBlower.controlInterface) annotation(
    Line(points = {{62, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(recirculationBlower.sen_H2_pump_speed, multiplex.u2[1]) annotation(
    Line(points = {{38, 6}, {92, 6}, {92, -16}, {102, -16}}, color = {0, 0, 127}));
  connect(pressureRegulator.Output, teeJunctionIdeal.port_1) annotation(
    Line(points = {{-20, 74}, {16, 74}}, color = {0, 170, 0}, thickness = 1));
  connect(tankHydrogen.ports[1], pressureRegulator.Input) annotation(
    Line(points = {{-108, 74}, {-40, 74}}, color = {0, 170, 0}, thickness = 1));
  connect(setH2Pressure.y, pressureRegulator.setDownstreamPressure) annotation(
    Line(points = {{-26, 32}, {-26, 66}}, color = {0, 0, 127}));
  connect(sensorPressureTank.port, pressureRegulator.Input) annotation(
    Line(points = {{-68, 52}, {-40, 52}, {-40, 74}}));
  connect(sensorPressureHydrogenLine.port, pressureRegulator.Output) annotation(
    Line(points = {{2, 52}, {-20, 52}, {-20, 74}}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1), graphics = {Text(origin = {-32, 90}, extent = {{-14, 4}, {22, -6}}, textString = "Pressure regulator"), Text(origin = {50, 14}, extent = {{-14, 4}, {22, -6}}, textString = "Recirculation blower")}),
    Icon(graphics = {Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-78, 83}, textColor = {255, 255, 255}, extent = {{30, -23}, {128, -141}}, textString = "H2"), Text(origin = {-75, 64}, textColor = {255, 255, 255}, extent = {{-19, 10}, {29, -18}}, textString = "Control"), Text(origin = {-74, -57}, textColor = {255, 255, 255}, extent = {{-28, 7}, {36, -11}}, textString = "Sensors")}, coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The hydrogen sub system provides hydrogen to the<a href=\"modelica://\">&nbsp;</a><a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>.&nbsp;<br><div><br></div><div><br></div><div><div><br></div><div><b>References to base model/related packages</b></div><div><p class=\"MsoNormal\"><o:p></o:p></p><p class=\"MsoNormal\"><a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl\">Subsystem Hydrogen Control</a>, <a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>,&nbsp;and <a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a></p><p class=\"MsoNormal\"><br></p>

<p class=\"MsoNormal\"><b>Description</b><o:p></o:p></p>

<p class=\"MsoNormal\">The compressed hydrogen from the hydrogen tank is depressurised to fuel cell operating pressure with the use of pressure regulator. The unreacted hydrogen is reintroduced to the fuel cell inlet using a recirculation blower. A simplified pruge strategy is also introduced. I<span style=\"font-size: 12px;\">f the fuel cell stack is turned on then the purge valve is opened at regular intervals predefined in the setPurgeValveState block.&nbsp;</span></p><div>The fluid ports connect to the hydrogen interfaces on the fuel cell stack, the electrical ports connect to the low-voltage power supply to provide power to the BoP components, and the control interface connects to the&nbsp;<a href=\"modelica://VirtualFCS.Control.FuelCellSystemControl\">Fuel Cell System Control</a>, which controls the&nbsp;<a href=\"modelica://\">Recirculation Blower</a>.</div>

<p class=\"MsoNormal\"><b><br></b></p><p class=\"MsoNormal\"><b>List of components</b></p><p class=\"MsoNormal\">The model comprises a hydrogen tank, <a href=\"modelica://VirtualFCS.Fluid.PressureRegulator\">Pressure Regulator</a>,&nbsp;<a href=\"modelica://\">Recirculation Blower</a>, and a <a href=\"modelica://Modelica.Fluid.Valves.ValveCompressible\">Purge Valve</a> linked to a fixed ambient boundary condition. The subsystem features 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port.&nbsp;</p>

<p class=\"MsoNormal\"><o:p>&nbsp;</o:p></p>

<!--EndFragment--></div></div></body></html>"));
end SubSystemHydrogen;
