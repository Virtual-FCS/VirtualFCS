within VirtualFCS.Powertrains;

model RangeExtenderPowertrain_ECMS
  

extends Powertrains.BatteryPowertrain;
  replaceable package Cathode_Medium = Media.MoistAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;

  parameter Integer N_cells = 42 "Number of cells in stack";

  Electrochemical.Hydrogen.FuelCells.FuelCellSystem fuelCellSystem(redeclare package Cathode_Medium = Cathode_Medium, redeclare package Anode_Medium = Anode_Medium, p_air_set = 200000, p_H2_set = 200000, N_cells = N_cells, V_tank_H2 = 0.606, p_tank_H2 = 3000000, redeclare SubSystems.Air.SubSystemAir subSystemAir(redeclare VirtualFCS.Fluid.CompressorSimple compressor(redeclare package Medium = Cathode_Medium), p_set = 2e5, redeclare VirtualFCS.Fluid.Humidifier humidifier(redeclare package dry_medium = Cathode_Medium, redeclare package wet_medium = Cathode_Medium, L_fiber = 0.3, UA = 40, V_dry = 0.003, V_wet = 0.001, dFiber_i(displayUnit = "mm"), dFiber_o(displayUnit = "mm") = 0.0011, dHousing(displayUnit = "mm") = 0.14, dp_nominal = 1e4, m_flow_nom = 0.1, n = 1, nFibers = 4000)), fuelCell(redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.ActivationLossSimple activation, anode(R_flow = 10000), cathode(R_flow = 10000), redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.MassTransportLossSimple mass_transport, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.OhmicResistance ohmic, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.VSourceNernst v_source))  annotation(
    Placement(transformation(origin = {50, -30}, extent = {{-10, -10}, {10, 10}})));
  // dC_converter.pin_pBus/pin_nBus (not pin_pFC/pin_nFC) drive the fuel cell system's
  // current here, so deadTime.y_start (not powerController.y_start) must be nonzero
  // to avoid div-by-0 in compressor.set_mass_flow at t=0
  VirtualFCS.Electrical.DC_converter dC_converter(deadTime(y_start = 1)) annotation(
    Placement(transformation(origin = {10, 2}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.MultiSensor multiSensor annotation(
    Placement(transformation(origin = {38, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
    Placement(transformation(origin = {30, -24}, extent = {{-4, -4}, {4, 4}})));
  Control.ECMS.EMS_ECMS ems_ecms(n_cell = N_cells)  annotation(
    Placement(transformation(origin = {-64, -64}, extent = {{-20, -10}, {20, 10}})));
  Modelica.Blocks.Sources.RealExpression getBatteryVoltage(y = batterySystem.pin_p.v) annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression getBatteryCurrent(y = batterySystem.pin_n.i) annotation(
    Placement(transformation(origin = {-110, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression getPowerDemand(y = pin_n.i*pin_p.v) annotation(
    Placement(transformation(origin = {-110, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression getFcTemp(y = fuelCellSystem.temperatureSensor.T) annotation(
    Placement(transformation(origin = {-110, -84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression getP_H2(y = fuelCellSystem.fuelCell.p_H2) annotation(
    Placement(transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression getP_O2(y = fuelCellSystem.fuelCell.p_O2) annotation(
    Placement(transformation(origin = {-110, -114}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression get_phi(y = fuelCellSystem.fuelCell.phi) annotation(
    Placement(transformation(origin = {-110, -130}, extent = {{-10, -10}, {10, 10}})));
  VirtualFCS.Control.FuelCellSystemController fuelCellSystemController annotation(
    Placement(transformation(origin = {10, -70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(dC_converter.pin_nFC, batterySystem.pin_n) annotation(
    Line(points = {{0, -8}, {-34, -8}, {-34, -20}}, color = {0, 0, 255}, thickness = 0.75));
  connect(dC_converter.pin_pFC, batterySystem.pin_p) annotation(
    Line(points = {{0, 12}, {-26, 12}, {-26, -20}}, color = {0, 0, 255}, thickness = 0.75));
  connect(dC_converter.pin_nBus, fuelCellSystem.pin_n) annotation(
    Line(points = {{20, -8}, {46, -8}, {46, -20}}, color = {0, 0, 255}, thickness = 0.75));
  connect(dC_converter.pin_pBus, multiSensor.pc) annotation(
    Line(points = {{20, 12}, {28, 12}}, color = {0, 0, 255}));
  connect(multiSensor.nc, fuelCellSystem.pin_p) annotation(
    Line(points = {{48, 12}, {56, 12}, {56, -20}}, color = {0, 0, 255}));
  connect(dC_converter.pin_nBus, multiSensor.nv) annotation(
    Line(points = {{20, -8}, {38, -8}, {38, 2}}, color = {0, 0, 255}));
  connect(dC_converter.pin_pBus, multiSensor.pv) annotation(
    Line(points = {{20, 12}, {20, 22}, {38, 22}}, color = {0, 0, 255}));
  connect(fuelCellSystem.pin_n, ground1.p) annotation(
    Line(points = {{46, -20}, {30, -20}}, color = {0, 0, 255}));
  connect(ems_ecms.inputSOC, batterySystem.sensorOutput) annotation(
    Line(points = {{-86, -64}, {-92, -64}, {-92, -30}, {-40, -30}}, color = {0, 0, 127}));
  connect(fuelCellSystemController.setCurrent, dC_converter.I_Ref) annotation(
    Line(points = {{22, -70}, {74, -70}, {74, 32}, {10, 32}, {10, 14}}, color = {0, 0, 127}));
  connect(multiSensor.v, fuelCellSystemController.fcVoltage) annotation(
    Line(points = {{44, 2}, {44, -14}, {-14, -14}, {-14, -74}, {-2, -74}}, color = {0, 0, 127}));
  connect(ems_ecms.controlSetCurrent, fuelCellSystemController.setPower) annotation(
    Line(points = {{-42, -64}, {-2, -64}}, color = {0, 0, 127}));
  connect(getPowerDemand.y, ems_ecms.inputPowerDemand) annotation(
    Line(points = {{-98, 4}, {-74, 4}, {-74, -52}}, color = {0, 0, 127}));
  connect(getBatteryCurrent.y, ems_ecms.inputBatteryCurrent) annotation(
    Line(points = {{-98, 22}, {-64, 22}, {-64, -52}}, color = {0, 0, 127}));
  connect(getBatteryVoltage.y, ems_ecms.inputBatteryVoltage) annotation(
    Line(points = {{-98, 40}, {-54, 40}, {-54, -52}}, color = {0, 0, 127}));
  connect(getFcTemp.y, ems_ecms.inputFCTemp) annotation(
    Line(points = {{-98, -84}, {-74, -84}, {-74, -76}}, color = {0, 0, 127}));
  connect(getP_H2.y, ems_ecms.inputP_H2) annotation(
    Line(points = {{-98, -100}, {-64, -100}, {-64, -76}}, color = {0, 0, 127}));
  connect(getP_O2.y, ems_ecms.inputP_O2) annotation(
    Line(points = {{-98, -114}, {-54, -114}, {-54, -76}}, color = {0, 0, 127}));
  connect(get_phi.y, ems_ecms.input_phi) annotation(
    Line(points = {{-98, -130}, {-44, -130}, {-44, -76}}, color = {0, 0, 127}));
  annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Fuel-cell/battery range-extender powertrain using equivalent-consumption minimization (ECMS). The controller selects the fuel-cell contribution from power demand, battery state of charge, and operating measurements, and sends a power request to FuelCellSystemController, which generates the DC-converter current reference. The controller receives battery voltage and current together with total power demand and fuel-cell operating measurements. The declared stack cell count is passed to the fuel-cell system and ECMS controller.</p><h3>Assembly</h3><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Component</th><th>Model</th><th>Description</th></tr>
<tr><td><code>fuelCellSystem</code></td><td><code>Electrochemical.Hydrogen.FuelCells.FuelCellSystem</code></td><td>-</td></tr>
<tr><td><code>dC_converter</code></td><td><code>VirtualFCS.Electrical.DC_converter</code></td><td>-</td></tr>
<tr><td><code>multiSensor</code></td><td><code>Modelica.Electrical.Analog.Sensors.MultiSensor</code></td><td>-</td></tr>
<tr><td><code>ground1</code></td><td><code>Modelica.Electrical.Analog.Basic.Ground</code></td><td>-</td></tr>
<tr><td><code>ems_ecms</code></td><td><code>Control.ECMS.EMS_ECMS</code></td><td>-</td></tr>
<tr><td><code>getBatteryVoltage</code></td><td><code>Modelica.Blocks.Sources.RealExpression</code></td><td>-</td></tr>
<tr><td><code>getBatteryCurrent</code></td><td><code>Modelica.Blocks.Sources.RealExpression</code></td><td>-</td></tr>
<tr><td><code>getPowerDemand</code></td><td><code>Modelica.Blocks.Sources.RealExpression</code></td><td>-</td></tr>
<tr><td><code>getFcTemp</code></td><td><code>Modelica.Blocks.Sources.RealExpression</code></td><td>-</td></tr>
<tr><td><code>getP_H2</code></td><td><code>Modelica.Blocks.Sources.RealExpression</code></td><td>-</td></tr>
<tr><td><code>getP_O2</code></td><td><code>Modelica.Blocks.Sources.RealExpression</code></td><td>-</td></tr>
<tr><td><code>get_phi</code></td><td><code>Modelica.Blocks.Sources.RealExpression</code></td><td>-</td></tr>
<tr><td><code>fuelCellSystemController</code></td><td><code>VirtualFCS.Control.FuelCellSystemController</code></td><td>-</td></tr>
</tbody></table>
<h2>Governing Equations</h2>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>42</code></td><td>Number of cells in stack</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
</tbody></table>

</body></html>"));
end RangeExtenderPowertrain_ECMS;
