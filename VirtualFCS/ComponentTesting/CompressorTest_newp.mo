within VirtualFCS.ComponentTesting;
model CompressorTest_newp "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air(reference_X={0.01,0.99});
Modelica.Fluid.Sources.FixedBoundary AirSink(redeclare package Medium = Medium,
    p=250000,
      nPorts=1)                                                                                         annotation (
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Fluid.Sources.FixedBoundary AirSink2(redeclare package Medium = Medium,
      nPorts=1)                                                                              annotation (
    Placement(visible = true, transformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(
    V_min_bat_pack=400,
    V_nom_bat_pack=440,
    V_max_bat_pack=480,
    SOC_init=0.9)                                              annotation (
    Placement(visible = true, transformation(origin={3,59},    extent={{13,-13},
            {-13,13}},                                                                          rotation = -180)));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=1,
    f=0.1,
    offset=100,
    startTime=0)                                                                            annotation (
    Placement(visible = true, transformation(origin = {-70, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Fluid.Compressor_newp compressor
    annotation (Placement(transformation(extent={{-16,-18},{20,18}})));
equation
  connect(AirSink.ports[1], compressor.Input)
    annotation (Line(points={{-70,0},{-17.8,0}}, color={0,127,255}));
  connect(compressor.Output, AirSink2.ports[1]) annotation (Line(points={{
          21.8,0},{38.9,0},{38.9,6.66134e-16},{56,6.66134e-16}}, color={0,127,
          255}));
  connect(compressor.pin_n, batterySystem.pin_n) annotation (Line(points={{-0.88,
          10.8},{-0.88,12},{-2.72,12},{-2.72,46.52}},
                                                  color={0,0,255}));
  connect(batterySystem.pin_p, compressor.pin_p) annotation (Line(points={{8.72,
          46.52},{8.72,10},{5.6,10},{5.6,10.8}},    color={0,0,255}));
  connect(sine1.y, compressor.controlInterface) annotation (Line(points={{
          -59,34},{-28,34},{-28,10.98},{-18.34,10.98}}, color={0,0,127}));
annotation (
  experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,80}})));
end CompressorTest_newp;
