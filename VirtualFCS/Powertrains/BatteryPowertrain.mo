within VirtualFCS.Powertrains;
model BatteryPowertrain
  extends VirtualFCS.Powertrains.PowertrainInterface;
  replaceable Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(transformation(origin = {-30, -30}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(batterySystem.pin_n, pin_n) annotation(
    Line(points = {{-34, -20}, {-34, 40}, {-40, 40}, {-40, 96}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, pin_p) annotation(
    Line(points = {{-26, -20}, {-26, 40}, {42, 40}, {42, 96}}, color = {0, 0, 255}));
  annotation (
    Icon(coordinateSystem(initialScale = 0.1)),
  Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>

<tr><td><code>Cp_bat_pack</code></td><td>SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>1000</td><td>Specific Heat Capacity</td></tr>
<tr><td><code>V_max_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>54.75</td><td>Battery pack maximum voltage</td></tr>
<tr><td><code>C_bat_pack</code></td><td>NonSI.ElectricCharge_Ah</td><td>Ah</td><td>2700</td><td>Battery pack nominal capacity</td></tr>
<tr><td><code>SOC_init</code></td><td>Real</td><td>1</td><td>0.5</td><td>Battery pack initial state of charge</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_p</code></td><td>Input-side interface</td><td>PositivePin</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><p>Battery-electric powertrain connecting a DC converter, battery system, and external electrical bus.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_n</code></td><td>Output-side interface</td><td>NegativePin</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end BatteryPowertrain;
