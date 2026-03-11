within VirtualFCS.ComponentTesting;


model HumidifierTest
  extends Modelica.Icons.Example;
  // initial parameters
  replaceable package dry_medium = VirtualFCS.Media.CathodeAir;
  replaceable package wet_medium = VirtualFCS.Media.CathodeAir;
  Modelica.Fluid.Sources.MassFlowSource_T dry_air_source(redeclare package Medium = dry_medium, m_flow = 0.5e-3, nPorts = 1, X={0.245,0.75, 0.005}) annotation(
    Placement(transformation(extent = {{-120, -10}, {-100, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T wet_air_source(redeclare package Medium = wet_medium, m_flow = 0.4e-3, nPorts = 1, X={0.24,0.75, 0.01}) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {0, 110})));
  Modelica.Fluid.Sources.FixedBoundary dry_air_sink(redeclare package Medium = dry_medium, nPorts = 1) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {110, 0})));
  Modelica.Fluid.Sources.FixedBoundary wet_air_sink(redeclare package Medium = wet_medium, nPorts = 1) annotation(
    Placement(transformation(origin = {0, -8}, extent = {{-28, -88}, {-8, -68}})));
  Fluid.Humidifier humidifier(redeclare package dry_medium = dry_medium, redeclare package wet_medium = wet_medium) annotation(
    Placement(transformation(origin = {0, -1}, extent = {{-18, -17}, {18, 17}})));
  Modelica.Fluid.Sensors.MassFractions massFraction_out_wet_oxygen(redeclare package Medium = wet_medium, substanceName = "oxygen") annotation(
    Placement(transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFractions massFraction_out_wet_nitrogen(redeclare package Medium = wet_medium, substanceName = "nitrogen") annotation(
    Placement(transformation(origin = {28, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFractionsTwoPort massFraction_out_dry_oxygen(redeclare package Medium = dry_medium, substanceName = "oxygen")  annotation(
    Placement(transformation(origin = {42, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFractions massFraction_out_dry_oxygen_2(redeclare package Medium = dry_medium, substanceName = "oxygen") annotation(
    Placement(transformation(origin = {40, 44}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(dry_air_source.ports[1], humidifier.portB_in) annotation(
    Line(points = {{-100, 0}, {-18, 0}}, color = {0, 127, 255}));
  connect(wet_air_source.ports[1], humidifier.portA_in) annotation(
    Line(points = {{0, 100}, {0, 16}}, color = {0, 127, 255}));
  connect(humidifier.portA_out, wet_air_sink.ports[1]) annotation(
    Line(points = {{0, -18}, {-8, -18}, {-8, -86}}, color = {0, 127, 255}));
  connect(massFraction_out_wet_oxygen.port, humidifier.portA_out) annotation(
    Line(points = {{30, -50}, {0, -50}, {0, -18}}, color = {0, 127, 255}));
  connect(massFraction_out_wet_nitrogen.port, humidifier.portA_out) annotation(
    Line(points = {{28, -80}, {0, -80}, {0, -18}}, color = {0, 127, 255}));
  connect(humidifier.portB_out, massFraction_out_dry_oxygen.port_a) annotation(
    Line(points = {{18, 0}, {32, 0}}, color = {0, 127, 255}));
  connect(massFraction_out_dry_oxygen.port_b, dry_air_sink.ports[1]) annotation(
    Line(points = {{52, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(massFraction_out_dry_oxygen_2.port, humidifier.portB_out) annotation(
    Line(points = {{40, 34}, {18, 34}, {18, 0}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 100, __Dymola_Algorithm = "Dassl"));
end HumidifierTest;
