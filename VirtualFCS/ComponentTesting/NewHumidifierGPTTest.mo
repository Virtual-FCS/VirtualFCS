within VirtualFCS.ComponentTesting;
model NewHumidifierGPTTest
  extends Modelica.Icons.Example;

  replaceable package dry_medium = Buildings.Media.Air(reference_X={0.00,1.0});
  replaceable package wet_medium = Buildings.Media.Air(reference_X={0.2,0.8});


  Modelica.Fluid.Sources.MassFlowSource_T dry_air_source(
    redeclare package Medium = dry_medium,
    m_flow=0.01,
    nPorts=1)
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T wet_air_source(
    redeclare package Medium = wet_medium,
    m_flow=0.005,
    nPorts=1)              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,110})));
  Modelica.Fluid.Sources.FixedBoundary dry_air_sink(redeclare package Medium =
        dry_medium, nPorts=1)
                           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,0})));
  Modelica.Fluid.Sources.FixedBoundary wet_air_sink(redeclare package Medium =
        wet_medium, nPorts=1)
    annotation (Placement(transformation(extent={{-28,-88},{-8,-68}})));
  Buildings.Fluid.Sensors.MassFlowRate sen_dry_in_MF(redeclare package Medium =
        dry_medium)
    annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort sen_dry_in_RH(
    redeclare package Medium = dry_medium,
    m_flow_nominal=0.1,
    phi_start=0)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort sen_dry_in_temp(redeclare package
      Medium = dry_medium, m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{-40,-10},{-26,10}})));
  Buildings.Fluid.Sensors.MassFlowRate sen_dry_out_MF(redeclare package Medium =
        dry_medium)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort sen_dry_out_RH(
    redeclare package Medium = dry_medium,
    m_flow_nominal=0.1,
    phi_start=0)
    annotation (Placement(transformation(extent={{52,-10},{72,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort sen_dry_out_temp(redeclare package
      Medium = dry_medium, m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{80,-10},{94,10}})));
  Buildings.Fluid.Sensors.MassFlowRate sen_wet_in_MF(redeclare package Medium =
        wet_medium)        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,84})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort sen_wet_in_RH(redeclare
      package Medium = wet_medium, m_flow_nominal=0.1)
                           annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,54})));
  Buildings.Fluid.Sensors.TemperatureTwoPort sen_wet_in_temp(redeclare package
      Medium = wet_medium, m_flow_nominal=0.1)
                           annotation (
      Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={0,30})));
  Fluid.Humidifier_test_GPT humidifier_test_GPT
    annotation (Placement(transformation(extent={{-14,-16},{16,16}})));
equation
  connect(dry_air_source.ports[1],sen_dry_in_MF. port_a)
    annotation (Line(points={{-100,0},{-94,0}}, color={0,127,255}));
  connect(sen_dry_in_MF.port_b,sen_dry_in_RH. port_a)
    annotation (Line(points={{-74,0},{-68,0}}, color={0,127,255}));
  connect(sen_dry_in_RH.port_b,sen_dry_in_temp. port_a)
    annotation (Line(points={{-48,0},{-40,0}}, color={0,127,255}));
  connect(sen_dry_out_MF.port_b,sen_dry_out_RH. port_a)
    annotation (Line(points={{46,0},{52,0}}, color={0,127,255}));
  connect(sen_dry_out_RH.port_b,sen_dry_out_temp. port_a)
    annotation (Line(points={{72,0},{80,0}}, color={0,127,255}));
  connect(sen_dry_out_temp.port_b,dry_air_sink. ports[1]) annotation (Line(
        points={{94,0},{97,0},{97,6.66134e-16},{100,6.66134e-16}}, color={0,127,
          255}));
  connect(wet_air_source.ports[1],sen_wet_in_MF. port_a) annotation (Line(
        points={{-1.83187e-15,100},{-1.83187e-15,97},{1.77636e-15,97},{1.77636e-15,
          94}},             color={0,127,255}));
  connect(sen_wet_in_MF.port_b,sen_wet_in_RH. port_a) annotation (Line(points={{
          -1.83187e-15,74},{-1.83187e-15,69},{1.77636e-15,69},{1.77636e-15,64}},
        color={0,127,255}));
  connect(sen_wet_in_RH.port_b,sen_wet_in_temp. port_a) annotation (Line(points={{
          -1.83187e-15,44},{-1.83187e-15,41},{1.4988e-15,41},{1.4988e-15,38}},
        color={0,127,255}));
  connect(sen_wet_in_temp.port_b, humidifier_test_GPT.portA_in) annotation (
      Line(points={{-1.4988e-15,22},{-1.4988e-15,16},{1,16}}, color={0,127,255}));
  connect(sen_dry_in_temp.port_b, humidifier_test_GPT.portB_in)
    annotation (Line(points={{-26,0},{-14,0}}, color={0,127,255}));
  connect(humidifier_test_GPT.portB_out, sen_dry_out_MF.port_a) annotation (
      Line(points={{16,2.22045e-15},{21,2.22045e-15},{21,0},{26,0}}, color={0,127,
          255}));
  connect(humidifier_test_GPT.portA_out, wet_air_sink.ports[1]) annotation (
      Line(points={{1,-16},{0,-16},{0,-78},{-8,-78}}, color={0,127,255}));
end NewHumidifierGPTTest;
