within VirtualFCS.SubSystems.Air;
model SubSystemAir_mc
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Medium = Buildings.Media.Air;
  // Parameter definition
  parameter Modelica.Units.SI.Mass m_system_air = 61 "Air system mass";
  parameter Integer N_FC_stack = 180 "FC stack number of cells";
  Modelica.Units.SI.Power Power_Compressor_mez "The power consumed by the Compressor";
  Modelica.Units.SI.Power Power_Compressor_electrical "The power consumed by the Compressor";
  Modelica.Units.SI.Efficiency Rendement_compressor  "Compressor efficiency";
  Real t  "parameter to cimpute efficiency";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.3     "Nominal mass flow rate";
//*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Sources.FixedBoundary airSink(redeclare package Medium = Medium,
    use_p=false,
    use_T=false,                                                                  nPorts = 2) annotation (
    Placement(visible = true, transformation(origin={-92.5,-62.5},    extent = {{8.5, -8.5}, {-8.5, 8.5}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {88, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {62, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={252,20},   extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin={-60,119},    extent = {{-20, -19}, {20, 19}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin={-10,48},   extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin={-26,48},   extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput control annotation (
    Placement(visible = true, transformation(origin = {-116, 86}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Control components
  Modelica.Blocks.Routing.Multiplex2 multiplexSensors(n1 = 1, n2 = 1) annotation (
    Placement(visible = true, transformation(origin = {58, -60}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Modelica.Blocks.Routing.DeMultiplex2 deMultiplexControl annotation (
    Placement(visible = true, transformation(origin = {-6, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setAirPressure(y = deMultiplexControl.y1[1]) annotation (
    Placement(visible = true, transformation(origin = {-36, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression FlowControlSignalCompressor(y=
        deMultiplexControl.y2[1]) annotation (Placement(visible=true,
        transformation(
        origin={-52,46},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  VirtualFCS.SubSystems.Air.SubSystemAirControl subSystemAirControl(N_FC_stack = N_FC_stack)  annotation (
    Placement(visible = true, transformation(origin = {-45, 79}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  // Machines
  // Sensors
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation (
    Placement(visible = true, transformation(origin = {80, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin={-110,-4},     extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.MassFlowRate sen_Air_mflow(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={-76,20},    extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature compressorOutletSensor(redeclare package
      Medium =                                                                         Medium) annotation (
    Placement(visible = true, transformation(origin={189,33},   extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  // Valves
  VirtualFCS.Fluid.ThrottleValve throttleValve(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin = {21, -35}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Modelica.Fluid.Sensors.Pressure Inlet_air_pressure(redeclare package Medium
      =                                                                         Medium) annotation (
    Placement(visible = true, transformation(origin={230,68},   extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput RH_cathode annotation (Placement(
        transformation(extent={{-100,-52},{-120,-32}}), iconTransformation(
          extent={{-100,-52},{-120,-32}})));
  Fluid.Compressor_mc_h compressor_mc_h(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V_flow_nominal=m_flow_nominal/1000,
    p_nominal=100000)
    annotation (Placement(transformation(extent={{-32,6},{-4,34}})));
  Buildings.Fluid.Humidifiers.Humidifier_u hum(
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    from_dp=true,
    dp_nominal(displayUnit="bar") = 6000,
    tau=20,
    mWat_flow_nominal=m_flow_nominal*0.09,
    T_start=system.T_start,
    m_flow_nominal=m_flow_nominal)     annotation (
    Placement(visible = true, transformation(origin={72,20},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)                                                                       annotation (
    Placement(visible = true, transformation(origin={46,-80},      extent = {{40, 90}, {60, 110}}, rotation = 0)));
  AixLib.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)                                                                        annotation (
    Placement(visible = true, transformation(origin={38,120},      extent={{74,-90},
            {94,-110}},                                                                            rotation = 0)));
  Buildings.Fluid.HeatExchangers.Heater_T hea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = 1000)
    annotation (Placement(transformation(extent={{150,10},{170,30}})));
  Modelica.Blocks.Sources.Constant const(k=323)
    annotation (Placement(transformation(extent={{124,44},{136,56}})));
  Modelica.Blocks.Continuous.LimPID limPID(
    Td=1,
    Ti=10,
    k=0.1,
    xd_start=0,
    xi_start=0,
    yMax=1,
    yMin=0,
    y_start=0.01)   annotation (
    Placement(visible = true, transformation(origin={54,42},      extent={{-8,-8},
            {8,8}},                                                                                rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k=(0.02897*1.75/(96485*4*0.21)*N_FC_stack))
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={20,62})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{28,38},{38,48}})));
  Modelica.Blocks.Sources.Constant const1(k=0.07)
    annotation (Placement(transformation(extent={{4,34},{16,46}})));
equation
Power_Compressor_mez = (sen_Air_mflow.m_flow*298.15*1004/(1*0.8))*(((Output.p*0.00001)^0.28)-1);//Input.p*(();
//Power_Compressor_mez = (sen_Air_mflow.m_flow*298.15*1004/(0.9*0.7))*(((Output.p*0.00001)^0.28)-1);//Input.p*(();
 Power_Compressor_electrical = pin_p.i*pin_p.v;
  if Power_Compressor_electrical > 1 then
    t = Power_Compressor_electrical;
    else
   t = 1;
   end if;

  Rendement_compressor = (sen_Air_mflow.m_flow*298.15*1004/(0.9*t))*(((Output.p*0.00001)^0.28)-1);
//*** DEFINE CONNECTIONS ***//
  connect(airSink.ports[1], sen_Air_mflow.port_a) annotation (
    Line(points={{-93.35,-54},{-93.35,20},{-86,20}},                color = {0, 170, 255}, thickness = 1));
  connect(throttleValve.port_a, Input) annotation (
    Line(points = {{36, -35}, {88, -35}}, color = {0, 170, 255}, thickness = 1));
  connect(throttleValve.port_b, airSink.ports[2]) annotation (
    Line(points={{6,-35},{6,-36},{-92,-36},{-92,-54},{-91.65,-54}}, color = {0, 170, 255}, thickness = 1));
  connect(setAirPressure.y, throttleValve.FC_pAirOut_P) annotation (
    Line(points={{-25,-94},{21,-94},{21,-37.1}},      color = {0, 0, 127}));
  connect(subSystemAirControl.controlInterface, deMultiplexControl.u) annotation (
    Line(points={{-29.1,78.85},{-20,78.85},{-20,78},{-18,78}},  color = {0, 0, 127}, thickness = 0.5));
  connect(multiplexSensors.y, sensors) annotation (
    Line(points={{58,-68.8},{58,-86},{80,-86}},      color = {0, 0, 127}));
  connect(sensors, subSystemAirControl.sensorInterface) annotation (
    Line(points={{80,-86},{108,-86},{108,-108},{-108,-108},{-108,71.5},{-61.5,71.5}},        color = {0, 0, 127}, thickness = 0.5));
  connect(control, subSystemAirControl.signalInterfaceFC) annotation (
    Line(points={{-116,86},{-88,86},{-88,86.5},{-61.5,86.5}},
                                           color = {0, 0, 127}));
  connect(compressorOutletSensor.port, Output)
    annotation (Line(points={{189,26},{189,20},{252,20}},
                                                       color={0,127,255}));
  connect(Inlet_air_pressure.port, Output)
    annotation (Line(points={{230,58},{230,20},{252,20}},
                                                       color={0,127,255}));
  connect(sen_Air_mflow.m_flow, multiplexSensors.u2[1]) annotation (Line(points={{-76,9},
          {-76,-14},{50,-14},{50,-50.4},{53.2,-50.4}},     color={0,0,127}));
  connect(Inlet_air_pressure.p, throttleValve.Measured_inlet_Air_pressure)
    annotation (Line(points={{219,68},{212,68},{212,-26},{37.5,-26}},
                                                                   color={0,0,
          127}));
  connect(FlowControlSignalCompressor.y, compressor_mc_h.controlInterface)
    annotation (Line(points={{-41,46},{-41,28.54},{-33.82,28.54}},        color
        ={0,0,127}));
  connect(pin_n, compressor_mc_h.pin_n) annotation (Line(points={{-26,48},{
          -20.24,48},{-20.24,28.4}},
                                   color={0,0,255}));
  connect(pin_p, compressor_mc_h.pin_p)
    annotation (Line(points={{-10,48},{-16,48},{-16,28.4},{-15.2,28.4}},
                                                             color={0,0,255}));
  connect(sen_Air_mflow.port_b, compressor_mc_h.Input)
    annotation (Line(points={{-66,20},{-33.4,20}},        color={0,127,255}));
  connect(compressor_mc_h.M_act, multiplexSensors.u1[1]) annotation (Line(
        points={{-18,9.64},{-18,-12},{54,-12},{54,-50.4},{62.8,-50.4}},
                                                                  color={0,0,127}));
  connect(compressor_mc_h.Output, hum.port_a)
    annotation (Line(points={{-2.6,20},{62,20}}, color={0,127,255}));
  connect(hum.port_b,senTem. port_a)
    annotation (Line(points={{82,20},{86,20}},
                                             color={0,127,255}));
  connect(senTem.port_b,senRelHum. port_a)
    annotation (Line(points={{106,20},{112,20}},
                                             color={0,127,255}));
  connect(hea.port_a,senRelHum. port_b)
    annotation (Line(points={{150,20},{132,20}},
                                              color={0,127,255}));
  connect(const.y,hea. TSet) annotation (Line(points={{136.6,50},{140,50},{140,28},
          {148,28}},color={0,0,127}));
  connect(hea.port_b, Output)
    annotation (Line(points={{170,20},{252,20}}, color={0,127,255}));
  connect(senRelHum.phi, RH_cathode) annotation (Line(points={{122.1,9},{122.1,2},
          {42,2},{42,-6},{-126,-6},{-126,-42},{-110,-42}}, color={0,0,127}));
  connect(limPID.y, hum.u) annotation (Line(points={{62.8,42},{68,42},{68,26},{
          61,26}}, color={0,0,127}));
  connect(pin_n, pin_n)
    annotation (Line(points={{-26,48},{-26,48}}, color={0,0,255}));
  connect(senRelHum.phi, limPID.u_m) annotation (Line(points={{122.1,9},{122.1,
          2},{54,2},{54,32.4}}, color={0,0,127}));
  connect(control, gain.u) annotation (Line(points={{-116,86},{-68,86},{-68,100},
          {20,100},{20,69.2}}, color={0,0,127}));
  connect(limPID.u_s, add.y) annotation (Line(points={{44.4,42},{44,42},{44,43},
          {38.5,43}}, color={0,0,127}));
  connect(gain.y, add.u1)
    annotation (Line(points={{20,55.4},{20,46},{27,46}}, color={0,0,127}));
  connect(const1.y, add.u2)
    annotation (Line(points={{16.6,40},{27,40}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(initialScale = 0.1), graphics={  Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-44, 70}, textColor = {255, 255, 255}, extent = {{-22, 12}, {112, -142}}, textString = "Air")}),
    Diagram(coordinateSystem(initialScale = 0.1), graphics={  Text(origin={-31,1},    extent = {{-7, 3}, {29, -3}}, textString = "Air compressor speed")}),
    Documentation(info = "<html><head></head><body>An air sub-system template is provided in the example model SubSystemAir.&nbsp;<div><br></div><div><b>Description</b></div><div><br></div><div>The model consists of an <a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a> and <a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a> connected to a fixed boundary condition reflecting the ambient conditions.&nbsp;</div><div><br></div><div>The subsystem model contains 5 interface connections: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the connection to the <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>. The electrical ports interface with the low-voltage DC power-supply to power the BoP components (in this case, the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>). The control port provides an interface to the Fuel Cell Control Unit, which controls the&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. A&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;is connected downstream from the Fuel Cell Stack to maintain the set pressure in the air line.&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>&nbsp;compares the set value of air mass flow rate with the actual mass flow rate and controls the speed of&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>. &nbsp;It also sets the air pressure.</div><div><br></div><div><br></div><div><b>Reference/Base packages</b></div><div><br></div><div><a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAirControl\">Air SubSystem Control</a>,&nbsp;<a href=\"modelica://VirtualFCS.Fluid.Compressor\">Air Compressor</a>&nbsp;and&nbsp;<a href=\"modelica://VirtualFCS.Fluid.ThrottleValve\">Throttle Valve</a>&nbsp;</div><div><br></div><div><b><br></b></div><div><b>Further updates</b></div><div><b><br></b></div><div>Future expansions on the air subsystem will include options for humidification and temperature control.</div></body></html>"));
end SubSystemAir_mc;
