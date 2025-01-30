within VirtualFCS.Thermal;
model HeatSink
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
                                                                                constrainedby
    Modelica.Media.Interfaces.PartialMedium;
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={-100,-54},  extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={100,-54},  extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Fluid.Pipes.DynamicPipe pipe(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 1, redeclare
      package Medium =                                                                                                                           Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true)
                                                                                                                                                                                                        annotation (
    Placement(visible = true, transformation(origin={10,-124},   extent = {{20, -80}, {0, -60}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation (
    Placement(visible = true, transformation(origin={0,-84},              extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature AmbientTemp(T(
        displayUnit="K") = 293.15) annotation (Placement(visible=true,
        transformation(
        origin={0,-110},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Blocks.Continuous.LimPID limPID(Ni = 0.1, Td = 0, Ti = 27, controllerType = Modelica.Blocks.Types.SimpleController.PI, initType = Modelica.Blocks.Types.Init.InitialOutput, k = 40,
    yMax=2000,                                                                                                                                                                                              yMin = 0, y_start = 1) annotation (
    Placement(visible = true, transformation(origin={-28,2},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Stack_temperature annotation (
    Placement(visible = true, transformation(origin={-120,2},     extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {108, 78}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Set_Point annotation (
    Placement(visible = true, transformation(origin={-120,-38},   extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {108, -8}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p
    annotation (Placement(transformation(extent={{-50,94},{-30,114}}),
        iconTransformation(extent={{-50,94},{-30,114}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n
    annotation (Placement(transformation(extent={{30,94},{50,114}}),
        iconTransformation(extent={{30,94},{50,114}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent
    annotation (Placement(transformation(extent={{-10,102},{10,82}})));
  Modelica.Units.SI.Power Power_heatsink "The power consumed by the Heat sink (radiator)";
  Modelica.Blocks.Math.Gain Voltagecorrection(k=1/1.24) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={0,16})));
  Modelica.Blocks.Math.Gain Voltagecorrection1(k=1^(1/1.38)) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={0,38})));
  Modelica.Blocks.Math.Gain Voltagecorrection2(k=1/400) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={0,62})));
equation
Power_heatsink =pin_p.i*pin_p.v;

//*** DEFINE CONNECTIONS ***//
  connect(port_a, pipe.port_a) annotation (
    Line(points={{-100,-54},{-10,-54}},  color = {255, 0, 0}, thickness = 1.5));
  connect(pipe.port_b, port_b) annotation (
    Line(points={{10,-54},{100,-54}},  color = {0, 0, 255}, thickness = 1.5));
  connect(pipe.heatPorts[1], convection.solid) annotation (
    Line(points={{0.1,-58.4},{0.1,-71.2},{1.77636e-15,-71.2},{1.77636e-15,-74}},
                                       color = {191, 0, 0}));
  connect(convection.fluid, AmbientTemp.port) annotation (Line(points={{
          -1.77636e-15,-94},{-1.77636e-15,-100},{5.55112e-16,-100}}, color={191,
          0,0}));
  connect(limPID.y, convection.Gc) annotation (
    Line(points={{-17,2},{20,2},{20,-84},{10,-84}},            color = {0, 0, 127}));
  connect(limPID.u_s, Stack_temperature) annotation (
    Line(points={{-40,2},{-120,2}},        color = {0, 0, 127}));
  connect(limPID.u_m, Set_Point) annotation (
    Line(points={{-28,-10},{-28,-38},{-120,-38}},                color = {0, 0, 127}));
  connect(pin_n, signalCurrent.n)
    annotation (Line(points={{40,104},{40,92},{10,92}},color={0,0,255}));
  connect(pin_p, signalCurrent.p)
    annotation (Line(points={{-40,104},{-40,92},{-10,92}},
                                                       color={0,0,255}));
  connect(Voltagecorrection.u, limPID.y) annotation (Line(points={{-4.44089e-16,
          8.8},{-4.44089e-16,2},{-17,2}}, color={0,0,127}));
  connect(Voltagecorrection.y, Voltagecorrection1.u) annotation (Line(points={{
          3.88578e-16,22.6},{3.88578e-16,24.7},{-4.44089e-16,24.7},{
          -4.44089e-16,30.8}}, color={0,0,127}));
  connect(Voltagecorrection1.y, Voltagecorrection2.u) annotation (Line(points={
          {3.88578e-16,44.6},{3.88578e-16,49.7},{-4.44089e-16,49.7},{
          -4.44089e-16,54.8}}, color={0,0,127}));
  connect(signalCurrent.i, Voltagecorrection2.y) annotation (Line(points={{0,80},
          {0,74.3},{3.88578e-16,74.3},{3.88578e-16,68.6}}, color={0,0,127}));
  annotation (
    Icon(graphics={  Rectangle(origin = {-16, -71}, fillColor = {0, 0, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-84, 11}, {116, -9}}), Ellipse(origin = {40, 76}, fillColor = {166, 166, 166}, fillPattern = FillPattern.Sphere, extent = {{40, 14}, {-40, -6}}), Ellipse(origin = {-40, 76}, fillColor = {166, 166, 166}, fillPattern = FillPattern.Sphere, extent = {{40, 14}, {-40, -6}}), Ellipse(origin = {30, 78}, fillColor = {166, 166, 166}, fillPattern = FillPattern.Sphere, extent = {{-20, 12}, {-40, -6}}), Rectangle(origin = {0, 20}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-100, 7}, {100, -21}}, radius = 2), Ellipse(origin = {0, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}, startAngle = 180, closure = EllipseClosure.Chord), Ellipse(origin = {-57.2, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}, startAngle = 180, closure = EllipseClosure.Chord), Ellipse(origin = {57.2, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}, startAngle = 180, closure = EllipseClosure.Chord), Rectangle(origin = {-85.75, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Rectangle(origin = {-28.6, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Rectangle(origin = {28.6, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Ellipse(origin = {-85.75, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}), Ellipse(origin = {-28.6, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}), Ellipse(origin = {28.6, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}), Rectangle(origin = {85.75, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Ellipse(origin = {85.75, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}})}, coordinateSystem(initialScale = 0.1)));
end HeatSink;
