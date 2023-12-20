within VirtualFCS.Electrochemical.Battery;

model LiIonCell "An equivalent circuit model for a Li-ion battery cell."
  // DECLARE PARAMETERS //
  // Physical parameters
  parameter Modelica.Units.SI.Mass mass = 0.045 "Mass of the cell";
  parameter Modelica.Units.SI.Area coolingArea = 0.003675 "Surface area for cooling";
  parameter Modelica.Units.SI.SpecificHeatCapacity specificHeatCapacity = 1000 "Specific Heat Capacity";
  // Pack design parameters
  parameter Real SOC_init(unit = "1") = 0.5 "Initial State of Charge";
  parameter Modelica.Units.NonSI.ElectricCharge_Ah chargeCapacity = 2.2 "Battery Cell Capacity";
  parameter Modelica.Units.SI.Resistance R_O = 0.02 "Ohmic Resistance";
  parameter Modelica.Units.SI.Resistance R1_0 = 0.01 "First RC Resistance";
  parameter Modelica.Units.SI.Resistance R2_0 = 0.005 "Second RC Resistance";
  parameter Modelica.Units.SI.Capacitance C1_0 = 5000 "First RC Capacitance";
  parameter Modelica.Units.SI.Capacitance C2_0 = 20000 "Second RC Capacitance";
  // DECLARE VARIABLES //
  // Coefficients for open-circuit voltage calculation
  // LFP
  Real a1 = 3.25;
  Real b1 = -1e-4;
  Real c1 = -0.08;
  Real d1 = 0.07;
  Real e1 = -0.02;
  Real f1 = -0.01;
  Real g1 = -0.06;
  Real h1 = -0.02;
  Real i1 = -0.002;
  // INSTANTIATE COMPONENTS //
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {154, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {107, 1}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-154, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-93, -1}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.SignalVoltage OCV annotation(
    Placement(visible = true, transformation(origin = {-120, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R2(R = R2_0, useHeatPort = false) annotation(
    Placement(visible = true, transformation(origin = {-14, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R = R1_0, useHeatPort = false) annotation(
    Placement(visible = true, transformation(origin = {-50, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor C2(C = C2_0, v(fixed = true)) annotation(
    Placement(visible = true, transformation(origin = {-14, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R_ohmic(R = R_O, T_ref = 300.15, useHeatPort = false) annotation(
    Placement(visible = true, transformation(origin = {-88, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor C1(C = C1_0, v(fixed = true)) annotation(
    Placement(visible = true, transformation(origin = {-50, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = chargeCapacity * 3600) annotation(
    Placement(visible = true, transformation(origin = {39, -82}, extent = {{-19, -10}, {19, 10}}, rotation = 0)));
  VirtualFCS.Control.ChargeCounter chargeCounter annotation(
    Placement(visible = true, transformation(origin = {108, -58}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = SOC_init) annotation(
    Placement(visible = true, transformation(origin = {42, -34}, extent = {{-16, -10}, {16, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor sensorCurrent annotation(
    Placement(visible = true, transformation(origin = {20, 52}, extent = {{11, 11}, {-11, -11}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatSource annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = specificHeatCapacity * mass) annotation(
    Placement(visible = true, transformation(origin = {-50, -28}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {-50, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// DEFINE EQUATIONS //
  OCV.v = a1 + b1 * (20 - (heatPort.T - 273.15)) * 1 / chargeCounter.SOC + c1 / sqrt(chargeCounter.SOC) + d1 * chargeCounter.SOC + e1 * log(chargeCounter.SOC) + f1 * log(1.01 - chargeCounter.SOC) + g1 * log(1.001 - chargeCounter.SOC) + h1 * exp(i1 * (heatPort.T - 273.15));
// Thermal equations
  heatSource.Q_flow = abs((OCV.v - pin_p.v) * abs(sensorCurrent.i));
// DEFINE CONNECTIONS //
  connect(C2.n, R2.n) annotation(
    Line(points = {{-4, 76}, {-4, 52}}, color = {0, 0, 255}));
  connect(R1.n, R2.p) annotation(
    Line(points = {{-40, 52}, {-24, 52}}, color = {0, 0, 255}));
  connect(R2.p, C2.p) annotation(
    Line(points = {{-24, 52}, {-24, 76}}, color = {0, 0, 255}));
  connect(C1.n, R1.n) annotation(
    Line(points = {{-40, 76}, {-40, 52}}, color = {0, 0, 255}));
  connect(C1.p, R1.p) annotation(
    Line(points = {{-60, 76}, {-60, 52}}, color = {0, 0, 255}));
  connect(OCV.n, pin_n) annotation(
    Line(points = {{-130, 52}, {-154, 52}}, color = {0, 0, 255}));
  connect(getSOC_init.y, chargeCounter.SOC_init) annotation(
    Line(points = {{60, -34}, {72, -34}}, color = {0, 0, 127}));
  connect(getChargeCapacity.y, chargeCounter.chargeCapacity) annotation(
    Line(points = {{60, -82}, {72, -82}}, color = {0, 0, 127}));
  connect(R2.n, sensorCurrent.p) annotation(
    Line(points = {{-4, 52}, {10, 52}, {10, 52}, {10, 52}}, color = {0, 0, 255}));
  connect(sensorCurrent.n, pin_p) annotation(
    Line(points = {{32, 52}, {154, 52}, {154, 52}, {154, 52}}, color = {0, 0, 255}));
  connect(sensorCurrent.i, chargeCounter.electricCurrent) annotation(
    Line(points = {{20, 40}, {20, 40}, {20, -58}, {72, -58}, {72, -58}}, color = {0, 0, 127}));
  connect(heatSource.port, heatCapacitor.port) annotation(
    Line(points = {{-120, -40}, {-50, -40}, {-50, -40}, {-50, -40}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{-50, -40}, {-50, -40}, {-50, -94}, {-50, -94}}, color = {191, 0, 0}));
  connect(OCV.p, R_ohmic.p) annotation(
    Line(points = {{-110, 52}, {-98, 52}}, color = {0, 0, 255}));
  connect(R_ohmic.n, R1.p) annotation(
    Line(points = {{-78, 52}, {-60, 52}}, color = {0, 0, 255}));
  annotation(
    Icon(graphics = {Rectangle(origin = {4, -9}, fillColor = {85, 170, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-104, 49}, {96, -31}}), Rectangle(origin = {104, 4}, fillColor = {200, 200, 200}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-4, 20}, {10, -28}}), Text(origin = {-19, 70}, lineColor = {0, 0, 255}, extent = {{-37, 18}, {57, -32}}, textString = "%name"), Text(origin = {-79, 10}, lineColor = {255, 255, 255}, extent = {{-37, 18}, {57, -32}}, textString = "-"), Text(origin = {87, 2}, lineColor = {255, 255, 255}, extent = {{-37, 18}, {31, -16}}, textString = "+")}, coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The LiIonCell class implements a simple 2RC equivalent circuit model for a lithium-ion battery cell. This circuit simulates the impedance due to electrochemical reactions and the internal resistance of a lithium ion cell. The model comes pre-programmed with default parameters for lithium iron phosphate (LFP) battery cells.<div>
<div><font face=\"Arial\"><br></font></div><div><font face=\"Arial\">The model includes a <a href=\"modelica://VirtualFCS.Control.ChargeCounter\">ChargeCounter</a> block to keep track of the state of charge (SOC) of the battery via a charge-counting method.</font></div>
<div><div><br></div><div>The equation for open-circuit voltage as a function of temperature and state of charge is taken from Vichard <i>et al.</i> [1], and is parameterized to the LFP chemistry by default.</div><div>

<br>
<span style=\"font-size: 12px;\">The battery pack is assumed to have a uniform temperature with a thermal mass based on its heat capacity, Cp, and mass m_bat_pack. The heat generated from passing current through the battery is calculated according to the&nbsp;</span><i style=\"font-size: 12px;\">Heat Generation</i><span style=\"font-size: 12px;\">&nbsp;equation below. The provided heatPort allows connection to cooling systems or other relevant temperature boundary conditions.</span><br><br>

<table border=\"0.9\">
<caption align=\"Left\" style=\"text-align: left;\"> <b><u>Default Battery Parameters</u></b></caption>
<tbody><tr><th>Parameter name</th>
            <th align=\"Left\">Value</th>
            <th>Unit</th>
         </tr>
         <tr>
            <td align=\"Left\">Chemistry</td>
            <td>=LFP-Graphite </td>
            <td> -- </td>
         </tr>
         
         <tr>
            <td align=\"Left\">Size</td>
            <td>=18650 Cylindrical</td>
            <td> -- </td>
         </tr>
         <tr>
            <td align=\"Left\">mass</td>
            <td>=0.045</td>
            <td> kg </td>
         </tr>
	   <tr>
            <td align=\"Left\">Charge capacity </td>
            <td>=2.2</td>
            <td> Ah </td>
         </tr>
         </tbody></table>
         
<br>
<br>

<table border=\"0.9\">
<caption align=\"Left\" style=\"text-align: left;\"> <b><u>Default Equivalent Circuit Parameters</u></b></caption>
<tbody><tr><th>Parameter name</th>
            <th>Value</th>
            <th>Unit</th>
         </tr><tr>
            <td align=\"Left\">R_0</td>
            <td>=0.02</td>
	      <td align=\"Right\">Ohm</td>
         </tr>
         <tr>
            <td align=\"Left\">R_1</td>
            <td>=0.01</td>
            <td align=\"Right\">Ohm</td>
         </tr>
         <tr>
            <td align=\"Left\">R_2</td>
            <td>=0.005</td>
            <td align=\"Right\">Ohm</td>
         </tr>
	   <tr>
            <td align=\"Left\">C_1</td>
            <td>=5000</td>
            <td align=\"Right\">F</td>
         </tr>
         <tr>
            <td align=\"Left\">C_2</td>
            <td>=20000</td>
            <td align=\"Right\">F</td>
         </tr>         
      </tbody></table>
<br>
<br>

<table border=\"0.9\">
<caption align=\"Left\" style=\"text-align: left;\"> <b><u>Default Thermal Parameters</u></b></caption>
<tbody><tr><th>Parameter name</th>
            <th>Value</th>
            <th>Unit</th>
         </tr><tr>
            <td align=\"Left\">specificHeatCapacity</td>
            <td>=1000</td>
	      <td align=\"Right\">J/(kg*K)</td>
         </tr>
         <tr>
            <td align=\"Left\">coolingArea</td>
            <td>=0.003675</td>
            <td align=\"Right\">m<sup>2</sup></td>
         </tr>
      </tbody></table><br>

</div></div></div><div><b><u>Equations</u></b></div><div><u><i>Open-Circuit Voltage</i></u></div><div>OCV = <i>A<sub>1</sub></i> + <i>B<sub>1</sub>*</i>(20&nbsp;<span style=\"color: rgb(51, 51, 51); font-family: monospace; orphans: 2; text-align: center; widows: 2; background-color: rgb(255, 255, 255);\">°</span>C - <i>T &nbsp;</i><span style=\"color: rgb(51, 51, 51); font-family: monospace; orphans: 2; text-align: center; widows: 2; background-color: rgb(255, 255, 255);\">°</span>C)/<i>SOC</i> + <i>C<sub>1</sub></i>/sqrt(<i>SOC</i>) + <i>D<sub>1</sub></i>*<i>SOC</i> + <i>E<sub>1</sub></i>*ln(<i>SOC</i>) + <i>F<sub>1</sub></i>*ln(1.01 - <i>SOC</i>) + <i>G<sub>1</sub></i>*ln(1.001 - <i>SOC</i>) + <i>H<sub>1</sub></i>*exp(<i>I<sub>1</sub>*</i>(<i>T</i>&nbsp;<span style=\"color: rgb(51, 51, 51); font-family: monospace; orphans: 2; text-align: center; widows: 2; background-color: rgb(255, 255, 255);\">°</span>C))</div><div><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--EndFragment--></pre></div><div><br></div><div>The coefficients for&nbsp;<i>A</i><sub><i>1</i></sub>&nbsp;through&nbsp;<i>I<sub>1</sub></i>&nbsp;are taken from [1] for LFP batteries.</div><div><br></div><div><div style=\"font-size: 12px;\"><i><u>Battery Temperature</u></i></div><div style=\"font-size: 12px;\">m*C<sub>p</sub>&nbsp;dT/dt = Q<sub>flow</sub></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><i><u>Heat Generation</u></i></div><div style=\"font-size: 12px;\">Q<sub>flow</sub>&nbsp;= (OCV - V<sub>pin,p</sub>)*I</div></div><div><br></div><div><br></div><div><b><u>References</u></b></div><div><!--StartFragment--><div class=\"csl-bib-body\" style=\"line-height: 2; \">
  <div class=\"csl-entry\" style=\"clear: left; \">
    <div class=\"csl-left-margin\" style=\"float: left; padding-right: 0.5em;text-align: right; width: 1em;\">1.</div><div class=\"csl-right-inline\" style=\"margin: 0 .4em 0 1.5em;\">Vichard, L. <i>et al.</i> A method to estimate battery SOH indicators based on vehicle operating data only. <i>Energy</i> <b>225</b>, 120235 (2021).</div>
  </div>
  <span class=\"Z3988\" title=\"url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_id=info%3Adoi%2F10.1016%2Fj.energy.2021.120235&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=A%20method%20to%20estimate%20battery%20SOH%20indicators%20based%20on%20vehicle%20operating%20data%20only&amp;rft.jtitle=Energy&amp;rft.stitle=Energy&amp;rft.volume=225&amp;rft.aufirst=L.&amp;rft.aulast=Vichard&amp;rft.au=L.%20Vichard&amp;rft.au=A.%20Ravey&amp;rft.au=P.%20Venet&amp;rft.au=F.%20Harel&amp;rft.au=S.%20Pelissier&amp;rft.au=D.%20Hissel&amp;rft.date=2021-06-15&amp;rft.pages=120235&amp;rft.issn=0360-5442&amp;rft.language=en\"></span>
</div><!--EndFragment--></div></body></html>"));
end LiIonCell;
