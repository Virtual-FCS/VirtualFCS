within VirtualFCS.ComponentTesting;

model HydrogenSubsystemTEST_withoutControl
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15), AbsolutePressure(start = 101325));
  
  Modelica.Blocks.Sources.Ramp ramp(duration = 50, height = 50, startTime = 100)  annotation(
    Placement(visible = true, transformation(origin = {-115, 19}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -114}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-94, -128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -0.00202*1/(96485*2))  annotation(
    Placement(visible = true, transformation(origin = {-132, -92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Medium, V = 0.13, nPorts = 1, p_start = 35000000, use_HeatTransfer = true, use_portsData = false)  annotation(
    Placement(visible = true, transformation(origin = {-80, 84}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {-62, 112}, extent = {{-8, 8}, {8, -8}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * 2) annotation(
    Placement(visible = true, transformation(origin = {-93, 111}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T(displayUnit = "K") = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {-126, 138}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 12)  annotation(
    Placement(visible = true, transformation(origin = {-24, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Fluid.PressureRegulator pressureRegulator annotation(
    Placement(visible = true, transformation(origin = {-34, 84}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-50, 60}, extent = {{-8, -8}, {8, 8}}, rotation = 180)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {2, 84}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sensors.Pressure pressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-22, 60}, extent = {{8, -8}, {-8, 8}}, rotation = -180)));
  VirtualFCS.Fluid.RecirculationBlower recirculationBlower annotation(
    Placement(visible = true, transformation(origin = {21, -1}, extent = {{-17, -17}, {17, 17}}, rotation = 90)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {-8, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 200000)  annotation(
    Placement(visible = true, transformation(origin = {-76, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation(
    Placement(visible = true, transformation(origin = {82, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, -42}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, -82}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Valves.ValveCompressible valveCompressible(redeclare package Medium = Medium, allowFlowReversal = true, checkValve = true, dp_nominal(displayUnit = "Pa") = 10000, m_flow(fixed = false), m_flow_nominal = 0.001, m_flow_small = 0, p_nominal = 2.5 * 100000) annotation(
    Placement(visible = true, transformation(origin = {-18, -82}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = x)  annotation(
    Placement(visible = true, transformation(origin = {-38, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium = Medium, T = 293.15, nPorts = 1, p = 101325, use_T_in = false)  annotation(
    Placement(visible = true, transformation(origin = {-80, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = 20)  annotation(
    Placement(visible = true, transformation(origin = {48, 24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Real x;
equation
  
  if (time >=40 and time <= 40.05) or (time >=80 and time <= 80.05) then
    x = 0.01;
  else
    x = 0;
  end if;
  
  connect(ramp.y, gain.u) annotation(
    Line(points = {{-108, 20}, {-102, 20}, {-102, 0}, {-132, 0}, {-132, -80}}, color = {0, 0, 127}));
  connect(boundary.ports[1], teeJunctionIdeal.port_3) annotation(
    Line(points = {{-84, -128}, {0, -128}, {0, -124}}, color = {0, 127, 255}));
  connect(volume.heatPort, convection.solid) annotation(
    Line(points = {{-80, 94}, {-80, 100}, {-62, 100}, {-62, 104}}, color = {191, 0, 0}));
  connect(volume.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{-80, 94}, {-80, 100}, {-92, 100}, {-92, 104}}, color = {191, 0, 0}));
  connect(convection.fluid, fixedTemperature.port) annotation(
    Line(points = {{-62, 120}, {-62, 138}, {-116, 138}}, color = {191, 0, 0}));
  connect(bodyRadiation.port_b, fixedTemperature.port) annotation(
    Line(points = {{-92, 118}, {-94, 118}, {-94, 138}, {-116, 138}}, color = {191, 0, 0}));
  connect(realExpression.y, convection.Gc) annotation(
    Line(points = {{-34, 112}, {-54, 112}}, color = {0, 0, 127}));
  connect(volume.ports[1], pressureRegulator.Input) annotation(
    Line(points = {{-70, 84}, {-44, 84}}, color = {0, 127, 255}));
  connect(pressureRegulator.Input, pressure.port) annotation(
    Line(points = {{-44, 84}, {-50, 84}, {-50, 68}}, color = {0, 127, 255}));
  connect(pressureRegulator.Output, teeJunctionIdeal1.port_1) annotation(
    Line(points = {{-24, 84}, {-8, 84}}, color = {0, 127, 255}));
  connect(pressureRegulator.Output, pressure1.port) annotation(
    Line(points = {{-24, 84}, {-22, 84}, {-22, 68}}, color = {0, 127, 255}));
  connect(recirculationBlower.Output, teeJunctionIdeal1.port_3) annotation(
    Line(points = {{22, 14}, {2, 14}, {2, 74}}, color = {0, 127, 255}));
  connect(batterySystem.pin_p, recirculationBlower.pin_p) annotation(
    Line(points = {{2, 4}, {10, 4}, {10, 8}}, color = {0, 0, 255}));
  connect(batterySystem.pin_n, recirculationBlower.pin_n) annotation(
    Line(points = {{2, -4}, {10, -4}, {10, -10}}, color = {0, 0, 255}));
  connect(realExpression1.y, pressureRegulator.setDownstreamPressure) annotation(
    Line(points = {{-64, 44}, {-30, 44}, {-30, 76}}, color = {0, 0, 127}));
  connect(recirculationBlower.sen_H2_pump_speed, multiplex2.u1[1]) annotation(
    Line(points = {{32, 4}, {62, 4}, {62, -16}, {70, -16}}, color = {0, 0, 127}));
  connect(massFlowRate.port_b, recirculationBlower.Input) annotation(
    Line(points = {{20, -32}, {20, -24}, {22, -24}, {22, -16}}, color = {0, 127, 255}));
  connect(massFlowRate.m_flow, multiplex2.u2[1]) annotation(
    Line(points = {{32, -42}, {56, -42}, {56, -28}, {70, -28}}, color = {0, 0, 127}));
  connect(massFlowRate.port_a, teeJunctionIdeal2.port_3) annotation(
    Line(points = {{20, -52}, {20, -72}}, color = {0, 127, 255}));
  connect(teeJunctionIdeal2.port_2, valveCompressible.port_a) annotation(
    Line(points = {{10, -82}, {-8, -82}}, color = {0, 127, 255}));
  connect(realExpression3.y, valveCompressible.opening) annotation(
    Line(points = {{-26, -60}, {-18, -60}, {-18, -74}}, color = {0, 0, 127}));
  connect(valveCompressible.port_b, boundary1.ports[1]) annotation(
    Line(points = {{-28, -82}, {-70, -82}}, color = {0, 127, 255}));
  connect(teeJunctionIdeal2.port_1, teeJunctionIdeal.port_2) annotation(
    Line(points = {{30, -82}, {38, -82}, {38, -114}, {10, -114}}, color = {0, 127, 255}));
  connect(teeJunctionIdeal1.port_2, teeJunctionIdeal.port_1) annotation(
    Line(points = {{12, 84}, {62, 84}, {62, 66}, {112, 66}, {112, -136}, {-26, -136}, {-26, -114}, {-10, -114}}, color = {0, 127, 255}));
  connect(gain.y, boundary.m_flow_in) annotation(
    Line(points = {{-132, -102}, {-132, -120}, {-104, -120}}, color = {0, 0, 127}));
  connect(realExpression2.y, recirculationBlower.control) annotation(
    Line(points = {{48, 14}, {48, -6}, {32, -6}}, color = {0, 0, 127}));
  annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end HydrogenSubsystemTEST_withoutControl;