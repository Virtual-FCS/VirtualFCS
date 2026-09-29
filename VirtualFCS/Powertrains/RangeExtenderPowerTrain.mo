within VirtualFCS.Powertrains;

model RangeExtenderPowertrain
  extends Powertrains.BatteryPowerTrain;
  
  parameter Modelica.Units.SI.AbsolutePressure p_air_set = 200000 "air outlet set pressure" annotation (
    Dialog(group = "Fuel Cell System Parameters"));
  parameter Modelica.Units.SI.AbsolutePressure p_H2_set = 200000 "H2 outlet set pressure" annotation (
    Dialog(group = "Fuel Cell System Parameters"));
  parameter Integer N_cells = 42 "FC stack number of cells" annotation (
    Dialog(group = "Fuel Cell System Parameters"));
  parameter Modelica.Units.SI.Volume V_tank_H2 = 0.606 "H2 tank volume" annotation (
    Dialog(group = "Fuel Cell System Parameters"));
  parameter Modelica.Units.SI.AbsolutePressure p_tank_H2 = 30000000 "H2 tank initial pressure" annotation (
    Dialog(group = "Fuel Cell System Parameters"));
  
  Electrochemical.Hydrogen.FuelCells.FuelCellSystem fuelCellSystem(p_air_set = p_air_set, p_H2_set = p_H2_set, N_cells = N_cells, V_tank_H2 = V_tank_H2, p_tank_H2 = p_tank_H2, redeclare SubSystems.Air.SubSystemAir subSystemAir(redeclare VirtualFCS.Fluid.CompressorSimple compressor, redeclare VirtualFCS.Fluid.Humidifier humidifier(L_fiber = 0.3, UA = 40, V_dry = 0.003, V_wet = 0.001, dFiber_i(displayUnit = "mm"), dFiber_o(displayUnit = "mm") = 0.0011, dHousing(displayUnit = "mm") = 0.14, dp_nominal = 1e4, m_flow_nom = 0.1, n = 2, nFibers = 4000), p_set = 2e5), fuelCell(redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.ActivationLossSimple activation, anode(R_flow = 10000), cathode(R_flow = 10000), redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.MassTransportLossSimple mass_transport, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.OhmicResistance ohmic, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.VSourceNernst v_source))  annotation(
    Placement(transformation(origin = {50, -30}, extent = {{-10, -10}, {10, 10}})));
equation

end RangeExtenderPowertrain;
