within VirtualFCS.ComponentTesting;

model SubSystemAirTest "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
  package Medium = VirtualFCS.Media.CathodeAir;
  
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {0, -70}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  SubSystems.Air.SubSystemAir subSystemAir(redeclare package Medium = Medium)   annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Trapezoid CurrentFC(amplitude = 2000, rising = 5, width = 20, falling = 5, offset = 1000, period = 50)  annotation(
    Placement(transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Vessels.ClosedVolume FuelCellDummy(V = 0.01, nPorts = 2, redeclare package Medium = Medium, use_portsData = false, p_start = 3*101325, T_start = 293.15, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(transformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(batterySystem.pin_n, subSystemAir.pin_n) annotation(
    Line(points = {{-4, -60}, {-8.75, -60}, {-8.75, -18}, {-10, -18}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, subSystemAir.pin_p) annotation(
    Line(points = {{4, -60}, {10, -60}, {10, -18}}, color = {0, 0, 255}));
  connect(CurrentFC.y, subSystemAir.stackCurrent) annotation(
    Line(points = {{-58, 10}, {-22, 10}}, color = {0, 0, 127}));
  connect(subSystemAir.toStack, FuelCellDummy.ports[1]) annotation(
    Line(points = {{-12, 24}, {0, 24}, {0, 70}}, color = {0, 127, 255}));
  connect(subSystemAir.fromStack, FuelCellDummy.ports[2]) annotation(
    Line(points = {{12, 24}, {0, 24}, {0, 70}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})));
end SubSystemAirTest;
