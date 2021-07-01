within VirtualFCS.Examples.SubsystemExamples;

model TestAirSubsystem "Example to evaluate the performance of the air subsystem."
  extends Modelica.Icons.Example;
  
  replaceable package Medium = Modelica.Media.Air.MoistAir;
  Modelica.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {70, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -0.032 * 1 / (96485 * 2)) annotation(
    Placement(visible = true, transformation(origin = {71, 79}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp setFuelCellCurrent(duration = 5, height = 50, startTime = 10) annotation(
    Placement(visible = true, transformation(origin = {-68, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal teeJunctionIdeal(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {41, 49}, extent = {{-9, -9}, {9, 9}}, rotation = -90)));
  VirtualFCS.SubSystems.Air.SubSystemAir subSystemAir annotation(
    Placement(visible = true, transformation(origin = {1, 49}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonBatteryPack.chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {74, -12}, extent = {{14, -10}, {-14, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped liIonBatteryPack(p = 4, s = 6) annotation(
    Placement(visible = true, transformation(origin = {-0.4233, -40.4314}, extent = {{-15.0767, -9.04602}, {15.0767, 10.0511}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS(p = liIonBatteryPack.p, s = liIonBatteryPack.s) annotation(
    Placement(visible = true, transformation(origin = {1.5, -1}, extent = {{-22.5, -15}, {22.5, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonBatteryPack.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {75, 10}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-82, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * liIonBatteryPack.coolingArea) annotation(
    Placement(visible = true, transformation(origin = {-20, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 7.8 * 10 ^ 0.78 * liIonBatteryPack.coolingArea) annotation(
    Placement(visible = true, transformation(origin = {75, -80}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(setFuelCellCurrent.y, gain.u) annotation(
    Line(points = {{-56, 80}, {62, 80}, {62, 80}, {62, 80}}, color = {0, 0, 127}));
  connect(gain.y, boundary.m_flow_in) annotation(
    Line(points = {{78, 80}, {94, 80}, {94, 58}, {80, 58}, {80, 58}}, color = {0, 0, 127}));
  connect(boundary.ports[1], teeJunctionIdeal.port_3) annotation(
    Line(points = {{60, 50}, {50, 50}, {50, 50}, {50, 50}}, color = {0, 127, 255}));
  connect(subSystemAir.Output, teeJunctionIdeal.port_1) annotation(
    Line(points = {{15, 57}, {15, 66}, {42, 66}, {42, 58}}, color = {0, 127, 255}));
  connect(subSystemAir.Input, teeJunctionIdeal.port_2) annotation(
    Line(points = {{15, 41}, {15, 34}, {40, 34}, {40, 40}, {42, 40}}, color = {0, 127, 255}));
  connect(subSystemAir.pin_n, BMS.pin_n_load) annotation(
    Line(points = {{-6, 38}, {-6, 38}, {-6, 12}, {-6, 12}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_p, BMS.pin_p_load) annotation(
    Line(points = {{8, 38}, {8, 38}, {8, 12}, {10, 12}}, color = {0, 0, 255}));
  connect(BMS.SOC_init, getSOC_init.y) annotation(
    Line(points = {{18, 4}, {40, 4}, {40, 10}, {58, 10}, {58, 10}}, color = {0, 0, 127}));
  connect(BMS.chargeCapacity, getChargeCapacity.y) annotation(
    Line(points = {{18, -6}, {40, -6}, {40, -12}, {58, -12}, {58, -12}}, color = {0, 0, 127}));
  connect(BMS.pin_n_battery, liIonBatteryPack.pin_n) annotation(
    Line(points = {{-6, -14}, {-6, -14}, {-6, -26}, {-10, -26}, {-10, -32}, {-10, -32}}, color = {0, 0, 255}));
  connect(BMS.pin_p_battery, liIonBatteryPack.pin_p) annotation(
    Line(points = {{10, -14}, {8, -14}, {8, -32}, {8, -32}}, color = {0, 0, 255}));
  connect(convection.Gc, setConvectiveCoefficient.y) annotation(
    Line(points = {{30, -80}, {58, -80}, {58, -80}, {58, -80}}, color = {0, 0, 127}));
  connect(liIonBatteryPack.heatPort, convection.solid) annotation(
    Line(points = {{0, -48}, {0, -48}, {0, -60}, {20, -60}, {20, -70}, {20, -70}}, color = {191, 0, 0}));
  connect(liIonBatteryPack.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{0, -48}, {0, -48}, {0, -60}, {-20, -60}, {-20, -70}, {-20, -70}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, bodyRadiation.port_b) annotation(
    Line(points = {{-60, -80}, {-40, -80}, {-40, -98}, {-20, -98}, {-20, -90}, {-20, -90}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, convection.fluid) annotation(
    Line(points = {{-60, -80}, {-40, -80}, {-40, -98}, {20, -98}, {20, -90}, {20, -90}}, color = {191, 0, 0}));
  annotation(
    Diagram,
    Icon,
  Documentation(info = "<html><head></head><body>This example is intended as a means to evaluate the performance of the air subsystem both for optimization and troubleshooting purposes.</body></html>"));
end TestAirSubsystem;
