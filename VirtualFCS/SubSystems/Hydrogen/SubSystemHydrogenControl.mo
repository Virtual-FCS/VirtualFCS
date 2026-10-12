within VirtualFCS.SubSystems.Hydrogen;
model SubSystemHydrogenControl

  import Modelica.Constants.F;

  constant Modelica.Units.SI.MolarMass M_H2 = Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM;

  parameter Modelica.Units.SI.AbsolutePressure pressure_H2_set = 200000 "Set H2 Pressure";
  parameter Real RR = 1.3 "Hydrogen recirculation ratio (recirculated/consumed)";
  parameter Integer N_cells = 180 "Number of cells in stack";
  parameter Modelica.Units.SI.MassFlowRate minimumFlow = 1.22e-05 "minimum hydrogen flow";
  
  VirtualFCS.Control.PurgeValveControl purgeValveControl annotation (
    Placement(transformation(origin = {0, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant setH2Pressure(k = pressure_H2_set) annotation (
    Placement(transformation(origin = {0, 160}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput stackCurrent annotation (
    Placement(visible = true, transformation(origin = {-220, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID pumpSpeedControl_PID(yMin = 0, yMax = 1, y(nominal = 1e-4))  annotation(
    Placement(transformation(origin = {0, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput p_h2_set annotation(
    Placement(transformation(origin = {220, 160}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {220, 140}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput purge_set annotation(
    Placement(transformation(origin = {220, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput pumpSpeed_set annotation(
    Placement(transformation(origin = {220, -160}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {220, -140}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Max max annotation(
    Placement(transformation(origin = {-50, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant minFlow(k = minimumFlow)  annotation(
    Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Gain currentToFlow(k = M_H2*RR/F/2*N_cells)  annotation(
    Placement(transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput pumpSpeed_measured annotation(
    Placement(transformation(origin = {-220, -140}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(stackCurrent, purgeValveControl.fuelCellCurrent) annotation(
    Line(points = {{-220, 120}, {-100, 120}, {-100, 60}, {-22, 60}}, color = {0, 0, 127}));
  connect(setH2Pressure.y, p_h2_set) annotation(
    Line(points = {{22, 160}, {220, 160}}, color = {0, 0, 127}));
  connect(pumpSpeedControl_PID.y, pumpSpeed_set) annotation(
    Line(points = {{22, -60}, {160, -60}, {160, -160}, {220, -160}}, color = {0, 0, 127}));
  connect(purgeValveControl.purgeValveControl, purge_set) annotation(
    Line(points = {{22, 60}, {126.5, 60}, {126.5, 0}, {220, 0}}, color = {0, 0, 127}));
  connect(minFlow.y, max.u2) annotation(
    Line(points = {{-98, -80}, {-80.5, -80}, {-80.5, -66}, {-62, -66}}, color = {0, 0, 127}));
  connect(currentToFlow.u, stackCurrent) annotation(
    Line(points = {{-144, -20}, {-160, -20}, {-160, 120}, {-220, 120}}, color = {0, 0, 127}));
  connect(currentToFlow.y, max.u1) annotation(
    Line(points = {{-98, -20}, {-80, -20}, {-80, -54}, {-62, -54}}, color = {0, 0, 127}));
  connect(max.y, pumpSpeedControl_PID.u_s) annotation(
    Line(points = {{-39, -60}, {-24, -60}}, color = {0, 0, 127}));
  connect(pumpSpeed_measured, pumpSpeedControl_PID.u_m) annotation(
    Line(points = {{-220, -140}, {0, -140}, {0, -84}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics={Text(origin = {-8, 257}, textColor = {0, 0, 255}, extent = {{-264, 69}, {264, -69}}, textString = "%name"), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 2, extent = {{-200, 200}, {200, -200}}, radius = 50), Text(  textColor = {255, 0, 0},extent = {{-200, 100}, {200, -100}}, textString = "H₂
Control")}),
Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p><b>SubSystemHydrogenControl</b> generates the three commands required by the hydrogen supply assembly: hydrogen feed pressure, purge-valve opening, and recirculation-blower speed.</p><h3>Working principle</h3><p>The stack-current input is converted to an estimated hydrogen flow using the cell count and recirculation ratio <code>RR</code>. A minimum-flow path prevents the commanded blower flow from reaching zero. A pressure controller uses the measured blower speed and requested flow to calculate the blower-speed command, while <a href=\"modelica://VirtualFCS.Control.PurgeValveControl\">PurgeValveControl</a> determines purge operation.</p><h3>Interfaces</h3><p><code>p_h2_set</code> provides the pressure-regulator set point, <code>purge_set</code> controls the purge valve, and <code>pumpSpeed_set</code> controls the recirculation blower. The pressure target, cell count, recirculation ratio, minimum flow, and measured blower speed are inputs or parameters of the control arrangement.</p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>pressure_H2_set</code></td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td><code>200000</code></td><td>Set H2 Pressure</td></tr>
<tr><td><code>RR</code></td><td>Real</td><td>1</td><td><code>1.3</code></td><td>Hydrogen recirculation ratio (recirculated/consumed)</td></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>180</code></td><td>Number of cells in stack</td></tr>
<tr><td><code>minimumFlow</code></td><td>Modelica.Units.SI.MassFlowRate</td><td>kg/s</td><td><code>1.22e-05</code></td><td>minimum hydrogen flow</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>stackCurrent</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td></td></tr>
<tr><td><code>pumpSpeed_measured</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td></td></tr>
<tr><td><code>p_h2_set</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>-</td><td></td></tr>
<tr><td><code>purge_set</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>-</td><td></td></tr>
<tr><td><code>pumpSpeed_set</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>-</td><td></td></tr>
</tbody></table>

</body></html>"));
end SubSystemHydrogenControl;
