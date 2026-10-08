within VirtualFCS.Powertrains;

model RangeExtenderPowertrain

  extends Powertrains.BatteryPowertrain;
  replaceable package Cathode_Medium = Media.MoistAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;

  Electrochemical.Hydrogen.FuelCells.FuelCellSystem fuelCellSystem(redeclare package Cathode_Medium = Cathode_Medium, redeclare package Anode_Medium = Anode_Medium, p_air_set = 200000, p_H2_set = 200000, N_cells = 42, V_tank_H2 = 0.606, p_tank_H2 = 3000000, redeclare SubSystems.Air.SubSystemAir subSystemAir(redeclare VirtualFCS.Fluid.CompressorSimple compressor(redeclare package Medium = Cathode_Medium), p_set = 2e5, redeclare VirtualFCS.Fluid.Humidifier humidifier(redeclare package dry_medium = Cathode_Medium, redeclare package wet_medium = Cathode_Medium, L_fiber = 0.3, UA = 40, V_dry = 0.003, V_wet = 0.001, dFiber_i(displayUnit = "mm"), dFiber_o(displayUnit = "mm") = 0.0011, dHousing(displayUnit = "mm") = 0.14, dp_nominal = 1e4, m_flow_nom = 0.1, n = 1, nFibers = 4000)), fuelCell(redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.ActivationLossSimple activation, anode(R_flow = 10000), cathode(R_flow = 10000), redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.MassTransportLossSimple mass_transport, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.OhmicResistance ohmic, redeclare VirtualFCS.Electrochemical.Hydrogen.ECM.VSourceNernst v_source))  annotation(
    Placement(transformation(origin = {50, -30}, extent = {{-10, -10}, {10, 10}})));
  VirtualFCS.Electrical.DC_converter dC_converter(deadTime(y_start = 1)) annotation(
    Placement(transformation(origin = {10, 2}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  replaceable VirtualFCS.Control.EnergyManagementSystem energyManagementSystem annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
  VirtualFCS.Control.FuelCellSystemController fuelCellSystemController annotation(
    Placement(transformation(origin = {-10, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.MultiSensor multiSensor annotation(
    Placement(transformation(origin = {38, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
    Placement(transformation(origin = {30, -24}, extent = {{-4, -4}, {4, 4}})));
equation
  connect(dC_converter.pin_nFC, batterySystem.pin_n) annotation(
    Line(points = {{0, -8}, {-34, -8}, {-34, -20}}, color = {0, 0, 255}, thickness = 0.75));
  connect(dC_converter.pin_pFC, batterySystem.pin_p) annotation(
    Line(points = {{0, 12}, {-26, 12}, {-26, -20}}, color = {0, 0, 255}, thickness = 0.75));
  connect(dC_converter.pin_nBus, fuelCellSystem.pin_n) annotation(
    Line(points = {{20, -8}, {46, -8}, {46, -20}}, color = {0, 0, 255}, thickness = 0.75));
  connect(batterySystem.sensorOutput, energyManagementSystem.sensorInterface) annotation(
    Line(points = {{-40, -30}, {-92, -30}, {-92, -70}, {-82, -70}}, color = {0, 0, 127}));
  connect(energyManagementSystem.controlInterface, fuelCellSystemController.setPower) annotation(
    Line(points = {{-58, -70}, {-46, -70}, {-46, -64}, {-22, -64}}, color = {0, 0, 127}));
  connect(dC_converter.pin_pBus, multiSensor.pc) annotation(
    Line(points = {{20, 12}, {28, 12}}, color = {0, 0, 255}));
  connect(multiSensor.nc, fuelCellSystem.pin_p) annotation(
    Line(points = {{48, 12}, {56, 12}, {56, -20}}, color = {0, 0, 255}));
  connect(dC_converter.pin_nBus, multiSensor.nv) annotation(
    Line(points = {{20, -8}, {38, -8}, {38, 2}}, color = {0, 0, 255}));
  connect(dC_converter.pin_pBus, multiSensor.pv) annotation(
    Line(points = {{20, 12}, {20, 22}, {38, 22}}, color = {0, 0, 255}));
  connect(multiSensor.v, fuelCellSystemController.fcVoltage) annotation(
    Line(points = {{44, 2}, {44, -16}, {0, -16}, {0, -48}, {-32, -48}, {-32, -74}, {-22, -74}}, color = {0, 0, 127}));
  connect(fuelCellSystemController.setCurrent, dC_converter.I_Ref) annotation(
    Line(points = {{2, -70}, {74, -70}, {74, 34}, {10, 34}, {10, 14}}, color = {0, 0, 127}));
  connect(fuelCellSystem.pin_n, ground1.p) annotation(
    Line(points = {{46, -20}, {30, -20}}, color = {0, 0, 255}));
  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Battery-electric powertrain augmented with a hydrogen fuel-cell range extender. The fuel-cell system supplies the battery bus through a controlled DC converter. Battery measurements feed the replaceable energy-management system, whose power request is converted to a current command using the measured fuel-cell voltage. The fuel-cell air subsystem uses CompressorSimple and a one-cell membrane Humidifier. The converter flow-delay output starts at 1 A to avoid a zero-flow compressor initialization. In this assembly, the converter&#x27;s FC-named pins connect to the battery and its Bus-named pins connect to the fuel-cell system.</p><h3>Assembly</h3><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Component</th><th>Model</th><th>Description</th></tr>
<tr><td><code>fuelCellSystem</code></td><td><code>Electrochemical.Hydrogen.FuelCells.FuelCellSystem</code></td><td>-</td></tr>
<tr><td><code>dC_converter</code></td><td><code>VirtualFCS.Electrical.DC_converter</code></td><td>-</td></tr>
<tr><td><code>energyManagementSystem</code></td><td><code>VirtualFCS.Control.EnergyManagementSystem</code></td><td>-</td></tr>
<tr><td><code>fuelCellSystemController</code></td><td><code>VirtualFCS.Control.FuelCellSystemController</code></td><td>-</td></tr>
<tr><td><code>multiSensor</code></td><td><code>Modelica.Electrical.Analog.Sensors.MultiSensor</code></td><td>-</td></tr>
<tr><td><code>ground1</code></td><td><code>Modelica.Electrical.Analog.Basic.Ground</code></td><td>-</td></tr>
</table>
<h2>Governing Equations</h2>
<p>The assembly connects <code>fuelCellSystem</code> (Electrochemical.Hydrogen.FuelCells.FuelCellSystem), <code>dC_converter</code> (VirtualFCS.Electrical.DC_converter), <code>energyManagementSystem</code> (VirtualFCS.Control.EnergyManagementSystem), <code>fuelCellSystemController</code> (VirtualFCS.Control.FuelCellSystemController), <code>multiSensor</code> (Modelica.Electrical.Analog.Sensors.MultiSensor), <code>ground1</code> (Modelica.Electrical.Analog.Basic.Ground).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
</table>
</body>
</html>"));
end RangeExtenderPowertrain;
