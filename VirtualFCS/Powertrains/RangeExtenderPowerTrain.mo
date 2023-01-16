within VirtualFCS.Powertrains;

model RangeExtenderPowerTrain
  // System
  outer Modelica.Fluid.System system "System properties";
  // Powertraom parameters
  parameter Real m_powertrain(unit = "kg") = fuelCellSystem.m_FC_system + batterySystem.m_bat_pack;
  parameter Real V_HV_Bus(unit = "V") = 343 "Voltage of the HV Bus";
  // H2 Subsystem Paramters
  parameter Real V_tank_H2(unit = "m3") = 0.13 "H2 tank volume";
  parameter Real p_tank_H2(unit = "Pa") = 35000000 "H2 tank initial pressure";
  // Fuel Cell Stack Paramters
  parameter Real m_FC_stack(unit = "kg") = 14.3 "FC stack mass";
  parameter Real L_FC_stack(unit = "m") = 0.255 "FC stack length";
  parameter Real W_FC_stack(unit = "m") = 0.760 "FC stack width";
  parameter Real H_FC_stack(unit = "m") = 0.060 "FC stack height";
  parameter Real vol_FC_stack(unit = "m3") = L_FC_stack * W_FC_stack * H_FC_stack "FC stack volume";
  parameter Real V_rated_FC_stack(unit = "V") = 57.9 "FC stack maximum operating voltage";
  parameter Real I_rated_FC_stack(unit = "A") = 300 "FC stack minimum operating current";
  parameter Real i_L_FC_stack(unit = "A") = 1.7 * I_rated_FC_stack "FC stack limiting current (max)";
  parameter Real I_nom_FC_stack(unit = "A") = 0.25 * I_rated_FC_stack "FC stack nominal current";
  parameter Real N_FC_stack(unit = "1") = floor(V_rated_FC_stack / 0.6433) "FC stack number of cells";
  // Battery Pack Parameters
  parameter Real m_bat_pack(unit = "kg") = 100 "Mass of the pack";
  parameter Real L_bat_pack(unit = "m") = 0.6 "Battery pack length";
  parameter Real W_bat_pack(unit = "m") = 0.45 "Battery pack width";
  parameter Real H_bat_pack(unit = "m") = 0.1 "Battery pack height";
  parameter Real Cp_bat_pack(unit = "J/(kg.K)") = 1000 "Specific Heat Capacity";
  parameter Real V_min_bat_pack(unit = "V") = 240 "Battery pack minimum voltage";
  parameter Real V_nom_bat_pack(unit = "V") = 336 "Battery pack nominal voltage";
  parameter Real V_max_bat_pack(unit = "V") = 403.2 "Battery pack maximum voltage";
  parameter Real C_bat_pack(unit = "A.h") = 200 "Battery pack nominal capacity";
  parameter Real SOC_init = 0.5 "Battery pack initial state of charge";
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-68, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Hydrogen.FuelCellSystem fuelCellSystem(H_FC_stack = H_FC_stack, I_rated_FC_stack = I_rated_FC_stack, L_FC_stack = L_FC_stack, V_tank_H2 = V_tank_H2, W_FC_stack = W_FC_stack, m_FC_stack = m_FC_stack, p_tank_H2 = p_tank_H2) annotation(
    Placement(visible = true, transformation(origin = {72, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(C_bat_pack = C_bat_pack, Cp_bat_pack = Cp_bat_pack, H_bat_pack = H_bat_pack, L_bat_pack = L_bat_pack, SOC_init = SOC_init, V_max_bat_pack = V_max_bat_pack, V_min_bat_pack = V_min_bat_pack, V_nom_bat_pack = V_nom_bat_pack, W_bat_pack = W_bat_pack) annotation(
    Placement(visible = true, transformation(origin = {-28, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrical.DCConverter converter(vDCref = V_HV_Bus) annotation(
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  VirtualFCS.Electrical.DC_converter dC_converter annotation(
    Placement(visible = true, transformation(origin = {22, -44}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  VirtualFCS.Control.EnergyManagementSystem energyManagementSystem annotation(
    Placement(visible = true, transformation(origin = {-66, -72}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Power & Efficiencies
  Real Power_del_DC_DC(unit = "W") "Power delivered from the DC/DC converter";
  Real Power_FC(unit = "W") "Power delivered from the FC system";
  Real Power_batt(unit = "W") "Power delivered from the batt system";
  Real eta_drivetrain(unit = "100") "Efficiency of the drivetrain";
  Real eta_DC_DC(unit = "100") = 100 "Efficiency of the DC/DC converter";
equation
  Power_del_DC_DC = converter.dc_p1.i * converter.dc_p1.v;
  Power_FC = fuelCellSystem.pin_n.i * fuelCellSystem.pin_p.v;
  Power_batt = batterySystem.pin_n.i * batterySystem.pin_p.v;
  if Power_del_DC_DC > 0 then
    eta_drivetrain = min(max(((Power_del_DC_DC)/max((Power_FC + Power_batt + ((Power_FC * (1-(fuelCellSystem.eta_FC_sys*0.01)))+ (Power_batt * (1-(batterySystem.eta_batt*0.01)))+ (Power_del_DC_DC * (1-(eta_DC_DC*0.01))))), 0.000001)) * 100, 0),100);
  else
    eta_drivetrain = min(max(((-Power_del_DC_DC)/max((Power_FC -Power_batt + ((Power_FC * (1-(fuelCellSystem.eta_FC_sys*0.01))) - (Power_batt * (1-(batterySystem.eta_batt*0.01))) - (Power_del_DC_DC * (1-(eta_DC_DC*0.01))))), 0.000001)) * 100, 0), 100);
  end if;
  connect(pin_n, ground.p) annotation(
    Line(points = {{-40, 96}, {-68, 96}, {-68, 14}}, color = {0, 0, 255}));
  connect(converter.dc_n2, batterySystem.pin_n) annotation(
    Line(points = {{-6, 20}, {-6, -22}, {-32, -22}, {-32, -62}}, color = {0, 0, 255}));
  connect(converter.dc_p2, batterySystem.pin_p) annotation(
    Line(points = {{6, 20}, {6, -36}, {-24, -36}, {-24, -62}}, color = {0, 0, 255}));
  connect(converter.dc_n1, pin_n) annotation(
    Line(points = {{-6, 40}, {-38, 40}, {-38, 96}, {-40, 96}}, color = {0, 0, 255}));
  connect(converter.dc_p1, pin_p) annotation(
    Line(points = {{6, 40}, {6, 80}, {40, 80}, {40, 96}}, color = {0, 0, 255}));
  connect(energyManagementSystem.sensorInterface, batterySystem.sensorOutput) annotation(
    Line(points = {{-54, -72}, {-40, -72}, {-40, -72}, {-38, -72}}, color = {0, 0, 127}));
  connect(energyManagementSystem.controlInterface, dC_converter.I_Ref) annotation(
    Line(points = {{-78, -72}, {-92, -72}, {-92, -16}, {24, -16}, {24, -32.5}, {22, -32.5}}, color = {0, 0, 127}));
  connect(dC_converter.pin_pBus, fuelCellSystem.pin_p) annotation(
    Line(points = {{32, -34}, {78, -34}, {78, -62}, {78, -62}}, color = {0, 0, 255}));
  connect(dC_converter.pin_nBus, fuelCellSystem.pin_n) annotation(
    Line(points = {{32, -54}, {68, -54}, {68, -62}, {68, -62}}, color = {0, 0, 255}));
  connect(dC_converter.pin_nFC, batterySystem.pin_n) annotation(
    Line(points = {{12, -54}, {-32, -54}, {-32, -62}, {-32, -62}}, color = {0, 0, 255}));
  connect(dC_converter.pin_pFC, batterySystem.pin_p) annotation(
    Line(points = {{12, -34}, {-24, -34}, {-24, -62}, {-24, -62}}, color = {0, 0, 255}));
protected
  annotation(
    Icon(graphics = {Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Text(origin = {17, 123}, extent = {{3, 5}, {-3, -5}}, textString = "text"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-16.7, 56.9}, {19.3, 56.9}, {5, 11.8}, {28.4, 11.8}, {-18.7, -56.5}, {-20, -56}, {-5.3, -6}, {-28.5, -6}, {-16.7, 56.9}})}, coordinateSystem(initialScale = 0.1)));
end RangeExtenderPowerTrain;
