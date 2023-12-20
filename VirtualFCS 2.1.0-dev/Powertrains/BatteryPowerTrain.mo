within VirtualFCS.Powertrains;

model BatteryPowerTrain
  outer Modelica.Fluid.System system "System properties";
  parameter Modelica.Units.SI.Mass m_powertrain = m_bat_pack + 50;
  parameter Modelica.Units.SI.Voltage V_HV_Bus = 343 "Voltage of the HV Bus";
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
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-68, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(C_bat_pack = C_bat_pack, Cp_bat_pack = Cp_bat_pack, H_bat_pack = H_bat_pack, L_bat_pack = L_bat_pack, SOC_init = SOC_init, V_max_bat_pack = V_max_bat_pack, V_min_bat_pack = V_min_bat_pack, V_nom_bat_pack = V_nom_bat_pack, W_bat_pack = W_bat_pack, m_bat_pack = m_bat_pack) annotation(
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrical.DCConverter converter(vDCref = V_HV_Bus) annotation(
    Placement(visible = true, transformation(origin = {0, 8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Units.SI.Power Power_batt "Power delivered from the batt system";
  Modelica.Units.SI.Power Power_del_DC_DC "Power delivered from the DC/DC converter";
  Modelica.Units.SI.Efficiency eta_drivetrain "Efficiency of the drivetrain";
  Modelica.Units.SI.Efficiency eta_DC_DC = 1 "Efficiency of the DC/DC converter";
equation
  Power_batt = batterySystem.pin_n.i * batterySystem.pin_p.v;
  Power_del_DC_DC = converter.dc_p1.i * converter.dc_p1.v;
  if Power_del_DC_DC > 0 then
    eta_drivetrain = min(max(((Power_del_DC_DC)/max((Power_batt + ((Power_batt * (1-(batterySystem.eta_batt)))+ (Power_del_DC_DC * (1-(eta_DC_DC))))), 0.000001)), 0),1);
  else
    eta_drivetrain = min(max(((-Power_del_DC_DC)/max(( -Power_batt + ( - (Power_batt * (1-(batterySystem.eta_batt))) - (Power_del_DC_DC * (1-(eta_DC_DC))))), 0.000001)), 0), 1);
  end if;
  connect(pin_n, ground.p) annotation(
    Line(points = {{-40, 96}, {-68, 96}, {-68, 14}}, color = {0, 0, 255}));
  connect(converter.dc_n2, batterySystem.pin_n) annotation(
    Line(points = {{-6, -2}, {-6, -31}, {-4, -31}, {-4, -60}}, color = {0, 0, 255}));
  connect(converter.dc_p2, batterySystem.pin_p) annotation(
    Line(points = {{6, -2}, {6, -31}, {4, -31}, {4, -60}}, color = {0, 0, 255}));
  connect(converter.dc_n1, pin_n) annotation(
    Line(points = {{-6, 18}, {-6, 80}, {-40, 80}, {-40, 96}}, color = {0, 0, 255}));
  connect(converter.dc_p1, pin_p) annotation(
    Line(points = {{6, 18}, {6, 80}, {40, 80}, {40, 96}}, color = {0, 0, 255}));
protected
  annotation(
    Icon(graphics = {Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Text(origin = {17, 123}, extent = {{3, 5}, {-3, -5}}, textString = "text"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-16.7, 56.9}, {19.3, 56.9}, {5, 11.8}, {28.4, 11.8}, {-18.7, -56.5}, {-20, -56}, {-5.3, -6}, {-28.5, -6}, {-16.7, 56.9}})}, coordinateSystem(initialScale = 0.1)));
end BatteryPowerTrain;
