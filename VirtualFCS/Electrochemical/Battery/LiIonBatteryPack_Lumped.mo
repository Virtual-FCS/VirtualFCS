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
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer heatTransferCoefficient = 7.8 * 10 ^ 0.78 "HeatTransferCoefficient (W/(m2.K))";
  parameter Real N_s = ceil(V_max_bat_pack / V_chem_max);
  Modelica.Units.SI.Volume vol_bat_pack = L_bat_pack * W_bat_pack * H_bat_pack;
  // ADD dropdown menu for selecting chemistry type
  // Coefficients for open-circuit voltage calculation
  // LFP
  parameter Modelica.Units.SI.Voltage V_chem_max = 3.65;
  Real a1 = 3.25;
  Real b1 = -1e-4;
  Real c1 = -0.08;
  Real d1 = 0.07;
  Real e1 = -0.02;
  Real f1 = -0.01;
  Real g1 = -0.06;
  Real h1 = -0.02;
  Real i1 = -0.002;
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {146, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-146, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {-70, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-146, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = C_bat_pack * 3600) annotation(
    Placement(visible = true, transformation(origin = {39, -82}, extent = {{-19, -10}, {19, 10}}, rotation = 0)));
  VirtualFCS.Control.ChargeCounter chargeCounter annotation(
    Placement(visible = true, transformation(origin = {108, -58}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = heatTransferCoefficient * A_cool_bat_pack) annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatBoundary annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * A_cool_bat_pack) annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
protected 
  parameter Modelica.Units.SI.Resistance R_O = 0.024 "Ohmic Resistance";
  parameter Modelica.Units.SI.Resistance R1_0 = 0.0006 "First RC Resistance";
  parameter Modelica.Units.SI.Resistance R2_0 = 0.008 "Second RC Resistance";
  parameter Modelica.Units.SI.Capacitance C1_0 = 5700 "First RC Capacitance";
  parameter Modelica.Units.SI.Capacitance C2_0 = 54300 "Second RC Capacitance";
  parameter Modelica.Units.SI.Area A_cool_bat_pack = L_bat_pack * W_bat_pack;
equation
// ***DEFINE EQUATIONS ***//
// Calculate the open-circuit voltage at given temperature and state of charge
  OCV.v = V_max_bat_pack * (a1 + b1 * (20 - (heatPort.T - 273.15)) * 1 / chargeCounter.SOC + c1 / sqrt(chargeCounter.SOC) + d1 * chargeCounter.SOC + e1 * log(chargeCounter.SOC) + f1 * log(1.01 - chargeCounter.SOC) + g1 * log(1.001 - chargeCounter.SOC) + h1 * exp(i1 * (heatPort.T - 273.15))) / V_chem_max;
// Thermal equations
  heatSource.Q_flow = abs((OCV.v - pin_p.v) * sensorCurrent.i);
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
    Line(points = {{20, 40}, {20, 40}, {20, -58}, {72, -58}, {72, -58}}, color = {0, 0, 127}));
  connect(getSOC_init.y, chargeCounter.SOC_init) annotation(
    Line(points = {{60, -34}, {68, -34}, {68, -34}, {72, -34}}, color = {0, 0, 127}));
  connect(getChargeCapacity.y, chargeCounter.chargeCapacity) annotation(
    Line(points = {{60, -82}, {70, -82}, {70, -82}, {72, -82}}, color = {0, 0, 127}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{-70, 0}, {-70, -22}}, color = {191, 0, 0}));
  connect(heatSource.port, heatCapacitor.port) annotation(
    Line(points = {{-110, 0}, {-70, 0}}, color = {191, 0, 0}));
  connect(pin_n, ground.p) annotation(
    Line(points = {{-146, 52}, {-146, 40}}, color = {0, 0, 255}));
  connect(convection.Gc, setConvectiveCoefficient.y) annotation(
    Line(points = {{-40, -50}, {-26, -50}, {-26, -50}, {-26, -50}}, color = {0, 0, 127}));
  connect(heatPort, convection.solid) annotation(
    Line(points = {{-70, -22}, {-70, -22}, {-70, -34}, {-50, -34}, {-50, -40}, {-50, -40}}, color = {191, 0, 0}));
  connect(heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{-70, -22}, {-70, -22}, {-70, -34}, {-90, -34}, {-90, -40}, {-90, -40}}, color = {191, 0, 0}));
  connect(bodyRadiation.port_b, heatBoundary) annotation(
    Line(points = {{-90, -60}, {-90, -60}, {-90, -66}, {-70, -66}, {-70, -80}, {-70, -80}}, color = {191, 0, 0}));
  connect(convection.fluid, heatBoundary) annotation(
    Line(points = {{-50, -60}, {-50, -60}, {-50, -66}, {-70, -66}, {-70, -80}, {-70, -80}}, color = {191, 0, 0}));
  connect(R2.n, sensorCurrent.p) annotation(
    Line(points = {{-4, 52}, {10, 52}, {10, 52}, {10, 52}}, color = {0, 0, 255}));
  connect(sensorCurrent.n, pin_p) annotation(
    Line(points = {{32, 52}, {148, 52}, {148, 50}, {146, 50}}, color = {0, 0, 255}));
  connect(OCV.p, R_ohmic.p) annotation(
    Line(points = {{-110, 52}, {-100, 52}}, color = {0, 0, 255}));
  connect(R_ohmic.n, R1.p) annotation(
    Line(points = {{-80, 52}, {-60, 52}}, color = {0, 0, 255}));
protected
  annotation(
    Icon(graphics = {Rectangle(origin = {0, -15}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-130, 85}, {130, -75}}), Rectangle(origin = {0, 85}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-150, 15}, {150, -15}}), Text(origin = {68, 93}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {10, -19}}, textString = "+"), Text(origin = {-74, 105}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {52, -41}}, textString = "-"), Text(origin = {-34, -103}, lineColor = {0, 0, 255}, extent = {{-22, 15}, {86, -41}}, textString = "%name")}, coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    Diagram(coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    version = "",
    Documentation(info = "<html><head></head><body><div><font face=\"Arial\">This model describes a lithium-ion battery pack as a lumped version of the&nbsp;<a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonCell\">LiIonCell model</a>. The primary difference is that the open-circuit voltage (OCV) is scaled by the number of cells in series in the stack, estimated as the battery pack maximum voltage divided by the maximum voltage of a single cell (</font><i style=\"font-size: 12px;\">V<sub>max,bat pack</sub></i><span style=\"font-size: 12px;\">/</span><i style=\"font-size: 12px;\">V<sub>chem,max</sub></i><span style=\"font-family: Arial;\">).</span></div><div><font face=\"Arial\"><br></font></div><div><font face=\"Arial\">The model includes a <a href=\"modelica://VirtualFCS.Control.ChargeCounter\">ChargeCounter</a> block to keep track of the state of charge (SOC) of the battery.</font></div><div>




<font face=\"Arial\"><br>
The equation for open-circuit voltage as a function of temperature and state of charge is taken from Vichard&nbsp;<i>et al.</i>&nbsp;[1], and is parameterized to the LFP chemistry by default.</font></div><div><br></div><div>The battery pack is assumed to have a uniform temperature with a thermal mass based on its heat capacity, Cp, and mass m_bat_pack. The heat generated from passing current through the battery is calculated according to the <i>Heat Generation</i>&nbsp;equation below. Heat is assumed to enter or leave the battery via convection and radiation on an area equivalent to the bottom wall of the pack. The ambient temperature is determined by the connection to the heatBoundary.</div><div><font face=\"Arial\"><br>

</font><table border=\"0.9\">
<caption align=\"Left\" style=\"text-align: left;\"> <b><u><font face=\"Arial\">Default Parameters</font></u></b></caption>
<tbody><tr><th><font face=\"Arial\">Parameter name</font></th>
            <th><font face=\"Arial\">Value</font></th>
            <th><font face=\"Arial\">Unit</font></th>
         </tr><tr>
            <td align=\"Left\"><font face=\"Arial\">m_bat_pack</font></td>
            <td><font face=\"Arial\">=100</font></td>
	      <td align=\"Right\"><font face=\"Arial\">kg<br></font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">L_bat_pack</font></td>
            <td><font face=\"Arial\">=0.6</font></td>
            <td align=\"Right\"><font face=\"Arial\">m</font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">W_bat_pack</font></td>
            <td><font face=\"Arial\">=0.45</font></td>
            <td align=\"Right\"><font face=\"Arial\">m</font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">H_bat_pack</font></td>
            <td><font face=\"Arial\">=0.1</font></td>
            <td align=\"Right\"><font face=\"Arial\">m</font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">Cp</font></td>
            <td><font face=\"Arial\">=1000</font></td>
            <td align=\"Right\"><font face=\"Arial\">J/(kg.K)</font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">V_min_bat_pack</font></td>
            <td><font face=\"Arial\">=37.5</font></td>
            <td align=\"Right\"><font face=\"Arial\">V</font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">V_nom_bat_pack</font></td>
            <td><font face=\"Arial\">=48</font></td>
            <td align=\"Right\"><font face=\"Arial\">V</font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">V_max_bat_pack</font></td>
            <td><font face=\"Arial\">=54.75</font></td>
            <td align=\"Right\"><font face=\"Arial\">V</font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">C_bat_pack</font></td>
            <td><font face=\"Arial\">=200</font></td>
            <td align=\"Right\"><font face=\"Arial\">Ah</font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">SOC_init</font></td>
            <td><font face=\"Arial\">=0.5</font></td>
            <td align=\"Right\"><font face=\"Arial\">-</font></td>
         </tr>
         <tr>
            <td align=\"Left\"><font face=\"Arial\">V_chem_max</font></td>
            <td><font face=\"Arial\">=3.65</font></td>
            <td align=\"Right\"><font face=\"Arial\">V<br></font></td>
         </tr>
      </tbody></table><font face=\"Arial\"><br></font><table border=\"0.9\"><caption align=\"Left\" style=\"text-align: left;\"><b><u><font face=\"Arial\">Default Equivalent Circuit Parameters</font></u></b></caption><tbody><tr><th><font face=\"Arial\">Parameter name</font></th><th><font face=\"Arial\">Value</font></th><th><font face=\"Arial\">Unit</font></th></tr><tr><td align=\"Left\"><font face=\"Arial\">R_0</font></td><td><font face=\"Arial\">=0.02</font></td><td align=\"Right\"><font face=\"Arial\">Ohm</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\">R_1</font></td><td><font face=\"Arial\">=0.01</font></td><td align=\"Right\"><font face=\"Arial\">Ohm</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\">R_2</font></td><td><font face=\"Arial\">=0.005</font></td><td align=\"Right\"><font face=\"Arial\">Ohm</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\">C_1</font></td><td><font face=\"Arial\">=5000</font></td><td align=\"Right\"><font face=\"Arial\">F</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\">C_2</font></td><td><font face=\"Arial\">=20000</font></td><td align=\"Right\"><font face=\"Arial\">F<br><br></font></td></tr></tbody></table><table border=\"0.9\"><caption align=\"Left\" style=\"text-align: left;\"><b><u>Default Thermal Parameters</u></b></caption><tbody><tr><th>Parameter name</th><th>Value</th><th>Unit</th></tr><tr><td align=\"Left\"><span style=\"font-family: Arial;\">Cp</span></td><td>=1000</td><td align=\"Right\">J/(kg*K)</td></tr><tr><td align=\"Left\">A_cool_bat_pack<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span></td><td>=L_bat_pack*W_bat_pack</td><td align=\"Right\">m<sup>2<br></sup></td></tr><tr><td align=\"Left\">heatTransferCoefficient<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span></td><td>=7.8*10^0.78</td><td align=\"Right\">W/(m<sup>2</sup>*K)</td></tr></tbody></table><br><div style=\"font-size: 12px;\"><b><u>Equations</u></b></div><div style=\"font-size: 12px;\"><u><i>Open-Circuit Voltage</i></u></div><div style=\"font-size: 12px;\">OCV =&nbsp;[<i>A<sub>1</sub></i>&nbsp;+&nbsp;<i>B<sub>1</sub>*</i>(20&nbsp;<span style=\"color: rgb(51, 51, 51); font-family: monospace; orphans: 2; text-align: center; widows: 2; background-color: rgb(255, 255, 255);\">°</span>C&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; font-size: medium; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;<i>T &nbsp;</i><span style=\"color: rgb(51, 51, 51); font-family: monospace; orphans: 2; text-align: center; widows: 2; background-color: rgb(255, 255, 255);\">°</span>C)/<i>SOC</i>&nbsp;+&nbsp;<i>C<sub>1</sub></i>/sqrt(<i>SOC</i>) +&nbsp;<i>D<sub>1</sub></i>*<i>SOC</i>&nbsp;+&nbsp;<i>E<sub>1</sub></i>*ln(<i>SOC</i>) +&nbsp;<i>F<sub>1</sub></i>*ln(1.01&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; font-size: medium; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;<i>SOC</i>) +&nbsp;<i>G<sub>1</sub></i>*ln(1.001&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; font-size: medium; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;<i>SOC</i>) +&nbsp;<i>H<sub>1</sub></i>*exp(<i>I<sub>1</sub>*</i>(<i>T</i>&nbsp;<span style=\"color: rgb(51, 51, 51); font-family: monospace; orphans: 2; text-align: center; widows: 2; background-color: rgb(255, 255, 255);\">°</span>C))]*(<i>V<sub>max,bat pack</sub></i>/<i>V<sub>chem,max</sub></i>)</div><div style=\"font-size: 12px;\"><pre style=\"margin-top: 0px; margin-bottom: 0px;\"></pre></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">The coefficients for&nbsp;<i>A</i><sub><i>1</i></sub>&nbsp;through&nbsp;<i>I<sub>1</sub></i>&nbsp;are taken from [1] for LFP batteries.</div></div><div><br></div><div><i><u>Battery Temperature</u></i></div><div>m*C<sub>p</sub> dT/dt = Q<sub>flow</sub> +&nbsp;Q<sub>conv&nbsp;</sub>+&nbsp;Q<sub>rad</sub></div><div><br></div><div><i><u>Heat Generation</u></i></div><div>Q<sub>flow</sub> = (OCV&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;V<sub>pin,p</sub>)*I</div><div><br></div><div><i><u>Convective Heat Transfer</u></i></div><div>Q<sub>conv</sub> = hA<sub>cool</sub>(T&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;T<sub>0</sub>); h = 47 W m<sup><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>2</sup> K<sup><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>1</sup></div><div><br></div><div><div><i><u>Radiative Heat Transfer</u></i></div><div>Q<sub>rad</sub>&nbsp;= 0.95A<sub>cool</sub><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">σ</span>(T<sup>4</sup>&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;(T<sub>0</sub>)<sup>4</sup>)</div></div><div><br></div><div><br></div><div><div><b><u><font face=\"Arial\">References</font></u></b></div><div><div class=\"csl-bib-body\" style=\"line-height: 2;\"><div class=\"csl-entry\" style=\"clear: left;\"><div class=\"csl-left-margin\" style=\"float: left; padding-right: 0.5em; text-align: right; width: 1em;\"><font face=\"Arial\">1.</font></div><div class=\"csl-right-inline\" style=\"margin: 0px 0.4em 0px 1.5em;\"><font face=\"Arial\">Vichard, L.&nbsp;<i>et al.</i>&nbsp;A method to estimate battery SOH indicators based on vehicle operating data only.&nbsp;<i>Energy</i>&nbsp;<b>225</b>, 120235 (2021).</font></div></div></div></div></div></body></html>"));
end LiIonBatteryPack_Lumped;
