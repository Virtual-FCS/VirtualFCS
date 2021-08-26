within VirtualFCS.Electrochemical.Hydrogen;

model FuelCellSystem

  // Fuel Cell Stack Paramters
  parameter Real m_FC_stack(unit = "kg") = 1 "FC stack mass";
  parameter Real V_FC_stack(unit = "m3") = 0.001 "FC stack volume";
  // Thermal parameters
  parameter Real Cp_FC_stack(unit = "J/(kg.K)") = 800 "FC stack specific heat capacity";
  // Stack design parameters
  parameter Real N_FC_stack(unit = "1") = 100 "FC stack number of cells";
  parameter Real A_FC_stack(unit = "m2") = 0.0237 "FC stack active area of cell";
  // Electrochemical parameters
  parameter Real i_0_FC_stack(unit = "A") = 0.0002 "FC stack cell exchange current";
  parameter Real i_L_FC_stack(unit = "A") = 520 "FC stack cell maximum limiting current";
  parameter Real i_x_FC_stack(unit = "A") = 0.001 "FC stack cell cross-over current";
  parameter Real b_1_FC_stack(unit = "V/dec") = 0.025 "FC stack cell Tafel slope";
  parameter Real b_2_FC_stack(unit = "V/dec") = 0.25 "FC stack cell trasport limitation factor";
  parameter Real R_0_FC_stack(unit = "Ohm") = 0.02 "FC stack cell ohmic resistance";
  parameter Real R_1_FC_stack(unit = "Ohm") = 0.01 "FC stack cell charge transfer resistance";
  parameter Real C_1_FC_stack(unit = "F") = 3e-3 "FC stack cell double layer capacitance";
  
  
  // H2 Subsystem Paramters
  parameter Real V_tank_H2(unit="m3") = 0.13 "H2 tank volume";
  parameter Real p_tank_H2(unit="Pa") = 3500000 "H2 tank initial pressure";
  

  VirtualFCS.Electrochemical.Hydrogen.FuelCellStack fuelCellStack(A_FC_stack = A_FC_stack, C_1_FC_stack = C_1_FC_stack, Cp_FC_stack = Cp_FC_stack, N_FC_stack = N_FC_stack, R_0_FC_stack = R_0_FC_stack, R_1_FC_stack = R_1_FC_stack, V_FC_stack = V_FC_stack, b_1_FC_stack = b_1_FC_stack, b_2_FC_stack = b_2_FC_stack, i_0_FC_stack = i_0_FC_stack, i_L_FC_stack = i_L_FC_stack, i_x_FC_stack = i_x_FC_stack, m_FC_stack = m_FC_stack)  annotation(
    Placement(visible = true, transformation(origin = {-1, 45}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.FuelCellSubSystems fuelCellSubSystems annotation(
    Placement(visible = true, transformation(origin = {-1, -25}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation(
    Placement(visible = true, transformation(origin = {-54, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = {-90, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {-36, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-94, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
equation
  connect(pin_p, fuelCellStack.pin_p) annotation(
    Line(points = {{40, 96}, {40, 96}, {40, 72}, {10, 72}, {10, 72}}, color = {0, 0, 255}));
  connect(fuelCellStack.port_b_Air, fuelCellSubSystems.air_port_a) annotation(
    Line(points = {{18, 32}, {18, -2}, {17, -2}}, color = {0, 127, 255}));
  connect(fuelCellSubSystems.air_port_b, fuelCellStack.port_a_Air) annotation(
    Line(points = {{22, -2}, {26, -2}, {26, 58}, {18, 58}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_b_H2, fuelCellSubSystems.H2_port_a) annotation(
    Line(points = {{-20, 32}, {-18, 32}, {-18, -2}, {-19, -2}}, color = {0, 127, 255}));
  connect(fuelCellSubSystems.H2_port_b, fuelCellStack.port_a_H2) annotation(
    Line(points = {{-24, -2}, {-26, -2}, {-26, 58}, {-20, 58}}, color = {0, 127, 255}));
  connect(multiplex2.y, fuelCellSubSystems.contolInput) annotation(
    Line(points = {{-42, -26}, {-32, -26}, {-32, -24}, {-32, -24}}, color = {0, 0, 127}, thickness = 0.5));
  connect(temperatureSensor.port, fuelCellStack.heatPort) annotation(
    Line(points = {{-100, -32}, {-118, -32}, {-118, 20}, {0, 20}, {0, 32}}, color = {191, 0, 0}));
  connect(temperatureSensor.T, multiplex2.u2[1]) annotation(
    Line(points = {{-80, -32}, {-68, -32}, {-68, -32}, {-66, -32}}, color = {0, 0, 127}));
  connect(pin_n, currentSensor.p) annotation(
    Line(points = {{-40, 96}, {-56, 96}, {-56, 72}, {-46, 72}, {-46, 72}}, color = {0, 0, 255}));
  connect(currentSensor.n, fuelCellStack.pin_n) annotation(
    Line(points = {{-26, 72}, {-12, 72}, {-12, 72}, {-12, 72}}, color = {0, 0, 255}));
  connect(currentSensor.i, multiplex2.u1[1]) annotation(
    Line(points = {{-36, 60}, {-40, 60}, {-40, 0}, {-74, 0}, {-74, -20}, {-66, -20}, {-66, -20}}, color = {0, 0, 127}));
  connect(fuelCellStack.port_b_Coolant, fuelCellSubSystems.coolant_port_b) annotation(
    Line(points = {{4, 30}, {4, 30}, {4, 12}, {-4, 12}, {-4, -2}, {-4, -2}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_a_Coolant, fuelCellSubSystems.coolant_port_a) annotation(
    Line(points = {{-6, 30}, {-6, 30}, {-6, 14}, {2, 14}, {2, -2}, {2, -2}}, color = {0, 127, 255}));
protected
end FuelCellSystem;
