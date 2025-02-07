within VirtualFCS.Fluid;
model Compressor_newp
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air(reference_X={0.01,0.99});
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={-78,-38},    extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={84,-38},    extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin={12,100},    extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {20, 60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin={-12,100},   extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-16, 60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  // Control components
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation (
    Placement(visible = true, transformation(origin={-107,59},    extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-113, 61}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k=1400)     annotation (
    Placement(visible = true, transformation(origin={-81,59},    extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  // Machines
  // Sensors
  // Other
  // Power & Efficiencies
  Modelica.Units.SI.Power Power_Compressor "The power consumed by the Compressor";
  Modelica.Blocks.Continuous.LimPID limPID(
    Td=2,
    Ti=15,
    k=8,                                                                xd_start = 0.01, xi_start = 0.01,
    yMax=1,
    yMin=-1,                                                                                                                       y_start = 0.01) annotation (
    Placement(visible = true, transformation(origin={-38,-62},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = Medium, m_flow_nominal = 0.1) annotation (
    Placement(visible = true, transformation(origin={10,-124},     extent = {{40, 90}, {60, 110}}, rotation = 0)));
  AixLib.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(redeclare package
      Medium =                                                                      Medium, m_flow_nominal = 0.1) annotation (
    Placement(visible = true, transformation(origin={-12,-164},    extent = {{74, 90}, {94, 110}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant3(k=0.51)  annotation (
    Placement(visible = true, transformation(origin={-72.5,-61.5},    extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Buildings.Fluid.Humidifiers.Humidifier_u hum(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    from_dp=false,
    dp_nominal=6000,
    tau=10,
    mWat_flow_nominal=0.05,
    T_start = system.T_start,
    m_flow_nominal=1)     annotation (
    Placement(visible = true, transformation(origin={34,-26},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput RH_cathode annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={96,-48}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={96,-48})));
  Buildings.Fluid.Movers.SpeedControlled_y mov(redeclare package Medium =
        Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    p_start=238500,
    allowFlowReversal=false,
    redeclare Buildings.Fluid.Movers.Data.Generic per(
      pressure(V_flow={0.01,1}, dp={5,1.01325}),
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve,
      etaMot_max=0.95),
    tau=1)
    annotation (Placement(transformation(extent={{-18,-46},{2,-26}})));

  Control.DCMotorControlCompressor_new dCMotorControlCompressor_new
    annotation (Placement(transformation(extent={{-22,36},{22,80}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent
    annotation (Placement(transformation(extent={{10,32},{-10,12}})));
  Modelica.Blocks.Math.Gain gain(k=1/230) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={0,-6})));
  Modelica.Blocks.Interfaces.RealOutput N_rpm annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-74})));
equation
  //torque.tau = -9.5488*mov.P/mov.y_actual;
  Power_Compressor = pin_p.i*pin_p.v;
  connect(controlInterface, gain1.u) annotation (
    Line(points={{-107,59},{-87,59}},                            color = {0, 0, 127}));
  connect(senTem.port_b, senRelHum.port_a) annotation (
    Line(points={{70,-24},{72,-24},{72,-38},{56,-38},{56,-64},{62,-64}}));
  connect(senRelHum.port_b, Output) annotation (
    Line(points={{82,-64},{84,-64},{84,-38}},        color = {0, 127, 255}));
  connect(senRelHum.phi, limPID.u_m) annotation (
    Line(points={{72.1,-53},{72.1,-54},{-22,-54},{-22,-84},{-38,-84},{-38,-74}},
                                                                 color = {0, 0, 127}));
  connect(constant3.y, limPID.u_s) annotation (
    Line(points={{-64.25,-61.5},{-57.125,-61.5},{-57.125,-62},{-50,-62}},
                                            color = {0, 0, 127}));
  connect(hum.port_b, senTem.port_a) annotation (
    Line(points={{44,-26},{44,-24},{50,-24}},                                         color = {0, 127, 255}));
  connect(hum.u, limPID.y) annotation (
    Line(points={{23,-20},{10,-20},{10,-62},{-27,-62}},          color = {0, 0, 127}));
  connect(senRelHum.phi, RH_cathode) annotation (Line(points={{72.1,-53},{72.1,-54},
          {58,-54},{58,-48},{96,-48}},
                                     color={0,0,127}));
  connect(Input, mov.port_a) annotation (Line(points={{-78,-38},{-78,-36},{-18,-36}},
        color={0,127,255}));
  connect(mov.port_b, hum.port_a) annotation (Line(points={{2,-36},{18,-36},{18,
          -26},{24,-26}}, color={0,127,255}));
  connect(gain1.y, dCMotorControlCompressor_new.setSpeedInput) annotation (Line(
        points={{-75.5,59},{-34,59},{-34,58},{-26.4,58}}, color={0,0,127}));
  connect(signalCurrent.p, dCMotorControlCompressor_new.pin_p) annotation (Line(
        points={{10,22},{10,28},{6.6,28},{6.6,38.2}},       color={0,0,255}));
  connect(signalCurrent.n, dCMotorControlCompressor_new.pin_n) annotation (Line(
        points={{-10,22},{-10,28},{-6.6,28},{-6.6,38.2}},        color={0,0,255}));
  connect(gain.y, signalCurrent.i) annotation (Line(points={{3.88578e-16,0.6},{3.88578e-16,
          5.3},{0,5.3},{0,10}},                   color={0,0,127}));
  connect(mov.P, gain.u) annotation (Line(points={{3,-27},{3,-22},{-4.44089e-16,
          -22},{-4.44089e-16,-13.2}}, color={0,0,127}));
  connect(mov.y, gain1.y) annotation (Line(points={{-8,-24},{-8,-16},{-66,-16},{
          -66,59},{-75.5,59}}, color={0,0,127}));
  connect(dCMotorControlCompressor_new.pwr_pin_n, pin_n) annotation (Line(
        points={{-6.6,77.8},{-6.6,86},{-12,86},{-12,100}}, color={0,0,255}));
  connect(dCMotorControlCompressor_new.pwr_pin_p, pin_p) annotation (Line(
        points={{6.6,77.8},{6.6,86},{12,86},{12,100}}, color={0,0,255}));
  connect(mov.y_actual, N_rpm) annotation (Line(points={{3,-29},{8,-29},{8,-96},
          {0,-96},{0,-110}}, color={0,0,127}));
  annotation (
    Icon(graphics={  Polygon(visible = false, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = false, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Polygon(visible = false, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(origin = {15, 0}, fillColor = {208, 208, 208}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-115, 80}, {-115, -80}, {85, -50}, {85, 50}, {85, 50}, {-115, 80}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier),
        Line(
          points={{-100,80},{-100,-80}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-100,-80},{100,-50}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-100,80},{100,50}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{100,-50},{100,50}},
          color={0,0,0},
          thickness=0.5)},                                                                                                                                                                                                        coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The Compressor model is designed to compress air from the ambient environment to the desired pressure and maintain a sufficient mass flow rate to support the needs of the <a href=\"modelica:77VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the compressor, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the compressor. A <a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">DC Motor</a> drives the compressor and is connected to an inertia and torque source, which is linked to the resistance of the <a href=\"modelica://Modelica.Fluid.Machines.PrescribedPump\">Pump</a>.</div></body></html>"));
end Compressor_newp;
