within VirtualFCS.Powertrains;
model ECMSPowerTrain
  // System
  outer Modelica.Fluid.System system "System properties";
  // Powertrain parameters
  parameter Modelica.Units.SI.Mass m_powertrain = fuelCellSystem.m_FC_system + batterySystem.m_bat_pack annotation (
    Dialog(group = "Powertrain Parameters"));
  parameter Modelica.Units.SI.Voltage V_HV_Bus = 343 "Voltage of the HV Bus" annotation (
    Dialog(group = "Powertrain Parameters"));
  // H2 Subsystem Paramters
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.13 "H2 tank volume" annotation (
    Dialog(group = "Hydrogen storage Parameters")); // 15 kg @ 300 bar from VFCS D4.1
  parameter Modelica.Units.SI.AbsolutePressure p_tank_H2 = 30000000 "H2 tank initial pressure" annotation (
    Dialog(group = "Hydrogen storage Parameters"));
  // Fuel Cell Stack Paramters
  parameter Modelica.Units.SI.Mass m_FC_stack = 14.3 "FC stack mass" annotation (
    Dialog(group = "Fuel Cell Stack Parameters"));
  parameter Modelica.Units.SI.Length L_FC_stack = 0.255 "FC stack length" annotation (
    Dialog(group = "Fuel Cell Stack Parameters"));
  parameter Modelica.Units.SI.Breadth W_FC_stack = 0.760 "FC stack width" annotation (
    Dialog(group = "Fuel Cell Stack Parameters"));
  parameter Modelica.Units.SI.Height H_FC_stack = 0.060 "FC stack height" annotation (
    Dialog(group = "Fuel Cell Stack Parameters"));
  parameter Modelica.Units.SI.Volume vol_FC_stack = L_FC_stack * W_FC_stack * H_FC_stack "FC stack volume" annotation (
    Dialog(group = "Fuel Cell Stack Parameters"));
  parameter Modelica.Units.SI.ElectricCurrent I_nom_FC_stack = 300 "FC stack nominal current" annotation (
    Dialog(group = "Fuel Cell Stack Parameters"));
  parameter Modelica.Units.SI.ElectricCurrent I_rated_FC_stack = 1.7 * I_nom_FC_stack "FC stack maximum operating current" annotation (
    Dialog(group = "Fuel Cell Stack Parameters"));
  parameter Integer N_FC_stack = 280 "FC stack number of cells" annotation (
    Dialog(group = "Fuel Cell Stack Parameters"));
  // Battery Pack Parameters
  parameter Modelica.Units.SI.Mass m_bat_pack = 100 "Mass of the pack" annotation (
    Dialog(group = "Battery Pack Parameters"));
  parameter Modelica.Units.SI.Length L_bat_pack = 0.6 "Battery pack length" annotation (
    Dialog(group = "Battery Pack Parameters"));
  parameter Modelica.Units.SI.Breadth W_bat_pack = 0.45 "Battery pack width" annotation (
    Dialog(group = "Battery Pack Parameters"));
  parameter Modelica.Units.SI.Height H_bat_pack = 0.1 "Battery pack height" annotation (
    Dialog(group = "Battery Pack Parameters"));
  parameter Modelica.Units.SI.SpecificHeatCapacity Cp_bat_pack = 1000 "Specific Heat Capacity" annotation (
    Dialog(group = "Battery Pack Parameters"));
  parameter Modelica.Units.SI.Voltage V_min_bat_pack = 240 "Battery pack minimum voltage" annotation (
    Dialog(group = "Battery Pack Parameters"));
  parameter Modelica.Units.SI.Voltage V_nom_bat_pack = 336 "Battery pack nominal voltage" annotation (
    Dialog(group = "Battery Pack Parameters"));
  parameter Modelica.Units.SI.Voltage V_max_bat_pack = 403.2 "Battery pack maximum voltage" annotation (
    Dialog(group = "Battery Pack Parameters"));
  parameter Modelica.Units.NonSI.ElectricCharge_Ah C_bat_pack = 200 "Battery pack nominal capacity" annotation (
    Dialog(group = "Battery Pack Parameters"));
  parameter Real SOC_init = 0.5 "Battery pack initial state of charge" annotation (
    Dialog(group = "Battery Pack Parameters"));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin = {42, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin = {-68, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Hydrogen.FuelCellSystem fuelCellSystem(H_FC_stack = H_FC_stack, I_nom_FC_stack = I_nom_FC_stack, I_rated_FC_stack = I_rated_FC_stack,L_FC_stack = L_FC_stack, N_FC_stack = N_FC_stack, V_tank_H2 = V_tank_H2, W_FC_stack = W_FC_stack, m_FC_stack = m_FC_stack, p_tank_H2 = p_tank_H2)  annotation (
    Placement(visible = true, transformation(origin = {72, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem(C_bat_pack = C_bat_pack, Cp_bat_pack = Cp_bat_pack, H_bat_pack = H_bat_pack, L_bat_pack = L_bat_pack, SOC_init = SOC_init, V_max_bat_pack = V_max_bat_pack, V_min_bat_pack = V_min_bat_pack, V_nom_bat_pack = V_nom_bat_pack, W_bat_pack = W_bat_pack, m_bat_pack = m_bat_pack) annotation (
    Placement(visible = true, transformation(origin = {-28, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrical.DCConverter converter(vDCref = V_HV_Bus) annotation (
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  VirtualFCS.Electrical.DC_converter dC_converter annotation (
    Placement(visible = true, transformation(origin = {22, -44}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  // Power & Efficiencies
  Modelica.Units.SI.Power Power_del_DC_DC "Power delivered from the DC/DC converter";
  Modelica.Units.SI.Power Power_FC "Power delivered from the FC system";
  Modelica.Units.SI.Power Power_batt "Power delivered from the batt system";
  Modelica.Units.SI.Efficiency eta_drivetrain "Efficiency of the drivetrain";
  Modelica.Units.SI.Efficiency eta_DC_DC = 1 "Efficiency of the DC/DC converter";
  Control.ECMS.EMS_ECMS eMS_ECMS(
    I_min_FC_stack=15,
    I_max_FC_stack=130,
    n_cell=N_FC_stack)
    annotation (Placement(transformation(extent={{-94,-32},{-54,-12}})));
  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={38,-10})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{84,-28},{64,-8}})));
  Modelica.Blocks.Sources.RealExpression bat_V(y=batterySystem.pin_p.v)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,0})));
  Modelica.Blocks.Sources.RealExpression fc_V(y=fuelCellSystem.pin_p.v)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-34})));
  Modelica.Blocks.Sources.RealExpression getBatteryVoltage(y=batterySystem.pin_p.v)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Modelica.Blocks.Sources.RealExpression getBatteryCurrent(y=batterySystem.pin_n.i)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,22})));
  Modelica.Blocks.Sources.RealExpression getPowerDemand(y=converter.powerDC2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,4})));
  Modelica.Blocks.Sources.RealExpression getFcTemp(y=fuelCellSystem.fuelCellStack.temperatureSensor.T)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-50})));
  Modelica.Blocks.Sources.RealExpression getP_H2(y=fuelCellSystem.fuelCellStack.p_H2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-66})));
  Modelica.Blocks.Sources.RealExpression getP_O2(y=fuelCellSystem.fuelCellStack.p_O2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-80})));
equation
  Power_del_DC_DC = converter.dc_p1.i * converter.dc_p1.v;
  Power_FC = fuelCellSystem.pin_n.i * fuelCellSystem.pin_p.v;
  Power_batt = batterySystem.pin_n.i * batterySystem.pin_p.v;
  if Power_del_DC_DC > 0 then
    eta_drivetrain = min(max(((Power_del_DC_DC)/max((Power_FC + Power_batt + ((Power_FC * (1-(fuelCellSystem.eta_FC_sys)))+ (Power_batt * (1-(batterySystem.eta_batt)))+ (Power_del_DC_DC * (1-(eta_DC_DC))))), 0.000001)), 0),1);
  else
    eta_drivetrain = min(max(((-Power_del_DC_DC)/max((Power_FC -Power_batt + ((Power_FC * (1-(fuelCellSystem.eta_FC_sys))) - (Power_batt * (1-(batterySystem.eta_batt))) - (Power_del_DC_DC * (1-(eta_DC_DC))))), 0.000001)), 0), 1);
  end if;
  connect(pin_n, ground.p) annotation (
    Line(points = {{-40, 96}, {-68, 96}, {-68, 14}}, color = {0, 0, 255}));
  connect(converter.dc_n2, batterySystem.pin_n) annotation (
    Line(points={{-6,20},{-6,-22},{-32.4,-22},{-32.4,-62.4}},    color = {0, 0, 255}));
  connect(converter.dc_p2, batterySystem.pin_p) annotation (
    Line(points={{6,20},{6,-36},{-23.6,-36},{-23.6,-62.4}},    color = {0, 0, 255}));
  connect(converter.dc_n1, pin_n) annotation (
    Line(points = {{-6, 40}, {-38, 40}, {-38, 96}, {-40, 96}}, color = {0, 0, 255}));
  connect(dC_converter.pin_pBus, fuelCellSystem.pin_p) annotation (
    Line(points={{32,-34},{77,-34},{77,-63}},        color = {0, 0, 255}));
  connect(dC_converter.pin_nBus, fuelCellSystem.pin_n) annotation (
    Line(points={{32,-54},{67,-54},{67,-63}},        color = {0, 0, 255}));
  connect(dC_converter.pin_nFC, batterySystem.pin_n) annotation (
    Line(points={{12,-54},{-32.4,-54},{-32.4,-62.4}},  color = {0, 0, 255}));
  connect(dC_converter.pin_pFC, batterySystem.pin_p) annotation (
    Line(points={{12,-34},{-23.6,-34},{-23.6,-62.4}},  color = {0, 0, 255}));
  connect(converter.dc_p1, pin_p) annotation (
    Line(points = {{6, 40}, {42, 40}, {42, 96}}, color = {0, 0, 255}));
  connect(division.y, product1.u1)
    annotation (Line(points={{63,-18},{63,-16},{50,-16}}, color={0,0,127}));
  connect(fc_V.y, division.u2)
    annotation (Line(points={{99,-34},{86,-34},{86,-24}}, color={0,0,127}));
  connect(bat_V.y, division.u1) annotation (Line(points={{99,1.38778e-15},{86,
          1.38778e-15},{86,-12}}, color={0,0,127}));
  connect(getBatteryVoltage.y, eMS_ECMS.inputBatteryVoltage) annotation (Line(
        points={{-99,40},{-54,40},{-54,-10},{-64,-10}}, color={0,0,127}));
  connect(getBatteryCurrent.y, eMS_ECMS.inputBatteryCurrent)
    annotation (Line(points={{-99,22},{-74,22},{-74,-10}}, color={0,0,127}));
  connect(getPowerDemand.y, eMS_ECMS.inputPowerDemand)
    annotation (Line(points={{-99,4},{-84,4},{-84,-10}}, color={0,0,127}));
  connect(getP_H2.y, eMS_ECMS.inputP_H2)
    annotation (Line(points={{-99,-66},{-74,-66},{-74,-34}}, color={0,0,127}));
  connect(getP_O2.y, eMS_ECMS.inputP_O2) annotation (Line(points={{-99,-80},{
          -88,-80},{-88,-68},{-64,-68},{-64,-34}}, color={0,0,127}));
  connect(batterySystem.sensorOutput, eMS_ECMS.inputSOC) annotation (Line(
        points={{-39,-72},{-90,-72},{-90,-42},{-94,-42},{-94,-36},{-106,-36},{
          -106,-22},{-96,-22}}, color={0,0,127}));
  connect(product1.y, dC_converter.I_Ref) annotation (Line(points={{27,-10},{
          21.9,-10},{21.9,-32.5}}, color={0,0,127}));
  connect(eMS_ECMS.controlSetCurrent, product1.u2) annotation (Line(points={{
          -53,-22},{-34,-22},{-34,-20},{18,-20},{18,4},{50,4},{50,-4}}, color={
          0,0,127}));
  connect(getFcTemp.y, eMS_ECMS.inputFCTemp)
    annotation (Line(points={{-99,-50},{-84,-50},{-84,-34}}, color={0,0,127}));
  annotation (
    Icon(graphics={  Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Text(origin = {17, 123}, extent = {{3, 5}, {-3, -5}}, textString = "text"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-16.7, 56.9}, {19.3, 56.9}, {5, 11.8}, {28.4, 11.8}, {-18.7, -56.5}, {-20, -56}, {-5.3, -6}, {-28.5, -6}, {-16.7, 56.9}})}, coordinateSystem(initialScale = 0.1)));
annotation(Documentation(info = "<html><p>Hybrid powertrain using equivalent-consumption minimization to coordinate the fuel-cell system and battery through a DC converter.</p></html>"));
end ECMSPowerTrain;
