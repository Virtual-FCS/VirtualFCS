within VirtualFCS.ComponentTesting;

model FuelCellTest
  extends Modelica.Icons.Example;
  
  import Modelica.Constants.F;
  
  parameter Real lambda = 3;
  parameter Integer N_cells = 42 "Number of cells in the stack";
  package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  package Cathode_Medium = VirtualFCS.Media.CathodeAir;
  package Coolant_Medium = Modelica.Media.Incompressible.Examples.Glycol47;
  
  Electrochemical.Hydrogen.FuelCell fc(N_cells=N_cells, redeclare package Anode_Medium = Anode_Medium, redeclare package Cathode_Medium = Cathode_Medium, redeclare package Coolant_Medium = Coolant_Medium, redeclare VirtualFCS.Electrochemical.Hydrogen.MassTransportLossSimple mass_transport, redeclare VirtualFCS.Electrochemical.Hydrogen.OhmicResistance ohmic(T), redeclare VirtualFCS.Electrochemical.Hydrogen.ActivationLossSimple activation, redeclare VirtualFCS.Electrochemical.Hydrogen.VSourceNernst v_source, cathode(p_start = air_sink.p), anode(p_start = hydrogen_source.p)) annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}})));


  Modelica.Fluid.Sources.FixedBoundary hydrogen_source(redeclare package Medium = Anode_Medium, nPorts = 1, p = 2.1e5)  annotation(
    Placement(transformation(origin = {-44, 10}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Fluid.Sources.FixedBoundary air_sink(redeclare package Medium = Cathode_Medium, nPorts = 1, p (displayUnit = "bar")= 2e5)  annotation(
    Placement(transformation(origin = {60, -10}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.FixedBoundary coolant_sink(redeclare package Medium = Coolant_Medium, nPorts = 1) annotation(
    Placement(transformation(origin = {25, -25}, extent = {{5, -5}, {-5, 5}})));
  Modelica.Fluid.Sources.MassFlowSource_T coolant_source(nPorts = 1, redeclare package Medium = Coolant_Medium, m_flow = 0.05, T = 323.15) annotation(
    Placement(transformation(origin = {-14, -26}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Fluid.Sources.MassFlowSource_T air_source(redeclare package Medium = Cathode_Medium, m_flow = 7.5e-4, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(transformation(origin = {46, 10}, extent = {{6, -6}, {-6, 6}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(transformation(origin = {10, 40}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  Modelica.Blocks.Sources.Step R_values(height = -2.4, offset = 3, startTime = 30) annotation(
    Placement(transformation(origin = {50, 80}, extent = {{10, -10}, {-10, 10}})));
equation
 
  connect(fc.pin_n, ground.p) annotation(
    Line(points = {{-10, 14}, {-10, 80}, {-30, 80}, {-30, 60}}, color = {0, 0, 255}));
  connect(resistor.n, fc.pin_n) annotation(
    Line(points = {{-10, 60}, {-10, 14}}, color = {0, 0, 255}));
  connect(fc.coolant_out, coolant_sink.ports[1]) annotation(
    Line(points = {{4, -12}, {4, -24}, {20, -24}}, color = {0, 127, 255}));
  connect(fc.anode_in, hydrogen_source.ports[1]) annotation(
    Line(points = {{-14, 10}, {-40, 10}}, color = {0, 127, 255}));
  connect(fc.cathode_out, air_sink.ports[1]) annotation(
    Line(points = {{14, -10}, {56, -10}}, color = {0, 127, 255}));
  connect(air_source.ports[1], fc.cathode_in) annotation(
    Line(points = {{40, 10}, {14, 10}}, color = {0, 127, 255}));
  connect(resistor.p, currentSensor.n) annotation(
    Line(points = {{10, 60}, {10, 50}}, color = {0, 0, 255}));
  connect(currentSensor.p, fc.pin_p) annotation(
    Line(points = {{10, 30}, {10, 14}}, color = {0, 0, 255}));
  connect(fc.coolant_in, coolant_source.ports[1]) annotation(
    Line(points = {{-4, -12}, {-4, -26}, {-8, -26}}, color = {0, 127, 255}));
  connect(resistor.R, R_values.y) annotation(
    Line(points = {{0, 72}, {0, 80}, {39, 80}}, color = {0, 0, 127}));


annotation(
    experiment(StartTime = 0, StopTime = 60, Tolerance = 1e-06, Interval = 0.5));
end FuelCellTest;
