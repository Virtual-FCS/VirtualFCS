within VirtualFCS.ComponentTesting;

model PressureRegulatorTest "Simple model to test the PressureRegulator model"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  VirtualFCS.Fluid.PressureRegulator pressureRegulator annotation(
    Placement(visible = true, transformation(origin = {2.66454e-15, -2.66454e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Medium, V = 0.13, nPorts = 1, p_start = 35000000, use_HeatTransfer = true, use_T_start = true, use_portsData = false) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 101325*2) annotation(
    Placement(visible = true, transformation(origin = {46, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Vessels.ClosedVolume closedVolume(redeclare package Medium = Medium, V = 10, nPorts = 1, p_start = 101325*2, use_HeatTransfer = false, use_T_start = true, use_portsData = false) annotation(
    Placement(visible = true, transformation(origin = {64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-20, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Pressure pressure1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {20, -40}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95*2)  annotation(
    Placement(visible = true, transformation(origin = {-90, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {-50, 30}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 12)  annotation(
    Placement(visible = true, transformation(origin = {-18, 54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T(displayUnit = "K") = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(realExpression.y, pressureRegulator.setDownstreamPressure) annotation(
    Line(points = {{35, 44}, {8, 44}, {8, 14}}, color = {0, 0, 127}));
  connect(pressureRegulator.Output, closedVolume.ports[1]) annotation(
    Line(points = {{20, 0}, {54, 0}}, color = {0, 170, 0}, thickness = 1));
  connect(pressureRegulator.Input, pressure.port) annotation(
    Line(points = {{-20, 0}, {-20, -30}}, color = {0, 127, 255}));
  connect(pressureRegulator.Output, pressure1.port) annotation(
    Line(points = {{20, 0}, {20, -30}}, color = {0, 127, 255}));
  connect(volume.ports[1], pressureRegulator.Input) annotation(
    Line(points = {{-60, 0}, {-20, 0}}, color = {0, 170, 0}, thickness = 1));
  connect(volume.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{-70, 10}, {-70, 14}, {-90, 14}, {-90, 20}}, color = {191, 0, 0}));
  connect(volume.heatPort, convection.solid) annotation(
    Line(points = {{-70, 10}, {-70, 14}, {-50, 14}, {-50, 20}}, color = {191, 0, 0}));
  connect(convection.fluid, fixedTemperature.port) annotation(
    Line(points = {{-50, 40}, {-50, 44}, {-70, 44}, {-70, 50}}, color = {191, 0, 0}));
  connect(bodyRadiation.port_b, fixedTemperature.port) annotation(
    Line(points = {{-90, 40}, {-90, 44}, {-70, 44}, {-70, 50}}, color = {191, 0, 0}));
  connect(realExpression1.y, convection.Gc) annotation(
    Line(points = {{-18, 44}, {-18, 30}, {-40, 30}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 100, Interval = 0.5, Tolerance = 1e-6));
end PressureRegulatorTest;
