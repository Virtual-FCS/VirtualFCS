within VirtualFCS.Examples.SubsystemExamples;

model TestCoolingSubsystem "Example to evaluate the performance of the cooling subsystem."
  extends Modelica.Icons.Example;
  
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  VirtualFCS.SubSystems.Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(visible = true, transformation(origin = {0, 64}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant getTermperature(k = 80)  annotation(
    Placement(visible = true, transformation(origin = {-58, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe1(redeclare package Medium = Medium, diameter = 0.01, length = 0.2, nParallel = 5, p_a_start = 102502, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {60, 84}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped liIonBatteryPack(p = 4, s = 6)  annotation(
    Placement(visible = true, transformation(origin = {0.422536, -30.5253}, extent = {{-19.9226, -11.9535}, {19.9226, 13.2817}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipe2(redeclare package Medium = Medium, diameter = 0.01, length = 0.2, nParallel = 5, p_a_start = 102502, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {58, 56}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 7.8 * 10 ^ 0.78 * liIonBatteryPack.coolingArea) annotation(
    Placement(visible = true, transformation(origin = {75, -70}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * liIonBatteryPack.coolingArea) annotation(
    Placement(visible = true, transformation(origin = {-20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  VirtualFCS.Control.BatteryManagementSystem BMS(p = liIonBatteryPack.p, s = liIonBatteryPack.s) annotation(
    Placement(visible = true, transformation(origin = {1.5, 15}, extent = {{-22.5, -15}, {22.5, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonBatteryPack.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {75, 26}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonBatteryPack.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {74, 4}, extent = {{14, -10}, {-14, 10}}, rotation = 0)));
equation
  connect(getTermperature.y, subSystemCooling.controlInterface) annotation(
    Line(points = {{-47, 72}, {-17, 72}}, color = {0, 0, 127}));
  connect(subSystemCooling.Output, pipe1.port_a) annotation(
    Line(points = {{18, 72}, {33, 72}, {33, 84}, {50, 84}}, color = {0, 127, 255}));
  connect(subSystemCooling.Input, pipe2.port_b) annotation(
    Line(points = {{18, 56}, {48, 56}}, color = {0, 127, 255}));
  connect(pipe1.port_b, pipe2.port_a) annotation(
    Line(points = {{70, 84}, {86, 84}, {86, 56}, {68, 56}}, color = {0, 127, 255}));
  connect(subSystemCooling.pin_n, BMS.pin_n_load) annotation(
    Line(points = {{-8, 50}, {-6, 50}, {-6, 28}, {-6, 28}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_p, BMS.pin_p_load) annotation(
    Line(points = {{8, 50}, {8, 50}, {8, 28}, {10, 28}}, color = {0, 0, 255}));
  connect(BMS.pin_n_battery, liIonBatteryPack.pin_n) annotation(
    Line(points = {{-6, 2}, {-6, 2}, {-6, -8}, {-12, -8}, {-12, -18}, {-12, -18}}, color = {0, 0, 255}));
  connect(BMS.pin_p_battery, liIonBatteryPack.pin_p) annotation(
    Line(points = {{10, 2}, {8, 2}, {8, -8}, {12, -8}, {12, -18}, {12, -18}}, color = {0, 0, 255}));
  connect(BMS.SOC_init, getSOC_init.y) annotation(
    Line(points = {{18, 20}, {40, 20}, {40, 26}, {58, 26}, {58, 26}}, color = {0, 0, 127}));
  connect(BMS.chargeCapacity, getChargeCapacity.y) annotation(
    Line(points = {{18, 10}, {40, 10}, {40, 4}, {58, 4}, {58, 4}}, color = {0, 0, 127}));
  connect(bodyRadiation.port_a, liIonBatteryPack.heatPort) annotation(
    Line(points = {{-20, -60}, {-20, -60}, {-20, -52}, {0, -52}, {0, -42}, {0, -42}}, color = {191, 0, 0}));
  connect(convection.solid, liIonBatteryPack.heatPort) annotation(
    Line(points = {{20, -60}, {20, -60}, {20, -52}, {0, -52}, {0, -42}, {0, -42}}, color = {191, 0, 0}));
  connect(setConvectiveCoefficient.y, convection.Gc) annotation(
    Line(points = {{58, -70}, {30, -70}, {30, -70}, {30, -70}}, color = {0, 0, 127}));
  connect(fixedTemperature.port, bodyRadiation.port_b) annotation(
    Line(points = {{-60, -80}, {-40, -80}, {-40, -92}, {-20, -92}, {-20, -80}, {-20, -80}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, convection.fluid) annotation(
    Line(points = {{-60, -80}, {-40, -80}, {-40, -92}, {20, -92}, {20, -80}, {20, -80}}, color = {191, 0, 0}));
  annotation(
    Diagram,
    Icon,
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst aliasConflicts",
  Documentation(info = "<html><head></head><body>This example is intended as a means to evaluate the performance of the cooling subsystem both for optimization and troubleshooting purposes.</body></html>"),
  experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-6, Interval = 1));
end TestCoolingSubsystem;
