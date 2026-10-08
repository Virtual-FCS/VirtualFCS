within VirtualFCS.Control.ECMS;

block EMS_ECMS
  //---- Imports ----
  //import Modelica.Utilities.Streams.print;
  import Modelica.Units.SI;
  import Modelica.Units.NonSI;
  //---- Parameters ----
  parameter Real ramp_up(unit = "1/s") = 5000 "FC stack power maximum ramp up rate" annotation (
    Dialog(group = "Control Parameters"));
  //---- Fuel cell ----
  parameter SI.Power power_FC_min = 100 "FC stack minimum operating power" annotation (
    Dialog(group = "Powertrain Parameters"));
  parameter SI.Power power_FC_max = 60000 "FC stack maximum operating power" annotation (
    Dialog(group = "Powertrain Parameters"));
  parameter Real n_cell(unit = "1") "Number of cells in fuel cell stack" annotation (
    Dialog(group = "Powertrain Parameters"));
  import Modelica.Constants.R; // Universal gas constant
  import Modelica.Constants.F; // Faradays number
  final SI.Efficiency eta_fc_sys_estimate "Polynomial fit fuel cell system efficiency";
  // Used to calculate test /and control parameters. Will not matter if removed.
  //---- Battery ----
  parameter Real SOC_min(unit = "1") = 0.4 "Minimum allowed SOC of battery" annotation (
    Dialog(group = "Control Parameters"));
  parameter Real SOC_max(unit = "1") = 0.7 "Maximum allowed SOC of battery" annotation (
    Dialog(group = "Control Parameters"));
  parameter SI.Power power_battery_max = 10000 "Battery max power" annotation (
    Dialog(group = "Powertrain Parameters"));
  parameter SI.Power power_battery_min = -8000 "Battery min power" annotation (
    Dialog(group = "Powertrain Parameters"));
  parameter SI.Voltage OCV = 49.17 "Open circuit voltage battery" annotation (
    Dialog(group = "Powertrain Parameters")); // Define this prior to experiment!
  Real SOC(unit = "1") "State of charge of battery";

  parameter SI.Resistance internalResistance = 0.6e-3 "Internal resistance of battery real time" annotation (
    Dialog(group = "Powertrain Parameters")); //Define this prior to experiment!!
  // -- Battery charging/discharging efficiencies --
  final SI.Efficiency eta_b_chr(start = 1) "Battery charge efficiency";
  final SI.Efficiency eta_b_dischr(start = 1) "Battery discharge efficiency";

  //---- Time

  parameter Integer t_const = 50 "FC should not start before this time" annotation (
    Dialog(group = "Control Parameters"));
  // Assumtion on start-up procedure. This is not modelled, so FC is just turned off this time.
  //---- Necessary for ECMS ----
  final Real sigma(start = 1);
  //Real mu(unit = "1") = 1;
  parameter Real mu(unit = "1") = 0.6 annotation (
    Dialog(group = "Control Parameters"));
  final SI.Power powerD(start = 0) "Power request";
  final Real k_b_f(start = 1);
  final NonSI.MassFlowRate_gps C_fc(start = 0);
  final NonSI.MassFlowRate_gps C_batt(start = 0);
  final NonSI.MassFlowRate_gps C_batt_2(start = 0); // C_batt*k_b
  final NonSI.MassFlowRate_gps C(start = 0);
  Real C_optim(start = 0);
  final Real C_sum(start = 0);
  Real C_cumulative_fc(start = 0);
  Real C_cumulative_bat(start = 0);
  Real C_cumulativeCost(start = 0);
  //---- Set power variable ---- Three is necessary to ensure constraints are maintained
  final SI.Power set_FC_power_1(start = 100) "Fuel cell set power";
  final SI.Power set_FC_power_2(start = 100) "Fuel cell set power";
  final SI.Power set_FC_power_3(start = 100) "Fuel cell set power";
  //SI.Power prev_power(start = 0) "Fuel cell set power previous time step";
  SI.Current current(start = 0) "Fuel cell set current";
  SI.Current current_prev(start = 0) "Fuel cell set current previous timestep";
  Real turn_off(start = 0);

  // Boolean to control if the FC is on or off.

  Modelica.Blocks.Interfaces.RealOutput controlSetCurrent
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Modelica.Blocks.Interfaces.RealInput inputSOC
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}})));
  Modelica.Blocks.Interfaces.RealInput inputFCTemp annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,-120})));
  Modelica.Blocks.Interfaces.RealInput inputP_H2 annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Interfaces.RealInput inputP_O2 annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={100,-120})));
  Modelica.Blocks.Interfaces.RealInput inputPowerDemand annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-100,120})));
  Modelica.Blocks.Interfaces.RealInput inputBatteryCurrent annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealInput inputBatteryVoltage annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={100,120})));
  Real testConstrain; // Should be zero


  Modelica.Blocks.Sources.RealExpression realExpression(y=set_FC_power_3)
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising=ramp_up)
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Modelica.Blocks.Math.Abs abs1
    annotation (Placement(transformation(extent={{88,-10},{108,10}})));
  Modelica.Blocks.Interfaces.RealInput input_phi annotation (
    Placement(transformation(origin = {180, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {190, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
protected
  final Integer eta_b_chr_counter(start = 1) "Counts the number of charge efficiencies calculated";
  final Real eta_b_chr_sum(start = 1);
  final Real eta_b_chr_avg(start = 1) "Battery charge efficiency average";
  final Integer eta_b_dischr_counter(start = 1) "Counts the number of discharge efficiencies calculated";
  final Real eta_b_dischr_sum(start = 1);
  final Real eta_b_dischr_avg(start = 1) "Battery discharge efficiency average";
  Real LHV_H2(unit = "Ws/g") = 119959.2 "Hydrogen lower heating value";
  SI.Voltage batt_V "Battery voltage real";
  SI.Current batt_I "Battery Current real";
  Real t = time;
  final Real t_comp(start = 0);


equation

  current = set_FC_power_3 / fcVoltage(42, inputFCTemp, inputP_H2, inputP_O2, current, 0.41, 0.03, 0.15e-4, 16000, 1, input_phi);

//---- Redefine variables ----
  SOC = inputSOC;
  batt_V = max(inputBatteryVoltage, 1);
  powerD = inputPowerDemand;
  batt_I = -inputBatteryCurrent;
  eta_fc_sys_estimate = efficiencyFC(set_FC_power_3);
//---- Recalculations ----
  testConstrain = powerD - set_FC_power_1 - (batt_V*batt_I);
// Calculates the constrain inside the optimization solver (Should be close to zero)
//---- Consumptions ----
// Calculates C_fc the same as the optimization solver. This will vary from the actual FC since set_current_1 is used, and no dynamic behavious is considered.
  C_fc = set_FC_power_3/(LHV_H2*eta_fc_sys_estimate);
  C_batt = sigma*(powerD - set_FC_power_3)/(LHV_H2*eta_fc_sys_estimate);
  k_b_f = 1 - 2*mu*((SOC - 0.5*(SOC_max + SOC_min))/(SOC_max + SOC_min));
// Calculates the k_b term
  C_batt_2 = k_b_f*C_batt;


// Calculates k_b * C_batt
  C = C_fc + C_batt;
  der(C_cumulative_fc) = C_fc;
  der(C_cumulative_bat) = C_batt;
  der(C_cumulativeCost) = C;
//---- If-else logic to calculate battery charging/discharing efficiencies ----
  if noEvent(batt_I >= 0) then
// battery is discharging, from: https://doi.org/10.1016/j.conengprac.2011.06.008
    eta_b_dischr = 0.5*(1 + sqrt(1 - 4*internalResistance*batt_I*batt_V/OCV^2));
    eta_b_chr = 1;
  else
// battery is charging
    eta_b_chr = 2/(1 + sqrt(1 - 4*internalResistance*batt_I*batt_V/OCV^2));
    eta_b_dischr = 1;
  end if;
//---- When statement to avoide long loops ----
  when t >= pre(t_comp) + 2 then
    t_comp = pre(t_comp) + 2;
    //prev_power = pre(set_FC_power_3);
    current_prev = pre(current);

    if noEvent(batt_I < 0) then
// Battery is Charging
      eta_b_chr_counter = pre(eta_b_chr_counter) + 1;
      eta_b_chr_sum = pre(eta_b_chr_sum) + eta_b_chr;
      eta_b_chr_avg = eta_b_chr_sum/eta_b_chr_counter;
      eta_b_dischr_counter = pre(eta_b_dischr_counter);
      eta_b_dischr_sum = pre(eta_b_dischr_sum);
      eta_b_dischr_avg = pre(eta_b_dischr_avg);
      sigma = eta_b_dischr_avg*eta_b_chr;
    else
// Battery is Discharging
      eta_b_dischr_counter = pre(eta_b_dischr_counter) + 1;
      eta_b_dischr_sum = pre(eta_b_dischr_sum) + eta_b_dischr;
      eta_b_dischr_avg = eta_b_dischr_sum/eta_b_dischr_counter;
      eta_b_chr_counter = pre(eta_b_chr_counter);
      eta_b_chr_sum = pre(eta_b_chr_sum);
      eta_b_chr_avg = pre(eta_b_chr_avg);
      sigma = 1/(eta_b_chr_avg*eta_b_dischr);
    end if;
//---- The core of ECMS, the cost function is ran ----
    (set_FC_power_1, C_optim) = bruteForceMinimization(200, power_FC_min, power_FC_max, powerD, power_battery_min, power_battery_max, LHV_H2, mu, SOC, SOC_min, SOC_max, sigma);


    C_sum = pre(C_sum) + C;
  end when;

  when {SOC > SOC_max, SOC < SOC_min + (2/3)*(SOC_max - SOC_min)} then

    if SOC > SOC_max then
      turn_off = 1;

    else
      turn_off = 0;
    end if;
  end when;

  if noEvent(turn_off == 0) then
    set_FC_power_2 = max(set_FC_power_1, power_FC_min);
//The fuel cell is minimum operated on the lower limited, no matter what the optimization solver outputs
  else
    set_FC_power_2 = 100;
  end if;
  if noEvent(set_FC_power_2 < power_FC_min) or noEvent(t < t_const) then
// If time is less then t_const, the fuel cell remains off
    set_FC_power_3 = 100;
  else
    set_FC_power_3 = set_FC_power_2;
  end if;
  connect(realExpression.y, slewRateLimiter.u) annotation (
    Line(points = {{-11, 0}, {26, 0}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, abs1.u) annotation (
    Line(points = {{49, 0}, {86, 0}}, color = {0, 0, 127}));
  connect(abs1.y, controlSetCurrent) annotation (
    Line(points={{109,0},{210,0}},      color = {0, 0, 127}));
  annotation (
    Icon(graphics={  Rectangle(fillColor = {0, 70, 40}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-200, 100}, {200, -100}}, radius = 35), Rectangle(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-43.2, 41.4}, {43, -45}}, radius = 8), Rectangle(origin = {-35, -3}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {-22.2, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {-35, -3}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, lineThickness = 0, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {-9.5, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {3.3, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {16.1, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {28.85, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {0, 30}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, 17.2}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, 4.35}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, -8.45}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, -21.25}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, -34.05}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(fillColor = {0, 70, 40}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{39.8, 38.3}, {-40, -41.8}}, radius = 5), Rectangle( fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-27.3, 25.5}, {27, -29}}), Rectangle(fillColor = {0, 70, 40}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-24.1, 22.25}, {23.85, -25.8}})}, coordinateSystem(extent = {{-200, -100}, {200, 100}}, initialScale = 0.1)), Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}}, initialScale = 0.1)),
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<div>The EnergyManagementSystem component is designed to manage the flow of power between the fuel cell stack, battery, vehicle load, and balance-of-plant load. It splits the load according to pre-defined energy management rules, which are implemented within the bounds of the battery management system and the fuel cell control unit.</div><div><br></div><p>Despite its name, controlSetCurrent carries the fuel-cell power request in W: it is driven by set_FC_power_3 through the slew-rate limiter and absolute-value block. The connected FuelCellSystemController converts that power to current. The current-estimation equation calls fcVoltage with a fixed 42-cell stack; changing n_cell does not change that literal. Battery current is sign-reversed internally, and measured battery voltage is bounded below by 1 V.</p>
<h2>Governing Equations</h2>
<pre>LHV_H2 = 119959.2;
t = time;
current = set_FC_power_3 / fcVoltage(42, inputFCTemp, inputP_H2, inputP_O2, current, 0.41, 0.03, 0.15e-4, 16000, 1, input_phi);
SOC = inputSOC;
batt_V = max(inputBatteryVoltage, 1);
powerD = inputPowerDemand;
batt_I = -inputBatteryCurrent;
eta_fc_sys_estimate = efficiencyFC(set_FC_power_3);
testConstrain = powerD - set_FC_power_1 - (batt_V*batt_I);
C_fc = set_FC_power_3/(LHV_H2*eta_fc_sys_estimate);
C_batt = sigma*(powerD - set_FC_power_3)/(LHV_H2*eta_fc_sys_estimate);
k_b_f = 1 - 2*mu*((SOC - 0.5*(SOC_max + SOC_min))/(SOC_max + SOC_min));
C_batt_2 = k_b_f*C_batt;
C = C_fc + C_batt;
der(C_cumulative_fc) = C_fc;
der(C_cumulative_bat) = C_batt;
der(C_cumulativeCost) = C;
if noEvent(batt_I &gt;= 0) then // battery is discharging, from: https://doi.org/10.1016/j.conengprac.2011.06.008 eta_b_dischr = 0.5*(1 + sqrt(1 - 4*internalResistance*batt_I*batt_V/OCV^2));
eta_b_chr = 1;
else // battery is charging eta_b_chr = 2/(1 + sqrt(1 - 4*internalResistance*batt_I*batt_V/OCV^2));
eta_b_dischr = 1;
end if;
when t &gt;= pre(t_comp) + 2 then t_comp = pre(t_comp) + 2;
current_prev = pre(current);
if noEvent(batt_I &lt; 0) then // Battery is Charging eta_b_chr_counter = pre(eta_b_chr_counter) + 1;
eta_b_chr_sum = pre(eta_b_chr_sum) + eta_b_chr;
eta_b_chr_avg = eta_b_chr_sum/eta_b_chr_counter;
eta_b_dischr_counter = pre(eta_b_dischr_counter);
eta_b_dischr_sum = pre(eta_b_dischr_sum);
eta_b_dischr_avg = pre(eta_b_dischr_avg);
sigma = eta_b_dischr_avg*eta_b_chr;
else // Battery is Discharging eta_b_dischr_counter = pre(eta_b_dischr_counter) + 1;
eta_b_dischr_sum = pre(eta_b_dischr_sum) + eta_b_dischr;
eta_b_dischr_avg = eta_b_dischr_sum/eta_b_dischr_counter;
eta_b_chr_counter = pre(eta_b_chr_counter);
eta_b_chr_sum = pre(eta_b_chr_sum);
eta_b_chr_avg = pre(eta_b_chr_avg);
sigma = 1/(eta_b_chr_avg*eta_b_dischr);
end if;
(set_FC_power_1, C_optim) = bruteForceMinimization(200, power_FC_min, power_FC_max, powerD, power_battery_min, power_battery_max, LHV_H2, mu, SOC, SOC_min, SOC_max, sigma);
C_sum = pre(C_sum) + C;
end when;
when {SOC &gt; SOC_max, SOC &lt; SOC_min + (2/3)*(SOC_max - SOC_min)} then if SOC &gt; SOC_max then turn_off = 1;
else turn_off = 0;
end if;
end when;
if noEvent(turn_off == 0) then set_FC_power_2 = max(set_FC_power_1, power_FC_min);
else set_FC_power_2 = 100;
end if;
if noEvent(set_FC_power_2 &lt; power_FC_min) or noEvent(t &lt; t_const) then // If time is less then t_const, the fuel cell remains off set_FC_power_3 = 100;
else set_FC_power_3 = set_FC_power_2;
end if;
connect(realExpression.y, slewRateLimiter.u);
connect(slewRateLimiter.y, abs1.u);
connect(abs1.y, controlSetCurrent);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>eta_fc_sys_estimate</code></td><td>Polynomial fit fuel cell system efficiency</td></tr>
<tr><td><code>SOC</code></td><td>State of charge of battery</td></tr>
<tr><td><code>eta_b_chr</code></td><td>Battery charge efficiency</td></tr>
<tr><td><code>eta_b_dischr</code></td><td>Battery discharge efficiency</td></tr>
<tr><td><code>powerD</code></td><td>Power request</td></tr>
<tr><td><code>set_FC_power_1</code></td><td>Fuel cell set power</td></tr>
<tr><td><code>set_FC_power_2</code></td><td>Fuel cell set power</td></tr>
<tr><td><code>set_FC_power_3</code></td><td>Fuel cell set power</td></tr>
<tr><td><code>current</code></td><td>Fuel cell set current</td></tr>
<tr><td><code>current_prev</code></td><td>Fuel cell set current previous timestep</td></tr>
<tr><td><code>eta_b_chr_counter</code></td><td>Counts the number of charge efficiencies calculated</td></tr>
<tr><td><code>eta_b_chr_avg</code></td><td>Battery charge efficiency average</td></tr>
<tr><td><code>eta_b_dischr_counter</code></td><td>Counts the number of discharge efficiencies calculated</td></tr>
<tr><td><code>eta_b_dischr_avg</code></td><td>Battery discharge efficiency average</td></tr>
<tr><td><code>LHV_H2</code></td><td>Hydrogen lower heating value</td></tr>
<tr><td><code>batt_V</code></td><td>Battery voltage real</td></tr>
<tr><td><code>batt_I</code></td><td>Battery Current real</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>ramp_up</code></td><td>Real</td><td>1/s</td><td><code>5000</code></td><td>FC stack power maximum ramp up rate</td></tr>
<tr><td><code>power_FC_min</code></td><td>SI.Power</td><td>W</td><td><code>100</code></td><td>FC stack minimum operating power</td></tr>
<tr><td><code>power_FC_max</code></td><td>SI.Power</td><td>W</td><td><code>60000</code></td><td>FC stack maximum operating power</td></tr>
<tr><td><code>n_cell</code></td><td>Real</td><td>1</td><td><code>-</code></td><td>Number of cells in fuel cell stack</td></tr>
<tr><td><code>SOC_min</code></td><td>Real</td><td>1</td><td><code>0.4</code></td><td>Minimum allowed SOC of battery</td></tr>
<tr><td><code>SOC_max</code></td><td>Real</td><td>1</td><td><code>0.7</code></td><td>Maximum allowed SOC of battery</td></tr>
<tr><td><code>power_battery_max</code></td><td>SI.Power</td><td>W</td><td><code>10000</code></td><td>Battery max power</td></tr>
<tr><td><code>power_battery_min</code></td><td>SI.Power</td><td>W</td><td><code>-8000</code></td><td>Battery min power</td></tr>
<tr><td><code>OCV</code></td><td>SI.Voltage</td><td>V</td><td><code>49.17</code></td><td>Open circuit voltage battery</td></tr>
<tr><td><code>internalResistance</code></td><td>SI.Resistance</td><td>Ohm</td><td><code>0.6e-3</code></td><td>Internal resistance of battery real time</td></tr>
<tr><td><code>t_const</code></td><td>Integer</td><td>1</td><td><code>50</code></td><td>FC should not start before this time</td></tr>
<tr><td><code>mu</code></td><td>Real</td><td>1</td><td><code>0.6</code></td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>controlSetCurrent</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>W</td><td>-</td></tr>
<tr><td><code>inputSOC</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>1</td><td>-</td></tr>
<tr><td><code>inputFCTemp</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>K</td><td>-</td></tr>
<tr><td><code>inputP_H2</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>Pa</td><td>-</td></tr>
<tr><td><code>inputP_O2</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>Pa</td><td>-</td></tr>
<tr><td><code>inputPowerDemand</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>W</td><td>-</td></tr>
<tr><td><code>inputBatteryCurrent</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>A</td><td>-</td></tr>
<tr><td><code>inputBatteryVoltage</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>V</td><td>-</td></tr>
<tr><td><code>input_phi</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>1</td><td>-</td></tr>
</table>
</body>
</html>"));

end EMS_ECMS;
