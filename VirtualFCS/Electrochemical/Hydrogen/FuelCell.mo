within VirtualFCS.Electrochemical.Hydrogen;

model FuelCell
  extends VirtualFCS.Electrochemical.Hydrogen.FCInterface;
  
  import Modelica.Constants.F "Faraday constant";
  
  Modelica.Electrical.Analog.Sources.SignalVoltage reversible_voltage annotation(
    Placement(transformation(origin = {-60, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  ButlerVolmer catalytic_loss annotation(
    Placement(transformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Resistor ohmic_loss(R = r/A)  annotation(
    Placement(transformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.ConstantCurrent crossover_current(I = A*i_x)  annotation(
    Placement(transformation(origin = {0, 140}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));

  constant Integer n = 2 "Electrons exchanged in reaction";
  constant Modelica.Units.SI.Voltage E_rev0 = 1.23 "Reversible voltage at standard conditions";
  constant Modelica.Units.SI.Voltage E_th0 = 1.48 "Thermoneutral voltage at standard conditions";
  constant Modelica.Units.SI.MolarMass M_H2  = Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM "Molar mass of hydrogen";
  constant Modelica.Units.SI.MolarMass M_O2  = Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM "Molar mass of oxygen";
  constant Modelica.Units.SI.MolarMass M_H2O = Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM "Molar mass of water";

  parameter Integer N_cell = 42 "Number of cells in the stack";
  parameter Modelica.Units.SI.Area A = 0.1 "Membrane active area";
  parameter ArealResistivity r = 1 "Areal resistivity of the membrane to proton conduction";
  parameter Modelica.Units.SI.CurrentDensity i_0 = 2 "Mass-transport limiting current density";
  parameter Modelica.Units.SI.CurrentDensity i_x = 1E-3 "Cross-over current density";
  parameter Modelica.Units.SI.CurrentDensity i_L = 2 "Mass-transport limiting current density";
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor annotation(
    Placement(transformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(transformation(origin = {-30, -100}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(transformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain reaction_rate(k = N_cell/n/F)  annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Sources.MassFlowSource_T H2_sink(nPorts = 1, redeclare package Medium = Anode_Medium, use_m_flow_in = true)  annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Fluid.Sources.MassFlowSource_T O2_sink(nPorts = 1, redeclare package Medium = Cathode_Medium, use_m_flow_in = true)  annotation(
    Placement(transformation(origin = {90, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.MassFlowSource_T H2O_source(nPorts = 1, redeclare package Medium = Cathode_Medium, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain H2_stoich(k = -1*M_H2) annotation(
    Placement(transformation(origin = {-28, 8}, extent = {{-8, 8}, {8, -8}}, rotation = -180)));
  Modelica.Blocks.Math.Gain O2_stoich(k = -0.5*M_O2) annotation(
    Placement(transformation(origin = {28, 28}, extent = {{8, 8}, {-8, -8}}, rotation = 180)));
  Modelica.Blocks.Math.Gain H2O_stoich(k = +1*M_H2O) annotation(
    Placement(transformation(origin = {28, -12}, extent = {{8, 8}, {-8, -8}}, rotation = 180)));
equation
  connect(reversible_voltage.n, pin_n) annotation(
    Line(points = {{-60, 130}, {-60, 150}}, color = {0, 0, 255}));
  connect(ohmic_loss.n, pin_p) annotation(
    Line(points = {{40, 110}, {60, 110}, {60, 150}}, color = {0, 0, 255}));
  connect(heatCapacitor.port, heatPort) annotation(
    Line(points = {{0, -100}, {0, -150}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, temperatureSensor.port) annotation(
    Line(points = {{0, -100}, {-20, -100}}, color = {191, 0, 0}));
  connect(ohmic_loss.p, currentSensor.n) annotation(
    Line(points = {{20, 110}, {10, 110}}, color = {0, 0, 255}));
  connect(currentSensor.p, catalytic_loss.n) annotation(
    Line(points = {{-10, 110}, {-20, 110}}, color = {0, 0, 255}));
  connect(catalytic_loss.p, reversible_voltage.p) annotation(
    Line(points = {{-40, 110}, {-60, 110}}, color = {0, 0, 255}));
  connect(currentSensor.i, reaction_rate.u) annotation(
    Line(points = {{0, 100}, {0, 82}}, color = {0, 0, 127}));
  connect(crossover_current.n, pin_n) annotation(
    Line(points = {{-10, 140}, {-60, 140}, {-60, 150}}, color = {0, 0, 255}));
  connect(crossover_current.p, pin_p) annotation(
    Line(points = {{10, 140}, {60, 140}, {60, 150}}, color = {0, 0, 255}));
  connect(H2_stoich.y, H2_sink.m_flow_in) annotation(
    Line(points = {{-37, 8}, {-80, 8}}, color = {0, 0, 127}));
  connect(reaction_rate.y, H2_stoich.u) annotation(
    Line(points = {{0, 60}, {0, 8}, {-18, 8}}, color = {0, 0, 127}));
  connect(O2_stoich.y, O2_sink.m_flow_in) annotation(
    Line(points = {{37, 28}, {80, 28}}, color = {0, 0, 127}));
  connect(H2O_stoich.y, H2O_source.m_flow_in) annotation(
    Line(points = {{37, -12}, {80, -12}}, color = {0, 0, 127}));
  connect(H2O_stoich.u, reaction_rate.y) annotation(
    Line(points = {{18, -12}, {0, -12}, {0, 60}}, color = {0, 0, 127}));
  connect(O2_stoich.u, reaction_rate.y) annotation(
    Line(points = {{18, 28}, {0, 28}, {0, 60}}, color = {0, 0, 127}));
  connect(anode_in, anode_out) annotation(
    Line(points = {{-150, 40}, {-120, 40}, {-120, -40}, {-150, -40}}));
  connect(H2_sink.ports[1], anode_in) annotation(
    Line(points = {{-100, 0}, {-120, 0}, {-120, 40}, {-150, 40}}, color = {0, 127, 255}));
  connect(cathode_out, cathode_in) annotation(
    Line(points = {{150, -40}, {120, -40}, {120, 40}, {150, 40}}));
  connect(O2_sink.ports[1], cathode_in) annotation(
    Line(points = {{100, 20}, {120, 20}, {120, 40}, {150, 40}}, color = {0, 127, 255}));
  connect(H2O_source.ports[1], cathode_out) annotation(
    Line(points = {{100, -20}, {120, -20}, {120, -40}, {150, -40}}, color = {0, 127, 255}));
  annotation(
    Diagram);
end FuelCell;
