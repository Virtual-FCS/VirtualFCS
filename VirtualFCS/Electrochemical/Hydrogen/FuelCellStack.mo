within VirtualFCS.Electrochemical.Hydrogen;
model FuelCellStack
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // System
  outer Modelica.Fluid.System system "System properties";
  // Medium models
  //replaceable package Cathode_Medium = Modelica.Media.Air.MoistAir;
  replaceable package Cathode_Medium = Buildings.Media.Air;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2 constrainedby
    Modelica.Media.Interfaces.PartialPureSubstance;
  replaceable package Coolant_Medium =
      Modelica.Media.Water.ConstantPropertyLiquidWater                                  constrainedby
    Modelica.Media.Interfaces.PartialMedium;
  //*** DECLARE PARAMETERS ***//
  // Physical parameters
  // Fuel Cell Stack Paramters
  parameter Modelica.Units.SI.Mass m_FC_stack = 42 "FC stack mass";
  parameter Modelica.Units.SI.Length L_FC_stack = 0.420 "FC stack length";
  parameter Modelica.Units.SI.Breadth W_FC_stack = 0.582 "FC stack width";
  parameter Modelica.Units.SI.Height H_FC_stack = 0.156 "FC stack height";
  parameter Modelica.Units.SI.Volume vol_FC_stack = L_FC_stack*W_FC_stack*H_FC_stack "FC stack volume";
  parameter Modelica.Units.SI.Current I_rated_FC_stack = 280 "FC stack rated current";
  parameter Modelica.Units.SI.Current i_L_FC_stack = 1.12 "FC stack cell maximum limiting current A/cm2";
  parameter Integer N_FC_stack = 180 "FC stack number of cells";
  parameter Modelica.Units.NonSI.Area_cm A_FC_surf = 285 "FC stack surface area";
  // Electrochemical parameters
  parameter Modelica.Units.SI.Current i_0_FC_stack = 0.0000193 "FC stack cell exchange current";
  parameter Modelica.Units.SI.Current i_x_FC_stack = 0.001 "FC stack cell cross-over current";
  //parameter Real b_1_FC_stack(unit = "V/dec") = 0.0985 "FC stack cell Tafel slope";
  //parameter Real b_2_FC_stack(unit = "V/dec") = 0.0985 "FC stack cell trasport limitation factor";
  parameter Modelica.Units.SI.Resistance R_O_FC_stack = 0.0923 "FC stack cell ohmic resistance";
  // Thermal parameters
  parameter Modelica.Units.SI.SpecificHeatCapacity Cp_FC_stack = 110.0 "FC stack specific heat capacity";
  parameter Modelica.Units.SI.Area A_cool_FCStack = L_FC_stack * W_FC_stack;//;
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer heatTransferCoefficient = 7.8 * 10 ^ 0.78 "HeatTransferCoefficient (W/(m2.K))";

  //*** DECLARE VARIABLES ***//
  // Physical constants
  constant Modelica.Units.SI.MolarHeatCapacity R = Modelica.Constants.R;
  constant Modelica.Units.SI.FaradayConstant F = Modelica.Constants.F;
  // Fuel cell variables
  Modelica.Units.SI.Voltage V_cell;
  Modelica.Units.SI.Power P_th;
  Modelica.Units.SI.Power P_cool;
  Modelica.Units.SI.AbsolutePressure p_H2(min = 0);
  Modelica.Units.SI.AbsolutePressure p_O2(min = 0);
  Modelica.Units.SI.AbsolutePressure p_0 = 100000 "Aprox. atmospheric pressure";
  //*** INSTANTIATE COMPONENTS ***//
  // Efficiencies
  Modelica.Units.SI.Efficiency eta_FC_LHV "Lower heating value efficiency of fuel cell stack";
  // Electrical Components
  // Fluid Components
  Modelica.Fluid.Interfaces.FluidPort_b port_b_H2(redeclare package Medium =
        Anode_Medium)                                                                      annotation (
    Placement(visible = true, transformation(origin = {-150, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_H2(redeclare package Medium =
        Anode_Medium)                                                                      annotation (
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_Coolant(redeclare package Medium =
        Coolant_Medium)                                                                           annotation (
    Placement(visible = true, transformation(origin = {-134, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_Coolant(redeclare package Medium =
        Coolant_Medium)                                                                           annotation (
    Placement(visible = true, transformation(origin = {130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe pipeCoolant(redeclare package Medium =
        Coolant_Medium,                                                                   T_start = 293.15, diameter = 0.003, length = 1, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, nParallel = 500, p_a_start = 102502, use_HeatTransfer = true) annotation (
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T O2_sink(redeclare package Medium =
        Cathode_Medium,                                                                      nPorts = 1, use_m_flow_in = true) annotation (
    Placement(visible = true, transformation(origin = {84, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Thermal Components
  // Other Components
  Modelica.Fluid.Sources.MassFlowSource_T H2_sink(redeclare package Medium =
        Anode_Medium,                                                                      nPorts = 1, use_T_in = true, use_m_flow_in = true) annotation (
    Placement(visible = true, transformation(origin = {-80, 41}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin = {60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin = {-60, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.SignalVoltage potentialSource annotation (
    Placement(visible = true, transformation(origin = {-60, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation (
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain H2_mflow(k = 0.002016/(96485*2)* N_FC_stack) annotation (
    Placement(visible = true, transformation(origin = {-33, 60}, extent = {{9, -9}, {-9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Gain O2_mflow(k = 0.02897/(96485*4*0.21)*N_FC_stack) annotation (
    Placement(visible = true, transformation(origin = {34, 60}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 10000) annotation (
    Placement(visible = true, transformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
    Placement(visible = true, transformation(origin = {0, -144}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin={-32,70},  extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = Cp_FC_stack*m_FC_stack, T(fixed = true, start = 293.15), der_T(fixed = false)) annotation (
    Placement(visible = true, transformation(origin = {0, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation (
    Placement(visible = true, transformation(origin = {48, -114}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin={-218,140},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation (
    Placement(visible = true, transformation(origin = {-50, -92}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_Air(redeclare package Medium =
        Cathode_Medium)                                                                       annotation (
    Placement(visible = true, transformation(origin = {150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_Air(redeclare package Medium =
        Cathode_Medium)                                                                       annotation (
    Placement(visible = true, transformation(origin = {150, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(redeclare package
      Medium =
        Cathode_Medium,                                                                                  V = 0.01) annotation (
    Placement(visible = true, transformation(origin = {120, 38}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifice(redeclare package Medium =
        Cathode_Medium,
    diameter=0.01,                                                                                                 zeta = 0.7)  annotation (
    Placement(visible = true, transformation(origin = {96, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume1(redeclare
      package Medium =
        Anode_Medium,                                                                                  V = 0.01) annotation (
    Placement(visible = true, transformation(origin = {-126, 44}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Fluid.Fittings.SimpleGenericOrifice simpleGenericOrifice(redeclare
      package Medium =
        Anode_Medium,                                                                                       diameter = 0.003, zeta = 0.7) annotation (
    Placement(visible = true, transformation(origin = {-104, 14}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y=
        heatTransferCoefficient*A_cool_FCStack)                                                                  annotation (
    Placement(visible = true, transformation(origin={62,-166},    extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation (
    Placement(visible = true, transformation(origin={22,-166},    extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr=0.95*
        A_cool_FCStack)                                                                             annotation (
    Placement(visible = true, transformation(origin={-18,-166},   extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatBoundary annotation (
    Placement(visible = true, transformation(origin={2,-196},     extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin={34,70},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput FCStack_V annotation (Placement(
        transformation(extent={{-120,104},{-140,124}}), iconTransformation(
          extent={{-120,104},{-140,124}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-102,114})));
  Modelica.Blocks.Interfaces.RealInput FCDeg_new
    annotation (Placement(transformation(extent={{-190,-138},{-150,-98}})));
equation
//*** DEFINE EQUATIONS ***//
// Redeclare variables
  p_H2 = H2_sink.ports[1].p*0.00001;
  p_O2 = 0.2*O2_sink.ports[1].p*0.00001;
// ELECTROCHEMICAL EQUATIONS //
// Calculate the stack voltage
//  potentialSource.v = N_FC_stack*(1.229 - R*temperatureSensor.T/(2*F)*log(1/(p_H2*(p_O2)^0.5)) - b_1_FC_stack*log10((abs(currentSensor.i) + i_x_FC_stack)/i_0_FC_stack) + b_2_FC_stack*log10(1 - (abs(currentSensor.i) + i_x_FC_stack)/i_L_FC_stack));
  potentialSource.v = (N_FC_stack*((1.229 - (R*temperatureSensor.T)/(2*F)*log(p_H2*(p_O2^0.5)) - (0.85*0.001)*(temperatureSensor.T - 298.15) - R_O_FC_stack*(abs(currentSensor.i)/A_FC_surf) - (R*temperatureSensor.T)/(2*F*0.3419)*log(max(abs((currentSensor.i/A_FC_surf)/i_0_FC_stack), 0.00001)) + (R*1.4672*temperatureSensor.T)/(2*F)*log(1 - (abs(currentSensor.i/A_FC_surf)/i_L_FC_stack)))));//-FCDeg_new;
// Calculate the voltage of the cell
  V_cell = if potentialSource.v/N_FC_stack >1 then 0.9 else potentialSource.v/N_FC_stack;
// THERMAL EQUATIONS //
  P_th = (1.481 - V_cell)*abs(currentSensor.i)*N_FC_stack; //Heat generated in the FC stack
  P_cool= (1.253- V_cell)*abs(currentSensor.i)*N_FC_stack; // Heat removed by the cooling system
// Assign the thermal power value to the heat flow component
  prescribedHeatFlow.Q_flow = P_th;
// Efficiencies
  eta_FC_LHV = V_cell/1.254;
//*** DEFINE CONNECTIONS ***//
  connect(pipeCoolant.port_b, port_b_Coolant) annotation (
    Line(points = {{10, -40}, {130, -40}}, color = {255, 0, 0}, thickness = 1));
  connect(pipeCoolant.port_a, port_a_Coolant) annotation (
    Line(points = {{-10, -40}, {-134, -40}}, color = {0, 0, 255}, thickness = 1));
  connect(pin_n, potentialSource.n) annotation (
    Line(points = {{-60, 150}, {-60, 150}, {-60, 130}, {-60, 130}}, color = {0, 0, 255}));
  connect(O2_mflow.y, O2_sink.m_flow_in) annotation (
    Line(points={{42.8,60},{74,60},{74,48}},      color = {0, 0, 127}));
  connect(H2_mflow.y, H2_sink.m_flow_in) annotation (
    Line(points={{-42.9,60},{-68,60},{-68,49},{-70,49}},        color = {0, 0, 127}));
  connect(thermalConductor.port_b, pipeCoolant.heatPorts[1]) annotation (
    Line(points={{0,-56},{0,-50},{0,-44.4},{0.1,-44.4}},
                                        color = {191, 0, 0}));
  connect(thermalConductor.port_a, heatCapacitor.port) annotation (
    Line(points = {{0, -76}, {0, -76}, {0, -114}, {0, -114}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, heatPort) annotation (
    Line(points = {{0, -114}, {0, -114}, {0, -144}, {0, -144}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, prescribedHeatFlow.port) annotation (
    Line(points = {{0, -114}, {38, -114}, {38, -114}, {38, -114}}, color = {191, 0, 0}));
  connect(pin_n, ground.p) annotation (
    Line(points={{-60,150},{-60,138},{-82,138},{-82,156},{-218,156},{-218,150}},
                                                                       color = {0, 0, 255}));
  connect(temperatureSensor.port, heatCapacitor.port) annotation (
    Line(points = {{-50, -102}, {-50, -102}, {-50, -114}, {2, -114}, {2, -114}, {0, -114}}, color = {191, 0, 0}));
  connect(temperatureSensor.T, H2_sink.T_in) annotation (
    Line(points={{-50,-81},{-50,-81},{-50,44},{-68,44},{-68,45}},            color = {0, 0, 127}));
  connect(currentSensor.n, potentialSource.p) annotation (
    Line(points = {{-10, 100}, {-60, 100}, {-60, 110}, {-60, 110}}, color = {0, 0, 255}));
  connect(currentSensor.i, H2_mflow.u) annotation (
    Line(points={{0,89},{-8,89},{-8,60},{-22.2,60}},        color = {0, 0, 127}));
  connect(currentSensor.i, O2_mflow.u) annotation (
    Line(points={{0,89},{10,89},{10,60},{24.4,60},{24.4,60}},        color = {0, 0, 127}));
  connect(currentSensor.p, pin_p) annotation (
    Line(points = {{10, 100}, {60, 100}, {60, 150}}, color = {0, 0, 255}));
  connect(teeJunctionVolume.port_1, port_a_Air) annotation (
    Line(points = {{120, 48}, {122, 48}, {122, 80}, {150, 80}}, color = {0, 127, 255}));
  connect(teeJunctionVolume.port_3, O2_sink.ports[1]) annotation (
    Line(points = {{110, 38}, {94, 38}, {94, 40}}, color = {0, 127, 255}));
  connect(teeJunctionVolume.port_2, orifice.port_a) annotation (
    Line(points = {{120, 28}, {96, 28}, {96, 20}}, color = {0, 127, 255}));
  connect(orifice.port_b, port_b_Air) annotation (
    Line(points = {{96, 0}, {97, 0}, {97, -8}, {150, -8}}, color = {0, 127, 255}));
  connect(teeJunctionVolume1.port_3, H2_sink.ports[1]) annotation (
    Line(points={{-116,44},{-106,44},{-106,41},{-90,41}},          color = {0, 127, 255}));
  connect(teeJunctionVolume1.port_1, port_a_H2) annotation (
    Line(points = {{-126, 54}, {-126, 80}, {-150, 80}}, color = {0, 127, 255}));
  connect(teeJunctionVolume1.port_2, simpleGenericOrifice.port_a) annotation (
    Line(points = {{-126, 34}, {-126, 30}, {-104, 30}, {-104, 24}}, color = {0, 127, 255}));
  connect(simpleGenericOrifice.port_b, port_b_H2) annotation (
    Line(points = {{-104, 4}, {-104, -4}, {-150, -4}}, color = {0, 127, 255}));
  connect(convection.Gc,setConvectiveCoefficient. y) annotation (
    Line(points={{32,-166},{45.5,-166}},                            color = {0, 0, 127}));
  connect(bodyRadiation.port_b,heatBoundary)  annotation (
    Line(points={{-18,-176},{-18,-178},{2,-178},{2,-196}},                                  color = {191, 0, 0}));
  connect(convection.fluid,heatBoundary)  annotation (
    Line(points={{22,-176},{22,-178},{2,-178},{2,-196}},                                    color = {191, 0, 0}));
  connect(bodyRadiation.port_a, heatPort) annotation (Line(points={{-18,-156},{-18,
          -144},{0,-144}}, color={191,0,0}));
  connect(convection.solid, heatPort)
    annotation (Line(points={{22,-156},{22,-144},{0,-144}}, color={191,0,0}));
  connect(potentialSource.n, voltageSensor.n) annotation (Line(points={{-60,130},
          {-60,132},{-102,132},{-102,124}}, color={0,0,255}));
  connect(potentialSource.p, voltageSensor.p) annotation (Line(points={{-60,110},
          {-60,98},{-102,98},{-102,104}}, color={0,0,255}));
  connect(voltageSensor.v, FCStack_V)
    annotation (Line(points={{-113,114},{-130,114}}, color={0,0,127}));
  connect(FCStack_V, FCStack_V)
    annotation (Line(points={{-130,114},{-130,114}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1), graphics={  Line(origin = {20.1754, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {80, 0}, fillColor = {0, 178, 227}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Line(origin = {40.1315, 2}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {0.219199, 1.92106}, points = {{0, 78}, {0, -80}, {0, -82}}), Line(origin = {-40.0001, 1.61404}, points = {{0, 78}, {0, -80}, {0, -82}}), Rectangle(origin = {-80, 0}, fillColor = {170, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-20, 100}, {20, -100}}), Text(origin = {10, -54}, textColor = {255, 0, 0}, extent = {{-11, 6}, {11, -6}}, textString = "K"), Line(origin = {-20.0439, -0.307018}, points = {{0, 80}, {0, -80}, {0, -80}}), Rectangle(origin = {35, 54}, fillColor = {177, 177, 177}, fillPattern = FillPattern.Vertical, extent = {{-95, 26}, {25, -134}}), Text(origin = {-80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "A"), Text(origin = {80, 6}, extent = {{-26, 24}, {26, -24}}, textString = "C")}),
    Documentation(info="<html>
<p>This model describes the dynamic behaviour of a proton exchange membrane fuel cell (PEMFC) stack. The model includes components describing the electrical, fluidic, and thermal properties of the stack.&nbsp;</p>
<p>The electrical performance is modelled using a 0-D polarization curve model , which incorporates Nernstian thermodynamic effects due to hydrogen and oxygen pressure changes, Tafel kinetics to calculate activation overpotentials, and an empirical relationship to calculate mass-transport overpotentials. These effects are combined in&nbsp;<span style=\"font-family: Courier New;\">potentialSource.v<span style=\"font-size: 12pt;\">,</span>which calculates the open-circuit voltage for a single cell, adjusts for hydrogen and oxygen partial pressures, subtracts the activation and mass-transport overpotentials, and finally multiplies by the number of cells in the stack. A simple resistor is included after the potential source to cover all Ohmic resistive losses in the fuel cell. Default parameters fit the polarization curve given by Powercell in their Powercellution data sheet, available <a href=\"https://powercellution.com/p-stack\">here</a>.</p>
<p>The fluidic performance is modelled using simple ideal flow components for the air and hydrogen gas lines, connected to mass sink boundary conditions. The magnitude of the mass sink is coupled to the electrical current in the stack using Faraday&apos;s law.&nbsp;&nbsp; </p>
<p>The thermal performance is considered by coupling a model describing the flow of liquid coolant to a thermal heat source. The magnitude of the heat source is calculated using the higher heating value of hydrogen and the calculated electrical voltage of the cell.</p>
<p>The hydrogen, air, and coolant ports can be connected to their respective subsystems, either by using the <a href=\"modelica://VirtualFCS.SubSystems.FuelCellSubSystems\">FuelCellSubSystems</a> block, or individual <a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen\">SubSystemHydrogen</a>, <a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">SubSystemAir</a>, and <a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCooling\">SubSystemCooling</a> blocks.</p><p>&nbsp; </p>
<p><u><b>Default Parameters</b></u></p>
<p><u><b></p><p></b></u></p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0.9\"><tr>
<td><p align=\"center\"><h4>Parameter name</h4></p></td>
<td><p align=\"center\"><h4>Value</h4></p></td>
<td><p align=\"center\"><h4>Unit</h4></p></td>
</tr>
<tr>
<td><p>m_FC_stack</p></td>
<td><p>=42</p></td>
<td><p align=\"right\">kg</p></td>
</tr>
<tr>
<td><p>L_FC_stack</p></td>
<td><p>=0.42</p></td>
<td><p align=\"right\">m</p></td>
</tr>
<tr>
<td><p>W_FC_stack</p></td>
<td><p>=0.582</p></td>
<td><p align=\"right\">m</p></td>
</tr>
<tr>
<td><p>H_FC_stack</p></td>
<td><p>=0.156</p></td>
<td><p align=\"right\">m</p></td>
</tr>
<tr>
<td><p>I_rated_FC_stack</p></td>
<td><p>=450</p></td>
<td><p align=\"right\">A</p></td>
</tr>
<tr>
<td><p>i_L_FC_stack</p></td>
<td><p>=760</p></td>
<td><p align=\"right\">A</p></td>
</tr>
<tr>
<td><p>N_FC_stack</p></td>
<td><p>=455</p></td>
<td><p align=\"right\">-</p></td>
</tr>
<tr>
<td><p>i_0_FC_stack</p></td>
<td><p>=0.0091</p></td>
<td><p align=\"right\">A</p></td>
</tr>
<tr>
<td><p>i_x_FC_stack</p></td>
<td><p>=0.001</p></td>
<td><p align=\"right\">A</p></td>
</tr>
<tr>
<td><p>b_1_FC_stack</p></td>
<td><p>=0.0985</p></td>
<td><p align=\"right\">V/dec</p></td>
</tr>
<tr>
<td><p>b_2_FC_stack</p></td>
<td><p>=0.0985</p></td>
<td><p align=\"right\">V/dec</p></td>
</tr>
<tr>
<td><p>R_0</p></td>
<td><p>=0.00022*N_FC_stack</p></td>
<td><p align=\"right\">Ohm</p></td>
</tr>
<tr>
<td><p>Cp</p></td>
<td><p>=1100</p></td>
<td><p>J/(kg.K)</p></td>
</tr>
</table>
<p><u><b>Electrochemical equations: </b></u></p>
<p>In the equations below, i<sub>stack</sub>&nbsp;represents the current flowing through the stack, accessible in the code as <span style=\"font-family: Courier New;\">currentSensor.i</span>.</p>
<p><u><i>The Nernst equilibrium potential, per cell</u>&nbsp;</i></p>
<p>U<sub>FC<sup>Nernst </sup>= (U<sup>0</sup> -((RT)/(2F) ln( 1/(p<sub>H2</sub> (p<sub>O2<sup>0.5</sup>))), U<sup>0 </sup>= 1.229 V</p>
<p><u><i>Activation overpotential, per cell</i></u></p>
<p>&eta;<sup>act </sup>= b<sub>1 </sub>ln( 1-(i<sub>stack&nbsp;</sub>+ i<sub>x</sub>) / i<sub>0</sub>)</p>
<p><u><i>Concentration overpotential, per cell</i></u></p>
<p>&eta;<sup>con </sup>= -b<sub>2 </sub>ln( 1-(i<sub>stack&nbsp;</sub>+ i<sub>x</sub>) / i<sub>L</sub>)</p>
<p><u><i>Stack voltage</i></u></p>
<p>V<sub>stack</sub> = N<sub>cell</sub> (U<sub>FC<sup>Nernst</sup>&nbsp;- &eta;<sup>act&nbsp;</sup>&nbsp;- i<sub>FC</sub>R<sub>0</sub> - &eta;<sup>con</sup>)</p>
<p><u><b>Thermal equations:</b> </u></p>
<p><u><i>Electrochemical heat generation</i></u></p>
<p>Q<sub>gen<sup>&nbsp;</sup>= (V<sub>TN</sub> - V<sub><span style=\"font-size: 8pt;\">stack</span></sub>)i<sub>stack</sub>, V<sub>TN</sub> = 1.481 V</p>
<p>&nbsp; </p>
</html>"));
end FuelCellStack;
