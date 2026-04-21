within VirtualFCS.Electrochemical.Hydrogen;

package Electrolysers
  extends Modelica.Icons.VariantsPackage;
  
  model Electrolyser
    // System
    outer Modelica.Fluid.System system "System properties";
    //*** DEFINE REPLACEABLE PACKAGES ***//
    // Medium models
    replaceable package H2_Medium = Modelica.Media.IdealGases.SingleGases.H2;
    replaceable package O2_Medium = Modelica.Media.IdealGases.SingleGases.O2;
    replaceable package H2O_Medium = AixLib.Media.Water;
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
    Modelica.Units.SI.Pressure p_H2;
    Modelica.Units.SI.Pressure p_O2;
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
    Modelica.Electrical.Analog.Sources.SignalVoltage potentialSource annotation(
      Placement(visible = true, transformation(origin = {-60, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
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
    Modelica.Blocks.Sources.RealExpression CellPotential(y = (E_rev + (R*TSStack.T)/(2*F)*(log((p_H2/p_H2O)*(p_O2/p_H2O)^0.5)) + activation.E_act + massTransport.E_diff + abs(ohmic.E_ohm/N_cells))*N_cells) annotation(
      Placement(visible = true, transformation(origin = {-94, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    equation
  //*** DEFINE EQUATIONS ***//
  // Redeclare variables
    p_H2 = H2ToTank.p;
    p_O2 = O2ToTank.p;
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
    connect(pin_n, potentialSource.n) annotation(
      Line(points = {{-60, 150}, {-60, 150}, {-60, 130}, {-60, 130}}, color = {0, 0, 255}));
    connect(potentialSource.p, currentSensor.p) annotation(
      Line(points = {{-60, 110}, {-31, 110}, {-31, 100}, {-8, 100}}, color = {0, 0, 255}));
    connect(currentSensor.i, H2_mflow.u) annotation(
      Line(points = {{2, 89}, {-9.2, 89}, {-9.2, 53}, {-18.4, 53}}, color = {0, 0, 127}));
    connect(pin_n, ground.p) annotation(
      Line(points = {{-60, 150}, {-144, 150}}, color = {0, 0, 255}));
    connect(CellPotential.y, potentialSource.v) annotation(
      Line(points = {{-83, 120}, {-72, 120}}, color = {0, 0, 127}));
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
  end Electrolyser;
  
  model ElectrolyserSystem
   // System
    outer Modelica.Fluid.System system "System properties";
    //*** DEFINE REPLACEABLE PACKAGES ***//
    // Medium models
    replaceable package H2_Medium = Modelica.Media.IdealGases.SingleGases.H2;
    replaceable package O2_Medium = Modelica.Media.IdealGases.SingleGases.O2;
    // replaceable package H2O_Medium = AixLib.Media.Water;
    replaceable package H2O_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
    //constrainedby Modelica.Media.Interfaces.PartialMedium;
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
    parameter Real N_cell(unit = "1") = 65 "Number of Cells";
    parameter Modelica.Units.SI.Area A_cell = 0.0214 "Active Area of the Cell";
    // Electrochemical parameters
    parameter Modelica.Units.SI.CurrentDensity i_0 = 1.7e-6 "Exchange Current density";
    parameter Modelica.Units.SI.CurrentDensity i_L = 6 "Maximum Current Limit density";
    parameter Modelica.Units.SI.CurrentDensity i_x = 0.001 "Cross-over Current density";
    //NA
    parameter Real a_C = 0.5 "Charge Transfer coefficient";
    parameter Real a_A = 0.5 "Charge Transfer coefficient";
    parameter Real lambda = 22 "Number of water molecules per sulfonic acid site";
    parameter Modelica.Units.SI.Thickness t_mem = 180e-6 "Membrane thickness";
    parameter Modelica.Units.SI.Thickness t_ele = 1e-3 "Electrode thickness";
    parameter Modelica.Units.SI.Resistivity rho_ele = 7.5e-5 "Electrode resistivity";
    //*** DECLARE VARIABLES ***//
    // Physical constants
    final constant Real R(final unit = "J/(mol.K)") = 8.3144598 "Molar gas constant";
    final constant Modelica.Units.SI.FaradayConstant F = 9.648533289e4 "Faraday constant, C/mol";
    // Variables to be logged
    Modelica.Units.SI.Power electrolyserPower "Power consumed by the electrolyser";
    Modelica.Units.SI.Mass hydrogenProduced "Amount of hydrogen produced by the electrolyser";
    Modelica.Units.SI.Efficiency electricEfficiency "Electrical efficiency of system";
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(visible = true, transformation(origin = {20, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(visible = true, transformation(origin = {-20, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Electrolyser electrolyser(m_cell = m_cell, v_cell = v_cell, Cp_cell = Cp_cell, N_cell = N_cell, A_cell = A_cell, i_0 = i_0, i_L = i_L, i_x = i_x, a_C = a_C, a_A = a_A, lambda = lambda, t_mem = t_mem, t_ele = t_ele, rho_ele = rho_ele, redeclare package H2O_Medium = H2O_Medium) annotation(
      Placement(transformation(extent = {{-40, -40}, {40, 40}})));
    Modelica.Fluid.Sources.FixedBoundary H2_tank(redeclare package Medium = H2_Medium, nPorts = 1, p = 3000000) annotation(
      Placement(visible = true, transformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Fluid.Sources.FixedBoundary O2_atm(redeclare package Medium = O2_Medium, nPorts = 1, p = 3000000) annotation(
      Placement(visible = true, transformation(origin = {90, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Fluid.Vessels.OpenTank tankWater(redeclare package Medium = H2O_Medium, crossArea = 1000, height = 0.5, level_start = 0.12, nPorts = 1, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, use_HeatTransfer = true, portsData = {Modelica.Fluid.Vessels.BaseClasses.VesselPortsData(diameter = 0.1)}, T_start = system.T_start) annotation(
      Placement(visible = true, transformation(origin = {90, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    SubSystems.Cooling.ThermalManagement thermalManagement(redeclare package H2O_Medium = H2O_Medium) annotation(
      Placement(transformation(origin = {-6, -20}, extent = {{28, -60}, {48, -40}})));
    Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(redeclare package Medium = H2O_Medium, V = 0.01) annotation(
      Placement(transformation(origin = {86, -74}, extent = {{-6, 6}, {6, -6}}, rotation = 90)));
    Modelica.Blocks.Math.Gain gain(k = 10*(0.01801528/(96485*2))*N_cell*100) annotation(
      Placement(transformation(origin = {-10, -12}, extent = {{16, -86}, {26, -76}}, rotation = -0)));
    Modelica.Electrical.Analog.Sources.ConstantVoltage voltageSource(V = 48) annotation(
      Placement(transformation(origin = {62, -44}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
    Modelica.Electrical.Analog.Basic.Ground ground annotation(
      Placement(transformation(origin = {40, -48}, extent = {{-10, -10}, {10, 10}})));
    Fluid.SimplePump pump(redeclare package Medium = H2O_Medium) annotation(
      Placement(transformation(origin = {56, -10}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  equation
    electrolyserPower = pin_n.i*pin_p.v;
    der(hydrogenProduced) = -electrolyser.H2_IToM.ports[1].m_flow;
    electricEfficiency = (-electrolyser.H2_IToM.ports[1].m_flow*119.96*10^6)/(max(electrolyserPower, 0.1))*100;
    connect(electrolyser.H2ToTank, H2_tank.ports[1]) annotation(
      Line(points = {{-28, 11}, {-74, 11}, {-74, 50}, {-80, 50}}, color = {0, 127, 255}));
    connect(thermalManagement.HotWaterOut, teeJunctionVolume.port_1) annotation(
      Line(points = {{43, -78}, {64.3, -78}, {64.3, -87.8}, {86, -87.8}, {86, -80}}, color = {0, 127, 255}));
    connect(teeJunctionVolume.port_3, tankWater.ports[1]) annotation(
      Line(points = {{92, -74}, {92, -20}, {90, -20}}, color = {0, 127, 255}));
    connect(electrolyser.TStack, gain.u) annotation(
      Line(points = {{-11, -24}, {-11, -93}, {5, -93}}, color = {0, 0, 127}));
    connect(pin_n, electrolyser.pin_n) annotation(
      Line(points = {{-20, 96}, {-20, 44}, {-19, 44}, {-19, 28}}, color = {0, 0, 255}));
    connect(ground.p, voltageSource.n) annotation(
      Line(points = {{40, -38}, {52, -38}, {52, -44}}, color = {0, 0, 255}));
    connect(voltageSource.n, pump.pin_n) annotation(
      Line(points = {{52, -44}, {52, -20}}, color = {0, 0, 255}));
    connect(voltageSource.p, pump.pin_p) annotation(
      Line(points = {{72, -44}, {72, -28}, {62, -28}, {62, -20}}, color = {0, 0, 255}));
    connect(teeJunctionVolume.port_2, pump.port_a) annotation(
      Line(points = {{86, -68}, {86, -24}, {66, -24}, {66, -10}}, color = {0, 127, 255}));
    connect(pump.port_b, electrolyser.H2OToPEMWE) annotation(
      Line(points = {{46, -2}, {36, -2}, {36, -18}, {30, -18}}, color = {0, 127, 255}));
    connect(gain.y, pump.u) annotation(
      Line(points = {{16, -92}, {120, -92}, {120, 6}, {56, 6}, {56, 0}}, color = {0, 0, 127}));
    connect(thermalManagement.HotWaterIn, electrolyser.H2OToTank) annotation(
      Line(points = {{22, -62}, {22, -30}}, color = {0, 127, 255}));
    connect(O2_atm.ports[1], electrolyser.O2ToTank) annotation(
      Line(points = {{80, 50}, {56, 50}, {56, 16}, {30, 16}, {30, 14}}, color = {0, 127, 255}));
    connect(pin_p, electrolyser.pin_p) annotation(
      Line(points = {{20, 96}, {20, 63}, {22, 63}, {22, 30}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Text(origin = {-6, -250}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Rectangle(origin = {-55, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {58.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {-40, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-29.8, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-19.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-8.7, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {1.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {12.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {22.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {32.3, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {42.9, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}})}, coordinateSystem(initialScale = 0.1)),
      Documentation(info = "<html><head></head><body>The FuelCellSystem class packages together a <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">FuelCellStack</a> module and a&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.FuelCellSubSystems\">FuelCellSubSystems</a>&nbsp;module for controlling hydrogen, air, and coolant feeds into and out of the fuel cell.<div><br></div><div>The hydrogen, air, and coolant ports can be connected to their respective subsystems, either by using theblock, or individual&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen\">SubSystemHydrogen</a>,&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">SubSystemAir</a>, and&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCooling\">SubSystemCooling</a>&nbsp;blocks.</div><div><br></div><div>In addition to the coolant subsystem, it is assumed that the fuel cell stack exchanges heat with its surroundings by convection and radiation.</div><div><br></div><div><div>Default parameters fit the polarization curve given by Powercell in their Powercellution data sheet, available&nbsp;<a href=\"https://powercellution.com/p-stack\">here</a>.</div>&nbsp;<table border=\"0.9\"><caption align=\"Left\" style=\"text-align: left;\"><strong><u>Default Parameters</u></strong></caption><caption align=\"Left\" style=\"text-align: left;\"><strong><u><br></u></strong></caption><tbody><tr><th>Parameter name</th><th>Value</th><th>Unit</th></tr><tr><td align=\"Left\">m_FC_stack</td><td>=42</td><td align=\"Right\">kg</td></tr><tr><td align=\"Left\">L_FC_stack</td><td>=0.42</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">W_FC_stack</td><td>=0.582</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">H_FC_stack</td><td>=0.156</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">I_rated_FC_stack</td><td>=450</td><td align=\"Right\">A</td></tr><tr><td align=\"Left\">i_L_FC_stack</td><td>=760</td><td align=\"Right\">A</td></tr><tr><td align=\"Left\">N_FC_stack</td><td>=455</td><td align=\"Right\">-</td></tr><tr><td align=\"Left\">V_tank_H2</td><td>=0.13</td><td align=\"Right\">m<sup>3</sup></td></tr><tr><td align=\"Left\">p_tank_H2</td><td>=35000000</td><td align=\"Right\">Pa</td></tr>
    <tr><td align=\"Left\">heatTransferCoefficient</td><td>=12</td><td align=\"Right\">W/(m<sup>2</sup> K)</td></tr><tr><td align=\"Left\"><br><u><b>Equations</b></u></td><td><br></td><td align=\"Right\"><br></td></tr></tbody></table><div><i><u>Convective Heat Transfer</u></i></div><div>Q<sub>conv</sub>&nbsp;= hA<sub>cool</sub>(T&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;T<sub>0</sub>); T<sub>0</sub>&nbsp;= 293 K</div><div><br></div><div><div><i><u>Radiative Heat Transfer</u></i></div><div>Q<sub>rad</sub>&nbsp;= 0.95A<sub>cool</sub><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">σ</span>(T<sup>4</sup>&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;T<sub>0</sub><sup>4</sup>), T<sub>0</sub> = 293 K</div></div></div></body></html>"),
      Diagram);
  
  
  end ElectrolyserSystem;
end Electrolysers;
