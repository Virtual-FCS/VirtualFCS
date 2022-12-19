within VirtualFCS.ComponentTesting;

model HydrogenSubsystemTEST_loop1
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15), AbsolutePressure(start = 101325));
  
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Medium, V = 0.13, nPorts = 1, p_start = 101325 * 3, use_T_start = true, use_HeatTransfer = true, use_portsData = false)  annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  VirtualFCS.Fluid.PressureRegulator pressureRegulator annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 200000)  annotation(
    Placement(visible = true, transformation(origin = {-28, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-18, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Pressure pressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {22, -18}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Vessels.ClosedVolume volume1(redeclare package Medium = Medium, V = 0.05, nPorts = 1, p_start = 101325, use_T_start = true, use_HeatTransfer = false, use_portsData = false) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T(displayUnit = "K") = 293.15) annotation(
    Placement(visible = true, transformation(origin = {-64, 92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95*2) annotation(
    Placement(visible = true, transformation(origin = {-82, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {-46, 50}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 12) annotation(
    Placement(visible = true, transformation(origin = {-10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(realExpression.y, pressureRegulator.setDownstreamPressure) annotation(
    Line(points = {{-16, -38}, {4, -38}, {4, -8}}, color = {0, 0, 127}));
  connect(volume.ports[1], pressureRegulator.Input) annotation(
    Line(points = {{-40, 0}, {-10, 0}}, color = {0, 170, 0}, thickness = 2));
  connect(pressure.port, pressureRegulator.Input) annotation(
    Line(points = {{-18, -6}, {-10, -6}, {-10, 0}}, color = {0, 127, 255}));
  connect(pressure1.port, pressureRegulator.Output) annotation(
    Line(points = {{22, -8}, {10, -8}, {10, 0}}, color = {0, 127, 255}));
  connect(volume.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{-60, 20}, {-82, 20}, {-82, 40}}, color = {191, 0, 0}));
  connect(bodyRadiation.port_b, fixedTemperature.port) annotation(
    Line(points = {{-82, 60}, {-64, 60}, {-64, 82}}, color = {191, 0, 0}));
  connect(convection.fluid, fixedTemperature.port) annotation(
    Line(points = {{-46, 60}, {-64, 60}, {-64, 82}}, color = {191, 0, 0}));
  connect(volume.heatPort, convection.solid) annotation(
    Line(points = {{-60, 20}, {-46, 20}, {-46, 40}}, color = {191, 0, 0}));
  connect(convection.Gc, realExpression1.y) annotation(
    Line(points = {{-36, 50}, {-20, 50}}, color = {0, 0, 127}));
  connect(pressureRegulator.Output, massFlowRate.port_a) annotation(
    Line(points = {{10, 0}, {28, 0}}, color = {0, 170, 0}, thickness = 2));
  connect(massFlowRate.port_b, volume1.ports[1]) annotation(
    Line(points = {{48, 0}, {72, 0}}, color = {0, 170, 0}, thickness = 2));
  annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end HydrogenSubsystemTEST_loop1;
