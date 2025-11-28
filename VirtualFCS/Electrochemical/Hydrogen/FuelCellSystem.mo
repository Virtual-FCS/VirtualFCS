within VirtualFCS.Electrochemical.Hydrogen;
model FuelCellSystem

  outer Modelica.Fluid.System system "System properties";

  parameter Modelica.Units.SI.Current I_nom_FC_stack = 280.0 "FC stack nominal current";
  parameter Modelica.Units.SI.Current I_rated_FC_stack = 320 "FC stack maximum operating current";
  parameter Integer N_FC_stack = 180 "FC stack number of cells";
  // H2 Subsystem Paramters
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.606 "H2 tank volume"; // 15 kg @ 300 bar from VFCS D4.1
  parameter Modelica.Units.SI.AbsolutePressure p_tank_H2 = 30000000 "H2 tank initial pressure";
  // Power and efficiency calculations
  Modelica.Units.SI.Power Power_system = Power_stack-Power_BOP "Power delivered from the FC system";
  Modelica.Units.SI.Power Power_stack = fuelCell.pin_n.i*(fuelCell.pin_p.v-fuelCell.pin_n.v) "Power delivered from the FC stack";
  Modelica.Units.SI.Power Power_BOP = batterySystem.pin_n.i*(batterySystem.pin_p.v-batterySystem.pin_n.v) "Power consumed by the BOP components";

  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin = {46, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  FuelCell fuelCell annotation (Placement(transformation(origin = {0, -4}, extent = {{-40, -15}, {40, 65}})));
  replaceable SubSystems.Air.SubSystemAir subSystemAir annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  replaceable SubSystems.Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(transformation(origin = {0, -54}, extent = {{-14, -14}, {14, 14}})));
  replaceable SubSystems.Hydrogen.SubSystemHydrogen subSystemHydrogen annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-15, -10}, {15, 10}}, rotation = -90)));
  replaceable VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(SOC_init = 0.9, V_max_bat_pack = 34, V_min_bat_pack = 30, V_nom_bat_pack = 32, m_bat_pack = 1) annotation(
    Placement(transformation(origin = {70, -90}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(pin_n, currentSensor.p) annotation(
    Line(points = {{-40, 96}, {-40, 80}}, color = {0, 0, 255}));
  connect(fuelCell.pin_n, currentSensor.n) annotation(
    Line(points = {{-21, 50}, {-21, 60}, {-40, 60}}, color = {0, 0, 255}));
  connect(fuelCell.pin_p, pin_p) annotation(
    Line(points = {{21, 50}, {21, 96}, {46, 96}}, color = {0, 0, 255}));
  connect(temperatureSensor.port, fuelCell.heatPort) annotation(
    Line(points = {{-30, -20}, {0, -20}, {0, 2}}, color = {191, 0, 0}));
  connect(temperatureSensor.T, subSystemCooling.stackTemperature) annotation(
    Line(points = {{-50, -20}, {-60, -20}, {-60, -47}, {-15, -47}}, color = {0, 0, 127}));
  connect(fuelCell.coolant_out, subSystemCooling.from_stack) annotation(
    Line(points = {{8, -3}, {8, -37}}, color = {0, 127, 255}));
  connect(fuelCell.coolant_in, subSystemCooling.to_stack) annotation(
    Line(points = {{-8, -3}, {-8, -37}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.toStack, fuelCell.anode_in) annotation(
    Line(points = {{-58, 26}, {-40, 26}, {-40, 40}, {-29, 40}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.fromStack, fuelCell.anode_out) annotation(
    Line(points = {{-58, 14}, {-40, 14}, {-40, 2}, {-29, 2}}, color = {0, 127, 255}));
  connect(subSystemAir.toStack, fuelCell.cathode_in) annotation(
    Line(points = {{58, 26}, {40, 26}, {40, 40}, {29, 40}}, color = {0, 127, 255}));
  connect(subSystemAir.fromStack, fuelCell.cathode_out) annotation(
    Line(points = {{58, 14}, {40, 14}, {40, 2}, {29, 2}}, color = {0, 127, 255}));
  connect(currentSensor.i, subSystemHydrogen.stackCurrent) annotation(
    Line(points = {{-50, 70}, {-70, 70}, {-70, 32}}, color = {0, 0, 127}));
  connect(currentSensor.i, subSystemAir.stackCurrent) annotation(
    Line(points = {{-50, 70}, {-70, 70}, {-70, 84}, {65, 84}, {65, 31}}, color = {0, 0, 127}));
  connect(batterySystem.pin_p, subSystemAir.pin_p) annotation(
    Line(points = {{74, -80}, {74, -76}, {88, -76}, {88, 16}, {80, 16}}, color = {255, 0, 0}));
  connect(batterySystem.pin_n, subSystemAir.pin_n) annotation(
    Line(points = {{66, -80}, {66, -70}, {94, -70}, {94, 26}, {80, 26}}));
  connect(batterySystem.pin_n, subSystemCooling.pin_n) annotation(
    Line(points = {{66, -80}, {66, -70}, {-8, -70}, {-8, -66}}));
  connect(batterySystem.pin_p, subSystemCooling.pin_p) annotation(
    Line(points = {{74, -80}, {74, -76}, {8, -76}, {8, -66}}, color = {255, 0, 0}));
  connect(batterySystem.pin_p, subSystemHydrogen.pin_p) annotation(
    Line(points = {{74, -80}, {74, -76}, {-90, -76}, {-90, 16}, {-78, 16}}, color = {255, 0, 0}));
  connect(batterySystem.pin_n, subSystemHydrogen.pin_n) annotation(
    Line(points = {{66, -80}, {66, -70}, {-96, -70}, {-96, 24}, {-78, 24}}));
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation (
    Placement(transformation(origin = {-40, -20}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(transformation(origin = {-40, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  annotation (
    Icon(graphics={  Text(origin = {-6, -250}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Rectangle(origin = {-55, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {58.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {-40, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-29.8, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-19.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-8.7, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {1.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {12.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {22.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {32.3, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {42.9, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The FuelCellSystem class packages together a FuelCell object and three different subsystems to control&nbsp;hydrogen, air, and coolant feeds into and out of the fuel cell. A battery object provides power to the subsystems.<div><br></div><div>In addition to the coolant subsystem, it is assumed that the fuel cell stack exchanges heat with its surroundings by convection and radiation.</div></body></html>"));
end FuelCellSystem;
