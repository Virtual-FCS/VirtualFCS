within VirtualFCS.ComponentTesting;

model FuelCellTest
  extends Modelica.Icons.Example;
  
  import Modelica.Constants.F;
  
  parameter Real lambda = 3;
  
  Electrochemical.Hydrogen.FuelCell fc(heatCapacitor(T(start = 323.15, fixed = true)))  annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogen(redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2, nPorts = 1)  annotation(
    Placement(transformation(origin = {-44, 10}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Fluid.Sources.FixedBoundary air_sink(redeclare package Medium = VirtualFCS.Media.CathodeAir, nPorts = 1)  annotation(
    Placement(transformation(origin = {44, -10}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Sine R_value(f (displayUnit = "mHz")= 0.1, phase = 0, offset = 30, startTime = 1, amplitude = 10)  annotation(
    Placement(transformation(origin = {50, 90}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary coolant_sink(redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, nPorts = 1) annotation(
    Placement(transformation(origin = {25, -25}, extent = {{5, -5}, {-5, 5}})));
  Modelica.Fluid.Sources.MassFlowSource_T coolant_source(nPorts = 1, redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47, m_flow = 1, T = 323.15) annotation(
    Placement(transformation(origin = {-14, -26}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Fluid.Sources.MassFlowSource_T air_source(redeclare package Medium = VirtualFCS.Media.CathodeAir, m_flow = 1, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {46, 10}, extent = {{6, -6}, {-6, 6}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(transformation(origin = {10, 40}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain stoich_air(k = lambda*0.029/(0.19*4*F)*fc.N_cell)  annotation(
    Placement(transformation(origin = {44, 40}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature fixedTemperature(T = 60)  annotation(
    Placement(transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(fc.pin_n, ground.p) annotation(
    Line(points = {{-10, 14}, {-10, 80}, {-30, 80}, {-30, 60}}, color = {0, 0, 255}));
  connect(resistor.n, fc.pin_n) annotation(
    Line(points = {{-10, 60}, {-10, 14}}, color = {0, 0, 255}));
  connect(R_value.y, resistor.R) annotation(
    Line(points = {{40, 90}, {0, 90}, {0, 72}}, color = {0, 0, 127}));
  connect(fc.coolant_out, coolant_sink.ports[1]) annotation(
    Line(points = {{4, -12}, {4, -24}, {20, -24}}, color = {0, 127, 255}));
  connect(fc.anode_in, hydrogen.ports[1]) annotation(
    Line(points = {{-14, 10}, {-40, 10}}, color = {0, 127, 255}));
  connect(fc.cathode_out, air_sink.ports[1]) annotation(
    Line(points = {{14, -10}, {40, -10}}, color = {0, 127, 255}));
  connect(air_source.ports[1], fc.cathode_in) annotation(
    Line(points = {{40, 10}, {14, 10}}, color = {0, 127, 255}));
  connect(currentSensor.i, stoich_air.u) annotation(
    Line(points = {{21, 40}, {39, 40}}, color = {0, 0, 127}));
  connect(resistor.p, currentSensor.n) annotation(
    Line(points = {{10, 60}, {10, 50}}, color = {0, 0, 255}));
  connect(currentSensor.p, fc.pin_p) annotation(
    Line(points = {{10, 30}, {10, 14}}, color = {0, 0, 255}));
  connect(stoich_air.y, air_source.m_flow_in) annotation(
    Line(points = {{48, 40}, {60, 40}, {60, 14}, {52, 14}}, color = {0, 0, 127}));
  connect(fc.coolant_in, coolant_source.ports[1]) annotation(
    Line(points = {{-4, -12}, {-4, -26}, {-8, -26}}, color = {0, 127, 255}));

annotation(
    experiment(StartTime = 0, StopTime = 60, Tolerance = 1e-06, Interval = 0.12));
end FuelCellTest;
