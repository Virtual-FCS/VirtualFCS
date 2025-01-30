within VirtualFCS.Fluid;
model RecirculationBlower_mc
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2;
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={-100,-60},   extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={100,-60},   extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin={12,100},    extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin={-12,100},   extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Control components
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation (
    Placement(visible = true, transformation(origin = {-113, 41}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain1(k=1/1400)           annotation (
    Placement(visible = true, transformation(origin={-67,41},    extent={{-9,-9},
            {9,9}},                                                                           rotation = 0)));
  // Machines
  // Sensors
  // Other
  // Power & Efficiencies
  Modelica.Units.SI.Power Power_RecirculationBlower "The power consumed by the RecirculationBlower";
  Control.DCMotorControlRecirculationBlower_mc
    dCMotorControlRecirculationBlower_mc
    annotation (Placement(transformation(extent={{-16,24},{16,56}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent
    annotation (Placement(transformation(extent={{10,0},{-10,-20}})));
  Modelica.Blocks.Math.Gain gain2(k=1/230)
                                          annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={0,-34})));
  Buildings.Fluid.Movers.FlowControlled_m_flow mov(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-32,-70},{-12,-50}})));
equation
  //torque.tau = -9.5488*pump.W_total/pump.N;
  Power_RecirculationBlower = pin_p.i*pin_p.v;
  connect(controlInterface, gain1.u) annotation (
    Line(points={{-113,41},{-77.8,41}},                          color = {0, 0, 127}));
  connect(dCMotorControlRecirculationBlower_mc.pwr_pin_p, pin_p) annotation (
      Line(points={{4.8,54.4},{4.8,60},{12,60},{12,100}}, color={0,0,255}));
  connect(pin_n, dCMotorControlRecirculationBlower_mc.pwr_pin_n) annotation (
      Line(points={{-12,100},{-12,62},{-4,62},{-4,54.4},{-4.8,54.4}}, color={0,0,
          255}));
  connect(gain2.y, signalCurrent.i) annotation (Line(points={{3.88578e-16,-27.4},
          {3.88578e-16,-24.7},{0,-24.7},{0,-22}},
                                               color={0,0,127}));
  connect(signalCurrent.n, dCMotorControlRecirculationBlower_mc.pin_n)
    annotation (Line(points={{-10,-10},{-14,-10},{-14,28},{-4.8,28},{-4.8,25.6}},
        color={0,0,255}));
  connect(signalCurrent.p, dCMotorControlRecirculationBlower_mc.pin_p)
    annotation (Line(points={{10,-10},{14,-10},{14,28},{4.8,28},{4.8,25.6}},
        color={0,0,255}));
  connect(Input, mov.port_a)
    annotation (Line(points={{-100,-60},{-32,-60}}, color={0,127,255}));
  connect(mov.port_b, Output)
    annotation (Line(points={{-12,-60},{100,-60}}, color={0,127,255}));
  connect(gain1.y, dCMotorControlRecirculationBlower_mc.setSpeedInput)
    annotation (Line(points={{-57.1,41},{-30,41},{-30,40},{-19.2,40}}, color={0,
          0,127}));
  connect(mov.P, gain2.u) annotation (Line(points={{-11,-51},{0,-51},{0,-41.2},
          {-4.44089e-16,-41.2}},      color={0,0,127}));
  connect(controlInterface, mov.m_flow_in) annotation (Line(points={{-113,41},{
          -84,41},{-84,-38},{-22,-38},{-22,-48}}, color={0,0,127}));
  annotation (
    Icon(graphics={  Polygon(visible = false, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = false, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Polygon(visible = false, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Ellipse(origin = {-26, 26}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-54, 54}, {106, -106}}), Polygon(origin = {70, -5}, rotation = -90, lineThickness = 1, points = {{-6, 9}, {-18, -9}, {6, -9}, {6, -9}, {-6, 9}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The RecirculationBlower model is designed to maintain hydrogen gas circulation within the hydrogen subsystem.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the Recirculation Blower, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the blower. A <a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">DC motor</a> drives the recirculation blower and is connected to an inertia and torque source, which is linked to the resistance of the pump.</div></body></html>"));
end RecirculationBlower_mc;
