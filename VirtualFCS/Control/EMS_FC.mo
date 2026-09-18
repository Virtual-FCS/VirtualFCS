within VirtualFCS.Control;
block EMS_FC
  parameter Modelica.Units.SI.TimeAging ramp_up = 20 "FC stack current ramp up rate";
  Modelica.Blocks.Math.Abs abs1 annotation (
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OFF(k = 0) annotation (
    Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput sensorInterface annotation (
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-121, -1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ON(k = Vehicles.VehicleProfile.V_load) annotation (
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising = ramp_up) annotation (
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation (
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(pre_y_start = true, uHigh = 0.8, uLow = 0.2) annotation (
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation (
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(sensorInterface, hysteresis.u) annotation (
    Line(points = {{-120, 0}, {-82, 0}, {-82, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, abs1.u) annotation (
    Line(points = {{42, 0}, {56, 0}, {56, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(abs1.y, controlInterface) annotation (
    Line(points = {{82, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch1.u2) annotation (
    Line(points = {{-58, 0}, {-24, 0}, {-24, 0}, {-22, 0}}, color = {255, 0, 255}));
  connect(OFF.y, switch1.u1) annotation (
    Line(points = {{-58, 40}, {-40, 40}, {-40, 8}, {-22, 8}, {-22, 8}}, color = {0, 0, 127}));
  connect(switch1.y, slewRateLimiter.u) annotation (
    Line(points = {{2, 0}, {16, 0}, {16, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(ON.y, switch1.u3) annotation (
    Line(points = {{-58, -40}, {-40, -40}, {-40, -8}, {-22, -8}, {-22, -8}}, color = {0, 0, 127}));
  annotation (
    Icon(graphics={  Rectangle( fillColor = {0, 70, 40}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Rectangle(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-43.2, 41.4}, {43, -45}}, radius = 8), Rectangle(origin = {-35, -3}, fillColor = {255, 0, 0}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {-22.2, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {-35, -3}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, lineThickness = 0, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {-9.5, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {3.3, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {16.1, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {28.85, -3}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{1.4, 58.9}, {4.5, -56.5}}), Rectangle(origin = {0, 30}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, 17.2}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, 4.35}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, -8.45}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, -21.25}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(origin = {0, -34.05}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-57.7, 1.85}, {57.35, -1.3}}), Rectangle(fillColor = {0, 70, 40}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{39.8, 38.3}, {-40, -41.8}}, radius = 5), Rectangle( fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-27.3, 25.5}, {27, -29}}), Rectangle(fillColor = {0, 70, 40}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-24.1, 22.25}, {23.85, -25.8}})}),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and input-side physical interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>ramp_up</code></td><td>Modelica.Units.SI.TimeAging</td><td>-</td><td>20</td><td>FC stack current ramp up rate</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>sensorInterface</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><p>Fuel-cell energy management block that determines the requested fuel-cell operating point from the system demand.</p><h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended model or enforced by instantiated components and their connected physical networks.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>controlInterface</code></td><td>Output</td><td>RealOutput</td><td>-</td><td></td></tr></tbody></table><h2><br></h2></body></html>"));
end EMS_FC;
