within VirtualFCS.ComponentTesting;
model CompressorTest_mc_h "Simple model to test the compressor component"

extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin={90,90},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium =  Buildings.Media.Air(reference_X={0.01,0.99});
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.3     "Nominal mass flow rate";


Modelica.Fluid.Sources.FixedBoundary AirSink(redeclare package Medium = Medium,
    use_p=false,
    use_T=false,
      nPorts=1)                                                                                         annotation (
    Placement(visible = true, transformation(origin={-110,0},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Fluid.Sources.FixedBoundary AirSink2(redeclare package Medium = Medium,
    use_p=true,
    p=230000,
    use_T=false,
    nPorts=2)                                                                                annotation (
    Placement(visible = true, transformation(origin={188,2},   extent = {{-10, -10}, {10, 10}}, rotation = 180)));
VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(
    V_min_bat_pack=400,
    V_nom_bat_pack=440,
    V_max_bat_pack=480,
    SOC_init=0.9)                                              annotation (
    Placement(visible = true, transformation(origin={-49,73},  extent={{13,-13},
            {-13,13}},                                                                          rotation = -180)));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=0.12,
    rising=100,
    width=20,
    falling=50,
    period=250,
    nperiod=2,
    offset=0.05,
    startTime=0)
    annotation (Placement(transformation(extent={{-122,44},{-102,64}})));
  Buildings.Fluid.Humidifiers.Humidifier_u hum(
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    from_dp=false,
    dp_nominal(displayUnit="bar") = 6000,
    tau=10,
    mWat_flow_nominal=m_flow_nominal*0.009,
    T_start=system.T_start,
    m_flow_nominal=m_flow_nominal)     annotation (
    Placement(visible = true, transformation(origin={32,0},      extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)                                                                       annotation (
    Placement(visible = true, transformation(origin={8,-100},      extent = {{40, 90}, {60, 110}}, rotation = 0)));
  AixLib.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)                                                                        annotation (
    Placement(visible = true, transformation(origin={0,100},       extent={{74,-90},
            {94,-110}},                                                                            rotation = 0)));
  Modelica.Blocks.Continuous.LimPID limPID(
    Td=2,
    Ti=15,
    k=8,
    xd_start=0.01,
    xi_start=0.01,
    yMax=1,
    yMin=-1,
    y_start=0.01)   annotation (
    Placement(visible = true, transformation(origin={2,20},       extent={{-8,-8},
            {8,8}},                                                                                rotation = 0)));
  Fluid.Compressor_mc_h compressor(redeclare package Medium =
        Medium,    m_flow_nominal=m_flow_nominal,
    V_flow_nominal=m_flow_nominal/1000,
    p_nominal=400000)
    annotation (Placement(transformation(extent={{-60,-14},{-32,14}})));



  Modelica.Blocks.Sources.Trapezoid trapezoid1(
    amplitude=trapezoid.amplitude + 0.07,
    rising=trapezoid.rising,
    width=trapezoid.width,
    falling=trapezoid.falling,
    period=trapezoid.period,
    nperiod=trapezoid.nperiod,
    offset=0.32,
    startTime=0)
    annotation (Placement(transformation(extent={{-34,14},{-20,28}})));
  Buildings.Fluid.HeatExchangers.Heater_T hea(redeclare package Medium =
        Medium,m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = 6000)
    annotation (Placement(transformation(extent={{112,-10},{132,10}})));
  Modelica.Blocks.Sources.Constant const(k=323)
    annotation (Placement(transformation(extent={{86,24},{98,36}})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)                                                                       annotation (
    Placement(visible = true, transformation(origin={108,-100},    extent = {{40, 90}, {60, 110}}, rotation = 0)));
equation


  connect(hum.port_b, senTem.port_a)
    annotation (Line(points={{42,0},{48,0}}, color={0,127,255}));
  connect(senTem.port_b, senRelHum.port_a)
    annotation (Line(points={{68,0},{74,0}}, color={0,127,255}));
  connect(limPID.y, hum.u) annotation (Line(points={{10.8,20},{18,20},{18,6},{
          21,6}},
               color={0,0,127}));
  connect(senRelHum.phi, limPID.u_m) annotation (Line(points={{84.1,-11},{84.1,
          -16},{84,-16},{84,-20},{2,-20},{2,10.4}},
                             color={0,0,127}));
  connect(compressor.pin_p, batterySystem.pin_p) annotation (Line(points={{-43.2,
          8.4},{-43.2,10},{-43.28,10},{-43.28,60.52}},       color={0,0,255}));
  connect(compressor.pin_n, batterySystem.pin_n) annotation (Line(points={{-48.24,
          8.4},{-48.24,10},{-54,10},{-54,60.52},{-54.72,60.52}},
                                                      color={0,0,255}));
  connect(AirSink.ports[1], compressor.Input) annotation (Line(points={{-100,0},
          {-81.7,0},{-81.7,1.77636e-15},{-61.4,1.77636e-15}},    color={0,127,255}));
  connect(compressor.Output, hum.port_a) annotation (Line(points={{-30.6,1.77636e-15},
          {-5.3,1.77636e-15},{-5.3,0},{22,0}}, color={0,127,255}));
  connect(compressor.controlInterface, trapezoid.y) annotation (Line(
        points={{-61.82,8.54},{-94,8.54},{-94,54},{-101,54}}, color={0,0,127}));


  connect(trapezoid1.y, limPID.u_s) annotation (Line(points={{-19.3,21},{-19.3,20},
          {-7.6,20}}, color={0,0,127}));
  connect(hea.port_a, senRelHum.port_b)
    annotation (Line(points={{112,0},{94,0}}, color={0,127,255}));
  connect(const.y, hea.TSet) annotation (Line(points={{98.6,30},{102,30},{102,8},
          {110,8}}, color={0,0,127}));
  connect(hea.port_b, senTem1.port_a)
    annotation (Line(points={{132,0},{148,0}}, color={0,127,255}));
  connect(AirSink2.ports[1], senTem1.port_b)
    annotation (Line(points={{178,3},{178,0},{168,0}}, color={0,127,255}));
annotation (
  experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,80}})));
end CompressorTest_mc_h;
