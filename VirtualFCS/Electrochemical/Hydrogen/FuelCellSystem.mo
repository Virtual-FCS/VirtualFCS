within VirtualFCS.Electrochemical.Hydrogen;

model FuelCellSystem
  // System
  outer Modelica.Fluid.System system "System properties";
  parameter Modelica.Units.SI.Mass m_FC_system = fuelCellStack.m_FC_stack + fuelCellSubSystems.m_FC_subsystems;
  // Fuel Cell Stack Paramters
  parameter Modelica.Units.SI.Mass m_FC_stack = 42 "FC stack mass";
  parameter Modelica.Units.SI.Length L_FC_stack = 0.420 "FC stack length";
  parameter Modelica.Units.SI.Breadth W_FC_stack = 0.582 "FC stack width";
  parameter Modelica.Units.SI.Height H_FC_stack = 0.156 "FC stack height";
  parameter Modelica.Units.SI.Volume vol_FC_stack = L_FC_stack * W_FC_stack * H_FC_stack "FC stack volume";
  //  parameter Real V_rated_FC_stack(unit="V") = 57.9 "Maximum stack operating voltage";
  parameter Modelica.Units.SI.Current I_nom_FC_stack = 280.0 "FC stack nominal current";
  parameter Modelica.Units.SI.Current I_rated_FC_stack = 320 "FC stack maximum operating current";
  // parameter Modelica.Units.SI.Current I_rated_FC_stack = 1.7 * I_nom_FC_stack "FC stack maximum operating current";
  parameter Real N_FC_stack(unit = "1") = 180 "FC stack number of cells";
  // H2 Subsystem Paramters
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.13 "H2 tank volume";
  parameter Modelica.Units.SI.Pressure p_tank_H2 = 35000000 "H2 tank initial pressure";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer heatTransferCoefficient = 12 "HeatTransferCoefficient (W/(m2.K))";
  // Power and efficiency calculations
  Modelica.Units.SI.Power Power_system "Power delivered from the FC system (Stack - BOP)";
  Modelica.Units.SI.Power Power_stack "Power delivered from the FC stack";
  Modelica.Units.SI.Power Power_BOP "Power consumed by the BOP components";
  Modelica.Units.SI.Efficiency eta_FC_sys "Fuel cell system efficiency";
  VirtualFCS.Electrochemical.Hydrogen.FuelCellStack fuelCellStack(H_FC_stack = H_FC_stack, I_rated_FC_stack = I_nom_FC_stack, L_FC_stack = L_FC_stack, N_FC_stack = N_FC_stack, W_FC_stack = W_FC_stack, i_L_FC_stack = I_rated_FC_stack, m_FC_stack = m_FC_stack, vol_FC_stack = vol_FC_stack) annotation(
    Placement(visible = true, transformation(origin = {-1, 10}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {46, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.FuelCellSubSystems fuelCellSubSystems(N_FC_stack = N_FC_stack,V_tank_H2 = V_tank_H2, p_tank_H2 = p_tank_H2) annotation(
    Placement(visible = true, transformation(origin = {-1, -60}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation(
    Placement(visible = true, transformation(origin = {-54, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = {-98, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {-58, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = I_rated_FC_stack, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  Power_stack = fuelCellStack.pin_n.i*fuelCellStack.pin_p.v;
  Power_BOP = fuelCellSubSystems.batterySystem.pin_n.i*fuelCellSubSystems.batterySystem.pin_p.v;
  Power_system = Power_stack - Power_BOP;
  eta_FC_sys = max((Power_system)/(286000*(N_FC_stack*(fuelCellStack.pin_n.i + 0.000001)/(2*96485.3321))), 0.001);
  connect(fuelCellStack.port_b_Air, fuelCellSubSystems.air_port_a) annotation(
    Line(points = {{18, -2}, {18, -37.5}, {16.5, -37.5}}, color = {0, 127, 255}));
  connect(fuelCellSubSystems.air_port_b, fuelCellStack.port_a_Air) annotation(
    Line(points = {{21.5, -37.5}, {26, -37.5}, {26, 22}, {18, 22}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_b_H2, fuelCellSubSystems.H2_port_a) annotation(
    Line(points = {{-20, -2}, {-18, -2}, {-18, -37.5}, {-18.5, -37.5}}, color = {0, 127, 255}));
  connect(fuelCellSubSystems.H2_port_b, fuelCellStack.port_a_H2) annotation(
    Line(points = {{-23.5, -37.5}, {-26, -37.5}, {-26, 22}, {-20, 22}}, color = {0, 127, 255}));
  connect(multiplex2.y, fuelCellSubSystems.contolInput) annotation(
    Line(points = {{-43, -60}, {-31, -60}}, color = {0, 0, 127}, thickness = 0.5));
  connect(temperatureSensor.T, multiplex2.u2[1]) annotation(
    Line(points = {{-88, -66}, {-66, -66}}, color = {0, 0, 127}));
  connect(fuelCellStack.port_a_Coolant, fuelCellSubSystems.coolant_port_b) annotation(
    Line(points = {{-6, -6}, {-6, 6}, {-3.5, 6}, {-3.5, -37.5}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_b_Coolant, fuelCellSubSystems.coolant_port_a) annotation(
    Line(points = {{4, -6}, {1.5, -6}, {1.5, -37.5}}, color = {0, 127, 255}));
  connect(temperatureSensor.port, fuelCellStack.heatPort) annotation(
    Line(points = {{-108, -66}, {-132, -66}, {-132, 76}, {-2, 76}, {-2, 22}, {-1, 22}}, color = {191, 0, 0}));
  connect(currentSensor.i, limiter.u) annotation(
    Line(points = {{-68, 46}, {-80, 46}, {-80, 12}, {-80, 12}}, color = {0, 0, 127}));
  connect(limiter.y, multiplex2.u1[1]) annotation(
    Line(points = {{-80, -12}, {-80, -12}, {-80, -54}, {-66, -54}, {-66, -54}}, color = {0, 0, 127}));
  connect(pin_n, currentSensor.p) annotation(
    Line(points = {{-40, 96}, {-58, 96}, {-58, 56}, {-58, 56}}, color = {0, 0, 255}));
  connect(currentSensor.n, fuelCellStack.pin_n) annotation(
    Line(points = {{-58, 36}, {-58, 30}, {-14, 30}}, color = {0, 0, 255}));
  connect(pin_p, fuelCellStack.pin_p) annotation(
    Line(points = {{46, 96}, {46, 30}, {12, 30}}, color = {0, 0, 255}));
protected
  annotation(
    Icon(graphics = {Text(origin = {-6, -250}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Rectangle(origin = {-55, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {58.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {-40, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-29.8, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-19.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-8.7, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {1.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {12.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {22.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {32.3, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {42.9, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The FuelCellSystem class packages together a <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">FuelCellStack</a> module and a&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.FuelCellSubSystems\">FuelCellSubSystems</a>&nbsp;module for controlling hydrogen, air, and coolant feeds into and out of the fuel cell.<div><br></div><div>The hydrogen, air, and coolant ports can be connected to their respective subsystems, either by using theblock, or individual&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen\">SubSystemHydrogen</a>,&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">SubSystemAir</a>, and&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCooling\">SubSystemCooling</a>&nbsp;blocks.</div><div><br></div><div>In addition to the coolant subsystem, it is assumed that the fuel cell stack exchanges heat with its surroundings by convection and radiation.</div><div><br></div><div><div>Default parameters fit the polarization curve given by Powercell in their Powercellution data sheet, available&nbsp;<a href=\"https://powercellution.com/p-stack\">here</a>.</div>&nbsp;<table border=\"0.9\"><caption align=\"Left\" style=\"text-align: left;\"><strong><u>Default Parameters</u></strong></caption><caption align=\"Left\" style=\"text-align: left;\"><strong><u><br></u></strong></caption><tbody><tr><th>Parameter name</th><th>Value</th><th>Unit</th></tr><tr><td align=\"Left\">m_FC_stack</td><td>=42</td><td align=\"Right\">kg</td></tr><tr><td align=\"Left\">L_FC_stack</td><td>=0.42</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">W_FC_stack</td><td>=0.582</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">H_FC_stack</td><td>=0.156</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">I_rated_FC_stack</td><td>=450</td><td align=\"Right\">A</td></tr><tr><td align=\"Left\">i_L_FC_stack</td><td>=760</td><td align=\"Right\">A</td></tr><tr><td align=\"Left\">N_FC_stack</td><td>=455</td><td align=\"Right\">-</td></tr><tr><td align=\"Left\">V_tank_H2</td><td>=0.13</td><td align=\"Right\">m<sup>3</sup></td></tr><tr><td align=\"Left\">p_tank_H2</td><td>=35000000</td><td align=\"Right\">Pa</td></tr>
<tr><td align=\"Left\">heatTransferCoefficient</td><td>=12</td><td align=\"Right\">W/(m<sup>2</sup> K)</td></tr><tr><td align=\"Left\"><br><u><b>Equations</b></u></td><td><br></td><td align=\"Right\"><br></td></tr></tbody></table><div><i><u>Convective Heat Transfer</u></i></div><div>Q<sub>conv</sub>&nbsp;= hA<sub>cool</sub>(T&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;T<sub>0</sub>); T<sub>0</sub>&nbsp;= 293 K</div><div><br></div><div><div><i><u>Radiative Heat Transfer</u></i></div><div>Q<sub>rad</sub>&nbsp;= 0.95A<sub>cool</sub><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">σ</span>(T<sup>4</sup>&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;T<sub>0</sub><sup>4</sup>), T<sub>0</sub> = 293 K</div></div></div></body></html>"));
end FuelCellSystem;
