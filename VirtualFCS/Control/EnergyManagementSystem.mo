within VirtualFCS.Control;
block EnergyManagementSystem "Implement algorithms to control the energy and power distribution in a hybrid system."
  parameter Modelica.Units.SI.Power P_FC_set = 30000 "Fuel cell system power setpoint";
  parameter Real SOC_lower_limit(unit = "1") = 0.2 "SOC lower limit";
  parameter Real SOC_higher_limit(unit = "1") = 0.8 "SOC lower limit";
  Modelica.Blocks.Sources.Constant shut_down(k = 100) annotation (
    Placement(transformation(origin = {-18, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(pre_y_start = true, uHigh = SOC_higher_limit, uLow = SOC_lower_limit) annotation (
    Placement(transformation(origin = {-18, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant setFuelCellCurrent(k = P_FC_set) annotation (
    Placement(transformation(origin = {-18, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput sensorInterface annotation (
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-121, -1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation (
    Placement(transformation(origin = {42, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation (
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(hysteresis.y, switch1.u2) annotation(
    Line(points = {{-7, 0}, {27, 0}, {27, 0}, {29, 0}}, color = {255, 0, 255}, thickness = 0.75));
  connect(shut_down.y, switch1.u1) annotation(
    Line(points = {{-7, 40}, {11, 40}, {11, 8}, {29, 8}, {29, 8}}, color = {0, 0, 127}, thickness = 0.75));
  connect(setFuelCellCurrent.y, switch1.u3) annotation(
    Line(points = {{-7, -40}, {11, -40}, {11, -8}, {29, -8}, {29, -8}}, color = {0, 0, 127}, thickness = 0.75));
  connect(sensorInterface, hysteresis.u) annotation(
    Line(points = {{-120, 0}, {-30, 0}}, color = {0, 0, 127}, thickness = 0.75));
  connect(switch1.y, controlInterface) annotation(
    Line(points = {{53, 0}, {110, 0}}, color = {0, 0, 127}));
  annotation (
    Icon(graphics={  Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-8, 121}, lineColor = {0, 0, 255}, extent = {{-54, 17}, {54, -17}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>P_FC_set</code></td><td>SI.Power</td><td>W</td><td>30 000</td><td>FC system setpoint power</td></tr>
<tr><td><code>SOC_lower_limit</code></td><td>Real</td><td>1</td><td>0.2</td><td>1</td></tr>
<tr><td><code>SOC_higher_limit</code></td><td>Real</td><td>1</td><td>0.8</td><td>1</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>sensorInterface</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><div>The EnergyManagementSystem component is designed to manage the flow of power between the fuel cell stack, battery, vehicle load, and balance-of-plant load. It splits the load according to pre-defined energy management rules, which are implemented within the bounds of the battery management system and the fuel cell control unit.</div><div><br></div>This model implements a simple energy management algorithm for a hybrid fuel cell &amp; battery system. The model reads the state-of-charge (SOC) of the battery. If it is less than a lower threshold value, then a signal is sent to activate the fuel cell with a given electric current. The rate at which current can be demanded from the fuel cell is limited by a slew rate.&nbsp;<h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended model or enforced by instantiated components and their connected physical networks.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>controlInterface</code></td><td>Output</td><td>RealOutput</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end EnergyManagementSystem;
