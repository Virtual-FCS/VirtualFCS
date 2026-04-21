within VirtualFCS.ComponentTesting;

model SubSystemAirTest_old "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(transformation(origin = {140, 82}, extent = {{-10, -10}, {10, 10}})));
  package Medium = Media.CathodeAir;
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {6, -72}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  SubSystems.Air.SubSystemAir_old subSystemAir(set_air_pressure = 2.4e5, redeclare package Medium = Medium, N_cell = 42, redeclare VirtualFCS.Fluid.Compressor compressor(redeclare package Medium = Medium)) annotation(
    Placement(transformation(origin = {7, -11}, extent = {{-21, -21}, {21, 21}})));
  Modelica.Fluid.Vessels.ClosedVolume FuelCellDummy(V = 1, nPorts = 2, redeclare package Medium = Medium, use_portsData = false) annotation(
    Placement(transformation(origin = {8, 76}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step currentFC(height = 6000, offset = 1000, startTime = 10) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(batterySystem.pin_n, subSystemAir.pin_n) annotation(
    Line(points = {{2, -62}, {-4, -62}, {-4, -30}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, subSystemAir.pin_p) annotation(
    Line(points = {{10, -62}, {18, -62}, {18, -30}}, color = {0, 0, 255}));
  connect(currentFC.y, subSystemAir.stackCurrent) annotation(
    Line(points = {{-59, 0}, {-16, 0}}, color = {0, 0, 127}));
  connect(subSystemAir.toStack, FuelCellDummy.ports[1]) annotation(
    Line(points = {{-6, 14}, {8, 14}, {8, 66}}, color = {0, 127, 255}));
  connect(subSystemAir.fromStack, FuelCellDummy.ports[2]) annotation(
    Line(points = {{20, 14}, {8, 14}, {8, 66}}, color = {0, 127, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.5),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})));
end SubSystemAirTest_old;
