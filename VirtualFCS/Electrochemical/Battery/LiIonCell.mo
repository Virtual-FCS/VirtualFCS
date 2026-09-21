within VirtualFCS.Electrochemical.Battery;

model LiIonCell "An equivalent circuit model for a Li-ion battery cell."
  // DECLARE PARAMETERS //
  import Modelica.Blocks.Tables.CombiTable1Ds;
  import Modelica.Utilities.Files.loadResource;
  // Physical parameters
  parameter Modelica.Units.SI.Mass mass = 0.08 "Mass of the cell";
  parameter Modelica.Units.SI.Area coolingArea = 0.00143 "Surface area for cooling";
  parameter Modelica.Units.SI.SpecificHeatCapacity specificHeatCapacity = 1000 "Specific Heat Capacity";
  // Pack design parameters
  parameter Real SOC_init(unit = "1") = 0.5 "Initial State of Charge";
  parameter Modelica.Units.NonSI.ElectricCharge_Ah chargeCapacity = 2.6 "Battery Cell Capacity";
  //  Modelica.Units.SI.Resistance R_O "Ohmic Resistance";
  //  Modelica.Units.SI.Resistance R1_0 "First RC Resistance";
  //  Modelica.Units.SI.Resistance R2_0 "Second RC Resistance";
  //  Modelica.Units.SI.Capacitance C1_0 "First RC Capacitance";
  //  Modelica.Units.SI.Capacitance C2_0 "Second RC Capacitance";
  // DECLARE VARIABLES //
  // Coefficients for open-circuit voltage calculation
  // LFP Ref https://www.mdpi.com/1996-1073/9/11/900
  Modelica.Units.SI.Voltage a1 = 3.135;
  Real b1 = -0.685;
  // Should be V/degC
  Modelica.Units.SI.Voltage c1 = -1.342;
  Modelica.Units.SI.Voltage d1 = 1.734;
  Real m1 = 0.478;
  Real n1 = 0.4;
  // INSTANTIATE COMPONENTS //
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {154, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {107, 1}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-154, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-93, -1}, extent = {{7, -7}, {-7, 7}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.SignalVoltage OCV annotation(
    Placement(visible = true, transformation(origin = {-120, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Units.SI.Power P_bat;
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = chargeCapacity*3600) annotation(
    Placement(visible = true, transformation(origin = {39, -82}, extent = {{-19, -10}, {19, 10}}, rotation = 0)));
  VirtualFCS.Control.ChargeCounter chargeCounter(chargeCapacity_Cou = chargeCapacity) annotation(
    Placement(visible = true, transformation(origin = {108, -58}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = SOC_init) annotation(
    Placement(visible = true, transformation(origin = {42, -34}, extent = {{-16, -10}, {16, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor sensorCurrent annotation(
    Placement(visible = true, transformation(origin = {20, 52}, extent = {{11, 11}, {-11, -11}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatSource annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = specificHeatCapacity*mass) annotation(
    Placement(visible = true, transformation(origin = {-50, -28}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {-50, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.VariableResistor R1 annotation(
    Placement(transformation(extent = {{-56, 62}, {-36, 42}})));
  Modelica.Electrical.Analog.Basic.VariableResistor R2 annotation(
    Placement(transformation(extent = {{-22, 62}, {-2, 42}})));
  Modelica.Electrical.Analog.Basic.VariableResistor R_ohm annotation(
    Placement(transformation(extent = {{-92, 62}, {-72, 42}})));
  Modelica.Electrical.Analog.Basic.VariableCapacitor C1 annotation(
    Placement(transformation(extent = {{-58, 66}, {-38, 86}})));
  Modelica.Electrical.Analog.Basic.VariableCapacitor C2 annotation(
    Placement(transformation(extent = {{-24, 66}, {-4, 86}})));
  Modelica.Blocks.Tables.CombiTable1Ds InputR0(tableOnFile = true, tableName = "SOCR0", fileName = ModelicaServices.ExternalReferences.loadResource("modelica://VirtualFCS/Resources/LFPBatParameters/LFP_SOCR0.mat"), verboseRead = false, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(transformation(extent = {{-116, 22}, {-96, 42}})));
  CombiTable1Ds InputR1(tableOnFile = true, tableName = "SOCR1", fileName = ModelicaServices.ExternalReferences.loadResource("modelica://VirtualFCS/Resources/LFPBatParameters/LFP_SOCR1.mat"), verboseRead = false, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(transformation(extent = {{-72, 22}, {-52, 42}})));
  CombiTable1Ds InputR2(tableOnFile = true, tableName = "SOCR2", fileName = ModelicaServices.ExternalReferences.loadResource("modelica://VirtualFCS/Resources/LFPBatParameters/LFP_SOCR2.mat"), verboseRead = false, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(transformation(extent = {{-38, 22}, {-18, 42}})));
  CombiTable1Ds InputC1(tableOnFile = true, tableName = "SOCC1", fileName = ModelicaServices.ExternalReferences.loadResource("modelica://VirtualFCS/Resources/LFPBatParameters/LFP_SOCC1.mat"), verboseRead = false, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(transformation(extent = {{-88, 78}, {-68, 98}})));
  CombiTable1Ds InputC2(tableOnFile = true, tableName = "SOCC2", fileName = ModelicaServices.ExternalReferences.loadResource("modelica://VirtualFCS/Resources/LFPBatParameters/LFP_SOCC2.mat"), verboseRead = false, smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation(
    Placement(transformation(extent = {{20, 80}, {0, 100}})));
equation
// DEFINE EQUATIONS //
//OCV-SOC relation Ref: https://www.mdpi.com/1996-1073/9/11/900
  OCV.v = a1 + b1*(-log(chargeCounter.SOC))^m1 + c1*chargeCounter.SOC + d1*exp(n1*(chargeCounter.SOC - 1));
// Thermal
  heatSource.Q_flow = abs((OCV.v - pin_p.v)*abs(sensorCurrent.i));
//Power
  P_bat = pin_p.v*sensorCurrent.i;
// DEFINE CONNECTIONS //
  connect(OCV.n, pin_n) annotation(
    Line(points = {{-130, 52}, {-154, 52}}, color = {0, 0, 255}));
  connect(getSOC_init.y, chargeCounter.SOC_init) annotation(
    Line(points = {{59.6, -34}, {72, -34}}, color = {0, 0, 127}));
  connect(getChargeCapacity.y, chargeCounter.chargeCapacity) annotation(
    Line(points = {{59.9, -82}, {72, -82}}, color = {0, 0, 127}));
  connect(sensorCurrent.n, pin_p) annotation(
    Line(points = {{31, 52}, {154, 52}, {154, 52}, {154, 52}}, color = {0, 0, 255}));
  connect(sensorCurrent.i, chargeCounter.electricCurrent) annotation(
    Line(points = {{20, 39.9}, {20, 39.9}, {20, -58}, {72, -58}, {72, -58}}, color = {0, 0, 127}));
  connect(heatSource.port, heatCapacitor.port) annotation(
    Line(points = {{-120, -40}, {-50, -40}, {-50, -40}, {-50, -40}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{-50, -40}, {-50, -40}, {-50, -94}, {-50, -94}}, color = {191, 0, 0}));
  connect(R_ohm.n, R1.p) annotation(
    Line(points = {{-72, 52}, {-56, 52}}, color = {0, 0, 255}));
  connect(R_ohm.p, OCV.p) annotation(
    Line(points = {{-92, 52}, {-110, 52}}, color = {0, 0, 255}));
  connect(R2.p, R1.n) annotation(
    Line(points = {{-22, 52}, {-36, 52}}, color = {0, 0, 255}));
  connect(R2.n, sensorCurrent.p) annotation(
    Line(points = {{-2, 52}, {9, 52}}, color = {0, 0, 255}));
  connect(C1.p, R1.p) annotation(
    Line(points = {{-58, 76}, {-58, 52}, {-56, 52}}, color = {0, 0, 255}));
  connect(C1.n, R1.n) annotation(
    Line(points = {{-38, 76}, {-32, 76}, {-32, 52}, {-36, 52}}, color = {0, 0, 255}));
  connect(C2.n, R2.n) annotation(
    Line(points = {{-4, 76}, {-2, 76}, {-2, 52}}, color = {0, 0, 255}));
  connect(R2.p, C2.p) annotation(
    Line(points = {{-22, 52}, {-24, 52}, {-24, 76}}, color = {0, 0, 255}));
  connect(InputR0.y[1], R_ohm.R) annotation(
    Line(points = {{-95, 32}, {-82, 32}, {-82, 40}}, color = {0, 0, 127}));
  connect(chargeCounter.SOC, InputR0.u) annotation(
    Line(points = {{141, -58}, {150, -58}, {150, -98}, {6, -98}, {6, 10}, {-122, 10}, {-122, 32}, {-118, 32}}, color = {0, 0, 127}));
  connect(R1.R, InputR1.y[1]) annotation(
    Line(points = {{-46, 40}, {-46, 36}, {-51, 36}, {-51, 32}}, color = {0, 0, 127}));
  connect(R2.R, InputR2.y[1]) annotation(
    Line(points = {{-12, 40}, {-12, 36}, {-17, 36}, {-17, 32}}, color = {0, 0, 127}));
  connect(C1.C, InputC1.y[1]) annotation(
    Line(points = {{-48, 88}, {-67, 88}}, color = {0, 0, 127}));
  connect(C2.C, InputC2.y[1]) annotation(
    Line(points = {{-14, 88}, {-14, 90}, {-1, 90}}, color = {0, 0, 127}));
  connect(chargeCounter.SOC, InputC2.u) annotation(
    Line(points = {{141, -58}, {168, -58}, {168, 90}, {22, 90}}, color = {0, 0, 127}));
  connect(InputR1.u, InputR0.u) annotation(
    Line(points = {{-74, 32}, {-80, 32}, {-80, 10}, {-122, 10}, {-122, 32}, {-118, 32}}, color = {0, 0, 127}));
  connect(InputR2.u, InputR0.u) annotation(
    Line(points = {{-40, 32}, {-44, 32}, {-44, 10}, {-122, 10}, {-122, 32}, {-118, 32}}, color = {0, 0, 127}));
  connect(InputC1.u, InputR0.u) annotation(
    Line(points = {{-90, 88}, {-180, 88}, {-180, 10}, {-122, 10}, {-122, 32}, {-118, 32}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(origin = {4, -9}, fillColor = {85, 170, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-104, 49}, {96, -31}}), Rectangle(origin = {104, 4}, fillColor = {200, 200, 200}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-4, 20}, {10, -28}}), Text(origin = {-19, 70}, lineColor = {0, 0, 255}, extent = {{-37, 18}, {57, -32}}, textString = "%name"), Text(origin = {-79, 10}, lineColor = {255, 255, 255}, extent = {{-37, 18}, {57, -32}}, textString = "-"), Text(origin = {87, 2}, lineColor = {255, 255, 255}, extent = {{-37, 18}, {31, -16}}, textString = "+")}, coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>mass</code></td><td>Modelica.Units.SI.Mass</td><td>kg</td><td>0.08</td><td>Mass of the cell</td></tr>
<tr><td><code>coolingArea</code></td><td>Modelica.Units.SI.Area</td><td>m2</td><td>0.00143</td><td>Surface area for cooling</td></tr>
<tr><td><code>specificHeatCapacity</code></td><td>Modelica.Units.SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>1000</td><td>Specific Heat Capacity</td></tr>
<tr><td><code>SOC_init</code></td><td>Real</td><td>1</td><td></td><td>1</td></tr>
<tr><td><code>chargeCapacity</code></td><td>Modelica.Units.NonSI.ElectricCharge_Ah</td><td>Ah</td><td>2.6</td><td>Battery Cell Capacity</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_p</code></td><td>Input-side interface</td><td>PositivePin</td><td>-</td><td></td></tr>
<tr><td><code>heatPort</code></td><td>Input-side interface</td><td>HeatPort_a</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2>The LiIonCell class implements a simple 2RC equivalent circuit model for a lithium-ion battery cell. This circuit simulates the impedance due to electrochemical reactions and the internal resistance of a lithium ion cell. The model comes pre-programmed with default parameters for lithium iron phosphate (LFP) battery cells.<div>
<div><font face=\"&quot;Arial&quot;\"><br></font></div><div><font face=\"&quot;Arial&quot;\">The model includes a <a href=\"&quot;modelica://VirtualFCS.Control.ChargeCounter&quot;\">ChargeCounter</a> block to keep track of the state of charge (SOC) of the battery via a charge-counting method.</font></div>
<div><div><br></div><div>The equation for open-circuit voltage as a function of temperature and state of charge is taken from Vichard <i>et al.</i> [1], and is parameterized to the LFP chemistry by default.</div><div>

<br>
<span style=\"&quot;font-size:\" 12px;&quot;=\"\">The battery pack is assumed to have a uniform temperature with a thermal mass based on its heat capacity, Cp, and mass m_bat_pack. The heat generated from passing current through the battery is calculated according to the&nbsp;</span><i style=\"&quot;font-size:\" 12px;&quot;=\"\">Heat Generation</i><span style=\"&quot;font-size:\" 12px;&quot;=\"\">&nbsp;equation below. The provided heatPort allows connection to cooling systems or other relevant temperature boundary conditions.</span></div></div></div><div><br></div><div><b><u>References</u></b></div><div><!--StartFragment--><div class=\"&quot;csl-bib-body&quot;\" style=\"&quot;line-height:\" 2;=\"\" &quot;=\"\">
  <div class=\"&quot;csl-entry&quot;\" style=\"&quot;clear:\" left;=\"\" &quot;=\"\">
    <div class=\"&quot;csl-left-margin&quot;\" style=\"&quot;float:\" left;=\"\" padding-right:=\"\" 0.5em;text-align:=\"\" right;=\"\" width:=\"\" 1em;&quot;=\"\">1. Vichard, L. <i>et al.</i> A method to estimate battery SOH indicators based on vehicle operating data only. <i>Energy</i> <b>225</b>, 120235 (2021).</div>
  </div>
  <span class=\"&quot;Z3988&quot;\" title=\"&quot;url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fzotero.org%3A2&amp;rft_id=info%3Adoi%2F10.1016%2Fj.energy.2021.120235&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=A%20method%20to%20estimate%20battery%20SOH%20indicators%20based%20on%20vehicle%20operating%20data%20only&amp;rft.jtitle=Energy&amp;rft.stitle=Energy&amp;rft.volume=225&amp;rft.aufirst=L.&amp;rft.aulast=Vichard&amp;rft.au=L.%20Vichard&amp;rft.au=A.%20Ravey&amp;rft.au=P.%20Venet&amp;rft.au=F.%20Harel&amp;rft.au=S.%20Pelissier&amp;rft.au=D.%20Hissel&amp;rft.date=2021-06-15&amp;rft.pages=120235&amp;rft.issn=0360-5442&amp;rft.language=en&quot;\"></span>
</div><!--EndFragment--></div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>OCV.v = a1 + b1 * (-log(chargeCounter.SOC))^m1 + c1*chargeCounter.SOC + d1*exp(n1*(chargeCounter.SOC -1));
heatSource.Q_flow = abs((OCV.v - pin_p.v) * abs(sensorCurrent.i));
P_bat= pin_p.v * sensorCurrent.i;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_n</code></td><td>Output-side interface</td><td>NegativePin</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end LiIonCell;
