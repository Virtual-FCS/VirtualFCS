within VirtualFCS.Thermal;

model HeatSink
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  // Input Parameters //
  Modelica.Units.SI.Pressure delp_fan = 190;
  //Delta p of 160 Pa
  Modelica.Units.SI.Temperature T_air_out = 303.15;
  //Fan outlet temperature K
  Modelica.Units.SI.Temperature T_air_in = 293.15;
  //Fan outlet temperature K
  Modelica.Units.SI.Density rho_air = 1.29;
  //Air density kg/m3
  Modelica.Units.SI.SpecificHeatCapacity Cp_air = 1005;
  //Air sp. heat cap J/kg K
  Modelica.Units.SI.Efficiency eta_fan = 0.7;
  //Fan electrical efficiency
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 1, redeclare package Medium = Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {10, -124}, extent = {{20, -80}, {0, -60}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {0, -84}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature AmbientTemp(T(displayUnit = "K") = 293.15) annotation(
    Placement(visible = true, transformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Continuous.LimPID limPID(Ni = 0.1, Td = 0, Ti = 0.1, controllerType = Modelica.Blocks.Types.SimpleController.PI, initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1, yMax = 880, yMin = 0, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Stack_temperature annotation(
    Placement(visible = true, transformation(origin = {-120, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {108, 78}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Set_Point annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {108, -8}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(extent = {{-50, 94}, {-30, 114}}), iconTransformation(extent = {{-50, 94}, {-30, 114}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(extent = {{30, 94}, {50, 114}}), iconTransformation(extent = {{30, 94}, {50, 114}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
    Placement(transformation(extent = {{-10, 102}, {10, 82}})));
  Modelica.Units.SI.Power Power_heatsink "The power consumed by the Heat sink (radiator)";
  Modelica.Blocks.Math.Gain PowerToCurrent(k = 1/24) annotation(
    Placement(transformation(extent = {{-6, -6}, {6, 6}}, rotation = 90, origin = {0, 66})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 1006.84 - limPID.y) annotation(
    Placement(transformation(extent = {{74, -10}, {94, 10}})));
  Modelica.Fluid.Sensors.Temperature TS_h_in(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-41, -37}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = (delp_fan*m_air)/(rho_air*eta_fan)) annotation(
    Placement(transformation(extent = {{-44, 30}, {-24, 50}})));
  //del T1=T_h_in-T_c_out;del T2= T_h_out-T_c_in
  Modelica.Fluid.Sensors.Temperature TS_h_out(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {39, -35}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Real LMTD;
  Real delT1;
  Real delT2;
  Modelica.Units.SI.MassFlowRate m_air;
equation
  Power_heatsink = pin_p.i*pin_p.v;
  delT1 = max(TS_h_in.T - T_air_out, 0.0002);
  delT2 = max(TS_h_out.T - T_air_in, 0.0001);
  LMTD = max(((delT1) - (delT2))/(log((delT1)/(delT2))), 0.001);
  m_air = realExpression.y*(LMTD)/(Cp_air*(T_air_out - T_air_in));
//*** DEFINE CONNECTIONS ***//
  connect(port_a, pipe.port_a) annotation(
    Line(points = {{-100, -54}, {-10, -54}}, color = {255, 0, 0}, thickness = 1.5));
  connect(pipe.port_b, port_b) annotation(
    Line(points = {{10, -54}, {100, -54}}, color = {0, 0, 255}, thickness = 1.5));
  connect(pipe.heatPorts[1], convection.solid) annotation(
    Line(points = {{0.1, -58.4}, {0.1, -71.2}, {1.77636e-15, -71.2}, {1.77636e-15, -74}}, color = {191, 0, 0}));
  connect(convection.fluid, AmbientTemp.port) annotation(
    Line(points = {{-1.77636e-15, -94}, {-1.77636e-15, -100}, {5.55112e-16, -100}}, color = {191, 0, 0}));
  connect(pin_n, signalCurrent.n) annotation(
    Line(points = {{40, 104}, {40, 92}, {10, 92}}, color = {0, 0, 255}));
  connect(pin_p, signalCurrent.p) annotation(
    Line(points = {{-40, 104}, {-40, 92}, {-10, 92}}, color = {0, 0, 255}));
  connect(signalCurrent.i, PowerToCurrent.y) annotation(
    Line(points = {{0, 80}, {0, 76.3}, {3.88578e-16, 76.3}, {3.88578e-16, 72.6}}, color = {0, 0, 127}));
  connect(Set_Point, limPID.u_s) annotation(
    Line(points = {{-120, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(Stack_temperature, limPID.u_m) annotation(
    Line(points = {{-120, -32}, {-70, -32}, {-70, -12}}, color = {0, 0, 127}));
  connect(port_a, TS_h_in.port) annotation(
    Line(points = {{-100, -54}, {-41, -54}, {-41, -42}}, color = {0, 127, 255}));
  connect(limPID.y, convection.Gc) annotation(
    Line(points = {{-59, 0}, {18, 0}, {18, -84}, {10, -84}}, color = {0, 0, 127}));
  connect(TS_h_out.port, port_b) annotation(
    Line(points = {{39, -40}, {40, -40}, {40, -54}, {100, -54}}, color = {0, 127, 255}));
  connect(realExpression1.y, PowerToCurrent.u) annotation(
    Line(points = {{-23, 40}, {-4.44089e-16, 40}, {-4.44089e-16, 58.8}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(origin = {-16, -71}, fillColor = {0, 0, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-84, 11}, {116, -9}}), Ellipse(origin = {40, 76}, fillColor = {166, 166, 166}, fillPattern = FillPattern.Sphere, extent = {{40, 14}, {-40, -6}}), Ellipse(origin = {-40, 76}, fillColor = {166, 166, 166}, fillPattern = FillPattern.Sphere, extent = {{40, 14}, {-40, -6}}), Ellipse(origin = {30, 78}, fillColor = {166, 166, 166}, fillPattern = FillPattern.Sphere, extent = {{-20, 12}, {-40, -6}}), Rectangle(origin = {0, 20}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-100, 7}, {100, -21}}, radius = 2), Ellipse(origin = {0, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}, startAngle = 180, closure = EllipseClosure.Chord), Ellipse(origin = {-57.2, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}, startAngle = 180, closure = EllipseClosure.Chord), Ellipse(origin = {57.2, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}, startAngle = 180, closure = EllipseClosure.Chord), Rectangle(origin = {-85.75, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Rectangle(origin = {-28.6, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Rectangle(origin = {28.6, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Ellipse(origin = {-85.75, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}), Ellipse(origin = {-28.6, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}), Ellipse(origin = {28.6, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}), Rectangle(origin = {85.75, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Ellipse(origin = {85.75, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Liquid-cooled heat sink that transfers heat from a thermal source to a coolant stream and regulates the coolant flow.</p>
<h2>Governing Equations</h2><pre>Power_heatsink = pin_p.i*pin_p.v;
delT1 = max(TS_h_in.T - T_air_out, 0.0002);
delT2 = max(TS_h_out.T - T_air_in, 0.0001);
LMTD = max(((delT1) - (delT2))/(log((delT1)/(delT2))), 0.001);
m_air = realExpression.y*(LMTD)/(Cp_air*(T_air_out - T_air_in));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>Power_heatsink</code></td><td>The power consumed by the Heat sink (radiator)</td></tr>
</tbody></table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>port_a</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td></td></tr>
<tr><td><code>Stack_temperature</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td></td></tr>
<tr><td><code>Set_Point</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td></td></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>port_b</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td></td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
</tbody></table>

</body></html>"));
end HeatSink;
