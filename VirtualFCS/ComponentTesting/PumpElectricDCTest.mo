within VirtualFCS.ComponentTesting;
model PumpElectricDCTest "Simple model to test the PumpElectricDC model"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
                                                                                                                 constrainedby
    Modelica.Media.Interfaces.PartialMedium;
  inner Modelica.Fluid.System system annotation (
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, nPorts = 1, p = system.p_start)  annotation (
    Placement(visible = true, transformation(origin={-92,0},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium,
      nPorts=1)                                                                                      annotation (
    Placement(visible = true, transformation(origin={92,0},    extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(
    C_bat_pack=2000,                                             SOC_init = 0.9,
    V_max_bat_pack=62,
    V_min_bat_pack=58,
    V_nom_bat_pack=60,                                                                                                                          m_bat_pack = 1) annotation (
    Placement(visible = true, transformation(origin={-46,58},  extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Sources.Sine sine1(amplitude = 0.15, f = 1, offset = 0.005, startTime = 350) annotation (
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Abs abs1 annotation (
    Placement(visible = true, transformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC annotation (
    Placement(visible = true, transformation(origin={-46,0},  extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=1,
    rising=100,
    width=100,
    falling=100,
    period=400,
    nperiod=-1,
    offset=0,
    startTime=50)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Modelica.Fluid.Pipes.DynamicPipe pipeCoolant(
    redeclare package Medium = Medium,
    T_start=293.15,
    diameter=0.003,
    length=1,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_vb,
    nNodes=1,
    nParallel=1,
    p_a_start=102502,
    use_HeatTransfer=true)                                                                                                                                                                                                         annotation (
    Placement(visible = true, transformation(                   extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe(
    use_T_start=true,
    length=0.2,
    diameter=0.01,
    nParallel=5,
    nNodes=1,
    redeclare package Medium = Medium,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b,
    use_HeatTransfer=true)                                                                                                                                                                              annotation (
    Placement(visible = true, transformation(origin={76,-70},    extent = {{20, -80}, {0, -60}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-59, 37}, extent = {{-5, -5}, {5, 5}})));
equation
  connect(sine1.y, abs1.u) annotation (
    Line(points={{-59,-70},{-42,-70}},      color = {0, 0, 127}));
  connect(boundary.ports[1], pumpElectricDC.Input) annotation (
    Line(points={{-82,0},{-64,0}},      color = {0, 0, 255}, thickness = 1.5));
  connect(batterySystem.pin_n, pumpElectricDC.pin_n) annotation (
    Line(points={{-50.4,48.4},{-50.4,24},{-52,24},{-52,16}},
                                                  color = {0, 0, 255}));
  connect(batterySystem.pin_p, pumpElectricDC.pin_p) annotation (
    Line(points={{-41.6,48.4},{-41.6,24},{-40,24},{-40,16}},
                                               color = {0, 0, 255}));
  connect(trapezoid.y, pumpElectricDC.contol_input)
    annotation (Line(points={{-39,-40},{-36,-40},{-36,-24},{-52,-24},{-52,-16}},
                                                           color={0,0,127}));
  connect(pumpElectricDC.Output, pipeCoolant.port_a)
    annotation (Line(points={{-28,0},{-10,0}}, color={0,127,255}));
  connect(pipeCoolant.port_b, massFlowRate.port_a)
    annotation (Line(points={{10,0},{28,0}}, color={0,127,255}));
  connect(massFlowRate.port_b, pipe.port_a) annotation (Line(points={{48,0},{52,
          0},{52,1.72085e-15},{56,1.72085e-15}}, color={0,127,255}));
  connect(pipe.port_b, fixedBoundary.ports[1]) annotation (Line(points={{76,
          -7.21645e-16},{79,-7.21645e-16},{79,6.66134e-16},{82,6.66134e-16}},
        color={0,127,255}));
  connect(batterySystem.pin_n, ground.p) annotation(
    Line(points = {{-50, 48}, {-59, 48}, {-59, 42}}, color = {0, 0, 255}));

annotation (
  experiment(
      StopTime=1200,
      Interval=0.5,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This test drives an electric DC pump with a trapezoidal control beginning at 50 s. The signal has amplitude 1, rise and fall times of 100 s, width 100 s, and a 400 s period.</p><p>The water circuit uses five parallel channels, a 1 m by 0.003 m inlet pipe, a 0.2 m by 0.01 m downstream pipe, and a 60 V nominal battery supply with 58 V to 62 V limits.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>system</code> (Modelica.Fluid.System), <code>boundary</code> (Modelica.Fluid.Sources.FixedBoundary), <code>fixedBoundary</code> (Modelica.Fluid.Sources.FixedBoundary), <code>batterySystem</code> (VirtualFCS.Electrochemical.Battery.BatterySystem), <code>sine1</code> (Modelica.Blocks.Sources.Sine), <code>abs1</code> (Modelica.Blocks.Math.Abs), <code>pumpElectricDC</code> (VirtualFCS.Fluid.PumpElectricDC), <code>trapezoid</code> (Modelica.Blocks.Sources.Trapezoid), <code>massFlowRate</code> (Modelica.Fluid.Sensors.MassFlowRate), <code>pipeCoolant</code> (Modelica.Fluid.Pipes.DynamicPipe), <code>pipe</code> (Modelica.Fluid.Pipes.DynamicPipe), <code>ground</code> (Modelica.Electrical.Analog.Basic.Ground).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end PumpElectricDCTest;
