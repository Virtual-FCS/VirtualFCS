within VirtualFCS.ComponentTesting;

model HydrogenSubsystemTEST_simplifiedV6
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15), AbsolutePressure(start = 101325));
    
  Modelica.Blocks.Sources.Ramp ramp(duration = 50, height = 50, startTime = 100)  annotation(
    Placement(visible = true, transformation(origin = {-115, 19}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  inner Modelica.Fluid.System system(p_ambient (displayUnit = "Pa"))  annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -114}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-94, -128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -0.00202*1/(96485*2))  annotation(
    Placement(visible = true, transformation(origin = {-132, -92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Medium, V = 0.13, nPorts = 1, p_start = 35000000, use_HeatTransfer = true, use_portsData = false)  annotation(
    Placement(visible = true, transformation(origin = {-78, 84}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {-60, 112}, extent = {{-8, 8}, {8, -8}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * 2) annotation(
    Placement(visible = true, transformation(origin = {-91, 111}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T(displayUnit = "K") = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {-128, 126}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 12)  annotation(
    Placement(visible = true, transformation(origin = {-22, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
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
  Modelica.Blocks.Sources.RealExpression realExpression1(y = deMultiplex3.y1[1])  annotation(
    Placement(visible = true, transformation(origin = {-68, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = deMultiplex3.y3[1])  annotation(
    Placement(visible = true, transformation(origin = {48, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation(
    Placement(visible = true, transformation(origin = {82, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = Medium, allowFlowReversal = true) annotation(
    Placement(visible = true, transformation(origin = {20, -42}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, -82}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Valves.ValveCompressible valveCompressible(redeclare package Medium = Medium, allowFlowReversal = true, checkValve = true, dp_nominal(displayUnit = "Pa") = 10000, m_flow_nominal = 0.001, m_flow_small = 0, p_nominal = 2.5 * 100000) annotation(
    Placement(visible = true, transformation(origin = {-18, -82}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = deMultiplex3.y2[1])  annotation(
    Placement(visible = true, transformation(origin = {-38, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium = Medium, T = 293.15, nPorts = 1, p = 101325, use_T_in = false)  annotation(
    Placement(visible = true, transformation(origin = {-80, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Routing.DeMultiplex3 deMultiplex3 annotation(
    Placement(visible = true, transformation(origin = {-34, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SubSystems.Hydrogen.SubSystemHydrogenControl subSystemHydrogenControl(pressure_H2_set = 200000) annotation(
    Placement(visible = true, transformation(origin = {-68, 6}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  VirtualFCS.Fluid.PressureRegulator_testNew pressureRegulator_testNew annotation(
    Placement(visible = true, transformation(origin = {-38, 84}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
equation
  connect(ramp.y, gain.u) annotation(
    Line(points = {{-108, 20}, {-102, 20}, {-102, 0}, {-132, 0}, {-132, -80}}, color = {0, 0, 127}));
  connect(boundary.ports[1], teeJunctionIdeal.port_3) annotation(
    Line(points = {{-84, -128}, {0, -128}, {0, -124}}, color = {0, 127, 255}));
  connect(volume.heatPort, convection.solid) annotation(
    Line(points = {{-78, 94}, {-78, 100}, {-60, 100}, {-60, 104}}, color = {191, 0, 0}));
  connect(volume.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{-78, 94}, {-78, 100}, {-90, 100}, {-90, 104}}, color = {191, 0, 0}));
  connect(convection.fluid, fixedTemperature.port) annotation(
    Line(points = {{-60, 120}, {-60, 126}, {-118, 126}}, color = {191, 0, 0}));
  connect(bodyRadiation.port_b, fixedTemperature.port) annotation(
    Line(points = {{-91, 118}, {-93, 118}, {-93, 126}, {-118, 126}}, color = {191, 0, 0}));
  connect(realExpression.y, convection.Gc) annotation(
    Line(points = {{-33, 112}, {-53, 112}}, color = {0, 0, 127}));
  connect(batterySystem.pin_p, recirculationBlower.pin_p) annotation(
    Line(points = {{2, 4}, {10, 4}, {10, 8}}, color = {0, 0, 255}));
  connect(batterySystem.pin_n, recirculationBlower.pin_n) annotation(
    Line(points = {{2, -4}, {10, -4}, {10, -10}}, color = {0, 0, 255}));
  connect(realExpression2.y, recirculationBlower.control) annotation(
    Line(points = {{38, -14}, {32, -14}, {32, -6}}, color = {0, 0, 127}));
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
  connect(multiplex2.y, subSystemHydrogenControl.signalInterface_H2) annotation(
    Line(points = {{94, -22}, {136, -22}, {136, -144}, {-164, -144}, {-164, -4}, {-88, -4}}, color = {0, 0, 127}, thickness = 0.5));
  connect(subSystemHydrogenControl.controlInterface, deMultiplex3.u) annotation(
    Line(points = {{-50, 6}, {-46, 6}, {-46, 20}}, color = {0, 0, 127}, thickness = 0.5));
  connect(ramp.y, subSystemHydrogenControl.signalInterface_FC) annotation(
    Line(points = {{-108, 20}, {-88, 20}, {-88, 16}}, color = {0, 0, 127}));
  connect(gain.y, boundary.m_flow_in) annotation(
    Line(points = {{-132, -102}, {-132, -120}, {-104, -120}}, color = {0, 0, 127}));
  connect(recirculationBlower.Output, teeJunctionIdeal1.port_3) annotation(
    Line(points = {{22, 14}, {20, 14}, {20, 48}, {2, 48}, {2, 74}}, color = {0, 127, 255}));
  connect(volume.ports[1], pressureRegulator_testNew.Input) annotation(
    Line(points = {{-68, 84}, {-48, 84}}, color = {0, 127, 255}));
  connect(pressureRegulator_testNew.Output, teeJunctionIdeal1.port_1) annotation(
    Line(points = {{-28, 84}, {-8, 84}}, color = {0, 127, 255}));
  connect(pressure1.port, pressureRegulator_testNew.Output) annotation(
    Line(points = {{-22, 68}, {-22, 84}, {-28, 84}}, color = {0, 127, 255}));
  connect(pressure.port, pressureRegulator_testNew.Input) annotation(
    Line(points = {{-50, 68}, {-50, 84}, {-48, 84}}, color = {0, 127, 255}));
  connect(realExpression1.y, pressureRegulator_testNew.setDownstreamPressure) annotation(
    Line(points = {{-56, 42}, {-34, 42}, {-34, 76}}, color = {0, 0, 127}));
  annotation (experiment(StopTime = 600, Interval = 0.25, Tolerance = 1e-6));
end HydrogenSubsystemTEST_simplifiedV6;
