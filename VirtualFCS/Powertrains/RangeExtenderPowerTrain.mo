within VirtualFCS.Powertrains;
model RangeExtenderPowerTrain
  // System
  outer Modelica.Fluid.System system "System properties";
  // Powertrain parameters
  parameter Modelica.Units.SI.Mass m_powertrain = fuelCellSystem.m_FC_system + batterySystem.m_bat_pack annotation (
    Dialog(group = "Powertrain Parameters"));
  parameter Modelica.Units.SI.Voltage V_HV_Bus = 343 "Voltage of the HV Bus" annotation (
    Dialog(group = "Powertrain Parameters"));
  // H2 Subsystem Paramters
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.606 "H2 tank volume" annotation (
    Dialog(group = "Hydrogen storage Parameters"));
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
  VirtualFCS.Control.EnergyManagementSystem energyManagementSystem annotation (
    Placement(visible = true, transformation(origin = {-66, -72}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Power & Efficiencies
  Modelica.Units.SI.Power Power_del_DC_DC "Power delivered from the DC/DC converter";
  Modelica.Units.SI.Power Power_FC "Power delivered from the FC system";
  Modelica.Units.SI.Power Power_batt "Power delivered from the batt system";
  Modelica.Units.SI.Efficiency eta_drivetrain "Efficiency of the drivetrain";
  Modelica.Units.SI.Efficiency eta_DC_DC = 1 "Efficiency of the DC/DC converter";
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
  connect(energyManagementSystem.sensorInterface, batterySystem.sensorOutput) annotation (
    Line(points={{-53.9,-72.1},{-40,-72.1},{-40,-72},{-39,-72}},    color = {0, 0, 127}));
  connect(energyManagementSystem.controlInterface, dC_converter.I_Ref) annotation (
    Line(points={{-77,-72},{-92,-72},{-92,-16},{24,-16},{24,-32.5},{21.9,-32.5}},            color = {0, 0, 127}));
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
  annotation (
    Icon(graphics = {Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Text(origin = {17, 123}, extent = {{3, 5}, {-3, -5}}, textString = "text"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-16.7, 56.9}, {19.3, 56.9}, {5, 11.8}, {28.4, 11.8}, {-18.7, -56.5}, {-20, -56}, {-5.3, -6}, {-28.5, -6}, {-16.7, 56.9}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>m_powertrain</code></td><td>SI.Mass</td><td>kg</td><td>fuelCellSystem.m_FC_system + batterySystem.m_bat_pack</td><td>Powertrain Parameters</td></tr>
<tr><td><code>V_HV_Bus</code></td><td>SI.Voltage</td><td>V</td><td>343</td><td>Voltage of the HV Bus</td></tr>
<tr><td><code>V_tank_H2</code></td><td>SI.Volume</td><td>m3</td><td>0.606</td><td>H2 tank volume</td></tr>
<tr><td><code>p_tank_H2</code></td><td>SI.AbsolutePressure</td><td>Pa</td><td>30000000</td><td>H2 tank initial pressure</td></tr>
<tr><td><code>m_FC_stack</code></td><td>SI.Mass</td><td>kg</td><td>14.3</td><td>FC stack mass</td></tr>
<tr><td><code>L_FC_stack</code></td><td>SI.Length</td><td>m</td><td>0.255</td><td>FC stack length</td></tr>
<tr><td><code>W_FC_stack</code></td><td>SI.Breadth</td><td>m</td><td>0.760</td><td>FC stack width</td></tr>
<tr><td><code>H_FC_stack</code></td><td>SI.Height</td><td>m</td><td>0.060</td><td>FC stack height</td></tr>
<tr><td><code>vol_FC_stack</code></td><td>SI.Volume</td><td>m3</td><td>L_FC_stack * W_FC_stack * H_FC_stack</td><td>FC stack volume</td></tr>
<tr><td><code>I_nom_FC_stack</code></td><td>SI.ElectricCurrent</td><td>-</td><td>300</td><td>FC stack nominal current</td></tr>
<tr><td><code>I_rated_FC_stack</code></td><td>SI.ElectricCurrent</td><td>-</td><td>1.7 * I_nom_FC_stack</td><td>FC stack maximum operating current</td></tr>
<tr><td><code>N_FC_stack</code></td><td>Integer</td><td>1</td><td>280</td><td>FC stack number of cells</td></tr>
<tr><td><code>m_bat_pack</code></td><td>SI.Mass</td><td>kg</td><td>100</td><td>Mass of the pack</td></tr>
<tr><td><code>L_bat_pack</code></td><td>SI.Length</td><td>m</td><td>0.6</td><td>Battery pack length</td></tr>
<tr><td><code>W_bat_pack</code></td><td>SI.Breadth</td><td>m</td><td>0.45</td><td>Battery pack width</td></tr>
<tr><td><code>H_bat_pack</code></td><td>SI.Height</td><td>m</td><td>0.1</td><td>Battery pack height</td></tr>
<tr><td><code>Cp_bat_pack</code></td><td>SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>1000</td><td>Specific Heat Capacity</td></tr>
<tr><td><code>V_min_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>240</td><td>Battery pack minimum voltage</td></tr>
<tr><td><code>V_nom_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>336</td><td>Battery pack nominal voltage</td></tr>
<tr><td><code>V_max_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>403.2</td><td>Battery pack maximum voltage</td></tr>
<tr><td><code>C_bat_pack</code></td><td>NonSI.ElectricCharge_Ah</td><td>Ah</td><td>200</td><td>Battery pack nominal capacity</td></tr>
<tr><td><code>SOC_init</code></td><td>Real</td><td>1</td><td>0.5</td><td>Battery pack initial state of charge</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_p</code></td><td>Input-side interface</td><td>PositivePin</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><p>Range-extender hybrid powertrain combining a battery-electric drive with a fuel-cell.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>Power_del_DC_DC = converter.dc_p1.i * converter.dc_p1.v;
Power_FC = fuelCellSystem.pin_n.i * fuelCellSystem.pin_p.v;
Power_batt = batterySystem.pin_n.i * batterySystem.pin_p.v;
eta_drivetrain = min(max(((Power_del_DC_DC)/max((Power_FC + Power_batt + ((Power_FC * (1-(fuelCellSystem.eta_FC_sys)))+ (Power_batt * (1-(batterySystem.eta_batt)))+ (Power_del_DC_DC * (1-(eta_DC_DC))))), 0.000001)), 0),1);
eta_drivetrain = min(max(((-Power_del_DC_DC)/max((Power_FC -Power_batt + ((Power_FC * (1-(fuelCellSystem.eta_FC_sys))) - (Power_batt * (1-(batterySystem.eta_batt))) - (Power_del_DC_DC * (1-(eta_DC_DC))))), 0.000001)), 0), 1);</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_n</code></td><td>Output-side interface</td><td>NegativePin</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end RangeExtenderPowerTrain;
