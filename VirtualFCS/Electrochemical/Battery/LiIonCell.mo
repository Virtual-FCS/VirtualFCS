within VirtualFCS.Electrochemical.Battery;

model LiIonCell
  // DECLARE PARAMETERS //
  // Physical parameters
  parameter Real mass(unit = "kg") = 0.045 "Mass of the pack";
  parameter Real coolingArea(unit = "m2") = 0.003675 "Surface area for cooling";
  //  parameter Real vol(unit = "L") = 0.016 "Volume of the pack";
  parameter Real specificHeatCapacity(unit = "J/(kg.K)") = 1000 "Specific Heat Capacity";
  // Pack design parameters
  parameter Real SOC_init(unit = "1") = 0.5 "Initial State of Charge";
  parameter Real chargeCapacity(unit = "Ah") = 2.2 "Battery Cell Capacity";
  parameter Real Rohm_0(unit = "Ohm") = 0.02 "Ohmic Resistance";
  parameter Real R1_0(unit = "Ohm") = 0.01 "First RC Resistance";
  parameter Real R2_0(unit = "Ohm") = 0.005 "Second RC Resistance";
  parameter Real C1_0(unit = "F") = 5000 "First RC Capacitance";
  parameter Real C2_0(unit = "F") = 20000 "Second RC Capacitance";
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
  Modelica.Electrical.Analog.Basic.Resistor R0(R = Rohm_0, T_ref = 300.15, useHeatPort = false) annotation(
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
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = specificHeatCapacity * mass)  annotation(
    Placement(visible = true, transformation(origin = {-50, -28}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {-50, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// DEFINE EQUATIONS //
  OCV.v = a1 + b1 * (20 - (heatPort.T - 273.15)) * 1 / chargeCounter.SOC + c1 / sqrt(chargeCounter.SOC) + d1 * chargeCounter.SOC + e1 * log(chargeCounter.SOC) + f1 * log(1.01 - chargeCounter.SOC) + g1 * log(1.001 - chargeCounter.SOC) + h1 * exp(i1 * (heatPort.T - 273.15));
// Thermal equations
  heatSource.Q_flow = abs((OCV.v - pin_p.v) * R0.i + R0.R_actual * R0.i ^ 2);
// DEFINE CONNECTIONS //
  connect(C2.n, R2.n) annotation(
    Line(points = {{-4, 76}, {-4, 52}}, color = {0, 0, 255}));
  connect(R1.n, R2.p) annotation(
    Line(points = {{-40, 52}, {-24, 52}}, color = {0, 0, 255}));
  connect(R2.p, C2.p) annotation(
    Line(points = {{-24, 52}, {-24, 76}}, color = {0, 0, 255}));
  connect(R0.n, R1.p) annotation(
    Line(points = {{-78, 52}, {-60, 52}}, color = {0, 0, 255}));
  connect(C1.n, R1.n) annotation(
    Line(points = {{-40, 76}, {-40, 52}}, color = {0, 0, 255}));
  connect(C1.p, R1.p) annotation(
    Line(points = {{-60, 76}, {-60, 52}}, color = {0, 0, 255}));
  connect(OCV.p, R0.p) annotation(
    Line(points = {{-110, 52}, {-98, 52}}, color = {0, 0, 255}));
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
  annotation(
    Icon(graphics = {Rectangle(origin = {4, -9}, fillColor = {85, 170, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-104, 49}, {96, -31}}), Rectangle(origin = {104, 4}, fillColor = {200, 200, 200}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-4, 20}, {10, -28}}), Text(origin = {-19, 70}, lineColor = {0, 0, 255}, extent = {{-37, 18}, {57, -32}}, textString = "%name"), Text(origin = {-79, 10}, lineColor = {255, 255, 255}, extent = {{-37, 18}, {57, -32}}, textString = "-"), Text(origin = {87, 2}, lineColor = {255, 255, 255}, extent = {{-37, 18}, {31, -16}}, textString = "+")}, coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The LiIonCell class implements a simple 2RC equivalent circuit model for a lithium-ion battery cell. This circuit simulates the internal electrochemical reaction of a lithium ion cell.<div><div><br></div><div><div><b>Default Battery Parameters</b></div></div><div>chemistry <span class=\"Apple-tab-span\" style=\"white-space:pre\">			</span>=&nbsp;LFP-Graphite</div><div>format&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">			</span>= 18650 Cylindrical</div><div>mass <span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>=&nbsp;45 g</div><div>chargeCapacity <span class=\"Apple-tab-span\" style=\"white-space:pre\">		</span>= 2.2 Ah</div><div><br></div><div><div><b>Default Equivalent Circuit Parameters</b></div><div>R0 = 20 mOhm</div><div>R1 = 10 mOhm</div><div>R2 = 5 mOhm</div><div>C1 = 5000 F</div><div>C2 = 20000 F</div><div><br></div><div><b>Default Thermal Parameters</b></div><div>specificHeatCapacity&nbsp;<span class=\"Apple-tab-span\" style=\"white-space: pre;\">	</span>= 1000 J/(kg*K)</div><div>surfaceEmissivity &nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>= 0.95</div><div>coolingArea&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">		</span>= 0.003675 m2</div><div><br></div><div><div><div><b>References</b></div></div></div></div><div>[1] Vichard et al. A method to estimate battery SOH indicators based on vehicles operating data only, Energy, vol. 225, 15 June 2021, 120235.</div><div><br></div><div>[2] Shen et al. The Co-estimation of State of Charge, State of Health, and State of Function for Lithium-Ion Batteries in Electric Vehicles, IEEE Transactions on Vehicular Technology, vol. 67, no. 1, January 2018.</div><div><br></div><div>[3] Lievre et al. Practical Online Estimation of Lithium-Ion Battery Apparent Series Resistance for Mild Hybrid Vehicles, IEEE Transactions on Vehicular Technology, vol. 65, no. 6, June 2016.</div></div></body></html>"));
end LiIonCell;
