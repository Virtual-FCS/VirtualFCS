within VirtualFCS.ComponentTesting;

model HydrogenSubsystemTEST_simplifiedV2
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15), AbsolutePressure(start = 101325));
  Modelica.Blocks.Sources.Ramp ramp(duration = 50, height = 50, startTime = 25) annotation(
    Placement(visible = true, transformation(origin = {-115, 19}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -114}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-94, -128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -0.00202*1/(96485*2)) annotation(
    Placement(visible = true, transformation(origin = {-132, -92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  VirtualFCS.Fluid.PressureRegulator pressureRegulator annotation(
    Placement(visible = true, transformation(origin = {-34, 84}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-50, 60}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {2, 84}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sensors.Pressure pressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-22, 60}, extent = {{8, -8}, {-8, 8}}, rotation = -180)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 200000) annotation(
    Placement(visible = true, transformation(origin = {-76, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, -42}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Fluid.Machines.PrescribedPump pump(redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.00365}, head_nominal = {150000, 100000}), 
  redeclare package Medium = Medium, 
  N_nominal = 365, 
  V(displayUnit = "l") = 1e-05, 
  allowFlowReversal = false, 
  checkValve = true,
  checkValveHomotopy = Modelica.Fluid.Types.CheckValveHomotopyType.Closed, 
  energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, 
  massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, 
  nParallel = 1, 
  use_N_in = true,
  use_T_start = true) annotation(
    Placement(visible = true, transformation(origin = {18, 16}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression realExpression4(y = 4078)  annotation(
    Placement(visible = true, transformation(origin = {62, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.FixedBoundary boundary1(p = 350000, nPorts = 1, redeclare package Medium = Medium)  annotation(
    Placement(visible = true, transformation(origin = {-86, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(ramp.y, gain.u) annotation(
    Line(points = {{-108, 20}, {-102, 20}, {-102, 0}, {-132, 0}, {-132, -80}}, color = {0, 0, 127}));
  connect(boundary.ports[1], teeJunctionIdeal.port_3) annotation(
    Line(points = {{-84, -128}, {0, -128}, {0, -124}}, color = {0, 127, 255}));
  connect(pressureRegulator.Input, pressure.port) annotation(
    Line(points = {{-44, 84}, {-50, 84}, {-50, 68}}, color = {0, 127, 255}));
  connect(pressureRegulator.Output, teeJunctionIdeal1.port_1) annotation(
    Line(points = {{-24, 84}, {-8, 84}}, color = {0, 127, 255}));
  connect(pressureRegulator.Output, pressure1.port) annotation(
    Line(points = {{-24, 84}, {-22, 84}, {-22, 68}}, color = {0, 127, 255}));
  connect(realExpression1.y, pressureRegulator.setDownstreamPressure) annotation(
    Line(points = {{-64, 44}, {-30, 44}, {-30, 76}}, color = {0, 0, 127}));
  connect(teeJunctionIdeal1.port_2, teeJunctionIdeal.port_1) annotation(
    Line(points = {{12, 84}, {62, 84}, {62, 66}, {112, 66}, {112, -136}, {-26, -136}, {-26, -114}, {-10, -114}}, color = {0, 127, 255}));
  connect(gain.y, boundary.m_flow_in) annotation(
    Line(points = {{-132, -102}, {-132, -120}, {-104, -120}}, color = {0, 0, 127}));
  connect(pump.port_a, massFlowRate.port_b) annotation(
    Line(points = {{18, 6}, {20, 6}, {20, -32}}, color = {0, 127, 255}));
  connect(pump.port_b, teeJunctionIdeal1.port_3) annotation(
    Line(points = {{18, 26}, {2, 26}, {2, 74}}, color = {0, 127, 255}));
  connect(realExpression4.y, pump.N_in) annotation(
    Line(points = {{52, 32}, {40, 32}, {40, 16}, {28, 16}}, color = {0, 0, 127}));
  connect(teeJunctionIdeal.port_2, massFlowRate.port_a) annotation(
    Line(points = {{10, -114}, {20, -114}, {20, -52}}, color = {0, 127, 255}));
  connect(boundary1.ports[1], pressureRegulator.Input) annotation(
    Line(points = {{-76, 84}, {-44, 84}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end HydrogenSubsystemTEST_simplifiedV2;
