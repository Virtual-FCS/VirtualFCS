within VirtualFCS.Electrochemical.Hydrogen.Electrolysers_dev;

model ElectrolyserSystem_old
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package H2_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package O2_Medium = Modelica.Media.IdealGases.SingleGases.O2;
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
  parameter Real N_cells(unit = "1") = 65 "Number of Cells";
  parameter Modelica.Units.SI.Area A_cell = 0.0214 "Active Area of the Cell";
  // Electrochemical parameters
  parameter Modelica.Units.SI.CurrentDensity i_0 = 1.7e-6 "Exchange Current density";
  parameter Modelica.Units.SI.CurrentDensity i_L = 6 "Maximum Current Limit density";
  parameter Modelica.Units.SI.CurrentDensity i_x = 0.001 "Cross-over Current density";
  //NA
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
  Electrolyser_old electrolyser_old(m_cell = m_cell, v_cell = v_cell, Cp_cell = Cp_cell, N_cells = N_cells, A_cell = A_cell, i_0 = i_0, i_x = i_x, redeclare package H2O_Medium = H2O_Medium) annotation(
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
  Modelica.Blocks.Math.Gain gain(k = 10*(0.01801528/(96485*2))*N_cells*100) annotation(
    Placement(transformation(origin = {-10, -12}, extent = {{16, -86}, {26, -76}}, rotation = -0)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage voltageSource(V = 48) annotation(
    Placement(transformation(origin = {62, -44}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {40, -48}, extent = {{-10, -10}, {10, 10}})));
  Fluid.SimplePump pump(redeclare package Medium = H2O_Medium) annotation(
    Placement(transformation(origin = {56, -10}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  electrolyserPower = pin_n.i*pin_p.v;
  der(hydrogenProduced) = -electrolyser_old.H2_IToM.ports[1].m_flow;
  electricEfficiency = (-electrolyser_old.H2_IToM.ports[1].m_flow*119.96*10^6)/(max(electrolyserPower, 0.1))*100;
  connect(electrolyser_old.H2ToTank, H2_tank.ports[1]) annotation(
    Line(points = {{-28, 11}, {-74, 11}, {-74, 50}, {-80, 50}}, color = {0, 127, 255}));
  connect(thermalManagement.HotWaterOut, teeJunctionVolume.port_1) annotation(
    Line(points = {{43, -78}, {64.3, -78}, {64.3, -87.8}, {86, -87.8}, {86, -80}}, color = {0, 127, 255}));
  connect(teeJunctionVolume.port_3, tankWater.ports[1]) annotation(
    Line(points = {{92, -74}, {92, -20}, {90, -20}}, color = {0, 127, 255}));
  connect(electrolyser_old.TStack, gain.u) annotation(
    Line(points = {{-11, -24}, {-11, -93}, {5, -93}}, color = {0, 0, 127}));
  connect(pin_n, electrolyser_old.pin_n) annotation(
    Line(points = {{-20, 96}, {-20, 44}, {-19, 44}, {-19, 28}}, color = {0, 0, 255}));
  connect(ground.p, voltageSource.n) annotation(
    Line(points = {{40, -38}, {52, -38}, {52, -44}}, color = {0, 0, 255}));
  connect(voltageSource.n, pump.pin_n) annotation(
    Line(points = {{52, -44}, {52, -20}}, color = {0, 0, 255}));
  connect(voltageSource.p, pump.pin_p) annotation(
    Line(points = {{72, -44}, {72, -28}, {62, -28}, {62, -20}}, color = {0, 0, 255}));
  connect(teeJunctionVolume.port_2, pump.port_a) annotation(
    Line(points = {{86, -68}, {86, -24}, {66, -24}, {66, -10}}, color = {0, 127, 255}));
  connect(pump.port_b, electrolyser_old.H2OToPEMWE) annotation(
    Line(points = {{46, -2}, {36, -2}, {36, -18}, {30, -18}}, color = {0, 127, 255}));
  connect(gain.y, pump.u) annotation(
    Line(points = {{16, -92}, {120, -92}, {120, 6}, {56, 6}, {56, 0}}, color = {0, 0, 127}));
  connect(thermalManagement.HotWaterIn, electrolyser_old.H2OToTank) annotation(
    Line(points = {{22, -62}, {22, -30}}, color = {0, 127, 255}));
  connect(O2_atm.ports[1], electrolyser_old.O2ToTank) annotation(
    Line(points = {{80, 50}, {56, 50}, {56, 16}, {30, 16}, {30, 14}}, color = {0, 127, 255}));
  connect(pin_p, electrolyser_old.pin_p) annotation(
    Line(points = {{20, 96}, {20, 63}, {22, 63}, {22, 30}}, color = {0, 0, 255}));
  annotation(
    Icon(graphics = {Text(origin = {-6, -250}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Rectangle(origin = {-55, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {58.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {-40, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-29.8, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-19.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-8.7, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {1.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {12.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {22.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {32.3, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {42.9, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Text(origin = {0, -78}, textColor = {255, 255, 255}, extent = {{-34, 16}, {34, -16}}, textString = "Old")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The FuelCellSystem class packages together a <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">FuelCellStack</a> module and a&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.FuelCellSubSystems\">FuelCellSubSystems</a>&nbsp;module for controlling hydrogen, air, and coolant feeds into and out of the fuel cell.<div><br></div><div>The hydrogen, air, and coolant ports can be connected to their respective subsystems, either by using theblock, or individual&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen\">SubSystemHydrogen</a>,&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">SubSystemAir</a>, and&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCooling\">SubSystemCooling</a>&nbsp;blocks.</div><div><br></div><div>In addition to the coolant subsystem, it is assumed that the fuel cell stack exchanges heat with its surroundings by convection and radiation.</div><div><br></div><div><div>Default parameters fit the polarization curve given by Powercell in their Powercellution data sheet, available&nbsp;<a href=\"https://powercellution.com/p-stack\">here</a>.</div>&nbsp;<table border=\"0.9\"><caption align=\"Left\" style=\"text-align: left;\"><strong><u>Default Parameters</u></strong></caption><caption align=\"Left\" style=\"text-align: left;\"><strong><u><br></u></strong></caption><tbody><tr><th>Parameter name</th><th>Value</th><th>Unit</th></tr><tr><td align=\"Left\">m_FC_stack</td><td>=42</td><td align=\"Right\">kg</td></tr><tr><td align=\"Left\">L_FC_stack</td><td>=0.42</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">W_FC_stack</td><td>=0.582</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">H_FC_stack</td><td>=0.156</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">I_rated_FC_stack</td><td>=450</td><td align=\"Right\">A</td></tr><tr><td align=\"Left\">i_L_FC_stack</td><td>=760</td><td align=\"Right\">A</td></tr><tr><td align=\"Left\">N_FC_stack</td><td>=455</td><td align=\"Right\">-</td></tr><tr><td align=\"Left\">V_tank_H2</td><td>=0.13</td><td align=\"Right\">m<sup>3</sup></td></tr><tr><td align=\"Left\">p_tank_H2</td><td>=35000000</td><td align=\"Right\">Pa</td></tr>
  <tr><td align=\"Left\">heatTransferCoefficient</td><td>=12</td><td align=\"Right\">W/(m<sup>2</sup> K)</td></tr><tr><td align=\"Left\"><br><u><b>Equations</b></u></td><td><br></td><td align=\"Right\"><br></td></tr></tbody></table><div><i><u>Convective Heat Transfer</u></i></div><div>Q<sub>conv</sub>&nbsp;= hA<sub>cool</sub>(T&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;T<sub>0</sub>); T<sub>0</sub>&nbsp;= 293 K</div><div><br></div><div><div><i><u>Radiative Heat Transfer</u></i></div><div>Q<sub>rad</sub>&nbsp;= 0.95A<sub>cool</sub><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">σ</span>(T<sup>4</sup>&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;T<sub>0</sub><sup>4</sup>), T<sub>0</sub> = 293 K</div></div></div></body></html>"),
    Diagram);
end ElectrolyserSystem_old;
