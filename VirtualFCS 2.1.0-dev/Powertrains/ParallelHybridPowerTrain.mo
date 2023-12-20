within VirtualFCS.Powertrains;

model ParallelHybridPowerTrain
  parameter Modelica.Units.SI.Mass m_powertrain = m_FC_stack + m_bat_pack;
  parameter Modelica.Units.SI.Voltage V_HV_Bus = 343 "Voltage of the HV Bus";
  // H2 Subsystem Paramters
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.13 "H2 tank volume";
  parameter Modelica.Units.SI.Pressure p_tank_H2 = 3500000 "H2 tank initial pressure";
  // Fuel Cell Stack Paramters
  parameter Modelica.Units.SI.Mass m_FC_stack = 14.3 "FC stack mass";
  parameter Modelica.Units.SI.Length L_FC_stack = 0.255 "FC stack length";
  parameter Modelica.Units.SI.Breadth W_FC_stack = 0.760 "FC stack breadth";
  parameter Modelica.Units.SI.Height H_FC_stack = 0.060 "FC stack height";
  parameter Modelica.Units.SI.Volume vol_FC_stack = L_FC_stack * W_FC_stack * H_FC_stack "FC stack volume";
  parameter Modelica.Units.SI.Voltage V_rated_FC_stack = 57.9 "FC stack maximum operating voltage";
  parameter Modelica.Units.SI.Current I_rated_FC_stack = 300 "FC stack minimum operating voltage";
  parameter Modelica.Units.SI.Current i_L_FC_stack = 1.7 * I_rated_FC_stack "FC stack maximum limiting current";
  parameter Modelica.Units.SI.Current I_nom_FC_stack = 0.25 * I_rated_FC_stack "FC stack maximum limiting current";
  parameter Real N_FC_stack(unit = "1") = floor(V_rated_FC_stack / 0.6433) "FC stack number of cells";
  // Battery Pack Parameters
  parameter Modelica.Units.SI.Mass m_bat_pack = 100 "Mass of the pack";
  parameter Modelica.Units.SI.Length L_bat_pack = 0.6 "Battery pack length";
  parameter Modelica.Units.SI.Breadth W_bat_pack = 0.45 "Battery pack width";
  parameter Modelica.Units.SI.Height H_bat_pack = 0.1 "Battery pack height";
  parameter Modelica.Units.SI.SpecificHeatCapacity Cp_bat_pack = 1000 "Specific Heat Capacity";
  parameter Modelica.Units.SI.Voltage V_min_bat_pack = 37.5 "Battery pack minimum voltage";
  parameter Modelica.Units.SI.Voltage V_nom_bat_pack = 48 "Battery pack nominal voltage";
  parameter Modelica.Units.SI.Voltage V_max_bat_pack = 54.75 "Battery pack maximum voltage";
  parameter Modelica.Units.NonSI.ElectricCharge_Ah C_bat_pack = 2700 "Battery pack nominal capacity";
  parameter Real SOC_init = 0.5 "Battery pack initial state of charge";
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-94, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-68, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Hydrogen.FuelCellSystem fuelCellSystem annotation(
    Placement(visible = true, transformation(origin = {72, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {-28, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrical.DCConverter converter(vDCref = V_HV_Bus) annotation(
    Placement(visible = true, transformation(origin = {-28, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  VirtualFCS.Electrical.DCConverterSwitch converter1(vDCref = V_HV_Bus) annotation(
    Placement(visible = true, transformation(origin = {72, 34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  VirtualFCS.Electrical.DC_converter dC_converter annotation(
    Placement(visible = true, transformation(origin = {22, -44}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  VirtualFCS.Control.EnergyManagementSystem energyManagementSystem(ramp_up = 1) annotation(
    Placement(visible = true, transformation(origin = {-68, -72}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant annotation(
    Placement(visible = true, transformation(origin = {36, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(pin_n, ground.p) annotation(
    Line(points = {{-40, 96}, {-68, 96}, {-68, 14}}, color = {0, 0, 255}));
  connect(converter.dc_n2, batterySystem.pin_n) annotation(
    Line(points = {{-34, 18}, {-34, -22}, {-32, -22}, {-32, -62}}, color = {0, 0, 255}));
  connect(converter.dc_p2, batterySystem.pin_p) annotation(
    Line(points = {{-22, 18}, {-22, -36}, {-24, -36}, {-24, -62}}, color = {0, 0, 255}));
  connect(converter.dc_n1, pin_n) annotation(
    Line(points = {{-34, 38}, {-38, 38}, {-38, 96}, {-40, 96}}, color = {0, 0, 255}));
  connect(converter.dc_p1, pin_p) annotation(
    Line(points = {{-22, 38}, {-22, 80}, {40, 80}, {40, 96}}, color = {0, 0, 255}));
  connect(converter1.dc_n2, fuelCellSystem.pin_n) annotation(
    Line(points = {{66, 24}, {68, 24}, {68, -62}, {68, -62}}, color = {0, 0, 255}));
  connect(converter1.dc_p2, fuelCellSystem.pin_p) annotation(
    Line(points = {{78, 24}, {78, 24}, {78, -62}, {78, -62}}, color = {0, 0, 255}));
  connect(converter1.dc_n1, pin_n) annotation(
    Line(points = {{66, 44}, {64, 44}, {64, 64}, {-38, 64}, {-38, 96}, {-40, 96}}, color = {0, 0, 255}));
  connect(pin_p, converter1.dc_p1) annotation(
    Line(points = {{40, 96}, {78, 96}, {78, 44}, {78, 44}}, color = {0, 0, 255}));
  connect(energyManagementSystem.sensorInterface, batterySystem.sensorOutput) annotation(
    Line(points = {{-56, -72}, {-38, -72}, {-38, -72}, {-38, -72}}, color = {0, 0, 127}));
  connect(energyManagementSystem.controlInterface, dC_converter.I_Ref) annotation(
    Line(points = {{-80, -72}, {-90, -72}, {-90, -18}, {22, -18}, {22, -32.5}}, color = {0, 0, 127}));
  connect(booleanConstant.y, converter1.u) annotation(
    Line(points = {{48, 32}, {58, 32}, {58, 32}, {60, 32}}, color = {255, 0, 255}));
  connect(dC_converter.pin_nBus, fuelCellSystem.pin_n) annotation(
    Line(points = {{32, -54}, {68, -54}, {68, -62}, {68, -62}}, color = {0, 0, 255}));
  connect(dC_converter.pin_pBus, fuelCellSystem.pin_p) annotation(
    Line(points = {{32, -34}, {78, -34}, {78, -62}, {78, -62}}, color = {0, 0, 255}));
  connect(dC_converter.pin_nFC, batterySystem.pin_n) annotation(
    Line(points = {{12, -54}, {-32, -54}, {-32, -62}, {-32, -62}}, color = {0, 0, 255}));
  connect(dC_converter.pin_pFC, batterySystem.pin_p) annotation(
    Line(points = {{12, -34}, {-24, -34}, {-24, -62}, {-24, -62}}, color = {0, 0, 255}));
protected
  annotation(
    Icon(graphics = {Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Text(origin = {17, 123}, extent = {{3, 5}, {-3, -5}}, textString = "text"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-16.7, 56.9}, {19.3, 56.9}, {5, 11.8}, {28.4, 11.8}, {-18.7, -56.5}, {-20, -56}, {-5.3, -6}, {-28.5, -6}, {-16.7, 56.9}})}, coordinateSystem(initialScale = 0.1)));
end ParallelHybridPowerTrain;
