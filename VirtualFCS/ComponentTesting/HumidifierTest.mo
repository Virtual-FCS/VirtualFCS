within VirtualFCS.ComponentTesting;


model HumidifierTest
  extends Modelica.Icons.Example;
  // initial parameters
  constant Real phi_start_dry = 1;
  constant Real phi_start_wet = 15; 
//replaceable package dry_medium = Buildings.Media.Air(reference_X = {phi_start_dry/100, (1 - phi_start_dry/100)});
  replaceable package dry_medium = Modelica.Media.Air.MoistAir(reference_X={phi_start_dry/100, (1 - phi_start_dry/100)});
  //replaceable package wet_medium = Buildings.Media.Air(reference_X = {phi_start_wet/100, (1 - phi_start_wet/100)});
  replaceable package wet_medium = Modelica.Media.Air.MoistAir(reference_X = {phi_start_wet/100, (1 - phi_start_wet/100)});

  
  Modelica.Fluid.Sources.MassFlowSource_T dry_air_source(redeclare package Medium = dry_medium, m_flow = 0.5e-3, nPorts = 1) annotation(
    Placement(transformation(extent = {{-120, -10}, {-100, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T wet_air_source(redeclare package Medium = wet_medium, m_flow = 0.4e-3, nPorts = 1) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {0, 110})));
  Modelica.Fluid.Sources.FixedBoundary dry_air_sink(redeclare package Medium = dry_medium, nPorts = 1) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 180, origin = {110, 0})));
  Modelica.Fluid.Sources.FixedBoundary wet_air_sink(redeclare package Medium = wet_medium, nPorts = 1) annotation(
    Placement(transformation(origin = {0, -8}, extent = {{-28, -88}, {-8, -68}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort sen_dry_in_RH(redeclare package Medium = dry_medium, m_flow_nominal = 0.1, tau = 0.00001, phi_start=phi_start_dry) annotation(
    Placement(transformation(extent = {{-68, -10}, {-48, 10}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort sen_dry_out_RH(redeclare package Medium = dry_medium, m_flow_nominal = 0.1, tau = 0.00001, phi_start=phi_start_dry) annotation(
    Placement(transformation(extent = {{52, -10}, {72, 10}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort sen_wet_in_RH(redeclare package Medium = wet_medium, m_flow_nominal = 0.1, tau = 0.00001, phi_start=phi_start_wet) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {0, 54})));
  Fluid.Humidifier humidifier(redeclare package dry_medium_in = dry_medium, redeclare package dry_medium_out = dry_medium, redeclare package wet_medium_in = wet_medium, redeclare package wet_medium_out = wet_medium) annotation(
    Placement(transformation(origin = {0, -1}, extent = {{-18, -17}, {18, 17}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort sen_wet_out_RH(redeclare package Medium = wet_medium, m_flow_nominal = 0.1, tau = 0.00001, phi_start=phi_start_wet) annotation(
    Placement(transformation(origin = {0, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
equation
  connect(humidifier.portA_in, sen_wet_in_RH.port_b) annotation(
    Line(points = {{0, 16}, {0, 44}}, color = {0, 127, 255}));
  connect(sen_wet_in_RH.port_a, wet_air_source.ports[1]) annotation(
    Line(points = {{0, 64}, {0, 100}}, color = {0, 127, 255}));
  connect(sen_dry_out_RH.port_a, humidifier.portB_out) annotation(
    Line(points = {{52, 0}, {18, 0}}, color = {0, 127, 255}));
  connect(sen_dry_out_RH.port_b, dry_air_sink.ports[1]) annotation(
    Line(points = {{72, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(dry_air_source.ports[1], sen_dry_in_RH.port_a) annotation(
    Line(points = {{-100, 0}, {-68, 0}}, color = {0, 127, 255}));
  connect(sen_dry_in_RH.port_b, humidifier.portB_in) annotation(
    Line(points = {{-48, 0}, {-18, 0}}, color = {0, 127, 255}));
  connect(humidifier.portA_out, sen_wet_out_RH.port_a) annotation(
    Line(points = {{0, -18}, {0, -34}}, color = {0, 127, 255}));
  connect(sen_wet_out_RH.port_b, wet_air_sink.ports[1]) annotation(
    Line(points = {{0, -54}, {0, -86}, {-8, -86}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 100, __Dymola_Algorithm = "Dassl"));
end HumidifierTest;
