within VirtualFCS.ComponentTesting;

model CompressorTest_30kW "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(transformation(origin = {140, 82}, extent = {{-10, -10}, {10, 10}})));
  package Medium = Modelica.Media.Air.MoistAir(reference_X={0.01,0.99});
  //package Medium = VirtualFCS.Media.CathodeAir;
  Modelica.Fluid.Sources.FixedBoundary AirSink(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {-82, -6}, extent = {{-10, -10}, {10, 10}})));
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {2, 52}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Fluid.Sources.FixedBoundary AirSink2(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {160, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {112, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temp_out_comp (redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {80, 14}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = 11000, offset = 0.01, startTime = 10)  annotation(
    Placement(transformation(origin = {-74, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant backPressure(k = 250000)  annotation(
    Placement(transformation(origin = {138, -46}, extent = {{-10, -10}, {10, 10}})));
  Fluid.ThrottleValve_2 throttleValve(m_flow_nominal = 0.5, redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {112, -8}, extent = {{-10, -10}, {10, 10}})));
  Fluid.Compressor_30kW compressor(redeclare package Medium = Medium, rpm_nom = 11000) annotation(
    Placement(transformation(origin = {1, -7}, extent = {{-29, -29}, {29, 29}})));
  Modelica.Fluid.Vessels.ClosedVolume FuelCellDummy(redeclare package Medium = Medium, V = 1, nPorts = 2, use_portsData = false) annotation(
    Placement(transformation(origin = {48, 16}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(pressure.port, throttleValve.port_a) annotation(
    Line(points = {{112, -40}, {112, -38}, {102, -38}, {102, -8}}, color = {0, 127, 255}));
  connect(backPressure.y, throttleValve.FC_pAirOut_P) annotation(
    Line(points = {{149, -46}, {150, -46}, {150, -9}, {112, -9}}, color = {0, 0, 127}));
  connect(throttleValve.Measured_inlet_Air_pressure, pressure.p) annotation(
    Line(points = {{101, -2}, {89, -2}, {89, -50}, {101, -50}}, color = {0, 0, 127}));
  connect(throttleValve.port_b, AirSink2.ports[1]) annotation(
    Line(points = {{122, -8}, {150, -8}}, color = {0, 127, 255}));
  connect(batterySystem.pin_p, compressor.pin_p) annotation(
    Line(points = {{6, 42}, {6, 26}, {7, 26}, {7, 10}}, color = {0, 0, 255}));
  connect(compressor.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-4, 10}, {-2, 10}, {-2, 42}}, color = {0, 0, 255}));
  connect(step.y, compressor.controlInterface) annotation(
    Line(points = {{-62, 42}, {-46, 42}, {-46, 11}, {-32, 11}}, color = {0, 0, 127}));
  connect(compressor.Output, temp_out_comp.port) annotation(
    Line(points = {{33, -7}, {80, -7}, {80, 4}}, color = {0, 127, 255}));
  connect(AirSink.ports[1], compressor.Input) annotation(
    Line(points = {{-72, -6}, {-51, -6}, {-51, -7}, {-31, -7}}, color = {0, 127, 255}));
  connect(compressor.Output, FuelCellDummy.ports[1]) annotation(
    Line(points = {{33, -7}, {48, -7}, {48, 6}}, color = {0, 127, 255}));
  connect(FuelCellDummy.ports[2], throttleValve.port_a) annotation(
    Line(points = {{48, 6}, {48, -8}, {102, -8}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})));
end CompressorTest_30kW;
