within VirtualFCS.ComponentTesting;

model HumidifierTest_2
  extends Modelica.Icons.Example;
  
  import VirtualFCS.Media.CathodeAir.Oxygen;
  import VirtualFCS.Media.CathodeAir.Nitrogen;
  import VirtualFCS.Media.CathodeAir.Water;
  import VirtualFCS.Media.CathodeAir.saturationPressure;
  import VirtualFCS.Media.CathodeAir.MMs;
  
  replaceable package dry_medium = VirtualFCS.Media.CathodeAir;
  replaceable package wet_medium = VirtualFCS.Media.CathodeAir;
  Modelica.Fluid.Sources.MassFlowSource_T dry_source(redeclare package Medium = dry_medium, m_flow = 0.0004, nPorts = 1, X = {0.24, 0.76, 0}, T = 353.15) annotation(
    Placement(transformation(origin = {32, -20}, extent = {{-120, -10}, {-100, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T wet_source(redeclare package Medium = wet_medium, nPorts = 1, use_m_flow_in = true, use_X_in = true, T = 353.15, use_T_in = true) annotation(
    Placement(transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Fluid.Sources.FixedBoundary dry_sink(redeclare package Medium = dry_medium, nPorts = 1, p = 2e5) annotation(
    Placement(transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Fluid.Humidifier humidifier(redeclare package dry_medium = dry_medium, redeclare package wet_medium = wet_medium) annotation(
    Placement(transformation(origin = {0, -20}, extent = {{-20, -20}, {20, 20}})));
  Fluid.RelativeHumiditySensor sink_dry(redeclare package Medium = dry_medium) annotation(
    Placement(transformation(origin = {50, 10}, extent = {{-10, -10}, {10, 10}})));
  VirtualFCS.Fluid.RelativeHumiditySensor sink_wet(redeclare package Medium = wet_medium) annotation(
    Placement(transformation(origin = {-20, -60}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  Modelica.Fluid.Sources.FixedBoundary wet_sink(redeclare package Medium = dry_medium, nPorts = 1, p = 1.8e5) annotation(
    Placement(transformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Sine mass_flow(offset = 0.0004, amplitude = 0.00003, f(displayUnit = "mHz") = 0.05, startTime = 50)  annotation(
    Placement(transformation(origin = {50, 50}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Sine temperature(amplitude = 10, f(displayUnit = "mHz") = 0.04, offset = 343, startTime = 40) annotation(
    Placement(transformation(origin = {30, 70}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Sine humidity(amplitude = 0.25, f(displayUnit = "mHz") = 0.03, offset = 0.75, startTime = 45) annotation(
    Placement(transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}})));
protected
  Modelica.Units.SI.MoleFraction X_mol[3] "Molar fraction in feed, helper variable";

equation
  X_mol[Water] = humidity.y * saturationPressure(temperature.y)/wet_sink.p;
  X_mol[Oxygen] = 0.21 * (1-X_mol[Water]);
  X_mol[Nitrogen] = 0.79 * (1-X_mol[Water]);
  wet_source.X_in = MMs .* X_mol / (MMs*X_mol);

  connect(dry_source.ports[1], humidifier.portB_in) annotation(
    Line(points = {{-68, -20}, {-20, -20}}, color = {0, 127, 255}, thickness = 0.75));
  connect(wet_source.ports[1], humidifier.portA_in) annotation(
    Line(points = {{0, 0}, {0, -8}}, color = {0, 127, 255}));
  connect(sink_wet.port, humidifier.portA_out) annotation(
    Line(points = {{-20, -70}, {0, -70}, {0, -32}}, color = {0, 127, 255}));
  connect(humidifier.portB_out, dry_sink.ports[1]) annotation(
    Line(points = {{20, -20}, {80, -20}}, color = {0, 127, 255}));
  connect(sink_dry.port, humidifier.portB_out) annotation(
    Line(points = {{50, 0}, {50, -20}, {20, -20}}, color = {0, 127, 255}));
  connect(humidifier.portA_out, wet_sink.ports[1]) annotation(
    Line(points = {{0, -32}, {0, -80}}, color = {0, 127, 255}));
  connect(mass_flow.y, wet_source.m_flow_in) annotation(
    Line(points = {{40, 50}, {8, 50}, {8, 20}}, color = {0, 0, 127}));
  connect(temperature.y, wet_source.T_in) annotation(
    Line(points = {{20, 70}, {4, 70}, {4, 22}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 400, StartTime = 0, Tolerance = 1e-06, Interval = 0.1));
annotation(Documentation(info = "<html><p>Alternative test model for the humidifier component.</p></html>"));
end HumidifierTest_2;
