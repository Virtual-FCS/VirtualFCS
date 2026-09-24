within VirtualFCS.Chemical.Examples;

model AmmoniaCrackerDynTest
  extends Modelica.Icons.Example;
  package AmmoniaMedium = Media.CrackedAmmonia;
  parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";
  parameter Modelica.Units.SI.Temperature T_out_target = 550 + 273.15 "Target outlet temperature (K)";
  parameter Modelica.Units.SI.Temperature T_in = 550 + 273.15 "Inlet temperature (K)";
  parameter Integer N = 10 "Number of reactor computational segments";
  parameter Real heatWeights[N] = {1.8, 1.5, 1.2, 1.0, 0.9, 0.8, 0.7, 0.6, 0.3, 0.2} "Relative heat distribution weights from inlet to outlet";
  Chemical.AmmoniaCracker.AmmoniaCrackerDyn ammoniaCracker(N = N, dp_small = 100, T_out_target = T_out_target, redeclare package AmmoniaMedium = AmmoniaMedium, constantTemperature = false) annotation(
    Placement(transformation(origin = {9, 5}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Fluid.Sources.FixedBoundary cracked_gas_sink(redeclare package Medium = AmmoniaMedium, nPorts = 1, use_p = true, p = P_out, use_T = false, T = T_in) annotation(
    Placement(transformation(origin = {86, 10}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, use_m_flow_in = false, m_flow = 0.3, nPorts = 1, T = T_in, X = {1, 0, 0}) annotation(
    Placement(transformation(origin = {-68, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature T_out_cracker(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {46, -40}, extent = {{10, -10}, {-10, 10}})));
  AmmoniaCracker.ElectricHeatingDistr electricHeatingDistr(N = N, T_out_target = T_out_target)  annotation(
    Placement(transformation(origin = {8, -42}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
equation
  connect(ammoniaCracker.outlet_cracked_gas, cracked_gas_sink.ports[1]) annotation(
    Line(points = {{32, 10}, {76, 10}}, color = {0, 127, 255}));
  connect(ammoniaCracker.inlet_nh3_feed, ammonia_source.ports[1]) annotation(
    Line(points = {{-14, 10}, {-58, 10}}, color = {0, 127, 255}));
  connect(T_out_cracker.port, ammoniaCracker.outlet_cracked_gas) annotation(
    Line(points = {{46, -50}, {46, -64}, {58, -64}, {58, 10}, {32, 10}}, color = {0, 127, 255}));
  connect(T_out_cracker.T, electricHeatingDistr.T_meas) annotation(
    Line(points = {{39, -40}, {29, -40}, {29, -39}, {17, -39}}, color = {0, 0, 127}));
  connect(electricHeatingDistr.heatPorts, ammoniaCracker.heatPorts) annotation(
    Line(points = {{8, -32}, {10, -32}, {10, -18}}, color = {191, 0, 0}, thickness = 0.5));
  annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.01),
    Documentation(info = "<html><p>This test feeds the dynamic ammonia cracker with 0.3 kg/s at 550 degC and evaluates the outlet at 3e5 Pa. The inlet composition is set to X = {1, 0, 0} in the cracked-ammonia medium order {NH3, H2, N2}. The example uses fewer axial segments and a wider pressure-flow regularization band than the default model to keep simulation turnaround short.</p></html>"),
    Diagram);
end AmmoniaCrackerDynTest;
