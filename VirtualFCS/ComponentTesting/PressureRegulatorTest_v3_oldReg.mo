within VirtualFCS.ComponentTesting;

model PressureRegulatorTest_v3_oldReg "Model to test the recirculation blower component"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15), AbsolutePressure(start = 101325));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Medium, V = 0.13, nPorts = 1, p_start = 70000000, use_HeatTransfer = true, use_T_start = true, use_portsData = false) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 101325*2) annotation(
    Placement(visible = true, transformation(origin = {46, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Vessels.ClosedVolume closedVolume(redeclare package Medium = Medium, V = 0.2, nPorts = 1, p_start = 101325*2, use_HeatTransfer = false, use_T_start = true, use_portsData = false) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
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
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, nPorts = 1, use_m_flow_in = true)  annotation(
    Placement(visible = true, transformation(origin = {60, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain(k = -0.00202*1/(96485*2))  annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 500, f = 0.1, offset = 225, startTime = 25)  annotation(
    Placement(visible = true, transformation(origin = {-44, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Fluid.PressureRegulator_old pressureRegulator_old annotation(
    Placement(visible = true, transformation(origin = {-1.77636e-15, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
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
  connect(teeJunctionIdeal.port_2, closedVolume.ports[1]) annotation(
    Line(points = {{70, 0}, {100, 0}}, color = {0, 170, 0}, thickness = 2));
  connect(teeJunctionIdeal.port_3, boundary.ports[1]) annotation(
    Line(points = {{60, -10}, {60, -38}}, color = {0, 170, 0}, thickness = 2));
  connect(gain.y, boundary.m_flow_in) annotation(
    Line(points = {{32, -80}, {52, -80}, {52, -58}}, color = {0, 0, 127}));
  connect(sine.y, gain.u) annotation(
    Line(points = {{-32, -80}, {8, -80}}, color = {0, 0, 127}));
  connect(realExpression.y, pressureRegulator_old.setDownstreamPressure) annotation(
    Line(points = {{36, 44}, {8, 44}, {8, 14}}, color = {0, 0, 127}));
  connect(pressureRegulator_old.Input, volume.ports[1]) annotation(
    Line(points = {{-20, 0}, {-60, 0}}, color = {0, 170, 0}, thickness = 2));
  connect(pressure.port, pressureRegulator_old.Input) annotation(
    Line(points = {{-20, -30}, {-20, 0}}));
  connect(pressure1.port, pressureRegulator_old.Output) annotation(
    Line(points = {{20, -30}, {20, 0}}));
  connect(pressureRegulator_old.Output, teeJunctionIdeal.port_1) annotation(
    Line(points = {{20, 0}, {50, 0}}, color = {0, 170, 0}, thickness = 2));
  annotation(
    experiment(StopTime = 2000, Interval = 0.5, Tolerance = 1e-6));
end PressureRegulatorTest_v3_oldReg;
