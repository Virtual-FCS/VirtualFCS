within VirtualFCS.ComponentTesting;

model HydrogenSubsystemTEST_simplifiedV1
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15), AbsolutePressure(start = 101325));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, -42}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = 0) annotation(
    Placement(visible = true, transformation(origin = {52, 32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
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
  connect(batterySystem.pin_p, recirculationBlower.pin_p) annotation(
    Line(points = {{2, 4}, {10, 4}, {10, 8}}, color = {0, 0, 255}));
  connect(batterySystem.pin_n, recirculationBlower.pin_n) annotation(
    Line(points = {{2, -4}, {10, -4}, {10, -10}}, color = {0, 0, 255}));
  connect(realExpression1.y, pressureRegulator.setDownstreamPressure) annotation(
    Line(points = {{-64, 44}, {-30, 44}, {-30, 76}}, color = {0, 0, 127}));
  connect(massFlowRate.port_b, recirculationBlower.Input) annotation(
    Line(points = {{20, -32}, {20, -24}, {22, -24}, {22, -16}}, color = {0, 127, 255}));
  connect(realExpression2.y, recirculationBlower.control) annotation(
    Line(points = {{52, 22}, {52, -6}, {32, -6}}, color = {0, 0, 127}));
  connect(teeJunctionIdeal1.port_2, massFlowRate.port_a) annotation(
    Line(points = {{12, 84}, {70, 84}, {70, 62}, {112, 62}, {112, -80}, {20, -80}, {20, -52}}, color = {0, 127, 255}));
  connect(recirculationBlower.Output, teeJunctionIdeal1.port_3) annotation(
    Line(points = {{22, 14}, {2, 14}, {2, 74}}, color = {0, 127, 255}));
  annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end HydrogenSubsystemTEST_simplifiedV1;
