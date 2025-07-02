within VirtualFCS.ComponentTesting;

model SubSystemAirTest "Simple model to test the compressor component"
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system(T_start = 300, p_start = 101325, m_flow_start = 0) annotation(
    Placement(transformation(origin = {140, 82}, extent = {{-10, -10}, {10, 10}})));
  //replaceable package Medium = Modelica.Media.Air.MoistAir;//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air(reference_X = {0.01, 0.99});
  Modelica.Fluid.Sources.FixedBoundary AirFromFuelCell(redeclare package Medium = Medium, nPorts = 1, p = subSystemAir.set_air_pressure, use_T = false, use_p = false) annotation(
    Placement(transformation(origin = {40, 77}, extent = {{16, -15}, {-16, 15}}, rotation = -0)));
  Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {6, -72}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Fluid.Sources.FixedBoundary AirToFuelCell(redeclare package Medium = Medium, nPorts = 2, p = subSystemAir.set_air_pressure, use_T = false, use_p = false) annotation(
    Placement(transformation(origin = {-26, 77}, extent = {{-16, -15}, {16, 15}})));
  SubSystems.Air.SubSystemAir_30kW subSystemAir(set_air_pressure = 2.4e5)  annotation(
    Placement(transformation(origin = {7, -11}, extent = {{-21, -21}, {21, 21}})));
  Modelica.Blocks.Sources.Trapezoid CurrentFC(amplitude = 2000, rising = 5, width = 20, falling = 5, offset = 1000, period = 50)  annotation(
    Placement(transformation(origin = {-70, 32}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(CurrentFC.y, subSystemAir.control) annotation(
    Line(points = {{-58, 32}, {-38, 32}, {-38, 0}, {-16, 0}}, color = {0, 0, 127}));
  connect(batterySystem.pin_n, subSystemAir.pin_n) annotation(
    Line(points = {{2, -62}, {-4, -62}, {-4, -30}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, subSystemAir.pin_p) annotation(
    Line(points = {{10, -62}, {18, -62}, {18, -30}}, color = {0, 0, 255}));
  connect(AirToFuelCell.ports[1], subSystemAir.Output) annotation(
    Line(points = {{-10, 78}, {-6, 78}, {-6, 14}}, color = {0, 127, 255}));
  connect(AirFromFuelCell.ports[1], subSystemAir.Input) annotation(
    Line(points = {{24, 78}, {20, 78}, {20, 14}}, color = {0, 127, 255}));
  annotation(
    experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{88, -38}, {88, -38}})}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 80}})));
end SubSystemAirTest;
