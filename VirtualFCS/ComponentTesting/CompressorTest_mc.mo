within VirtualFCS.ComponentTesting;
model CompressorTest_mc "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air(reference_X={0.01,0.99});
Modelica.Fluid.Sources.FixedBoundary AirSink(redeclare package Medium = Medium,
    use_p=false,
    use_T=false,
      nPorts=1)                                                                                         annotation (
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Fluid.Sources.FixedBoundary AirSink2(redeclare package Medium = Medium,
    use_p=true,
    p=200000,
    use_T=false,
      nPorts=1)                                                                              annotation (
    Placement(visible = true, transformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(
    V_min_bat_pack=400,
    V_nom_bat_pack=440,
    V_max_bat_pack=480,
    SOC_init=0.9)                                              annotation (
    Placement(visible = true, transformation(origin={3,59},    extent={{13,-13},
            {-13,13}},                                                                          rotation = -180)));
  Fluid.Compressor_mc compressor_mc(m_flow_nominal=0.3)
    annotation (Placement(transformation(extent={{-14,-16},{20,18}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=0.12,
    rising=10,
    width=2,
    falling=5,
    period=25,
    nperiod=25,
    offset=0.05,
    startTime=0)
    annotation (Placement(transformation(extent={{-70,48},{-50,68}})));
equation
  connect(compressor_mc.Output, AirSink2.ports[1]) annotation (Line(points={{
          21.7,1},{22,1},{22,6.66134e-16},{56,6.66134e-16}}, color={0,127,255}));
  connect(compressor_mc.Input, AirSink.ports[1]) annotation (Line(points={{
          -15.7,1},{-20,1},{-20,0},{-70,0}}, color={0,127,255}));
  connect(compressor_mc.pin_n, batterySystem.pin_n) annotation (Line(points={{
          0.28,11.2},{0.28,28.86},{-2.72,28.86},{-2.72,46.52}}, color={0,0,255}));
  connect(compressor_mc.pin_p, batterySystem.pin_p) annotation (Line(points={{
          6.4,11.2},{6.4,46.52},{8.72,46.52}}, color={0,0,255}));
  connect(trapezoid.y, compressor_mc.controlInterface) annotation (Line(points=
          {{-49,58},{-24,58},{-24,11.37},{-16.21,11.37}}, color={0,0,127}));
annotation (
  experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,80}})));
end CompressorTest_mc;
