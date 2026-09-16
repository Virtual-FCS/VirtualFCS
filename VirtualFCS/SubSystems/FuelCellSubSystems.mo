within VirtualFCS.SubSystems;

model FuelCellSubSystems
  outer Modelica.Fluid.System system "System properties";
  replaceable package Cathode_Medium = Media.CathodeAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2 constrainedby Modelica.Media.Interfaces.PartialPureSubstance;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Integer N_cells = 399 "FC stack number of cells";

  Modelica.Fluid.Interfaces.FluidPort_a H2_toStack(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-70, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b H2_fromStack(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stackTemperature annotation(
    Placement(transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Interfaces.FluidPort_a air_toStack(redeclare package Medium = Cathode_Medium) annotation(
    Placement(transformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {70, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b air_fromStack(redeclare package Medium = Cathode_Medium) annotation(
    Placement(transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_a coolant_toStack(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {-10, 70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {10, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b coolant_fromStack(redeclare package Medium = Coolant_Medium) annotation(
    Placement(transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-10, 90}, extent = {{-10, -10}, {10, 10}})));
  Hydrogen.SubSystemHydrogen subSystemHydrogen(N_cells = N_cells) annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-30, -20}, {30, 20}})));
  VirtualFCS.SubSystems.Air.SubSystemAir subSystemAir(N_cells = N_cells) annotation(
    Placement(transformation(origin = {60, 0}, extent = {{-20, -20}, {20, 20}})));
  Cooling.SubSystemCooling subSystemCooling annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Electrochemical.Battery.BatterySystem batterySystem(V_min_bat_pack = 50, V_nom_bat_pack = 60, V_max_bat_pack = 70, C_bat_pack = 2000, SOC_init = 0.99, m_bat_pack = 1) annotation(
    Placement(transformation(origin = {0, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(subSystemHydrogen.toStack, H2_toStack) annotation(
    Line(points = {{-70, 24}, {-70, 70}}, color = {0, 127, 255}));
  connect(subSystemHydrogen.fromStack, H2_fromStack) annotation(
    Line(points = {{-50, 24}, {-50, 50}}, color = {0, 127, 255}));
  connect(subSystemCooling.to_stack, coolant_toStack) annotation(
    Line(points = {{-12, 24}, {-10, 24}, {-10, 70}}, color = {0, 127, 255}));
  connect(subSystemCooling.from_stack, coolant_fromStack) annotation(
    Line(points = {{12, 24}, {10, 24}, {10, 50}}, color = {0, 127, 255}));
  connect(subSystemAir.toStack, air_toStack) annotation(
    Line(points = {{48, 24}, {50, 24}, {50, 70}}, color = {0, 127, 255}));
  connect(subSystemAir.fromStack, air_fromStack) annotation(
    Line(points = {{72, 24}, {70, 24}, {70, 50}}, color = {0, 127, 255}));
  connect(stackCurrent, subSystemHydrogen.stackCurrent) annotation(
    Line(points = {{-120, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(stackCurrent, subSystemAir.stackCurrent) annotation(
    Line(points = {{-120, 0}, {-92, 0}, {-92, 34}, {30, 34}, {30, 10}, {38, 10}}, color = {0, 0, 127}));
  connect(stackTemperature, subSystemCooling.stackTemperature) annotation(
    Line(points = {{-120, -30}, {-30, -30}, {-30, 10}, {-22, 10}}, color = {0, 0, 127}));
  connect(batterySystem.pin_p, subSystemCooling.pin_p) annotation(
    Line(points = {{8, -60}, {10, -60}, {10, -18}}, color = {255, 0, 0}));
  connect(batterySystem.pin_p, subSystemAir.pin_p) annotation(
    Line(points = {{8, -60}, {10, -60}, {10, -40}, {70, -40}, {70, -18}}, color = {255, 0, 0}));
  connect(batterySystem.pin_p, subSystemHydrogen.pin_p) annotation(
    Line(points = {{8, -60}, {10, -60}, {10, -40}, {-50, -40}, {-50, -18}}, color = {255, 0, 0}));
  connect(batterySystem.pin_n, subSystemCooling.pin_n) annotation(
    Line(points = {{-8, -60}, {-10, -60}, {-10, -18}}));
  connect(batterySystem.pin_n, subSystemAir.pin_n) annotation(
    Line(points = {{-8, -60}, {-10, -60}, {-10, -50}, {50, -50}, {50, -18}}));
  connect(batterySystem.pin_n, subSystemHydrogen.pin_n) annotation(
    Line(points = {{-8, -60}, {-10, -60}, {-10, -50}, {-66, -50}, {-66, -18}}));
  annotation(
    Icon(graphics = {Text(origin = {-31, -100}, lineColor = {0, 0, 255}, extent = {{-105, 8}, {167, -40}}, textString = "%name"), Rectangle(extent = {{-100, 100}, {100, -100}}), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Text(origin = {-82, 60}, lineColor = {255, 255, 255}, extent = {{-22, 10}, {22, -10}}, textString = "H2"), Text(origin = {-2, 60}, lineColor = {255, 255, 255}, extent = {{-22, 10}, {22, -10}}, textString = "Cool"), Text(origin = {80, 60}, lineColor = {255, 255, 255}, extent = {{-22, 10}, {22, -10}}, textString = "Air")}, coordinateSystem(initialScale = 0.1)));
annotation(Documentation(info = "<html><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below. Units are explicit; <code>1</code> denotes a dimensionless quantity.</p><table border=&quot;1&quot; cellspacing=&quot;0&quot; cellpadding=&quot;4&quot;><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td>399</td><td>FC stack number of cells</td></tr></table><h3>Inputs and input-side interfaces</h3><table border=&quot;1&quot; cellspacing=&quot;0&quot; cellpadding=&quot;4&quot;><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>H2_toStack</code></td><td>Input-side interface</td><td>FluidPort_a</td><td>-</td><td></td></tr>
<tr><td><code>stackTemperature</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr>
<tr><td><code>air_toStack</code></td><td>Input-side interface</td><td>FluidPort_a</td><td>-</td><td></td></tr>
<tr><td><code>coolant_toStack</code></td><td>Input-side interface</td><td>FluidPort_a</td><td>-</td><td></td></tr>
<tr><td><code>stackCurrent</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr></table><h2>2. Model description</h2><html><p>Fuel-cell subsystem assembly containing the air, hydrogen, and cooling subsystems connected to a common battery and electrical interface.</p><h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended model or enforced by instantiated components and their connected physical networks.</p><p>References retained from the original model documentation are included in the description above.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=&quot;1&quot; cellspacing=&quot;0&quot; cellpadding=&quot;4&quot;><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>H2_fromStack</code></td><td>Output-side interface</td><td>FluidPort_b</td><td>-</td><td></td></tr>
<tr><td><code>air_fromStack</code></td><td>Output-side interface</td><td>FluidPort_b</td><td>-</td><td></td></tr>
<tr><td><code>coolant_fromStack</code></td><td>Output-side interface</td><td>FluidPort_b</td><td>-</td><td></td></tr></table></html>"));
annotation(Documentation(info = "<html><p><b>FuelCellSubSystems</b> is the integrated balance-of-plant assembly around a fuel-cell stack.</p><h3>Composition</h3><p>It combines <a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">SubSystemAir</a>, <a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen\">SubSystemHydrogen</a>, and <a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCooling\">SubSystemCooling</a>. The three assemblies provide the cathode air, anode hydrogen, and coolant paths; the stack-current and stack-temperature inputs are distributed to the relevant controls.</p><h3>Interfaces and purpose</h3><p>The external fluid ports are grouped as <code>air_toStack</code>/<code>air_fromStack</code>, <code>H2_toStack</code>/<code>H2_fromStack</code>, and <code>coolant_toStack</code>/<code>coolant_fromStack</code>. Electrical pins power the subsystem components. Use this class when a system model needs a single replaceable balance-of-plant interface; use the individual subsystem classes when testing or replacing one line independently.</p><p>The cell count and three fluid media are replaceable. Verify controller tuning and medium compatibility for the selected fuel-cell stack.</p></html>"));
end FuelCellSubSystems;
