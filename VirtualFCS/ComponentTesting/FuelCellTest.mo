within VirtualFCS.ComponentTesting;

model FuelCellTest
  extends Modelica.Icons.Example;
  Electrochemical.Hydrogen.FuelCell fc annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogen(redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2, nPorts = 1)  annotation(
    Placement(transformation(origin = {-50, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary air(redeclare package Medium = VirtualFCS.Media.CathodeAir, nPorts = 1)  annotation(
    Placement(transformation(origin = {50, 10}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature setT(T = 343.15)  annotation(
    Placement(transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.Sine R_value(f (displayUnit = "mHz")= 0.1, phase = 0, offset = 30, startTime = 1, amplitude = 10)  annotation(
    Placement(transformation(origin = {50, 90}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(hydrogen.ports[1], fc.anode_in) annotation(
    Line(points = {{-40, 10}, {-14, 10}}, color = {0, 127, 255}));
  connect(air.ports[1], fc.cathode_in) annotation(
    Line(points = {{40, 10}, {14, 10}}, color = {0, 127, 255}));
  connect(setT.port, fc.heatPort) annotation(
    Line(points = {{-20, -50}, {0, -50}, {0, -10}}, color = {191, 0, 0}));
  connect(fc.pin_n, ground.p) annotation(
    Line(points = {{-10, 14}, {-10, 80}, {-30, 80}, {-30, 60}}, color = {0, 0, 255}));
  connect(resistor.p, fc.pin_p) annotation(
    Line(points = {{10, 60}, {10, 14}}, color = {0, 0, 255}));
  connect(resistor.n, fc.pin_n) annotation(
    Line(points = {{-10, 60}, {-10, 14}}, color = {0, 0, 255}));
  connect(R_value.y, resistor.R) annotation(
    Line(points = {{40, 90}, {0, 90}, {0, 72}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 60, Tolerance = 1e-06, Interval = 0.12));
end FuelCellTest;
