within VirtualFCS.Electrochemical.Examples;

model FuelCellSystemTest
  extends Modelica.Icons.Example;
  
  replaceable package Cathode_Medium = VirtualFCS.Media.MoistAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  Electrochemical.Hydrogen.FuelCells.FuelCellSystem fcs(redeclare package Cathode_Medium = Cathode_Medium, redeclare package Anode_Medium = Anode_Medium, fuelCell(redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.VSourceNernst v_source,redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.OhmicResistance ohmic, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.MassTransportLossSimple mass_transport, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.ActivationLossSimple activation, cathode(R_flow = 10000), anode(R_flow = 10000)), redeclare SubSystems.Air.SubSystemAir subSystemAir(redeclare VirtualFCS.Fluid.CompressorSimple compressor(redeclare package Medium = Cathode_Medium), p_set = 2e5, redeclare VirtualFCS.Fluid.Humidifier humidifier(redeclare package dry_medium = Cathode_Medium, redeclare package wet_medium = Cathode_Medium, UA = 40, n = 2, nFibers = 4000, m_flow_nom = 0.1, L_fiber = 0.3, dHousing (displayUnit = "mm")= 0.14, V_wet = 0.001, V_dry = 0.003, dFiber_i(displayUnit = "mm"), dFiber_o(displayUnit = "mm") = 0.0011, dp_nominal = 1e4))) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {0, 40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-40, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(height = -2.99, duration = 20, offset = 3, startTime = 20)  annotation(
    Placement(transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(resistor.p, fcs.pin_p) annotation(
    Line(points = {{10, 40}, {10, 18}}, color = {0, 0, 255}));
  connect(resistor.n, fcs.pin_n) annotation(
    Line(points = {{-10, 40}, {-10, 18}}, color = {0, 0, 255}));
  connect(ground.p, resistor.n) annotation(
    Line(points = {{-40, 40}, {-10, 40}}, color = {0, 0, 255}));
  connect(ramp.y, resistor.R) annotation(
    Line(points = {{-58, 70}, {0, 70}, {0, 52}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 60, Tolerance = 1e-06, Interval = 0.012),
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
annotation(Documentation(info = "<html><p>This integrated fuel-cell system test ramps the electrical load resistance from 3 ohm to 0.01 ohm over 20 s, starting at 20 s. </p><p>The cathode and anode flow resistances are 10000 and the compressor starts at 0.01 kg/s. </p></html>"));
end FuelCellSystemTest;
