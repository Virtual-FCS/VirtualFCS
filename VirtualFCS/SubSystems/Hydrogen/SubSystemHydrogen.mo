within VirtualFCS.SubSystems.Hydrogen;

model SubSystemHydrogen
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  // Parameter definition
  parameter Real Tank_Volume = 0.13 "Volume of the tank";
  parameter Real Tank_Pressure = 3500000 "Initial pressure";
  //*** INSTANTIATE COMPONENTS ***//
  // System
  // Interfaces and boundaries
  Modelica.Fluid.Sources.Boundary_pT exhaustHydrogen(redeclare package Medium = Anode_Medium, T = 293.15, nPorts = 1, p = 101325) annotation(
    Placement(visible = true, transformation(origin = {-120, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_H2ToStack(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {79, 74}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {118, 60}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_StackToH2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {77, -76}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {118, -57}, extent = {{-18, -19}, {18, 19}}, rotation = 0)));
  // Vessels
  Modelica.Fluid.Vessels.ClosedVolume tankHydrogen(redeclare package Medium = Anode_Medium, V = Tank_Volume, nPorts = 1, p_start = Tank_Pressure, use_HeatTransfer = false, use_portsData = false) annotation(
    Placement(visible = true, transformation(origin = {-117, 74}, extent = {{17, -17}, {-17, 17}}, rotation = 90)));
  // Machines
  // Valves
  VirtualFCS.Fluid.PressureRegulator pressureRegulatorHydrogenTank annotation(
    Placement(visible = true, transformation(origin = {-30, 74}, extent = {{-16, 16}, {16, -16}}, rotation = 0)));
  Modelica.Fluid.Valves.ValveCompressible valveH2Purge(redeclare package Medium = Anode_Medium, allowFlowReversal = true, checkValve = true, dp_nominal(displayUnit = "Pa") = 10000, m_flow(fixed = false), m_flow_nominal = 0.001, m_flow_small = 0, p_nominal = 2.5 * 100000) annotation(
    Placement(visible = true, transformation(origin = {-34, -76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Other
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {26, 74}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {26, -76}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Pressure sensorPressureTank(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-72, 42}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Pressure sensorPressureHydrogenLine(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 42}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  VirtualFCS.Fluid.RecirculationBlower recirculationBlower annotation(
    Placement(visible = true, transformation(origin = {26, -2}, extent = {{-18, -18}, {18, 18}}, rotation = 90)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {132, 86}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput control annotation(
    Placement(visible = true, transformation(origin = {-147, 0}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-16, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-15, -11}, extent = {{11, 11}, {-11, -11}}, rotation = 0), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation(
    Placement(visible = true, transformation(origin = {138, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex(n1 = 1, n2 = 1) annotation(
    Placement(visible = true, transformation(origin = {112, -21}, extent = {{-8, 8}, {8, -8}}, rotation = 0)));
  Modelica.Fluid.Sensors.MassFlowRate sen_H2_mflow(redeclare package Medium = Anode_Medium, m_flow_nominal = 1e-5, m_flow_small = 1e-7) annotation(
    Placement(visible = true, transformation(origin = {26, -43}, extent = {{-11, 11}, {11, -11}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression setH2Pressure(y = controlSignals.y1[1]) annotation(
    Placement(visible = true, transformation(origin = {-38, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setPurgeValveState(y = controlSignals.y2[1]) annotation(
    Placement(visible = true, transformation(origin = {-62, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setBlowerSpeed(y = controlSignals.y3[1]) annotation(
    Placement(visible = true, transformation(origin = {70, -8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogenControl subSystemHydrogenControl(pressure_H2_set = 200000) annotation(
    Placement(visible = true, transformation(origin = {-98, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Routing.DeMultiplex3 controlSignals annotation(
    Placement(visible = true, transformation(origin = {-56, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(sensors, multiplex.y) annotation(
    Line(points = {{138, -1}, {122.5, -1}, {122.5, -21}, {121, -21}}, color = {0, 0, 127}));
  connect(teeJunctionIdeal.port_2, port_H2ToStack) annotation(
    Line(points = {{36, 74}, {79, 74}}, color = {255, 0, 0}, thickness = 1));
  connect(teeJunctionIdeal2.port_1, port_StackToH2) annotation(
    Line(points = {{36, -76}, {77, -76}}, color = {255, 0, 0}, thickness = 1));
  connect(teeJunctionIdeal2.port_3, sen_H2_mflow.port_a) annotation(
    Line(points = {{26, -66}, {26, -54}}, color = {255, 0, 0}, thickness = 1));
  connect(valveH2Purge.port_b, exhaustHydrogen.ports[1]) annotation(
    Line(points = {{-44, -76}, {-110, -76}}, color = {255, 0, 0}, thickness = 1));
  connect(valveH2Purge.port_a, teeJunctionIdeal2.port_2) annotation(
    Line(points = {{-24, -76}, {16, -76}, {16, -76}, {16, -76}}, color = {255, 0, 0}, thickness = 1));
  connect(tankHydrogen.ports[1], pressureRegulatorHydrogenTank.Input) annotation(
    Line(points = {{-100, 74}, {-46, 74}}, color = {255, 0, 0}, thickness = 1));
  connect(sensorPressureTank.port, pressureRegulatorHydrogenTank.Input) annotation(
    Line(points = {{-72, 52}, {-46, 52}, {-46, 74}}, color = {255, 0, 0}, thickness = 1));
  connect(pressureRegulatorHydrogenTank.Output, teeJunctionIdeal.port_1) annotation(
    Line(points = {{-14, 74}, {16, 74}, {16, 74}, {16, 74}}, color = {0, 127, 255}));
  connect(pressureRegulatorHydrogenTank.Output, sensorPressureHydrogenLine.port) annotation(
    Line(points = {{-14, 74}, {0, 74}, {0, 52}}, color = {0, 127, 255}));
  connect(setH2Pressure.y, pressureRegulatorHydrogenTank.setDownstreamPressure) annotation(
    Line(points = {{-27, 32}, {-24, 32}, {-24, 62}}, color = {0, 0, 127}));
  connect(setPurgeValveState.y, valveH2Purge.opening) annotation(
    Line(points = {{-50, -50}, {-34, -50}, {-34, -68}, {-34, -68}}, color = {0, 0, 127}));
  connect(sen_H2_mflow.m_flow, multiplex.u1[1]) annotation(
    Line(points = {{38, -42}, {60, -42}, {60, -26}, {102, -26}}, color = {0, 0, 127}));
  connect(recirculationBlower.Output, teeJunctionIdeal.port_3) annotation(
    Line(points = {{26, 14}, {26, 64}}, color = {0, 127, 255}));
  connect(recirculationBlower.Input, sen_H2_mflow.port_b) annotation(
    Line(points = {{26, -18}, {26, -32}}, color = {0, 127, 255}));
  connect(pin_p, recirculationBlower.pin_p) annotation(
    Line(points = {{-16, 8}, {14, 8}}, color = {0, 0, 255}));
  connect(pin_n, recirculationBlower.pin_n) annotation(
    Line(points = {{-15, -11}, {12, -11}, {12, -10}, {14, -10}}, color = {0, 0, 255}));
  connect(recirculationBlower.sen_H2_pump_speed, multiplex.u2[1]) annotation(
    Line(points = {{38, 4}, {102, 4}, {102, -16}}, color = {0, 0, 127}));
  connect(setBlowerSpeed.y, recirculationBlower.control) annotation(
    Line(points = {{59, -8}, {38, -8}}, color = {0, 0, 127}));
  connect(control, subSystemHydrogenControl.signalInterface_FC) annotation(
    Line(points = {{-146, 0}, {-122, 0}, {-122, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(subSystemHydrogenControl.controlInterface, controlSignals.u) annotation(
    Line(points = {{-76, -12}, {-68, -12}, {-68, -12}, {-68, -12}}, color = {0, 0, 127}, thickness = 0.5));
  connect(sensors, subSystemHydrogenControl.signalInterface_H2) annotation(
    Line(points = {{138, -1}, {146, -1}, {146, -96}, {-144, -96}, {-144, -24}, {-120, -24}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1), graphics = {Text(origin = {-32, 90}, extent = {{-14, 4}, {22, -6}}, textString = "Pressure regulator"), Text(origin = {50, 14}, extent = {{-14, 4}, {22, -6}}, textString = "Recirculation blower")}),
    Icon(graphics = {Rectangle(fillColor = {255, 85, 127}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-78, 83}, extent = {{30, -23}, {128, -141}}, textString = "H2"), Text(origin = {-74, -57}, extent = {{-28, 7}, {36, -11}}, textString = "Sensors"), Text(origin = {-75, 64}, extent = {{-19, 10}, {29, -18}}, textString = "Control")}, coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    version = "");
end SubSystemHydrogen;
