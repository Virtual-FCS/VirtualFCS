within VirtualFCS.ComponentTesting;
model ThrottleValveTest "Simple model to test the ThrottleValve model"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  //replaceable package Medium = Buildings.Media.Air;
  replaceable package Medium = VirtualFCS.Media.CathodeAir;
  VirtualFCS.Fluid.ThrottleValve throttleValve annotation (
    Placement(visible = true, transformation(origin = {1.77636e-15, -1.77636e-15}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1) annotation (
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 101325*3)  annotation (
    Placement(visible = true, transformation(origin = {36, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-46,-32})));
  Modelica.Fluid.Vessels.ClosedVolume closedVolume(
    redeclare package Medium = Medium,
    V=10,
    p_start=101325*10,
    use_HeatTransfer=false,
    use_T_start=true,
    use_portsData=false, nPorts = 1)                                                                                                                                                                           annotation (
    Placement(visible = true, transformation(origin={-84,0},   extent = {{-10, -10}, {10, 10}}, rotation=90)));
equation
  connect(realExpression.y, throttleValve.FC_pAirOut_P) annotation (
    Line(points={{25,34},{0,34},{0,2.8}},      color = {0, 0, 127}));
  connect(throttleValve.downstream, fixedBoundary.ports[1]) annotation(
    Line(points = {{20, 0}, {40, 0}}, color = {0, 127, 255}));
  connect(closedVolume.ports[1], throttleValve.upstream) annotation(
    Line(points = {{-74, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(pressure.port, throttleValve.upstream) annotation(
    Line(points = {{-46, -22}, {-46, 0}, {-20, 0}}, color = {0, 127, 255}));
  connect(pressure.p, throttleValve.Measured_inlet_Air_pressure) annotation(
    Line(points = {{-56, -32}, {-66, -32}, {-66, -12}, {-22, -12}}, color = {0, 0, 127}));
  annotation (
    experiment(StopTime = 1000, Interval = 0.5, Tolerance = 1e-6));
end ThrottleValveTest;
