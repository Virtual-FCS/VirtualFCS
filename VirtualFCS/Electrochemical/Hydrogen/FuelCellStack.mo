within VirtualFCS.Electrochemical.Hydrogen;

model FuelCellStack "Model for a PEM fuel cell stack"
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  //*** DECLARE PARAMETERS ***//
  // Physical parameters
  parameter Real mass(unit = "kg") = 1 "Mass of the Stack";
  parameter Real volume(unit = "m3") = 0.001 "Volume of the Stack";
  // Thermal parameters
  parameter Real heatCapacity(unit = "J/(kg.K)") = 800 "Specific Specific Heat Capacity";
  // Stack design parameters
  parameter Real N_cell(unit = "1") = 100 "Number of Cells";
  parameter Real A_cell(unit = "m2") = 0.0237 "Active Area of the Cell";
  // Electrochemical parameters
  parameter Real i_0(unit = "A") = 0.0002 "Exchange Current";
  parameter Real i_L(unit = "A") = 520 "Maximum Current Limit";
  parameter Real i_x(unit = "A") = 0.001 "Cross-over Current";
  parameter Real b_1(unit = "V/dec") = 0.025 "Tafel Slope";
  parameter Real b_2(unit = "V/dec") = 0.25 "Transport Limitation Factor";
  parameter Real R_0(unit = "Ohm") = 0.02 "Ohmic Resistance";
  parameter Real R_1(unit = "Ohm") = 0.01 "Charge Transfer Resistance";
  parameter Real C_1(unit = "F") = 3e-3 "Double Layer Capacitance";
  //*** DECLARE VARIABLES ***//
  // Physical constants
  Real R = 8.314;
  Real F = 96485;
  // Fuel cell variables
  Real V_cell;
  Real j;
  Real P_th;
  Real p_H2(min = 0);
  Real p_O2(min = 0);
  Real p_0 = 100000;
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
  Modelica.Electrical.Analog.Basic.Resistor R_ohmic(R = R_0)  annotation(
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
equation
//*** DEFINE EQUATIONS ***//
// Redeclare variables
  p_H2 = H2_sink.ports[1].p;
  p_O2 = 0.2 * O2_sink.ports[1].p;
  j = currentSensor.i / A_cell;
// ELECTROCHEMICAL EQUATIONS //
// Calculate the Nernst equilibrium voltage
  potentialSource.v = N_cell * (1.229 - R * 298 / (2 * F) * log(1 / (p_H2 / p_0 * (p_O2 / p_0) ^ 0.5)) - b_1 * log((R_ohmic.i + i_x) / i_0) + b_2 * log(1 - (R_ohmic.i + i_x) / i_L));
// Calculate the voltage of the cell
  V_cell = pin_p.v / N_cell;
// THERMAL EQUATIONS //
  P_th = (1.481 - V_cell) * currentSensor.i * N_cell;
// Assign the thermal power value to the heat flow component
  prescribedHeatFlow.Q_flow = P_th;
//*** DEFINE CONNECTIONS ***//
  connect(pipeCoolant.port_b, port_b_Coolant) annotation(
    Line(points = {{10, -42}, {130, -42}}, color = {0, 127, 255}, thickness = 1));
  connect(pipeCoolant.port_a, port_a_Coolant) annotation(
    Line(points = {{-10, -42}, {-134, -42}}, color = {0, 127, 255}, thickness = 1));
  connect(port_a_H2, qH2.port_1) annotation(
    Line(points = {{-148, 80}, {-118, 80}, {-118, 50}, {-118, 50}}));
  connect(port_b_H2, qH2.port_2) annotation(
    Line(points = {{-150, 0}, {-118, 0}, {-118, 30}, {-118, 30}}));
  connect(port_a_Air, qAir.port_1) annotation(
    Line(points = {{150, 80}, {120, 80}, {120, 50}, {120, 50}}));
  connect(qAir.port_2, port_b_Air) annotation(
    Line(points = {{120, 30}, {120, 30}, {120, -2}, {150, -2}, {150, -2}}));
  connect(O2_sink.ports[1], qAir.port_3) annotation(
    Line(points = {{94, 40}, {110, 40}, {110, 40}, {110, 40}}, color = {0, 127, 255}));
  connect(qH2.port_3, H2_sink.ports[1]) annotation(
    Line(points = {{-108, 40}, {-90, 40}, {-90, 42}, {-90, 42}}, color = {0, 127, 255}));
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
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{0, -114}, {0, -114}, {0, -144}, {0, -144}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, prescribedHeatFlow.port) annotation(
    Line(points = {{0, -114}, {38, -114}, {38, -114}, {38, -114}}, color = {191, 0, 0}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1), graphics = {Line(origin = {20.1754, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {80, 0}, fillColor = {0, 178, 227}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Line(origin = {40.1315, 2}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {0.219199, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {-40.0001, 1.61404}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {-80, 0}, fillColor = {170, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Text(origin = {10, -54}, lineColor = {255, 0, 0}, extent = {{-11, 6}, {11, -6}}, textString = "K"), Line(origin = {-20.0439, -0.307018}, points = {{0, 80}, {0, -80}, {0, -80}}), Rectangle(origin = {35, 54}, fillColor = {177, 177, 177}, fillPattern = FillPattern.Vertical, extent = {{-95, 26}, {25, -134}}), Text(origin = {-80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "A"), Text(origin = {80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "C")}),
    version = "",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This model describes the dynamic behaviour of a proton exchange membrane fuel cell (PEMFC) stack. The model includes components describing the electrical, fluidic, and thermal properties of the stack.<div><br></div><div>The electrical performance is modelled using a simple 1RC equivalent circuit.&nbsp;</div><div><br></div><div>The fluidic performance is modelled using simple ideal flow components for the air and hydrogen gas lines, connected to mass sink boundary conditions. The magnitude of the mass sink is coupled to the electrical current in the stack using Faraday's law.&nbsp;</div><div><br></div><div>The thermal performance is considered by coupling a model describing the flow of liquid coolant to a thermal heat source. The magnitude of the heat source is calculated using the higher heating value of hydrogen and the calculated electrical voltage of the cell.
<br>
<br>

<table border=\"0.9\">
<caption align=\"Left\" style=\"text-align: left;\"> <b><u>Default Parameters</u></b></caption>
<tbody><tr><th>Parameter name</th>
            <th>Value</th>
            <th>Unit</th>
         </tr>
         <tr>
            <td align=\"Left\">mass</td>
            <td>=50 </td>
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
            <td>=100</td>
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
         
         
      </tbody></table>
</div>
</body></html>"));
end FuelCellStack;
