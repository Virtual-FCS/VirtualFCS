within VirtualFCS.Chemical.Examples;

model AmmoniaCrackerDynTest
  extends Modelica.Icons.Example;
  package AmmoniaMedium = Media.CrackedAmmonia;
  parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";
  parameter Modelica.Units.NonSI.Temperature_degC T_in_degC = 550 "Inlet temperature (degC)";
  parameter Modelica.Units.SI.Temperature T_in = T_in_degC + 273.15 "Inlet temperature (K)";
  parameter Integer N = 10 "Number of reactor computational segments";
  parameter Real heatWeights[N] = {1.8, 1.5, 1.2, 1.0, 0.9, 0.8, 0.7, 0.6, 0.3, 0.2} "Relative heat distribution weights from inlet to outlet";
  Chemical.AmmoniaCracker.AmmoniaCrackerDyn ammoniaCracker(N = N, dp_small = 100, T_in_degC = T_in_degC, redeclare package AmmoniaMedium = AmmoniaMedium, constantTemperature = false) annotation(
    Placement(transformation(origin = {9, 5}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Fluid.Sources.FixedBoundary cracked_gas_sink(redeclare package Medium = AmmoniaMedium, nPorts = 1, use_p = true, p = P_out, use_T = false, T = T_in) annotation(
    Placement(transformation(origin = {86, 10}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, use_m_flow_in = false, m_flow = 0.3, nPorts = 1, T = T_in, X = {1, 0, 0}) annotation(
    Placement(transformation(origin = {-68, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow[ammoniaCracker.N] annotation(
    Placement(transformation(origin = {-8, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PI_heater(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = 1e5, yMax = 1e6, yMin = 0) annotation(
    Placement(transformation(origin = {-46, -48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression temp_cracked_target(y = T_in) annotation(
    Placement(transformation(origin = {-84, -48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression heatCommand[ammoniaCracker.N](y = {PI_heater.y*heatWeights[i]/sum(heatWeights) for i in 1:N}) annotation(
    Placement(transformation(origin = {-46, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.Temperature temp_out_cracker(redeclare package Medium = AmmoniaMedium) annotation(
    Placement(transformation(origin = {34, -38}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(ammoniaCracker.outlet_cracked_gas, cracked_gas_sink.ports[1]) annotation(
    Line(points = {{32, 10}, {76, 10}}, color = {0, 127, 255}));
  connect(ammoniaCracker.inlet_nh3_feed, ammonia_source.ports[1]) annotation(
    Line(points = {{-14, 10}, {-58, 10}}, color = {0, 127, 255}));
  connect(prescribedHeatFlow.port, ammoniaCracker.heatPorts) annotation(
    Line(points = {{2, -50}, {10, -50}, {10, -18}}, color = {191, 0, 0}));
  connect(temp_cracked_target.y, PI_heater.u_s) annotation(
    Line(points = {{-73, -48}, {-58, -48}}, color = {0, 0, 127}));
  connect(temp_out_cracker.port, ammoniaCracker.outlet_cracked_gas) annotation(
    Line(points = {{34, -48}, {34, -64}, {58, -64}, {58, 10}, {32, 10}}, color = {0, 127, 255}));
  connect(temp_out_cracker.T, PI_heater.u_m) annotation(
    Line(points = {{28, -38}, {18, -38}, {18, -60}, {-46, -60}}, color = {0, 0, 127}));
  connect(heatCommand.y, prescribedHeatFlow.Q_flow) annotation(
    Line(points = {{-35, -26}, {-24.5, -26}, {-24.5, -50}, {-18, -50}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.01));
  annotation(
    Documentation(info = "<html><p>This test feeds the dynamic ammonia cracker with 0.3 kg/s at 550 degC and evaluates the outlet at 3e5 Pa. The inlet composition is set to X = {1, 0, 0} in the cracked-ammonia medium order {NH3, H2, N2}. The example uses fewer axial segments and a wider pressure-flow regularization band than the default model to keep simulation turnaround short.</p></html>"));
end AmmoniaCrackerDynTest;
