within VirtualFCS.Electrochemical.Hydrogen;

model FuelCell "Model for a single PEM fuel cell"
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  //*** DECLARE PARAMETERS ***//
  // Physical parameters
  parameter Modelica.Units.SI.Mass mass = 1 "Mass of the cell";
  parameter Modelica.Units.SI.Volume volume = 0.001 "Volume of the cell";
  // Thermal parameters
  parameter Modelica.Units.SI.SpecificHeatCapacity heatCapacity = 800 "Specific Heat Capacity";
  // Stack design parameters
  parameter Real N_cell(unit = "1") = 1 "Number of Cells";
  parameter Modelica.Units.SI.Area A_cell = 0.0237 "Active Area of the Cell";
  // Electrochemical parameters
  parameter Modelica.Units.SI.Current i_0 = 0.0002 "Exchange Current";
  parameter Modelica.Units.SI.Current i_L = 520 "Maximum Current Limit";
  parameter Modelica.Units.SI.Current i_x = 0.001 "Cross-over Current";
  parameter Real b_1(unit = "V/dec") = 0.025 "Tafel Slope";
  parameter Real b_2(unit = "V/dec") = 0.25 "Transport Limitation Factor";
  parameter Modelica.Units.SI.Resistance R_0 = 0.02 "Ohmic Resistance";
  parameter Modelica.Units.SI.Resistance R_1 = 0.01 "Charge Transfer Resistance";
  parameter Modelica.Units.SI.Capacitance C_1 = 3e-3 "Double Layer Capacitance";
  //*** DECLARE VARIABLES ***//
  // Physical constants
  Modelica.Units.SI.MolarHeatCapacity R = 8.314 "J/(mol.K)";
  Modelica.Units.SI.FaradayConstant F = 96485 "C/mol";
  // Fuel cell variables
  Modelica.Units.SI.Voltage V_cell;
  Modelica.Units.SI.CurrentDensity j;
  Modelica.Units.SI.Power P_th;
  Modelica.Units.SI.Pressure p_H2(min = 0);
  Modelica.Units.SI.Pressure p_O2(min = 0);
  Modelica.Units.SI.Pressure p_0 = 100000;
  //*** INSTANTIATE COMPONENTS ***//
  //System
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(visible = true, transformation(extent = {{-140, -142}, {-120, -122}}, rotation = 0)));
  // Electrical Components
  // Fluid Components
  Modelica.Fluid.Fittings.TeeJunctionIdeal qH2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-118, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_H2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_H2(redeclare package Medium = Anode_Medium) annotation(
    Placement(visible = true, transformation(origin = {-148, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_Coolant(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {-134, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_Coolant(redeclare package Medium = Coolant_Medium) annotation(
    Placement(visible = true, transformation(origin = {130, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipeCoolant(redeclare package Medium = Coolant_Medium, diameter = 0.003, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, nParallel = 500, p_a_start = 102502, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {0, -42}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_Air(redeclare package Medium = Cathode_Medium) annotation(
    Placement(visible = true, transformation(origin = {150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_Air(redeclare package Medium = Cathode_Medium) annotation(
    Placement(visible = true, transformation(origin = {150, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal qAir(redeclare package Medium = Cathode_Medium) annotation(
    Placement(visible = true, transformation(origin = {120, 40}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T O2_sink(redeclare package Medium = Cathode_Medium, nPorts = 1, use_m_flow_in = false) annotation(
    Placement(visible = true, transformation(origin = {84, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Thermal Components
  // Other Components
  Modelica.Fluid.Sources.MassFlowSource_T H2_sink(redeclare package Medium = Anode_Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-80, 41}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R_ohmic(R = R_0) annotation(
    Placement(visible = true, transformation(origin = {60, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Sources.SignalVoltage potentialSource annotation(
    Placement(visible = true, transformation(origin = {-60, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain H2_mflow(k = -0.00202 / (96485 * 2) * N_cell) annotation(
    Placement(visible = true, transformation(origin = {-28, 51}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain O2_mflow(k = -0.032 / (96485 * 4) * N_cell) annotation(
    Placement(visible = true, transformation(origin = {32, 50}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 1777) annotation(
    Placement(visible = true, transformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {0, -144}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = heatCapacity * mass, T(fixed = false, start = 293.15), der_T(fixed = false)) annotation(
    Placement(visible = true, transformation(origin = {0, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(visible = true, transformation(origin = {48, -114}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = {-50, -92}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
equation
//*** DEFINE EQUATIONS ***//
// Redeclare variables
  p_H2 = H2_sink.ports[1].p;
  p_O2 = 0.2 * O2_sink.ports[1].p;
  j = currentSensor.i / A_cell;
// ELECTROCHEMICAL EQUATIONS //
// Calculate the Nernst equilibrium voltage
  potentialSource.v = N_cell * (1.229 - R * temperatureSensor.T / (2 * F) * log(1 / (p_H2 / p_0 * (p_O2 / p_0) ^ 0.5)) - b_1 * log((R_ohmic.i + i_x) / i_0) + b_2 * log(1 - (R_ohmic.i + i_x) / i_L));
// Calculate the voltage of the cell
  V_cell = pin_p.v / N_cell;
// THERMAL EQUATIONS //
  P_th = (1.481 - V_cell) * abs(currentSensor.i) * N_cell;
// Assign the thermal power value to the heat flow component
  prescribedHeatFlow.Q_flow = P_th;
//*** DEFINE CONNECTIONS ***//
  connect(pipeCoolant.port_b, port_b_Coolant) annotation(
    Line(points = {{10, -42}, {130, -42}}, color = {255, 0, 0}, thickness = 1));
  connect(pipeCoolant.port_a, port_a_Coolant) annotation(
    Line(points = {{-10, -42}, {-134, -42}}, color = {0, 0, 255}, thickness = 1));
  connect(port_a_H2, qH2.port_1) annotation(
    Line(points = {{-148, 80}, {-118, 80}, {-118, 50}, {-118, 50}}, color = {0, 170, 0}, thickness = 1));
  connect(port_b_H2, qH2.port_2) annotation(
    Line(points = {{-150, 0}, {-118, 0}, {-118, 30}, {-118, 30}}, color = {0, 170, 0}, thickness = 1));
  connect(port_a_Air, qAir.port_1) annotation(
    Line(points = {{150, 80}, {120, 80}, {120, 50}, {120, 50}}, color = {0, 170, 255}, thickness = 1));
  connect(qAir.port_2, port_b_Air) annotation(
    Line(points = {{120, 30}, {120, 30}, {120, -2}, {150, -2}, {150, -2}}, color = {0, 170, 255}, thickness = 1));
  connect(O2_sink.ports[1], qAir.port_3) annotation(
    Line(points = {{94, 40}, {110, 40}, {110, 40}, {110, 40}}, color = {0, 170, 255}, thickness = 1));
  connect(qH2.port_3, H2_sink.ports[1]) annotation(
    Line(points = {{-108, 40}, {-90, 40}, {-90, 42}, {-90, 42}}, color = {0, 170, 0}, thickness = 1));
  connect(R_ohmic.n, pin_p) annotation(
    Line(points = {{60, 130}, {60, 150}}, color = {0, 0, 255}));
  connect(pin_n, potentialSource.n) annotation(
    Line(points = {{-60, 150}, {-60, 150}, {-60, 130}, {-60, 130}}, color = {0, 0, 255}));
  connect(O2_mflow.y, O2_sink.m_flow_in) annotation(
    Line(points = {{40, 50}, {74, 50}, {74, 48}, {74, 48}}, color = {0, 0, 127}));
  connect(H2_mflow.y, H2_sink.m_flow_in) annotation(
    Line(points = {{-36, 52}, {-68, 52}, {-68, 50}, {-70, 50}}, color = {0, 0, 127}));
  connect(potentialSource.p, currentSensor.p) annotation(
    Line(points = {{-60, 110}, {-60, 110}, {-60, 100}, {-10, 100}, {-10, 100}}, color = {0, 0, 255}));
  connect(currentSensor.n, R_ohmic.p) annotation(
    Line(points = {{10, 100}, {60, 100}, {60, 110}, {60, 110}}, color = {0, 0, 255}));
  connect(currentSensor.i, H2_mflow.u) annotation(
    Line(points = {{0, 88}, {0, 88}, {0, 52}, {-18, 52}, {-18, 52}}, color = {0, 0, 127}));
  connect(currentSensor.i, O2_mflow.u) annotation(
    Line(points = {{0, 88}, {0, 88}, {0, 50}, {22, 50}, {22, 50}}, color = {0, 0, 127}));
  connect(thermalConductor.port_b, pipeCoolant.heatPorts[1]) annotation(
    Line(points = {{0, -56}, {0, -56}, {0, -46}, {0, -46}}, color = {191, 0, 0}));
  connect(thermalConductor.port_a, heatCapacitor.port) annotation(
    Line(points = {{0, -76}, {0, -76}, {0, -114}, {0, -114}}, color = {191, 0, 0}));
    connect(temperatureSensor.port, heatCapacitor.port) annotation(
    Line(points = {{-50, -102}, {-50, -102}, {-50, -114}, {2, -114}, {2, -114}, {0, -114}}, color = {191, 0, 0}));
  connect(temperatureSensor.T, H2_sink.T_in) annotation(
    Line(points = {{-50, -82}, {-50, -82}, {-50, 44}, {-68, 44}, {-68, 46}}, color = {0, 0, 127}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{0, -114}, {0, -114}, {0, -144}, {0, -144}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, prescribedHeatFlow.port) annotation(
    Line(points = {{0, -114}, {38, -114}, {38, -114}, {38, -114}}, color = {191, 0, 0}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1), graphics = {Line(origin = {20.1754, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {80, 0}, fillColor = {0, 178, 227}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Line(origin = {40.1315, 2}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {0.219199, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {-40.0001, 1.61404}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {-80, 0}, fillColor = {170, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Text(origin = {10, -54}, lineColor = {255, 0, 0}, extent = {{-11, 6}, {11, -6}}, textString = "K"), Line(origin = {-20.0439, -0.307018}, points = {{0, 80}, {0, -80}, {0, -80}}), Rectangle(origin = {35, 54}, fillColor = {177, 177, 177}, fillPattern = FillPattern.Vertical, extent = {{-95, 26}, {25, -134}}), Text(origin = {-80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "A"), Text(origin = {80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "C")}),
    Documentation(info = "<html><head></head><body>This model describes the dynamic behaviour of a proton exchange membrane fuel cell (PEMFC). The model includes components describing the electrical, fluidic, and thermal properties of the cell.&nbsp;<div><br></div><div>The electrical performance is modelled using a 0-D polarization curve model , which incorporates Nernstian thermodynamic effects due to hydrogen and oxygen pressure changes, Tafel kinetics to calculate activation overpotentials, and an empirical relationship to calculate mass-transport overpotentials. These effects are combined in&nbsp;<span style=\"font-family: 'Courier New';\">potentialSource.v</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">,</span>which calculates the open-circuit voltage for a single cell, adjusts for hydrogen and oxygen partial pressures, subtracts the activation and mass-transport overpotentials, and finally multiplies by the number of cells in the stack. A simple resistor is included after the potential source to cover all Ohmic resistive losses in the fuel cell.</div><div><br></div><div>The fluidic performance is modelled using simple ideal flow components for the air and hydrogen gas lines, connected to mass sink boundary conditions. The magnitude of the mass sink is coupled to the electrical current in the cell using Faraday's law.&nbsp;</div><div><br></div><div>The thermal performance is considered by coupling a model describing the flow of liquid coolant to a thermal heat source. The magnitude of the heat source is calculated using the higher heating value of hydrogen and the calculated electrical voltage of the cell.</div><div><br></div><div>The hydrogen, air, and coolant ports can be connected to their respective subsystems, either by using the&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.FuelCellSubSystems\">FuelCellSubSystems</a>&nbsp;block, or individual&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen\">SubSystemHydrogen</a>,&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">SubSystemAir</a>, and&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCooling\">SubSystemCooling</a>&nbsp;blocks.<br> 
<br> 






<table border=\"0.9\">
<caption align=\"Left\" style=\"text-align: left;\"> <b><u>Default Parameters</u></b></caption>
<tbody><tr><th>Parameter name</th>
            <th>Value</th>
            <th>Unit</th>
         </tr>
         <tr>
            <td align=\"Left\">mass</td>
            <td>=1 </td>
            <td align=\"Right\">kg</td>
         </tr>
         
         <tr>
            <td align=\"Left\">volume</td>
            <td>=0.001</td>
	      <td align=\"Right\">m3</td>
         </tr>
         <tr>
            <td align=\"Left\">Cp</td>
            <td>=800</td>
            <td align=\"Left\">J/(kg.K)</td>
         </tr>
	   <tr>
            <td align=\"Left\">N_cell </td>
            <td>=1</td>
            <td align=\"Right\">-</td>
         </tr>
         
         <tr>
            <td align=\"Left\">A_cell </td>
            <td>=0.0237</td>
	      <td align=\"Right\">m2</td>
         </tr>
         <tr>
            <td align=\"Left\">i_0</td>
            <td>=0.0002</td>
            <td align=\"Right\">A</td>
         </tr>
	   <tr>
            <td align=\"Left\">i_L</td>
            <td>=520</td>
            <td align=\"Right\">A</td>
         </tr>         
         <tr>
            <td align=\"Left\">i_x</td>
            <td>=0.001</td>
	      <td align=\"Right\"> A </td>
         </tr>
         <tr>
            <td align=\"Left\">b_1</td>
            <td>=0.025</td>
            <td align=\"Right\"> V/dec </td>
         </tr>
	   <tr>
            <td align=\"Left\">b_2</td>
            <td>=0.25</td>
            <td align=\"Right\">V/dec</td>
         </tr>
         
         <tr>
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
            <td align=\"Left\">C_1</td>
            <td>=0.003</td>
            <td align=\"Right\">F</td>
         </tr>
         
         
      </tbody></table><br>
</div><div><div><span style=\"text-decoration: underline;\"><strong>Electrochemical equations:</strong></span></div><div>In the equations below, i<sub>stack</sub>&nbsp;represents the current flowing through the stack, accessible in the code as&nbsp;<font face=\"Courier New\">currentSensor.i</font>.</div><p><i><u>The Nernst equilibrium potential</u></i></p><p>U<sub>FC</sub><sup>Nernst&nbsp;</sup>= (U<sup>0</sup>&nbsp;-((RT)/(2F) ln( 1/(p<sub>H2</sub>&nbsp;(p<sub>O2</sub><sup>0.5</sup>))), U<sup>0&nbsp;</sup>= 1.229 V</p><p><span style=\"text-decoration: underline;\"><i>Activation overpotential</i></span></p><p>η<sup>act&nbsp;</sup>= b<sub>1&nbsp;</sub>ln( 1-(i<sub>cell&nbsp;</sub>+ i<sub>x</sub>) / i<sub>0</sub>)</p><p><u><i>Concentration overpotential</i></u></p><p>η<sup>con&nbsp;</sup>= -b<sub>2&nbsp;</sub>ln( 1-(i<sub>cell&nbsp;</sub>+ i<sub>x</sub>) / i<sub>L</sub>)</p><p><u><i>Cell voltage</i></u></p><p>V<sub>cell</sub>&nbsp;= N<sub>cell</sub>&nbsp;(U<sub>FC</sub><sup>Nernst</sup>&nbsp;- η<sup>act&nbsp;</sup>&nbsp;- i<sub>FC</sub>R<sub>0</sub>&nbsp;- η<sup>con</sup>)</p><p><span style=\"text-decoration: underline;\"><strong>Thermal equations:</strong></span></p><p><i><u>Electrochemical heat generation</u></i></p><p>Q<sub>gen</sub><sup>&nbsp;</sup>= (V<sub>TN</sub>&nbsp;- V<sub><font size=\"2\">cell</font></sub>)i<sub>cell</sub>, V<sub>TN</sub>&nbsp;= 1.481 V</p></div></body></html>"));
end FuelCell;
