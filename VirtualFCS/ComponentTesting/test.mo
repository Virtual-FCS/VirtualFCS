within VirtualFCS.ComponentTesting;
model test "Simple model to test the ThrottleValve model"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //replaceable package Medium = Modelica.Media.Air.MoistAir(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air;
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium,
      nPorts=1)                                                                                     annotation (
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Vessels.ClosedVolume closedVolume(
    redeclare package Medium = Medium,
    V=10,
    p_start=101325*10,
    use_HeatTransfer=false,
    use_T_start=true,
    use_portsData=false,
    nPorts=1)                                                                                                                                                                                      annotation (
    Placement(visible = true, transformation(origin={-68,0},   extent = {{-10, -10}, {10, 10}}, rotation=90)));
equation
  connect(closedVolume.ports[1], fixedBoundary.ports[1])
    annotation (Line(points={{-58,0},{40,0}}, color={0,127,255}));
  annotation (
    experiment(StopTime = 1000, Interval = 0.5, Tolerance = 1e-6));
end test;
