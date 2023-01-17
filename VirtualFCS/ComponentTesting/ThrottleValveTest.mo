within VirtualFCS.ComponentTesting;

model ThrottleValveTest "Simple model to test the ThrottleValve model"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable package Medium = Modelica.Media.Air.MoistAir(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  VirtualFCS.Fluid.ThrottleValve throttleValve annotation(
    Placement(visible = true, transformation(origin = {1.77636e-15, -1.77636e-15}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Vessels.ClosedVolume volume(redeclare package Medium = Medium, V = 10, nPorts = 1, p_start = 101325*11, use_T_start = true, use_HeatTransfer = false, use_portsData = false)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 101325*3)  annotation(
    Placement(visible = true, transformation(origin = {36, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(throttleValve.port_b, fixedBoundary.ports[1]) annotation(
    Line(points = {{20, 0}, {40, 0}}, color = {0, 170, 255}, thickness = 2));
  connect(throttleValve.port_a, volume.ports[1]) annotation(
    Line(points = {{-20, 0}, {-60, 0}}, color = {0, 170, 255}, thickness = 2));
  connect(realExpression.y, throttleValve.FC_pAirOut_P) annotation(
    Line(points = {{26, 34}, {0, 34}, {0, 2}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 1000, Interval = 0.5, Tolerance = 1e-6));
end ThrottleValveTest;
