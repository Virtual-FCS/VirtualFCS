within VirtualFCS.Fluid;
model Compressor_mc_h
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air(reference_X={0.01,0.99});
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=3     "Nominal mass flow rate";
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal;
  parameter Modelica.Units.SI.Pressure p_nominal=1;
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={-100,-26},   extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={100,-30},   extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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

  Control.DCMotorControlCompressor_new dCMotorControlCompressor_new
    annotation (Placement(transformation(extent={{-22,36},{22,80}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent
    annotation (Placement(transformation(extent={{10,32},{-10,12}})));
  Modelica.Blocks.Math.Gain gain(k=1/230) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={0,-2})));
  Modelica.Blocks.Interfaces.RealOutput M_act annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-74})));
  AixLib.Fluid.Sensors.TemperatureTwoPort Comp_out(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(visible=true,
        transformation(
        origin={8,-160},
        extent={{40,90},{60,110}},
        rotation=0)));
  Buildings.Fluid.Movers.FlowControlled_m_flow mov1(redeclare package Medium =
        Medium,
    allowFlowReversal=false,
    redeclare Buildings.Fluid.Movers.Data.Generic per(pressure(V_flow={0,V_flow_nominal}, dp={p_nominal,0}),
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      efficiency(V_flow={0}, eta={0.99})),
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=false,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = p_nominal)
    annotation (Placement(transformation(extent={{-48,-72},{-28,-52}})));
                                          //powerOrEfficiencyIsHydraulic=true
equation
  //torque.tau = -9.5488*mov.P/mov.y_actual;
  Power_Compressor = pin_p.i*pin_p.v;
 // V_flow_nominal=m_flow_nominal/1000;
  connect(controlInterface, gain1.u) annotation (
    Line(points={{-107,59},{-87,59}},                            color = {0, 0, 127}));
  connect(gain1.y, dCMotorControlCompressor_new.setSpeedInput) annotation (Line(
        points={{-75.5,59},{-34,59},{-34,58},{-26.4,58}}, color={0,0,127}));
  connect(signalCurrent.p, dCMotorControlCompressor_new.pin_p) annotation (Line(
        points={{10,22},{10,28},{6.6,28},{6.6,38.2}},       color={0,0,255}));
  connect(signalCurrent.n, dCMotorControlCompressor_new.pin_n) annotation (Line(
        points={{-10,22},{-10,28},{-6.6,28},{-6.6,38.2}},        color={0,0,255}));
  connect(gain.y, signalCurrent.i) annotation (Line(points={{3.88578e-16,4.6},{3.88578e-16,
          5.3},{0,5.3},{0,10}},                   color={0,0,127}));
  connect(dCMotorControlCompressor_new.pwr_pin_n, pin_n) annotation (Line(
        points={{-6.6,77.8},{-6.6,86},{-12,86},{-12,100}}, color={0,0,255}));
  connect(dCMotorControlCompressor_new.pwr_pin_p, pin_p) annotation (Line(
        points={{6.6,77.8},{6.6,86},{12,86},{12,100}}, color={0,0,255}));
  connect(Comp_out.port_b, Output) annotation (Line(points={{68,-60},{100,-60},
          {100,-30}},      color={0,127,255}));
  connect(controlInterface, mov1.m_flow_in) annotation (Line(points={{-107,59},{
          -108,59},{-108,-12},{-38,-12},{-38,-50}}, color={0,0,127}));
  connect(Input, mov1.port_a) annotation (Line(points={{-100,-26},{-100,-62},{-48,
          -62}}, color={0,127,255}));
  connect(mov1.port_b, Comp_out.port_a) annotation (Line(points={{-28,-62},{-26,
          -62},{-26,-60},{48,-60}}, color={0,127,255}));
  connect(mov1.P, gain.u) annotation (Line(points={{-27,-53},{0,-53},{0,-10},{-4.44089e-16,
          -10},{-4.44089e-16,-9.2}}, color={0,0,127}));
  connect(mov1.m_flow_actual, M_act) annotation (Line(points={{-27,-57},{-24,-57},
          {-24,-96},{0,-96},{0,-110}}, color={0,0,127}));
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
end Compressor_mc_h;
