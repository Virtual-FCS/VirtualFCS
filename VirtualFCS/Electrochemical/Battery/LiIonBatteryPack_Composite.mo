within VirtualFCS.Electrochemical.Battery;

model LiIonBatteryPack_Composite "A Li-ion battery pack comprised of individual Li-ion cell models."
  // DECLARE PARAMETERS //
  // Pack design parameters
  parameter Real SOC_init(unit = "1") = 0.5 "Initial State of Charge";
  parameter Integer p = 5 "Number of Cells in Parallel";
  parameter Integer s = 10 "Number of Cells in Series";
  parameter Modelica.Units.SI.Area coolingArea = p*s*liIonCell[1].coolingArea "Cooling Area";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer heatTransferCoefficient = 7.8*10^0.78 "HeatTransferCoefficient (W/(m2.K))";
  Modelica.Units.NonSI.ElectricCharge_Ah chargeCapacity;
  VirtualFCS.Electrochemical.Battery.LiIonCell liIonCell[s*p](each SOC_init = SOC_init) annotation(
    Placement(visible = true, transformation(origin = {0, 50.3333}, extent = {{-37, -24.6667}, {37, 24.6667}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-90, 92}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m = s*p) annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = heatTransferCoefficient*coolingArea) annotation(
    Placement(visible = true, transformation(origin = {80, -50}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {20, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95*coolingArea) annotation(
    Placement(visible = true, transformation(origin = {-20, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatBoundary annotation(
    Placement(visible = true, transformation(origin = {0, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// ***DEFINE EQUATIONS ***//
  chargeCapacity = p*liIonCell[1].chargeCapacity;
// ***DEFINE CONNECTIONS ***//
  for i in 1:p loop
    connect(pin_n, liIonCell[s*(i - 1) + 1].pin_n);
    connect(pin_p, liIonCell[i*s].pin_p);
  end for;
  for i in 1:p loop
    for j in 1:s - 1 loop
      connect(liIonCell[s*(i - 1) + j].pin_p, liIonCell[s*(i - 1) + j + 1].pin_n);
    end for;
  end for;
  connect(liIonCell.heatPort, thermalCollector.port_a) annotation(
    Line(points = {{0, 43}, {0, 20}}, color = {191, 0, 0}, thickness = 0.5));
  connect(pin_n, ground.p) annotation(
    Line(points = {{-90, 92}, {-90, 92}, {-90, 60}, {-90, 60}}, color = {0, 0, 255}));
  connect(thermalCollector.port_b, heatPort) annotation(
    Line(points = {{0, 0}, {0, -20}}, color = {191, 0, 0}));
  connect(convection.Gc, setConvectiveCoefficient.y) annotation(
    Line(points = {{30, -50}, {64, -50}, {64, -50}, {64, -50}}, color = {0, 0, 127}));
  connect(heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{0, -20}, {0, -20}, {0, -32}, {-20, -32}, {-20, -40}, {-20, -40}}, color = {191, 0, 0}));
  connect(heatPort, convection.solid) annotation(
    Line(points = {{0, -20}, {0, -20}, {0, -32}, {20, -32}, {20, -40}, {20, -40}}, color = {191, 0, 0}));
  connect(bodyRadiation.port_b, heatBoundary) annotation(
    Line(points = {{-20, -60}, {-20, -60}, {-20, -68}, {0, -68}, {0, -84}, {0, -84}}, color = {191, 0, 0}));
  connect(convection.fluid, heatBoundary) annotation(
    Line(points = {{20, -60}, {20, -60}, {20, -68}, {0, -68}, {0, -84}, {0, -84}}, color = {191, 0, 0}));
  annotation(
    Icon(graphics = {Rectangle(origin = {0, -15}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-130, 85}, {130, -75}}), Rectangle(origin = {0, 85}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-150, 15}, {150, -15}}), Text(origin = {68, 93}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {10, -19}}, textString = "+"), Text(origin = {-74, 105}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {52, -41}}, textString = "-"), Text(origin = {-34, -103}, lineColor = {0, 0, 255}, extent = {{-22, 15}, {86, -41}}, textString = "%name")}, coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    Diagram(coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<div>This model describes a lithium-ion battery pack as a composite of several separate instances of the&nbsp;<a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonCell\">LiIonCell model</a>. This setup has the advantage of being able to consider the performance of each individual cell, which may be useful for some investigations such as cell-balancing. However, it can also lead to a very large system of equations for complex models with many cells causing high computational cost.&nbsp;</div><div>

<br>
This class automatically generates instances of the LiIonCell model based on the user's input. The user must determine how many cells are in parallel (parameter <b>p</b>) and in series (parameter <b>s</b>). A series of <font face=\"Consolas\">for</font> loops then connects the cells in series or in parallel based on the requested architecture. The stack voltage is accessible by <span style=\"font-family:\" consolas;&quot;=\"\">pin_p</span>&nbsp;and&nbsp;<span style=\"font-family:\" consolas;&quot;=\"\">pin_n</span>.</div><div><br></div><div>The thermalCollector class automatically gathers all the heatPort outputs from each instance of LiIonCell and connects them to parallel convective and radiative heat transfer blocks. The effective cooling area for the blocks is the same and is assumed equal to the surface area of each cell multiplied by the number of cells in the pack. The ambient temperature T<sub>0</sub> is determined by connection to the heatBoundary.</div>
<h2>Governing Equations</h2>
<pre>chargeCapacity = p*liIonCell[1].chargeCapacity;
for i in 1:p loop connect(pin_n, liIonCell[s*(i - 1) + 1].pin_n);
connect(pin_p, liIonCell[i*s].pin_p);
end for;
for i in 1:p loop for j in 1:s - 1 loop connect(liIonCell[s*(i - 1) + j].pin_p, liIonCell[s*(i - 1) + j + 1].pin_n);
end for;
end for;
<br></pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>SOC_init</code></td><td>Real</td><td>1</td><td><code>0.5</code></td><td>Initial State of Charge</td></tr>
<tr><td><code>p</code></td><td>Integer</td><td>1</td><td><code>5</code></td><td>Number of Cells in Parallel</td></tr>
<tr><td><code>s</code></td><td>Integer</td><td>1</td><td><code>10</code></td><td>Number of Cells in Series</td></tr>
<tr><td><code>coolingArea</code></td><td>Modelica.Units.SI.Area</td><td>m2</td><td><code>p*s*liIonCell[1].coolingArea</code></td><td>Cooling Area</td></tr>
<tr><td><code>heatTransferCoefficient</code></td><td>Modelica.Units.SI.CoefficientOfHeatTransfer</td><td>-</td><td><code>7.8*10^0.78</code></td><td>HeatTransferCoefficient (W/(m2.K))</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>heatPort</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a</td><td>K; W</td><td></td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
<tr><td><code>heatBoundary</code></td><td>Connection</td><td>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b</td><td>K; W</td><td></td></tr>
</tbody></table>

</body></html>"));
end LiIonBatteryPack_Composite;
