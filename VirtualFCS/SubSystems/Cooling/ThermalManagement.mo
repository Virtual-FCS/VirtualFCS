within VirtualFCS.SubSystems.Cooling;

model ThermalManagement
  outer Modelica.Fluid.System system "System properties";

  replaceable package H2O_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  replaceable package Cool_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  Modelica.Fluid.Sources.Boundary_pT CoolantSink(redeclare package Medium = Cool_Medium, nPorts = 1, p(displayUnit = "Pa"), use_p_in = false) annotation(
    Placement(transformation(origin = {-58, 100}, extent = {{-52, 10}, {-32, 30}})));
  Modelica.Fluid.Sources.Boundary_pT CoolantSource(redeclare package Medium = Cool_Medium, T = 293, nPorts = 1, p(displayUnit = "bar"), use_T_in = false, use_p_in = false) annotation(
    Placement(transformation(origin = {70, 0}, extent = {{140, 10}, {120, 30}})));
  Modelica.Fluid.Interfaces.FluidPort_a HotWaterIn(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-106, 70}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Fluid.Interfaces.FluidPort_b HotWaterOut(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {200, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {106, -78}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort THotIn(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {-66, 60}, extent = {{-8, -8}, {8, 8}}, rotation = -0)));
  Modelica.Fluid.Sensors.TemperatureTwoPort THotOut(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {36, 60}, extent = {{-8, -8}, {8, 8}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort TColdOut(redeclare package Medium = Cool_Medium) annotation(
    Placement(transformation(origin = {-68, 120}, extent = {{8, -8}, {-8, 8}})));
  Modelica.Blocks.Sources.Constant T_setpoint(k = 273.15 + 55) annotation(
    Placement(transformation(origin = {150, -10}, extent = {{-10, -10}, {10, 10}})));
  Fluid.SimplePump pump_coolant(redeclare package Medium = Cool_Medium) annotation(
    Placement(transformation(origin = {50, 20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage voltageSource(V = 48) annotation(
    Placement(transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {30, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.PI pi(k = 0.001, T = 1) annotation(
    Placement(transformation(origin = {110, 40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add error_flow(k2 = -1) annotation(
    Placement(transformation(origin = {140, 40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 0.5, uMin = 0.2) annotation(
    Placement(transformation(origin = {80, 40}, extent = {{10, -10}, {-10, 10}})));
  Fluid.HeatExchanger hex(redeclare package Medium_2 = Cool_Medium, redeclare package Medium_1 = H2O_Medium)  annotation(
    Placement(transformation(origin = {-20, 60}, extent = {{-20, 20}, {20, -20}})));
equation
  connect(TColdOut.port_b, CoolantSink.ports[1]) annotation(
    Line(points = {{-76, 120}, {-90, 120}}, color = {0, 127, 255}));
  connect(THotOut.port_b, HotWaterOut) annotation(
    Line(points = {{44, 60}, {200, 60}}, color = {0, 127, 255}));
  connect(THotIn.port_a, HotWaterIn) annotation(
    Line(points = {{-74, 60}, {-100, 60}}, color = {0, 127, 255}));
  connect(pump_coolant.port_a, CoolantSource.ports[1]) annotation(
    Line(points = {{60, 20}, {190, 20}}, color = {0, 127, 255}));
  connect(voltageSource.n, ground.p) annotation(
    Line(points = {{40, -20}, {30, -20}}, color = {0, 0, 255}));
  connect(voltageSource.n, pump_coolant.pin_n) annotation(
    Line(points = {{40, -20}, {40, -3}, {45, -3}, {45, 10}}, color = {0, 0, 255}));
  connect(voltageSource.p, pump_coolant.pin_p) annotation(
    Line(points = {{60, -20}, {60, -2}, {55.5, -2}, {55.5, 10}, {55, 10}}, color = {0, 0, 255}));
  connect(error_flow.y, pi.u) annotation(
    Line(points = {{129, 40}, {122, 40}}, color = {0, 0, 127}));
  connect(THotOut.T, error_flow.u1) annotation(
    Line(points = {{36, 68}, {36, 76}, {180, 76}, {180, 46}, {152, 46}}, color = {0, 0, 127}));
  connect(pump_coolant.u, limiter.y) annotation(
    Line(points = {{50, 29}, {50, 40}, {69, 40}}, color = {0, 0, 127}));
  connect(pi.y, limiter.u) annotation(
    Line(points = {{99, 40}, {91, 40}}, color = {0, 0, 127}));
  connect(error_flow.u2, T_setpoint.y) annotation(
    Line(points = {{152, 34}, {170, 34}, {170, -10}, {162, -10}}, color = {0, 0, 127}));
  connect(THotIn.port_b, hex.port_a1) annotation(
    Line(points = {{-58, 60}, {-40, 60}}, color = {0, 127, 255}));
  connect(hex.port_b1, THotOut.port_a) annotation(
    Line(points = {{0, 60}, {28, 60}}, color = {0, 127, 255}));
  connect(pump_coolant.port_b, hex.port_a2) annotation(
    Line(points = {{40, 28}, {-20, 28}, {-20, 40}}, color = {0, 127, 255}));
  connect(TColdOut.port_a, hex.port_b2) annotation(
    Line(points = {{-60, 120}, {-20, 120}, {-20, 80}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {200, 200}})),
    experiment(Tolerance = 1e-6, StopTime = 100),
    Icon(graphics = {Rectangle(origin = {0, -1}, fillColor = {85, 0, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 4, extent = {{-98, 99}, {98, -99}}), Text(origin = {0, 1}, textColor = {255, 255, 255}, extent = {{-76, 65}, {76, -65}}, textString = "Thermal Sub-System")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    version = "1",
    conversion(noneFromVersion = ""),
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p><b>ThermalManagement</b> is a compact cooling-loop example that transfers heat from a hot-water circuit to a separate coolant circuit.</p><h3>Composition and operation</h3><p>A heat exchanger connects the hot-water ports <code>HotWaterIn</code>/<code>HotWaterOut</code> to the coolant loop. The coolant loop contains a pump, temperature sensors, fixed-temperature source and sink boundaries, and a PI controller. The controller compares the cold-side temperature with a 328.15 K set point and commands the pump within a 0.2 to 0.5 flow range.</p><p>The hot-water and coolant media are replaceable. The 48 V source and boundary conditions are example values for system-level thermal-management studies.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>system</code> (Modelica.Fluid.System), <code>CoolantSink</code> (Modelica.Fluid.Sources.Boundary_pT), <code>CoolantSource</code> (Modelica.Fluid.Sources.Boundary_pT), <code>THotIn</code> (Modelica.Fluid.Sensors.TemperatureTwoPort), <code>THotOut</code> (Modelica.Fluid.Sensors.TemperatureTwoPort), <code>TColdOut</code> (Modelica.Fluid.Sensors.TemperatureTwoPort), <code>T_setpoint</code> (Modelica.Blocks.Sources.Constant), <code>pump_coolant</code> (Fluid.SimplePump), <code>voltageSource</code> (Modelica.Electrical.Analog.Sources.ConstantVoltage), <code>ground</code> (Modelica.Electrical.Analog.Basic.Ground), <code>pi</code> (Modelica.Blocks.Continuous.PI), <code>error_flow</code> (Modelica.Blocks.Math.Add), <code>limiter</code> (Modelica.Blocks.Nonlinear.Limiter), <code>hex</code> (Fluid.HeatExchanger).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>HotWaterIn</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td></td></tr>
<tr><td><code>HotWaterOut</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td></td></tr>
</table>
</body>
</html>"));
end ThermalManagement;
