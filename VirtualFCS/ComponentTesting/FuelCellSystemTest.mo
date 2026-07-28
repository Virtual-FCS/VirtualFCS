within VirtualFCS.ComponentTesting;

model FuelCellSystemTest
  extends Modelica.Icons.Example;
  Electrochemical.Hydrogen.FuelCellSystem fcs(fuelCell(redeclare VirtualFCS.Electrochemical.Hydrogen.OhmicResistance ohmic, redeclare VirtualFCS.Electrochemical.Hydrogen.MassTransportLossSimple mass_transport, redeclare VirtualFCS.Electrochemical.Hydrogen.ActivationLossSimple activation, cathode(R_flow = 1), anode(R_flow = 1)), subSystemAir(PID_compressor(k = 1e3, Ti = 1))) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {0, 40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Step R_values(height = -2.99, offset = 3, startTime = 30) annotation(
    Placement(transformation(origin = {50, 60}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-40, 30}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(resistor.p, fcs.pin_p) annotation(
    Line(points = {{10, 40}, {10, 18}}, color = {0, 0, 255}));
  connect(resistor.n, fcs.pin_n) annotation(
    Line(points = {{-10, 40}, {-10, 18}}, color = {0, 0, 255}));
  connect(resistor.R, R_values.y) annotation(
    Line(points = {{0, 52}, {0, 60}, {39, 60}}, color = {0, 0, 127}));
  connect(ground.p, resistor.n) annotation(
    Line(points = {{-40, 40}, {-10, 40}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 60, Tolerance = 1e-06, Interval = 0.012),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end FuelCellSystemTest;
