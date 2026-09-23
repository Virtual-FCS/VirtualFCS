within VirtualFCS.Chemical.Examples;

model AmmoniaCrackerDynTest
  extends Modelica.Icons.Example;
  package AmmoniaMedium = Media.CrackedAmmonia;
  parameter Modelica.Units.SI.Pressure P_out = 30e5 "Outlet pressure";
  parameter Modelica.Units.SI.Temperature T_in_degC = 550 "Inlet temperature (K)";
  parameter Modelica.Units.SI.Temperature T_in = T_in_degC + 273.15 "Inlet temperature (K)";
  Chemical.AmmoniaCracker.AmmoniaCrackerDyn ammoniaCracker(N = 10, dp_small = 100, T_in_degC = T_in_degC, redeclare package AmmoniaMedium = AmmoniaMedium, constantTemperature = false) annotation(
    Placement(transformation(origin = {9, 5}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Fluid.Sources.FixedBoundary cracked_gas_sink(redeclare package Medium = AmmoniaMedium, nPorts = 1, use_p = true, p = P_out, use_T = false, T = T_in) annotation(
    Placement(transformation(origin = {86, 10}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T ammonia_source(redeclare package Medium = AmmoniaMedium, use_m_flow_in = false, m_flow = 0.3, nPorts = 1, X = {1, 0, 0}) annotation(
    Placement(transformation(origin = {-68, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow[ammoniaCracker.N] annotation(
    Placement(transformation(origin = {-8, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PI_heater[ammoniaCracker.N](each controllerType = Modelica.Blocks.Types.SimpleController.PI, each k = 1e4, each yMax = 1e6, each yMin = 0) annotation(
    Placement(transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression temp_cracked_target[ammoniaCracker.N](each y = 550+ 273.15) annotation(
    Placement(transformation(origin = {-88, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression temp_cracked_measurement[ammoniaCracker.N](each y = temp_out_cracker.T) annotation(
    Placement(transformation(origin = {-20, -70}, extent = {{-10, -10}, {10, 10}})));
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
    Line(points = {{-76, -44}, {-69, -44}, {-69, -50}, {-62, -50}}, color = {0, 0, 127}));
  connect(temp_out_cracker.port, ammoniaCracker.outlet_cracked_gas) annotation(
    Line(points = {{34, -48}, {34, -64}, {58, -64}, {58, 10}, {32, 10}}, color = {0, 127, 255}));
  connect(temp_cracked_measurement.y, PI_heater.u_m) annotation(
    Line(points = {{-8, -70}, {-8, -78}, {-50, -78}, {-50, -62}}, color = {0, 0, 127}));
  connect(PI_heater.y, prescribedHeatFlow.Q_flow) annotation(
    Line(points = {{-38, -50}, {-18, -50}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.01));
  annotation(
    Documentation(info = "<html><p>This test feeds the dynamic ammonia cracker with 0.3 kg/s at 550 degC and evaluates the outlet at 3e5 Pa. The inlet composition is set to X = {1, 0, 0} in the cracked-ammonia medium order {NH3, H2, N2}. The example uses fewer axial segments and a wider pressure-flow regularization band than the default model to keep simulation turnaround short.</p></html>"));
end AmmoniaCrackerDynTest;
