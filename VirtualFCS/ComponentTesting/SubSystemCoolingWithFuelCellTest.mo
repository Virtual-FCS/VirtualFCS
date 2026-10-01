within VirtualFCS.ComponentTesting;

model SubSystemCoolingWithFuelCellTest
  extends Modelica.Icons.Example;
  import Modelica.Constants.F;
  parameter Real lambda = 3;
  parameter Real P_air = 2.5e5;
  parameter Integer N_cells = 42 "Number of cells in the stack";
  parameter Modelica.Units.SI.Temperature T_stack = 320 "Stack temperature";
  package cathode_medium = Media.MoistAir;
  Electrochemical.Hydrogen.FuelCells.FuelCell fc(N_cells = N_cells, heatCapacitor(T(start = 323.15, fixed = true))) annotation(
    Placement(transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.FixedBoundary hydrogen(redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2, nPorts = 1) annotation(
    Placement(transformation(origin = {-44, 10}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Fluid.Sources.FixedBoundary air_sink(redeclare package Medium = Media.MoistAir, nPorts = 1, p = P_air) annotation(
    Placement(transformation(origin = {60, -10}, extent = {{4, -4}, {-4, 4}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {0, 60}, extent = {{10, -10}, {-10, 10}})));
  inner Modelica.Fluid.System system(p_start = P_air)  annotation(
    Placement(transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T air_source(redeclare package Medium = Media.MoistAir, m_flow = 7.5e-5, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(transformation(origin = {46, 10}, extent = {{6, -6}, {-6, 6}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(transformation(origin = {10, 40}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  Modelica.Blocks.Sources.Step R_values(height = 20, offset = 30, startTime = 250) annotation(
    Placement(transformation(origin = {50, 76}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  SubSystems.Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(transformation(origin = {0, -48}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_sensor annotation(
    Placement(transformation(origin = {-40, -41}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage V_source(V = 24) annotation(
    Placement(transformation(origin = {0, -80}, extent = {{10, -10}, {-10, 10}})));
equation
  connect(fc.pin_n, ground.p) annotation(
    Line(points = {{-10, 14}, {-10, 80}, {-30, 80}, {-30, 60}}, color = {0, 0, 255}));
  connect(resistor.n, fc.pin_n) annotation(
    Line(points = {{-10, 60}, {-10, 14}}, color = {0, 0, 255}));
  connect(fc.anode_in, hydrogen.ports[1]) annotation(
    Line(points = {{-14, 10}, {-40, 10}}, color = {0, 127, 255}));
  connect(fc.cathode_out, air_sink.ports[1]) annotation(
    Line(points = {{14, -10}, {56, -10}}, color = {0, 127, 255}));
  connect(air_source.ports[1], fc.cathode_in) annotation(
    Line(points = {{40, 10}, {14, 10}}, color = {0, 127, 255}));
  connect(resistor.p, currentSensor.n) annotation(
    Line(points = {{10, 60}, {10, 50}}, color = {0, 0, 255}));
  connect(currentSensor.p, fc.pin_p) annotation(
    Line(points = {{10, 30}, {10, 14}}, color = {0, 0, 255}));
  connect(R_values.y, resistor.R) annotation(
    Line(points = {{40, 76}, {0, 76}, {0, 72}}, color = {0, 0, 127}));
  connect(subSystemCooling.from_stack, fc.coolant_out) annotation(
    Line(points = {{8, -31}, {8, -20.5}, {4, -20.5}, {4, -12}}, color = {0, 127, 255}));
  connect(subSystemCooling.to_stack, fc.coolant_in) annotation(
    Line(points = {{-8, -31}, {-8, -20.5}, {-4, -20.5}, {-4, -12}}, color = {0, 127, 255}));
  connect(T_sensor.T, subSystemCooling.stackTemperature) annotation(
    Line(points = {{-29, -41}, {-15, -41}}, color = {0, 0, 127}));
  connect(fc.heatPort, T_sensor.port) annotation(
    Line(points = {{0, -10}, {0, -24}, {-50, -24}, {-50, -41}}, color = {191, 0, 0}));
  connect(V_source.p, subSystemCooling.pin_p) annotation(
    Line(points = {{10, -81}, {8.5, -81}, {8.5, -71}, {7, -71}, {7, -61}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_n, V_source.n) annotation(
    Line(points = {{-7, -61}, {-8, -61}, {-8, -71}, {-10, -71}, {-10, -81}}, color = {0, 0, 255}));
  connect(V_source.n, ground.p) annotation(
    Line(points = {{-10, -80}, {-60, -80}, {-60, 60}, {-30, 60}}, color = {0, 0, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 500, Tolerance = 1e-06, Interval = 0.833333));
annotation(Documentation(info = "<html><p>This test couples the cooling subsystem to a 42-cell fuel cell. It uses lambda = 3, 2.5e5 Pa air pressure, 7.5e-5 kg/s air flow, 320 K stack temperature, 323.15 K coolant start temperature, and a 24 V supply.</p><p>The load resistance steps from 30 ohm to 50 ohm at 250 s.</p></html>"));
end SubSystemCoolingWithFuelCellTest;
