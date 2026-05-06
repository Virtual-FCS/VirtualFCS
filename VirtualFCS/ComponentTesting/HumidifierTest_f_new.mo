within VirtualFCS.ComponentTesting;

model HumidifierTest_f_new
extends Modelica.Icons.Example;
  replaceable package dry_medium = VirtualFCS.Media.CathodeAir;
  replaceable package wet_medium = VirtualFCS.Media.CathodeAir;
  Modelica.Fluid.Sources.MassFlowSource_T dry_air_source(redeclare package Medium = dry_medium, m_flow = 0.4e-3, nPorts = 1, X = {0.245, 0.75, 0.005}, T = 353.15) annotation(
    Placement(transformation(origin = {32, 0}, extent = {{-120, -10}, {-100, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T wet_air_source(redeclare package Medium = wet_medium, m_flow = 0.4e-3, nPorts = 1, X = {0.24, 0.75, 0.01}, T = 333.15) annotation(
    Placement(transformation(origin = {0, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Fluid.Sources.FixedBoundary dry_air_sink(redeclare package Medium = dry_medium, nPorts = 1, p = 1.5e5) annotation(
    Placement(transformation(origin = {76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sources.FixedBoundary wet_air_sink(redeclare package Medium = wet_medium, nPorts = 1, p = 1.5e5) annotation(
    Placement(transformation(origin = {-78, -60}, extent = {{-28, -88}, {-8, -68}}, rotation = 90)));
  Fluid.Humidifier humidifier(redeclare package dry_medium = dry_medium, redeclare package wet_medium = wet_medium) annotation(
    Placement(transformation(origin = {0, -1}, extent = {{-18, -17}, {18, 17}})));
equation
  connect(dry_air_source.ports[1], humidifier.portB_in) annotation(
    Line(points = {{-68, 0}, {-18, 0}}, color = {0, 127, 255}, thickness = 0.75));
  connect(wet_air_source.ports[1], humidifier.portA_in) annotation(
    Line(points = {{0, 46}, {0, 16}}, color = {0, 127, 255}, thickness = 0.75));
  connect(humidifier.portB_out, dry_air_sink.ports[1]) annotation(
    Line(points = {{18, 0}, {66, 0}}, color = {0, 127, 255}));
  connect(humidifier.portA_out, wet_air_sink.ports[1]) annotation(
    Line(points = {{0, -18}, {0, -68}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 100, __Dymola_Algorithm = "Dassl"));

end HumidifierTest_f_new;
