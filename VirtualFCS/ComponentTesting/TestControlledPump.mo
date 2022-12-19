within VirtualFCS.ComponentTesting;

model TestControlledPump "Model to test the recirculation blower component"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = 293.15));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, nPorts = 1, p = 101325*2)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Machines.ControlledPump pump(
  redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.00365}, head_nominal = {150000, 100000}), 
  m_flow_nominal=1, N_nominal = 365,
    control_m_flow=true,
    use_p_set=false,
    use_m_flow_set = true,
    redeclare package Medium = Medium
    ) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {-42, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(boundary.ports[1], pump.port_a) annotation(
    Line(points = {{-60, 0}, {-10, 0}}, color = {0, 127, 255}));
  connect(pump.port_b, fixedBoundary.ports[1]) annotation(
    Line(points = {{10, 0}, {60, 0}}, color = {0, 127, 255}));
  connect(realExpression.y, pump.m_flow_set) annotation(
    Line(points = {{-30, 30}, {-4, 30}, {-4, 8}}, color = {0, 0, 127}));
  annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end TestControlledPump;
