within VirtualFCS.Examples.SubsystemExamples;

model TestHydrogenSubsystem "Example to evaluate the performance of the hydrogen subsystem."
extends Modelica.Icons.Example;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {36,40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Anode_Medium, nPorts = 1, use_m_flow_in = true)  annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen subSystemHydrogen annotation(
    Placement(visible = true, transformation(origin = {-1, 40.6667}, extent = {{-17, -11.3333}, {17, 11.3333}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -0.00202 * 1 / (96485 * 2))  annotation(
    Placement(visible = true, transformation(origin = {70, 72}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp setFuelCellCurrent(duration = 5, height = 50, startTime = 10)  annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonBatteryPack.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {75, 8}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS(p = liIonBatteryPack.p, s = liIonBatteryPack.s) annotation(
    Placement(visible = true, transformation(origin = {1, -0.666667}, extent = {{-22, -14.6667}, {22, 14.6667}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonBatteryPack.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {75, -12}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped liIonBatteryPack(p = 1, s = 4) annotation(
    Placement(visible = true, transformation(origin = {0.576698, -43.0981}, extent = {{-22.0767, -13.246}, {22.0767, 14.7178}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * liIonBatteryPack.coolingArea) annotation(
    Placement(visible = true, transformation(origin = {-20, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 7.8 * 10 ^ 0.78 * liIonBatteryPack.coolingArea) annotation(
    Placement(visible = true, transformation(origin = {75, -80}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
equation
  connect(setFuelCellCurrent.y, gain.u) annotation(
    Line(points = {{-58, 70}, {60, 70}, {60, 72}, {60, 72}}, color = {0, 0, 127}));
  connect(gain.y, boundary.m_flow_in) annotation(
    Line(points = {{78, 72}, {96, 72}, {96, 48}, {80, 48}, {80, 48}}, color = {0, 0, 127}));
  connect(teeJunctionIdeal.port_3, boundary.ports[1]) annotation(
    Line(points = {{46, 40}, {60, 40}, {60, 40}, {60, 40}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.port_H2ToStack, teeJunctionIdeal.port_1) annotation(
    Line(points = {{12, 48}, {12, 48}, {12, 58}, {36, 58}, {36, 50}, {36, 50}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.port_StackToH2, teeJunctionIdeal.port_2) annotation(
    Line(points = {{12, 34}, {12, 34}, {12, 24}, {36, 24}, {36, 30}, {36, 30}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.pin_p, BMS.pin_p_load) annotation(
    Line(points = {{4, 30}, {4, 30}, {4, 18}, {8, 18}, {8, 12}, {8, 12}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_n, BMS.pin_n_load) annotation(
    Line(points = {{-4, 30}, {-4, 30}, {-4, 18}, {-6, 18}, {-6, 12}, {-6, 12}}, color = {0, 0, 255}));
  connect(BMS.pin_n_battery, liIonBatteryPack.pin_n) annotation(
    Line(points = {{-6, -14}, {-6, -14}, {-6, -20}, {-12, -20}, {-12, -30}, {-12, -30}}, color = {0, 0, 255}));
  connect(BMS.pin_p_battery, liIonBatteryPack.pin_p) annotation(
    Line(points = {{8, -14}, {8, -14}, {8, -20}, {14, -20}, {14, -30}, {14, -30}}, color = {0, 0, 255}));
  connect(getSOC_init.y, BMS.SOC_init) annotation(
    Line(points = {{58, 8}, {40, 8}, {40, 4}, {18, 4}, {18, 4}}, color = {0, 0, 127}));
  connect(getChargeCapacity.y, BMS.chargeCapacity) annotation(
    Line(points = {{58, -12}, {40, -12}, {40, -4}, {18, -4}, {18, -6}}, color = {0, 0, 127}));
  connect(fixedTemperature.port, bodyRadiation.port_b) annotation(
    Line(points = {{-60, -80}, {-50, -80}, {-50, -98}, {-20, -98}, {-20, -90}, {-20, -90}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, convection.fluid) annotation(
    Line(points = {{-60, -80}, {-50, -80}, {-50, -98}, {20, -98}, {20, -90}, {20, -90}}, color = {191, 0, 0}));
  connect(liIonBatteryPack.heatPort, convection.solid) annotation(
    Line(points = {{0, -54}, {0, -54}, {0, -64}, {20, -64}, {20, -70}, {20, -70}}, color = {191, 0, 0}));
  connect(liIonBatteryPack.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{0, -54}, {0, -54}, {0, -64}, {-20, -64}, {-20, -70}, {-20, -70}}, color = {191, 0, 0}));
  connect(convection.Gc, setConvectiveCoefficient.y) annotation(
    Line(points = {{30, -80}, {58, -80}, {58, -80}, {58, -80}}, color = {0, 0, 127}));
  connect(setFuelCellCurrent.y, subSystemHydrogen.control) annotation(
    Line(points = {{-58, 70}, {-40, 70}, {-40, 48}, {-14, 48}, {-14, 48}}, color = {0, 0, 127}));
  annotation(
    Diagram,
    Icon,
  Documentation(info = "<html><head></head><body>This example is intended as a means to evaluate the performance of the hydrogen subsystem both for optimization and troubleshooting purposes.</body></html>"),
  experiment(StartTime = 0, StopTime = 600, Tolerance = 1e-6, Interval = 1));
end TestHydrogenSubsystem;
