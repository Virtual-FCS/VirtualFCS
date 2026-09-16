within VirtualFCS.Electrochemical.Hydrogen;
model FuelCellSystem

  outer Modelica.Fluid.System system "System properties";
  constant Modelica.Units.SI.SpecificEnergy H2HHV = 142e6 "(J/kg) Hydrogen low heating value";
  constant Modelica.Units.SI.SpecificEnergy H2LHV = 120e6 "(J/kg) Hydrogen low heating value";
  constant Real eta_max = 70. "Maximum system efficiency to avoid spurious peak efficiencies due to current step changes";
  parameter Modelica.Units.SI.AbsolutePressure p_air_set = 200000 "air outlet set pressure";
  parameter Modelica.Units.SI.AbsolutePressure p_H2_set = 200000 "H2 outlet set pressure";

  parameter Integer N_cells = 42 "FC stack number of cells";
  // H2 Subsystem Paramters
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.606 "H2 tank volume"; // 15 kg @ 300 bar from VFCS D4.1
  parameter Modelica.Units.SI.AbsolutePressure p_tank_H2 = 30000000 "H2 tank initial pressure";
  // Mediums
  replaceable package Cathode_Medium = Media.CathodeAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  // Power and efficiency calculations
  Modelica.Units.SI.Power Power_system = Power_stack-Power_BOP "Power delivered from the FC system";
  Modelica.Units.SI.Power Power_stack = fuelCell.pin_n.i*(fuelCell.pin_p.v-fuelCell.pin_n.v) "Power delivered from the FC stack";
  Modelica.Units.SI.Power Power_BOP = batterySystem.pin_n.i*(batterySystem.pin_p.v-batterySystem.pin_n.v) "Power consumed by the BOP components";
  Real eta_sys_HHV(unit = "100") "Fuel cell system efficiency High Heating Value";
  Real eta_sys_LHV(unit = "100") "Fuel cell system efficiency Low Heating Value";

  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin = {46, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable FuelCell fuelCell(N_cells = N_cells, redeclare package Cathode_Medium = Cathode_Medium) annotation(
    Placement(transformation(origin = {0, -4}, extent = {{-40, -15}, {40, 65}})));
  replaceable SubSystems.Air.SubSystemAir subSystemAir(N_cells = N_cells, p_set = p_air_set, redeclare package Medium = Cathode_Medium)  annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  replaceable SubSystems.Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(transformation(origin = {1, -47}, extent = {{-11, -11}, {11, 11}})));
  replaceable SubSystems.Hydrogen.SubSystemHydrogen subSystemHydrogen(subSystemHydrogenControl(pressure_H2_set = p_H2_set), redeclare package Anode_Medium = Anode_Medium)  annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-15, -10}, {15, 10}}, rotation = -90)));
  Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {42, -84}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  eta_sys_HHV = min(Power_system/(max((fuelCell.anode_in.m_flow + fuelCell.anode_out.m_flow), 1e-10)*H2HHV)*100, eta_max);
  eta_sys_LHV = min(Power_system/(max((fuelCell.anode_in.m_flow + fuelCell.anode_out.m_flow), 1e-10)*H2LHV)*100, eta_max);
  connect(pin_n, currentSensor.p) annotation(
    Line(points = {{-40, 96}, {-40, 80}}, color = {0, 0, 255}));
  connect(fuelCell.pin_n, currentSensor.n) annotation(
    Line(points = {{-21, 50}, {-21, 60}, {-40, 60}}, color = {0, 0, 255}));
  connect(fuelCell.pin_p, pin_p) annotation(
    Line(points = {{21, 50}, {21, 96}, {46, 96}}, color = {0, 0, 255}));
  connect(temperatureSensor.port, fuelCell.heatPort) annotation(
    Line(points = {{-30, -20}, {0, -20}, {0, 2}}, color = {191, 0, 0}));
  connect(temperatureSensor.T, subSystemCooling.stackTemperature) annotation(
    Line(points = {{-50, -20}, {-60, -20}, {-60, -41.5}, {-11, -41.5}}, color = {0, 0, 127}));
  connect(fuelCell.coolant_out, subSystemCooling.from_stack) annotation(
    Line(points = {{8, -3}, {8, -34}}, color = {0, 127, 255}));
  connect(fuelCell.coolant_in, subSystemCooling.to_stack) annotation(
    Line(points = {{-8, -3}, {-8, -18}, {-6, -18}, {-6, -34}}, color = {0, 127, 255}));
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
  connect(subSystemAir.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{80, 16}, {92, 16}, {92, -66}, {38, -66}, {38, -74}}, color = {0, 0, 255}));
  connect(subSystemAir.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{80, 26}, {96, 26}, {96, -70}, {46, -70}, {46, -74}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{6, -56}, {6, -66}, {38, -66}, {38, -74}}, color = {0, 0, 255}));
  connect(subSystemCooling.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-4, -56}, {-4, -70}, {46, -70}, {46, -74}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_p, batterySystem.pin_p) annotation(
    Line(points = {{-78, 16}, {-86, 16}, {-86, -66}, {38, -66}, {38, -74}}, color = {0, 0, 255}));
  connect(subSystemHydrogen.pin_n, batterySystem.pin_n) annotation(
    Line(points = {{-78, 24}, {-92, 24}, {-92, -70}, {46, -70}, {46, -74}}, color = {0, 0, 255}));
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation (
    Placement(transformation(origin = {-40, -20}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(transformation(origin = {-40, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  annotation (
    Icon(graphics={  Text(origin = {-6, -250}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Rectangle(origin = {-55, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {58.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {-40, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-29.8, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-19.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-8.7, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {1.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {12.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {22.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {32.3, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {42.9, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>p_air_set</code></td><td>SI.AbsolutePressure</td><td>Pa</td><td>200000</td><td>air outlet set pressure</td></tr>
<tr><td><code>p_H2_set</code></td><td>SI.AbsolutePressure</td><td>Pa</td><td>200000</td><td>H2 outlet set pressure</td></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td>42</td><td>FC stack number of cells</td></tr>
<tr><td><code>V_tank_H2</code></td><td>SI.Volume</td><td>m3</td><td>0.606</td><td>H2 tank volume</td></tr>
<tr><td><code>p_tank_H2</code></td><td>SI.AbsolutePressure</td><td>Pa</td><td>30000000</td><td>H2 tank initial pressure</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_p</code></td><td>Input-side interface</td><td>PositivePin</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2>The FuelCellSystem class packages together a FuelCell object and three different subsystems to control&nbsp;hydrogen, air, and coolant feeds into and out of the fuel cell. A battery object provides power to the subsystems.<h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>eta_sys_HHV = min(Power_system/(max((fuelCell.anode_in.m_flow + fuelCell.anode_out.m_flow), 1e-10)*H2HHV)*100, eta_max);
eta_sys_LHV = min(Power_system/(max((fuelCell.anode_in.m_flow + fuelCell.anode_out.m_flow), 1e-10)*H2LHV)*100, eta_max);</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_n</code></td><td>Output-side interface</td><td>NegativePin</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end FuelCellSystem;
