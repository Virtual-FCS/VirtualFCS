within VirtualFCS.Electrochemical.Hydrogen.Electrolysers_dev;

model Electrolyser_dev
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package H2_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package O2_Medium = Modelica.Media.IdealGases.SingleGases.O2;
  replaceable package H2O_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  // Equivalent circuit models
  replaceable VirtualFCS.Electrochemical.Hydrogen.OhmicNafion ohmic annotation(
    Placement(visible = true, transformation(origin = {54, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable VirtualFCS.Electrochemical.Hydrogen.ActivationLossAnCa activation annotation(
    Placement(visible = true, transformation(origin = {86, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable  MassTransportLossElec massTransport annotation(
    Placement(visible = true, transformation(origin = {124, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

//*** DECLARE PARAMETERS ***//
  // Physical parameters from https://nelhydrogen.com/product/c10-c20-c30/ and 10.1016/j.ijhydene.2020.01.228; 10.1016/j.enconman.2022.116622
  parameter Modelica.Units.SI.Mass m_cell = 1 "Mass of the Cell";
  //NA
  parameter Modelica.Units.SI.Volume v_cell = 0.001 "Volume of the Cell";
  //NA
  // Thermal parameters
  parameter Modelica.Units.SI.SpecificHeatCapacity Cp_cell = 1100 "Specific Specific Heat Capacity";
  //NA
  // Stack design parameters
  inner parameter Real N_cells(unit = "1") = 65 "Number of Cells";
  inner parameter Modelica.Units.SI.Area A_cell = 0.0214 "Active Area of the Cell";
  // Electrochemical parameters
  parameter Modelica.Units.SI.CurrentDensity i_0 = 1.7e-6 "Exchange Current density";
  parameter Modelica.Units.SI.CurrentDensity i_x = 0.001 "Cross-over Current density";
  //NA
  inner constant Real a_A = 0.5 "Charge Transfer coefficient";
  parameter Modelica.Units.SI.Resistivity rho_ele = 7.5e-5 "Electrode resistivity";
  //*** DECLARE VARIABLES ***//
  inner Modelica.Units.SI.AbsolutePressure p_H2(min = 0) = H2ToTank.p;
  inner Modelica.Units.SI.AbsolutePressure p_O2(min = 0) = O2ToTank.p;
  // Physical constants
  final constant Real R(final unit = "J/(mol.K)") = 8.3144598 "Molar gas constant";
  final constant Modelica.Units.SI.FaradayConstant F = 9.648533289e4 "Faraday constant, C/mol";
  // Electrolyser variables
  //hydrogen diffusivity in membrane
  Modelica.Units.SI.Voltage E_rev;
  Modelica.Units.SI.Voltage E_tn;
  Modelica.Units.SI.Voltage E_cell;
  Modelica.Units.SI.CurrentDensity j;
  Modelica.Units.SI.Power P_th;
  Modelica.Units.SI.Power P_el;
  Modelica.Units.SI.Pressure p_H2O;
  Modelica.Units.SI.Heat Q_rev;
  Modelica.Units.SI.Heat Q_irr;
  inner Modelica.Units.SI.Temperature T_water_in "Input for the simple PipeCoolant";
  inner Modelica.Units.SI.Temperature T_stack "Variable created to avoid numerical issues from T sensor";
  //*** INSTANTIATE COMPONENTS ***//
  //System
  // Electrical Components
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {2, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-144, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Fluid Components
  Modelica.Fluid.Sources.MassFlowSource_T O2_IToM(redeclare package Medium = O2_Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {76, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b O2ToTank(redeclare package Medium = O2_Medium) annotation(
    Placement(visible = true, transformation(origin = {150, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T H2_IToM(redeclare package Medium = H2_Medium, nPorts = 1, use_T_in = false, use_m_flow_in = true) annotation(
    Placement(visible = true, transformation(origin = {-80, 45}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b H2ToTank(redeclare package Medium = H2_Medium) annotation(
    Placement(visible = true, transformation(origin = {-150, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionIdeal T_junc(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {126, 54}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T H2O_IToM(redeclare package Medium = H2O_Medium, nPorts = 1, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {78, 54}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b H2OToTank(redeclare package Medium = H2O_Medium) annotation(
    Placement(visible = true, transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a H2OToPEMWE(redeclare package Medium = H2O_Medium) annotation(
    Placement(visible = true, transformation(origin = {150, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Thermal Components
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(visible = true, transformation(origin = {-48, -22}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = Cp_cell*m_cell, T(displayUnit = "degC", fixed = true, start = 293.15), der_T(fixed = false)) annotation(
    Placement(transformation(origin = {-48, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSStack annotation(
    Placement(visible = true, transformation(origin = {-106, -38}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 1000) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a HPStack annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-2, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Other Components
  Modelica.Blocks.Math.Gain H2_mflow(k = 0.00201588/(96485*2)*N_cells) annotation(
    Placement(visible = true, transformation(origin = {-28, 53}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  // Calculate the Nernst equilibrium potential
  Modelica.Blocks.Math.Gain O2_mflow(k = 0.0319988/(96485*4)*N_cells) annotation(
    Placement(visible = true, transformation(origin = {0, -29}, extent = {{8, -8}, {-8, 8}}, rotation = 90)));
  Modelica.Blocks.Math.Gain H2O_mflow_con(k = -0.01801528/(96485*2)*N_cells) annotation(
    Placement(visible = true, transformation(origin = {28, 53}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput I_PEMWE annotation(
    Placement(visible = true, transformation(origin = {-160, 76}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput TStack annotation(
    Placement(visible = true, transformation(origin = {-160, -38}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-40, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Fluid.simplePipe pipeCoolant(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {128, -10}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Fluid.Sensors.TemperatureTwoPort Water_Temp_In(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {126, 26}, extent = {{-8, 8}, {8, -8}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort Water_Temp_Out(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {118, -52}, extent = {{-10, -10}, {10, 10}})));
  VSourceNernst potentialSource annotation(
    Placement(transformation(origin = {-40, 100}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));  equation
//*** DEFINE EQUATIONS ***//
// Redeclare variables
  p_H2O = H2OToPEMWE.p;
  j = currentSensor.i/A_cell;
// Thermodynamics equations
// ELECTROCHEMICAL EQUATIONS //
  E_rev = 1.5184 - (1.5421e-3*T_stack) + (9.523e-5*T_stack*log(T_stack)) + (9.84e-8*(T_stack)^2);
//reversible voltage at T and 1 atm;
  E_tn = 1.485 - (1.49e-4*(T_stack - 273.15)) - (9.84e-8*(T_stack - 273.15)^2);
// Thermoneutral voltage at T and 1 atm
// Calculate the ovepotentials
// Calculate the voltage of the cell
  E_cell = E_rev + activation.E_act + ohmic.E_ohm + massTransport.E_diff;
// Electrical power  needed
  P_el = potentialSource.v*currentSensor.i;
// THERMAL EQUATIONS //
  P_th = (E_cell - E_tn)*abs(currentSensor.i)*N_cells;
  Q_rev = (E_tn - E_rev)*abs(currentSensor.i);
  Q_irr = (E_cell - E_rev)*abs(currentSensor.i);
// Assign the thermal power value to the heat flow component
  prescribedHeatFlow.Q_flow = P_th;
  T_water_in = Water_Temp_In.T;
  T_stack = max(TSStack.T, 288);
// Stack shouldn't have temperatures below ambient (TSStack has numerical issues when running FMU)
//*** DEFINE CONNECTIONS ***//
  connect(currentSensor.i, H2_mflow.u) annotation(
    Line(points = {{2, 89}, {-9.2, 89}, {-9.2, 53}, {-18.4, 53}}, color = {0, 0, 127}));
  connect(pin_n, ground.p) annotation(
    Line(points = {{-60, 150}, {-144, 150}}, color = {0, 0, 255}));
  connect(currentSensor.i, H2O_mflow_con.u) annotation(
    Line(points = {{2, 89}, {9.2, 89}, {9.2, 53}, {18.4, 53}}, color = {0, 0, 127}));
  connect(currentSensor.i, O2_mflow.u) annotation(
    Line(points = {{2, 89}, {2, 34.8}, {0, 34.8}, {0, -19.4}}, color = {0, 0, 127}));
  connect(O2_mflow.y, O2_IToM.m_flow_in) annotation(
    Line(points = {{0, -37.8}, {0, -82}, {66, -82}}, color = {0, 0, 127}));
  connect(H2_IToM.m_flow_in, H2_mflow.y) annotation(
    Line(points = {{-70, 53}, {-36.8, 53}, {-36.8, 53}}, color = {0, 0, 127}));
  connect(H2O_mflow_con.y, H2O_IToM.m_flow_in) annotation(
    Line(points = {{36.8, 53}, {52, 53}, {52, 62}, {68, 62}}, color = {0, 0, 127}));
  connect(H2O_IToM.ports[1], T_junc.port_3) annotation(
    Line(points = {{88, 54}, {116, 54}}, color = {0, 127, 255}));
  connect(O2_IToM.ports[1], O2ToTank) annotation(
    Line(points = {{86, -90}, {150, -90}}, color = {0, 127, 255}));
  connect(H2_IToM.ports[1], H2ToTank) annotation(
    Line(points = {{-90, 45}, {-120, 45}, {-120, 46}, {-150, 46}}, color = {0, 127, 255}));
  connect(thermalConductor.port_a, heatCapacitor.port) annotation(
    Line(points = {{80, 0}, {-48, 0}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, TSStack.port) annotation(
    Line(points = {{-48, 0}, {-48, 13}, {-96, 13}, {-96, -38}}, color = {191, 0, 0}));
  connect(prescribedHeatFlow.port, heatCapacitor.port) annotation(
    Line(points = {{-48, -12}, {-48, 0}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, HPStack) annotation(
    Line(points = {{-48, 0}, {-150, 0}}, color = {191, 0, 0}));
  connect(T_junc.port_1, H2OToPEMWE) annotation(
    Line(points = {{126, 64}, {126, 84}, {150, 84}}, color = {0, 127, 255}));
  connect(currentSensor.i, I_PEMWE) annotation(
    Line(points = {{2, 89}, {2, 76}, {-160, 76}}, color = {0, 0, 127}));
  connect(TStack, TSStack.T) annotation(
    Line(points = {{-160, -38}, {-117, -38}}, color = {0, 0, 127}));
  connect(thermalConductor.port_b, pipeCoolant.heat_port) annotation(
    Line(points = {{100, 0}, {111, 0}, {111, -10}, {123, -10}}, color = {191, 0, 0}));
  connect(pipeCoolant.port_b, Water_Temp_Out.port_a) annotation(
    Line(points = {{128, -30}, {108, -30}, {108, -52}}, color = {0, 127, 255}));
  connect(Water_Temp_Out.port_b, H2OToTank) annotation(
    Line(points = {{128, -52}, {128, -60}, {150, -60}}, color = {0, 127, 255}));
  connect(T_junc.port_2, Water_Temp_In.port_a) annotation(
    Line(points = {{126, 44}, {106, 44}, {106, 26}, {118, 26}}, color = {0, 127, 255}));
  connect(Water_Temp_In.port_b, pipeCoolant.port_a) annotation(
    Line(points = {{134, 26}, {140, 26}, {140, 10}, {128, 10}}, color = {0, 127, 255}));
  connect(currentSensor.n, ohmic.p) annotation(
    Line(points = {{12, 100}, {36, 100}, {36, 114}, {44, 114}}, color = {0, 0, 255}));
  connect(ohmic.n, activation.p) annotation(
    Line(points = {{64, 114}, {64, 101}, {76, 101}, {76, 114}}, color = {0, 0, 255}));
  connect(activation.n, massTransport.p) annotation(
    Line(points = {{96, 114}, {114, 114}}, color = {0, 0, 255}));
  connect(massTransport.n, pin_p) annotation(
    Line(points = {{134, 114}, {140, 114}, {140, 150}, {60, 150}}, color = {0, 0, 255}));
  connect(pin_n, potentialSource.n) annotation(
    Line(points = {{-60, 150}, {-60, 100}, {-50, 100}}, color = {0, 0, 255}));
  connect(potentialSource.p, currentSensor.p) annotation(
    Line(points = {{-30, 100}, {-8, 100}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1), graphics = {Line(origin = {20.1754, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {80, 0}, fillColor = {0, 178, 227}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Line(origin = {40.1315, 2}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {0.219199, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {-40.0001, 1.61404}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {-80, 0}, fillColor = {170, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Text(origin = {10, -54}, textColor = {255, 0, 0}, extent = {{-11, 6}, {11, -6}}, textString = "K"), Line(origin = {-20.0439, -0.307018}, points = {{0, 80}, {0, -80}, {0, -80}}), Rectangle(origin = {35, 54}, fillColor = {177, 177, 177}, fillPattern = FillPattern.Vertical, extent = {{-95, 26}, {25, -134}}), Text(origin = {-80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "C"), Text(origin = {80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "A"), Text(origin = {0, -88}, extent = {{-14, 16}, {14, -16}}, textString = "Stack"), Text(origin = {46, -110}, extent = {{-14, 16}, {14, -16}}, textString = "CoolOut", horizontalAlignment = TextAlignment.Left), Text(origin = {-3, 9}, extent = {{-45, 45}, {45, -45}}, textString = "Dev")}),
    Documentation(info = "<html><head></head><body>This model describes the dynamic behaviour of a proton exchange membrane water electrolyser cell (PEMWE). The model includes components describing the electrical, fluidic, and thermal properties of the cell.&nbsp;<div><br></div><div>The electrical performance is modelled using a 0-D polarization curve model , which incorporates Nernstian thermodynamic effects due to hydrogen and oxygen pressure changes, Tafel kinetics to calculate activation overpotentials, and an empirical relationship to calculate mass-transport overpotentials. These effects are combined in&nbsp;<span style=\"font-family: 'Courier New';\">potentialSource.v</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">,</span>which calculates the open-circuit voltage for a single cell, adjusts for hydrogen and oxygen partial pressures, subtracts the activation and mass-transport overpotentials, and finally multiplies by the number of cells in the stack. A simple resistor is included after the potential source to cover all Ohmic resistive losses in the fuel cell.</div><div><br></div><div>The fluidic performance is modelled using simple ideal flow components for the air and hydrogen gas lines, connected to mass sink boundary conditions. The magnitude of the mass sink is coupled to the electrical current in the cell using Faraday's law.&nbsp;</div><div><br></div><div>The thermal performance is considered by coupling a model describing the flow of liquid coolant to a thermal heat source. The magnitude of the heat source is calculated using the higher heating value of hydrogen and the calculated electrical voltage of the cell.</div><div><br></div><div>The hydrogen, air, and coolant ports can be connected to their respective subsystems, either by using the xx 
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
                <td align=\"Left\">N_cells </td>
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
    </div><div><div><span style=\"text-decoration: underline;\"><strong>Electrochemical equations:</strong></span></div><div>In the equations below, i<sub>stack</sub>&nbsp;represents the current flowing through the stack, accessible in the code as&nbsp;<font face=\"Courier New\">currentSensor.i</font>.</div><p><i><u>The Nernst equilibrium potential</u></i></p><p>U<sub>FC</sub><sup>Nernst&nbsp;</sup>= (U<sup>0</sup>&nbsp;-((RT)/(2F) ln( 1/(p<sub>H2</sub>&nbsp;(p<sub>O2</sub><sup>0.5</sup>))), U<sup>0&nbsp;</sup>= 1.229 V</p><p><span style=\"text-decoration: underline;\"><i>Activation overpotential</i></span></p><p>η<sup>act&nbsp;</sup>= b<sub>1&nbsp;</sub>ln( 1-(i<sub>cell&nbsp;</sub>+ i<sub>x</sub>) / i<sub>0</sub>)</p><p><u><i>Concentration overpotential</i></u></p><p>η<sup>con&nbsp;</sup>= -b<sub>2&nbsp;</sub>ln( 1-(i<sub>cell&nbsp;</sub>+ i<sub>x</sub>) / i<sub>L</sub>)</p><p><u><i>Cell voltage</i></u></p><p>V<sub>cell</sub>&nbsp;= N<sub>cell</sub>&nbsp;(U<sub>FC</sub><sup>Nernst</sup>&nbsp;- η<sup>act&nbsp;</sup>&nbsp;- i<sub>FC</sub>R<sub>0</sub>&nbsp;- η<sup>con</sup>)</p><p><span style=\"text-decoration: underline;\"><strong>Thermal equations:</strong></span></p><p><i><u>Electrochemical heat generation</u></i></p><p>Q<sub>gen</sub><sup>&nbsp;</sup>= (V<sub>TN</sub>&nbsp;- V<sub><font size=\"2\">cell</font></sub>)i<sub>cell</sub>, V<sub>TN</sub>&nbsp;= 1.481 V</p></div></body></html>"),
    uses(Modelica(version = "4.0.0")),
    experiment(StopTime = 3153600, Interval = 100, __Dymola_Algorithm = "Dassl"));
end Electrolyser_dev;
