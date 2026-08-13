within VirtualFCS.Examples.ElectrochemicalComponents;

model PolarizeFuelCellStack "Generate a polarization curve for a fuel cell stack."
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Area A_el = 0.03 "Electrode Area (m^2)";
  parameter Modelica.Units.SI.Current I_final = 370.0 "Final step current [A]" annotation(
    Placement(visible = false, transformation(extent = {{0, 0}, {0, 0}})));
  
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  //replaceable package Anode_Medium = VirtualFCS.Media.NH3Cracked;
  replaceable package Cathode_Medium = VirtualFCS.Media.CathodeAir;
  replaceable package Coolant_Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  inner Modelica.Fluid.System system(p_ambient(displayUnit = "Pa")) annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrochemical.Hydrogen.FuelCellSystem fcs(p_air_set = 2e5, p_H2_set = 2e5, N_cells = 180, fuelCell(redeclare VirtualFCS.Electrochemical.Hydrogen.VSourceNernst v_source, redeclare VirtualFCS.Electrochemical.Hydrogen.OhmicResistance ohmic, redeclare VirtualFCS.Electrochemical.Hydrogen.MassTransportLossSimple mass_transport, redeclare VirtualFCS.Electrochemical.Hydrogen.ActivationLossSimple activation(i_0 = 0.005), A_el = A_el, G_cool = 1500, cathode(R_flow = 1e6), anode(R_flow = 4e7)), subSystemAir(lambda = 1.7, compressor(compressor(eta = 0.9))), subSystemHydrogen( RR = 1.3, V_flow_HRB_min = 6e-4), redeclare package Cathode_Medium = Cathode_Medium, redeclare package Anode_Medium = Anode_Medium) annotation(
    Placement(transformation(extent = {{-22, -22}, {22, 22}})));
  Modelica.Electrical.Analog.Basic.VariableResistor resistor annotation(
    Placement(transformation(origin = {0, 40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-40, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression Resistance(y = fcs.N_cells*0.9/scalar(I_aprox.y)) annotation(
    Placement(transformation(origin = {54, 56}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.CombiTimeTable I_aprox(table = [0, 20; 50, 150; 100, I_final], smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {94, 56}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(ground.p, resistor.n) annotation(
    Line(points = {{-40, 40}, {-10, 40}}, color = {0, 0, 255}));
  connect(Resistance.y, resistor.R) annotation(
    Line(points = {{44, 56}, {0, 56}, {0, 52}}, color = {0, 0, 127}));
  connect(fcs.pin_p, resistor.p) annotation(
    Line(points = {{11, 20}, {10, 20}, {10, 40}}, color = {0, 0, 255}));
  connect(resistor.n, fcs.pin_n) annotation(
    Line(points = {{-10, 40}, {-12, 40}, {-12, 20}, {-11, 20}}, color = {0, 0, 255}));
  annotation(
    Icon,
    Documentation(info = "<html><head></head><body>This example demonstrates the setup for a fuel cell system to generate a polarization curve. The fuel cell stack is connected to subsystems for hydrogen, air, and cooling. The electrical load is provided by a ramp voltage source that sweeps the current domain over a period of 500 seconds.&nbsp;</body></html>"),
    experiment(StopTime = 150, Interval = 0.5, Tolerance = 1e-06, __Dymola_Algorithm = "Dassl"));
end PolarizeFuelCellStack;
