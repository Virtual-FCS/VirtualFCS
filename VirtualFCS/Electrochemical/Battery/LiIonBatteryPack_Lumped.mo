within VirtualFCS.Electrochemical.Battery;

model LiIonBatteryPack_Lumped "A Li-ion battery pack model comprising a single lumped battery model."
  // DECLARE PARAMETERS //
  // Pack-level parameters
  parameter Modelica.Units.SI.Mass m_bat_pack = 100 "Mass of the pack";
  parameter Modelica.Units.SI.Length L_bat_pack = 0.6 "Battery pack length";
  parameter Modelica.Units.SI.Breadth W_bat_pack = 0.45 "Battery pack width";
  parameter Modelica.Units.SI.Height H_bat_pack = 0.1 "Battery pack height";
  parameter Modelica.Units.SI.SpecificHeatCapacity Cp_bat_pack = 1000 "Specific Heat Capacity";
  parameter Modelica.Units.SI.Voltage V_min_bat_pack = 37.5 "Battery pack minimum voltage";
  parameter Modelica.Units.SI.Voltage V_nom_bat_pack = 48 "Battery pack nominal voltage";
  parameter Modelica.Units.SI.Voltage V_max_bat_pack = 54.75 "Battery pack maximum voltage";
  parameter Modelica.Units.NonSI.ElectricCharge_Ah C_bat_pack = 200 "Battery pack nominal capacity";
  parameter Real SOC_init = 0.5 "Battery pack initial state of charge";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer heatTransferCoefficient = 7.8*10^0.78 "HeatTransferCoefficient (W/(m2.K))";
  parameter Real N_s = ceil(V_max_bat_pack/V_chem_max);
  Modelica.Units.SI.Volume vol_bat_pack = L_bat_pack*W_bat_pack*H_bat_pack;
  // ADD dropdown menu for selecting chemistry type
  // Coefficients for open-circuit voltage calculation
  // LFP
  parameter Modelica.Units.SI.Voltage V_chem_max = 3.65;
  parameter Modelica.Units.SI.Voltage a1 = 3.39;
  parameter Real b1 = -1e-4;
  parameter Modelica.Units.SI.Voltage c1 = -7.46e-2;
  parameter Modelica.Units.SI.Voltage d1 = 5.82e-3;
  parameter Modelica.Units.SI.Voltage e1 = -2.75e-2;
  parameter Modelica.Units.SI.Voltage f1 = 2.30e-2;
  parameter Modelica.Units.SI.Voltage g1 = -4.71e-2;
  parameter Modelica.Units.SI.Voltage h1 = -0.02;
  parameter Modelica.Units.SI.LinearTemperatureCoefficient i1 = -0.002;
  Real C_rate = pin_p.i/C_bat_pack "Cycle rate";
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {146, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-146, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {-70, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R = R1_0, useHeatPort = false) annotation(
    Placement(visible = true, transformation(origin = {-50, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor C2(C = C2_0, v(fixed = true)) annotation(
    Placement(visible = true, transformation(origin = {-14, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = Cp_bat_pack*m_bat_pack, T(fixed = true)) annotation(
    Placement(visible = true, transformation(origin = {-70, 12}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor sensorCurrent annotation(
    Placement(visible = true, transformation(origin = {20, 52}, extent = {{11, 11}, {-11, -11}}, rotation = 180)));
  Modelica.Electrical.Analog.Sources.SignalVoltage OCV annotation(
    Placement(visible = true, transformation(origin = {-120, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor C1(C = C1_0, v(fixed = true)) annotation(
    Placement(visible = true, transformation(origin = {-50, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R2(R = R2_0, useHeatPort = false) annotation(
    Placement(visible = true, transformation(origin = {-14, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatSource annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R_ohmic(R = R_O, T_ref = 300.15, useHeatPort = false) annotation(
    Placement(visible = true, transformation(origin = {-90, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = SOC_init) annotation(
    Placement(visible = true, transformation(origin = {42, -34}, extent = {{-16, -10}, {16, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = C_bat_pack*3600) annotation(
    Placement(visible = true, transformation(origin = {39, -82}, extent = {{-19, -10}, {19, 10}}, rotation = 0)));
  VirtualFCS.Control.ChargeCounter chargeCounter annotation(
    Placement(visible = true, transformation(origin = {108, -58}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = heatTransferCoefficient*A_cool_bat_pack) annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatBoundary annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95*A_cool_bat_pack) annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
protected
  parameter Modelica.Units.SI.Resistance R_O = 0.024 "Ohmic Resistance";
  parameter Modelica.Units.SI.Resistance R1_0 = 0.0006 "First RC Resistance";
  parameter Modelica.Units.SI.Resistance R2_0 = 0.008 "Second RC Resistance";
  parameter Modelica.Units.SI.Capacitance C1_0 = 5700 "First RC Capacitance";
  parameter Modelica.Units.SI.Capacitance C2_0 = 54300 "Second RC Capacitance";
  parameter Modelica.Units.SI.Area A_cool_bat_pack = L_bat_pack*W_bat_pack;
equation
// ***DEFINE EQUATIONS ***//
// Calculate the open-circuit voltage at given temperature and state of charge
  OCV.v = N_s*(a1 + b1*(20 - (heatPort.T - 273.15))*1/chargeCounter.SOC + c1/sqrt(chargeCounter.SOC) + d1*chargeCounter.SOC + e1*log(chargeCounter.SOC) + f1*log(1.01 - chargeCounter.SOC) + g1*log(1.001 - chargeCounter.SOC) + h1*exp(i1*(heatPort.T - 273.15)));
// Thermal equations
  heatSource.Q_flow = abs((OCV.v - pin_p.v)*sensorCurrent.i);
// ***DEFINE CONNECTIONS ***//
  connect(pin_n, OCV.n) annotation(
    Line(points = {{-146, 52}, {-130, 52}, {-130, 52}, {-130, 52}}, color = {0, 0, 255}));
  connect(R1.n, R2.p) annotation(
    Line(points = {{-40, 52}, {-24, 52}, {-24, 52}, {-24, 52}}, color = {0, 0, 255}));
  connect(C2.p, R2.p) annotation(
    Line(points = {{-24, 76}, {-24, 76}, {-24, 52}, {-24, 52}}, color = {0, 0, 255}));
  connect(C2.n, R2.n) annotation(
    Line(points = {{-4, 76}, {-4, 76}, {-4, 52}, {-4, 52}}, color = {0, 0, 255}));
  connect(C1.n, R1.n) annotation(
    Line(points = {{-40, 76}, {-40, 76}, {-40, 52}, {-40, 52}}, color = {0, 0, 255}));
  connect(C1.p, R1.p) annotation(
    Line(points = {{-60, 76}, {-60, 76}, {-60, 52}, {-60, 52}}, color = {0, 0, 255}));
  connect(sensorCurrent.i, chargeCounter.electricCurrent) annotation(
    Line(points = {{20, 39.9}, {20, 39.9}, {20, -58}, {72, -58}, {72, -58}}, color = {0, 0, 127}));
  connect(getSOC_init.y, chargeCounter.SOC_init) annotation(
    Line(points = {{59.6, -34}, {68, -34}, {68, -34}, {72, -34}}, color = {0, 0, 127}));
  connect(getChargeCapacity.y, chargeCounter.chargeCapacity) annotation(
    Line(points = {{59.9, -82}, {70, -82}, {70, -82}, {72, -82}}, color = {0, 0, 127}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{-70, 0}, {-70, -22}}, color = {191, 0, 0}));
  connect(heatSource.port, heatCapacitor.port) annotation(
    Line(points = {{-110, 0}, {-70, 0}}, color = {191, 0, 0}));
  connect(convection.Gc, setConvectiveCoefficient.y) annotation(
    Line(points = {{-40, -50}, {-26, -50}, {-26, -50}, {-26.5, -50}}, color = {0, 0, 127}));
  connect(heatPort, convection.solid) annotation(
    Line(points = {{-70, -22}, {-70, -22}, {-70, -34}, {-50, -34}, {-50, -40}, {-50, -40}}, color = {191, 0, 0}));
  connect(heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{-70, -22}, {-70, -22}, {-70, -34}, {-90, -34}, {-90, -40}, {-90, -40}}, color = {191, 0, 0}));
  connect(bodyRadiation.port_b, heatBoundary) annotation(
    Line(points = {{-90, -60}, {-90, -60}, {-90, -66}, {-70, -66}, {-70, -80}, {-70, -80}}, color = {191, 0, 0}));
  connect(convection.fluid, heatBoundary) annotation(
    Line(points = {{-50, -60}, {-50, -60}, {-50, -66}, {-70, -66}, {-70, -80}, {-70, -80}}, color = {191, 0, 0}));
  connect(R2.n, sensorCurrent.p) annotation(
    Line(points = {{-4, 52}, {10, 52}, {10, 52}, {9, 52}}, color = {0, 0, 255}));
  connect(sensorCurrent.n, pin_p) annotation(
    Line(points = {{31, 52}, {148, 52}, {148, 50}, {146, 50}}, color = {0, 0, 255}));
  connect(OCV.p, R_ohmic.p) annotation(
    Line(points = {{-110, 52}, {-100, 52}}, color = {0, 0, 255}));
  connect(R_ohmic.n, R1.p) annotation(
    Line(points = {{-80, 52}, {-60, 52}}, color = {0, 0, 255}));
  annotation(
    Icon(graphics = {Rectangle(origin = {0, -15}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-130, 85}, {130, -75}}), Rectangle(origin = {0, 85}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-150, 15}, {150, -15}}), Text(origin = {68, 93}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {10, -19}}, textString = "+"), Text(origin = {-74, 105}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {52, -41}}, textString = "-"), Text(origin = {-34, -103}, lineColor = {0, 0, 255}, extent = {{-22, 15}, {86, -41}}, textString = "%name")}, coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    Diagram(coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    version = "",
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>m_bat_pack</code></td><td>SI.Mass</td><td>kg</td><td>100</td><td>Mass of the pack</td></tr>
<tr><td><code>L_bat_pack</code></td><td>SI.Length</td><td>m</td><td>0.6</td><td>Battery pack length</td></tr>
<tr><td><code>W_bat_pack</code></td><td>SI.Breadth</td><td>m</td><td>0.45</td><td>Battery pack width</td></tr>
<tr><td><code>H_bat_pack</code></td><td>SI.Height</td><td>m</td><td>0.1</td><td>Battery pack height</td></tr>
<tr><td><code>Cp_bat_pack</code></td><td>SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>1000</td><td>Specific Heat Capacity</td></tr>
<tr><td><code>V_min_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>37.5</td><td>Battery pack minimum voltage</td></tr>
<tr><td><code>V_nom_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>48</td><td>Battery pack nominal voltage</td></tr>
<tr><td><code>V_max_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>54.75</td><td>Battery pack maximum voltage</td></tr>
<tr><td><code>C_bat_pack</code></td><td>NonSI.ElectricCharge_Ah</td><td>Ah</td><td>200</td><td>Battery pack nominal capacity</td></tr>
<tr><td><code>SOC_init</code></td><td>Real</td><td>1</td><td>0.5</td><td>Battery pack initial state of charge</td></tr>
<tr><td><code>heatTransferCoefficient</code></td><td>SI.CoefficientOfHeatTransfer</td><td>-</td><td>7.8 * 10 ^ 0.78</td><td>HeatTransferCoefficient (W/(m2.K))</td></tr>
<tr><td><code>N_s</code></td><td>Real</td><td>1</td><td>ceil(V_max_bat_pack / V_chem_max)</td><td></td></tr>
<tr><td><code>V_chem_max</code></td><td>SI.Voltage</td><td>V</td><td>3.65</td><td></td></tr>
<tr><td><code>a1</code></td><td>SI.Voltage</td><td>V</td><td>3.39</td><td></td></tr>
<tr><td><code>b1</code></td><td>Real</td><td>1</td><td>-1e-4</td><td></td></tr>
<tr><td><code>c1</code></td><td>SI.Voltage</td><td>V</td><td>-7.46e-2</td><td></td></tr>
<tr><td><code>d1</code></td><td>SI.Voltage</td><td>V</td><td>5.82e-3</td><td></td></tr>
<tr><td><code>e1</code></td><td>SI.Voltage</td><td>V</td><td>-2.75e-2</td><td></td></tr>
<tr><td><code>f1</code></td><td>SI.Voltage</td><td>V</td><td>2.30e-2</td><td></td></tr>
<tr><td><code>g1</code></td><td>SI.Voltage</td><td>V</td><td>-4.71e-2</td><td></td></tr>
<tr><td><code>h1</code></td><td>SI.Voltage</td><td>V</td><td>-0.02</td><td></td></tr>
<tr><td><code>i1</code></td><td>SI.LinearTemperatureCoefficient</td><td>-</td><td>-0.002</td><td></td></tr>
<tr><td><code>R_O</code></td><td>SI.Resistance</td><td>Ohm</td><td>0.024</td><td>Ohmic Resistance</td></tr>
<tr><td><code>R1_0</code></td><td>SI.Resistance</td><td>Ohm</td><td>0.0006</td><td>First RC Resistance</td></tr>
<tr><td><code>R2_0</code></td><td>SI.Resistance</td><td>Ohm</td><td>0.008</td><td>Second RC Resistance</td></tr>
<tr><td><code>C1_0</code></td><td>SI.Capacitance</td><td>F</td><td>5700</td><td>First RC Capacitance</td></tr>
<tr><td><code>C2_0</code></td><td>SI.Capacitance</td><td>F</td><td>54300</td><td>Second RC Capacitance</td></tr>
<tr><td><code>A_cool_bat_pack</code></td><td>SI.Area</td><td>m2</td><td>L_bat_pack * W_bat_pack</td><td></td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_p</code></td><td>Input-side interface</td><td>PositivePin</td><td>-</td><td></td></tr>
<tr><td><code>heatPort</code></td><td>Input-side interface</td><td>HeatPort_a</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><div><font face=\"&quot;Arial&quot;\">This model describes a lithium-ion battery pack as a lumped version of the&nbsp;<a href=\"&quot;modelica://VirtualFCS.Electrochemical.Battery.LiIonCell&quot;\">LiIonCell model</a>. The primary difference is that the open-circuit voltage (OCV) is scaled by the number of cells in series in the stack, estimated as the battery pack maximum voltage divided by the maximum voltage of a single cell (</font><i style=\"&quot;font-size:\" 12px;&quot;=\"\">V<sub>max,bat pack</sub></i><span style=\"&quot;font-size:\" 12px;&quot;=\"\">/</span><i style=\"&quot;font-size:\" 12px;&quot;=\"\">V<sub>chem,max</sub></i><span style=\"&quot;font-family:\" arial;&quot;=\"\">).</span></div><div><font face=\"&quot;Arial&quot;\"><br></font></div><div><font face=\"&quot;Arial&quot;\">The model includes a <a href=\"&quot;modelica://VirtualFCS.Control.ChargeCounter&quot;\">ChargeCounter</a> block to keep track of the state of charge (SOC) of the battery.</font></div><div>




<font face=\"&quot;Arial&quot;\"><br>
The equation for open-circuit voltage as a function of temperature and state of charge is taken from Vichard&nbsp;<i>et al.</i>&nbsp;[1], and is parameterized to the LFP chemistry by default.</font></div><div><br></div><div>The battery pack is assumed to have a uniform temperature with a thermal mass based on its heat capacity, Cp, and mass m_bat_pack. The heat generated from passing current through the battery is calculated according to the <i>Heat Generation</i>&nbsp;equation below. Heat is assumed to enter or leave the battery via convection and radiation on an area equivalent to the bottom wall of the pack. The ambient temperature is determined by the connection to the heatBoundary.</div><div><br></div><div><br></div><div><div><b><u><font face=\"&quot;Arial&quot;\">References</font></u></b></div><div><div class=\"&quot;csl-bib-body&quot;\" style=\"&quot;line-height:\" 2;&quot;=\"\"><div class=\"&quot;csl-entry&quot;\" style=\"&quot;clear:\" left;&quot;=\"\"><div class=\"&quot;csl-left-margin&quot;\" style=\"&quot;float:\" left;=\"\" padding-right:=\"\" 0.5em;=\"\" text-align:=\"\" right;=\"\" width:=\"\" 1em;&quot;=\"\"><font face=\"&quot;Arial&quot;\">1.&nbsp;</font><span style=\"font-family: Arial;\">Vichard, L.&nbsp;</span><i style=\"font-family: Arial;\">et al.</i><span style=\"font-family: Arial;\">&nbsp;A method to estimate battery SOH indicators based on vehicle operating data only.&nbsp;</span><i style=\"font-family: Arial;\">Energy</i><span style=\"font-family: Arial;\">&nbsp;</span><b style=\"font-family: Arial;\">225</b><span style=\"font-family: Arial;\">, 120235 (2021).</span></div></div></div></div></div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>OCV.v = N_s * (a1 + b1 * (20 - (heatPort.T - 273.15)) * 1 / chargeCounter.SOC + c1 / sqrt(chargeCounter.SOC) + d1 * chargeCounter.SOC + e1 * log(chargeCounter.SOC) + f1 * log(1.01 - chargeCounter.SOC) + g1 * log(1.001 - chargeCounter.SOC) + h1 * exp(i1 * (heatPort.T - 273.15)));
heatSource.Q_flow = abs((OCV.v - pin_p.v) * sensorCurrent.i);</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_n</code></td><td>Output-side interface</td><td>NegativePin</td><td>-</td><td></td></tr>
<tr><td><code>heatBoundary</code></td><td>Output-side interface</td><td>HeatPort_b</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end LiIonBatteryPack_Lumped;
