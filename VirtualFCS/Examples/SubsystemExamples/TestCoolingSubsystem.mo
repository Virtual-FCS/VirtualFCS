within VirtualFCS.Examples.SubsystemExamples;

model TestCoolingSubsystem "Example to evaluate the performance of the cooling subsystem."
  extends Modelica.Icons.Example;
  
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  VirtualFCS.SubSystems.Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant getTermperature(k = 80)  annotation(
    Placement(visible = true, transformation(origin = {-60, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe1(redeclare package Medium = Medium, diameter = 0.01, length = 0.2, nParallel = 5, p_a_start = 102502, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {-12, 50}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Modelica.Fluid.Pipes.DynamicPipe pipe2(redeclare package Medium = Medium, diameter = 0.01, length = 0.2, nParallel = 5, p_a_start = 102502, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {12, 50}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.9,V_max_bat_pack = 54, V_min_bat_pack = 42, V_nom_bat_pack = 48)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(getTermperature.y, subSystemCooling.controlInterface) annotation(
    Line(points = {{-49, 10}, {-22, 10}}, color = {0, 0, 127}));
  connect(pipe1.port_a, subSystemCooling.Output) annotation(
    Line(points = {{-12, 40}, {-12, 24}}, color = {0, 127, 255}));
  connect(subSystemCooling.Input, pipe2.port_b) annotation(
    Line(points = {{12, 24}, {12, 40}}, color = {0, 127, 255}));
  connect(pipe2.port_a, pipe1.port_b) annotation(
    Line(points = {{12, 60}, {12, 76}, {-12, 76}, {-12, 60}}, color = {0, 127, 255}));
  connect(subSystemCooling.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-10, -18}, {-10, -27}, {-8, -27}, {-8, -40}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{10, -18}, {10, -29}, {8, -29}, {8, -40}}, color = {0, 0, 255}));
  annotation(
    Diagram,
    Icon,
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst aliasConflicts",
  Documentation(info = "<html><head></head><body>This example is intended as a means to evaluate the performance of the cooling subsystem both for optimization and troubleshooting purposes.</body></html>"),
  experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-6, Interval = 1));
end TestCoolingSubsystem;
