within VirtualFCS.Electrochemical.Battery;

model LiIonBatteryPack_Lumped "A Li-ion battery pack model comprised of a single lumped battery model."
  // DECLARE PARAMETERS //
  // Pack-level parameters
  parameter Real m_bat_pack(unit = "kg") = 100 "Mass of the pack";
  parameter Real L_bat_pack(unit = "m") = 0.6 "Battery pack length";
  parameter Real W_bat_pack(unit = "m") = 0.45 "Battery pack width";
  parameter Real H_bat_pack(unit = "m") = 0.1 "Battery pack height";
  parameter Real Cp_bat_pack(unit = "J/(kg.K)") = 1000 "Specific Heat Capacity";
  parameter Real V_min_bat_pack(unit = "V") = 37.5 "Battery pack minimum voltage";
  parameter Real V_nom_bat_pack(unit = "V") = 48 "Battery pack nominal voltage";
  parameter Real V_max_bat_pack(unit = "V") = 54.75 "Battery pack maximum voltage";
  parameter Real C_bat_pack(unit = "A.h") = 200 "Battery pack nominal capacity";
  parameter Real SOC_init = 0.5 "Battery pack initial state of charge";

  parameter Real N_s = ceil(V_max_bat_pack / V_chem_max);
  Real vol_bat_pack = L_bat_pack * W_bat_pack * H_bat_pack;


  // ADD dropdown menu for selecting chemistry type

  // Coefficients for open-circuit voltage calculation
  // LFP
  parameter Real V_chem_max = 3.65;
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
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = Cp_bat_pack * m_bat_pack) annotation(
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
  Modelica.Electrical.Analog.Basic.Resistor R0(R = Rohm_0, T_ref = 300.15, useHeatPort = false) annotation(
    Placement(visible = true, transformation(origin = {-90, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = SOC_init) annotation(
    Placement(visible = true, transformation(origin = {42, -34}, extent = {{-16, -10}, {16, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = C_bat_pack * 3600) annotation(
    Placement(visible = true, transformation(origin = {39, -82}, extent = {{-19, -10}, {19, 10}}, rotation = 0)));
  VirtualFCS.Control.ChargeCounter chargeCounter annotation(
    Placement(visible = true, transformation(origin = {108, -58}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 7.8 * 10 ^ 0.78 * A_cool_bat_pack) annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatBoundary annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * A_cool_bat_pack) annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

protected
  parameter Real Rohm_0(unit = "Ohm") = 0.02 "Ohmic Resistance";
  parameter Real R1_0(unit = "Ohm") = 0.01 "First RC Resistance";
  parameter Real R2_0(unit = "Ohm") = 0.005 "Second RC Resistance";
  parameter Real C1_0(unit = "F") = 5000 "First RC Capacitance";
  parameter Real C2_0(unit = "F") = 20000 "Second RC Capacitance";
  parameter Real A_cool_bat_pack = L_bat_pack * W_bat_pack;

equation
// ***DEFINE EQUATIONS ***//
// Calculate the open-circuit voltage at given temperature and state of charge
  OCV.v = V_max_bat_pack * (a1 + b1 * (20 - (heatPort.T - 273.15)) * 1 / chargeCounter.SOC + c1 / sqrt(chargeCounter.SOC) + d1 * chargeCounter.SOC + e1 * log(chargeCounter.SOC) + f1 * log(1.01 - chargeCounter.SOC) + g1 * log(1.001 - chargeCounter.SOC) + h1 * exp(i1 * (heatPort.T - 273.15)))/V_chem_max;
// Thermal equations
  heatSource.Q_flow = abs((OCV.v - pin_p.v) * sensorCurrent.i + R0.R_actual * sensorCurrent.i ^ 2);
// ***DEFINE CONNECTIONS ***//
  connect(pin_n, OCV.n) annotation(
    Line(points = {{-146, 52}, {-130, 52}, {-130, 52}, {-130, 52}}, color = {0, 0, 255}));
  connect(OCV.p, R0.p) annotation(
    Line(points = {{-110, 52}, {-100, 52}, {-100, 52}, {-100, 52}}, color = {0, 0, 255}));
  connect(R0.n, R1.p) annotation(
    Line(points = {{-80, 52}, {-60, 52}, {-60, 52}, {-60, 52}}, color = {0, 0, 255}));
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
protected
  annotation(
    Icon(graphics = {Rectangle(origin = {0, -15}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-130, 85}, {130, -75}}), Rectangle(origin = {0, 85}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-150, 15}, {150, -15}}), Text(origin = {68, 93}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {10, -19}}, textString = "+"), Text(origin = {-74, 105}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {52, -41}}, textString = "-"), Text(origin = {-34, -103}, lineColor = {0, 0, 255}, extent = {{-22, 15}, {86, -41}}, textString = "%name")}, coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    version = "",
  Documentation(info = "<html><head></head><body><div>This model describes a lithium-ion battery pack as a lumped of <a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonCell\">LiIonCell model</a>. It simulates the single cell equation and multiplies is by number of cells in series and parallel. This setup has the advantage of low computational time.&nbsp;</div><div>




<br>
<br>

<table border=\"0.9\">
<caption align=\"Left\" style=\"text-align: left;\"> <b><u>Default Parameters</u></b></caption>
<tbody><tr><th>Parameter name</th>
            <th>Value</th>
            <th>Unit</th>
         </tr><tr>
            <td align=\"Left\">mass</td>
            <td>=2.5</td>
	      <td align=\"Right\">kg</td>
         </tr>
         <tr>
            <td align=\"Left\">Cp</td>
            <td>=1000</td>
            <td align=\"Right\">J/(kg.K)</td>
         </tr>
         <tr>
            <td align=\"Left\">SOC_init</td>
            <td>=0.5</td>
            <td align=\"Right\">-</td>
         </tr>
	   <tr>
            <td align=\"Left\">p</td>
            <td>=5</td>
            <td align=\"Right\">Cells in parallel</td>
         </tr>
         <tr>
            <td align=\"Left\">s</td>
            <td>=2</td>
            <td align=\"Right\">Cells in series</td>
         </tr>
      </tbody></table>
</body></html>"));

end LiIonBatteryPack_Lumped;
