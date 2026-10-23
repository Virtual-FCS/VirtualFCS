within VirtualFCS.Examples.ElectrochemicalComponents;
model CycleBatteryCell "Example demonstrating constant-current constant-voltage cycling of a Li-ion battery cell."
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.Electrochemical.Battery.LiIonCell liIonCell(
    mass=0.08,
    coolingArea=0.00143,
    specificHeatCapacity=1000,
    SOC_init=0,
    chargeCapacity=2.6)                                                  annotation (
    Placement(visible = true, transformation(origin = {0, -28}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.PulseCurrent pulseCurrent(
    I=5.2,
    offset=-2.6,
    period=7200,
    width=50)                                                                                                     annotation (
    Placement(visible = true, transformation(origin = {0, 80}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = liIonCell.chargeCapacity * 3600) annotation (
    Placement(visible = true, transformation(origin = {74, 10}, extent = {{14, -10}, {-14, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = liIonCell.SOC_init) annotation (
    Placement(visible = true, transformation(origin = {75, 40}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  VirtualFCS.Control.BatteryManagementSystem BMS(N_s = 1) annotation (
    Placement(visible = true, transformation(origin = {0.5, 30}, extent = {{-31.5, -21}, {31.5, 21}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation (
    Placement(visible = true, transformation(origin = {20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * liIonCell.coolingArea) annotation (
    Placement(visible = true, transformation(origin = {-20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation (
    Placement(visible = true, transformation(origin = {-70, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 7.8 * 10 ^ 0.78 * liIonCell.coolingArea) annotation (
    Placement(visible = true, transformation(origin = {75, -70}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
equation
  connect(getSOC_init.y, BMS.SOC_init) annotation (
    Line(points={{58.5,40},{41,40},{41,36.3},{23.6,36.3}},    color = {0, 0, 127}));
  connect(BMS.chargeCapacity, getChargeCapacity.y) annotation (
    Line(points={{23.6,23.7},{40,23.7},{40,10},{58.6,10}},  color = {0, 0, 127}));
  connect(ground.p, liIonCell.pin_n) annotation (
    Line(points={{-60,-50},{-60,-28.37},{-22.94,-28.37}},
                                                        color = {0, 0, 255}));
  connect(convection.Gc, setConvectiveCoefficient.y) annotation (
    Line(points={{30,-70},{58.5,-70}},    color = {0, 0, 127}));
  connect(fixedTemperature.port, bodyRadiation.port_b) annotation (
    Line(points = {{-60, -88}, {-20, -88}, {-20, -80}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, convection.fluid) annotation (
    Line(points = {{-60, -88}, {20, -88}, {20, -80}}, color = {191, 0, 0}));
  connect(BMS.pin_n_battery, liIonCell.pin_n) annotation (
    Line(points={{-10,11.1},{-10,11.1},{-10,0},{-40,0},{-40,-28},{-22.94,-28},{
          -22.94,-28.37}},                                                                        color = {0, 0, 255}));
  connect(BMS.pin_p_battery, liIonCell.pin_p) annotation (
    Line(points={{11,11.1},{10,11.1},{10,0},{40,0},{40,-28},{26.3933,-28},{
          26.3933,-27.63}},                                                                color = {0, 0, 255}));
  connect(liIonCell.heatPort, bodyRadiation.port_a) annotation (
    Line(points={{0,-39.1},{0,-39.1},{0,-50},{-20,-50},{-20,-60},{-20,-60}},          color = {191, 0, 0}));
  connect(liIonCell.heatPort, convection.solid) annotation (
    Line(points={{0,-39.1},{0,-39.1},{0,-50},{20,-50},{20,-60},{20,-60}},          color = {191, 0, 0}));
  connect(pulseCurrent.p, BMS.pin_n_load) annotation (
    Line(points={{-18,80},{-42,80},{-42,60},{-10,60},{-10,48.9},{-10,48.9}},          color = {0, 0, 255}));
  connect(pulseCurrent.n, BMS.pin_p_load) annotation (
    Line(points={{18,80},{40,80},{40,58},{10,58},{10,48.9},{11,48.9}},          color = {0, 0, 255}));
  annotation (
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>This example applies a symmetric pulse current to one Li-ion cell for a 7200 s charge-discharge cycle. The current alternates between -2.6 A and +2.6 A with a 3600 s half-period, starting from SOC = 0.</p><p>The cell has a 2.6 Ah capacity, 0.08 kg mass, and is cooled to 298.15 K. The BMS limits the cell voltage during the charge and discharge portions.</p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"),
    experiment(StartTime = 0, StopTime = 7200, Tolerance = 1e-06, Interval = 1));
end CycleBatteryCell;
