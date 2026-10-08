within VirtualFCS.Vehicles;
model JoystickDriveInput
  parameter Real R_accel = 6;
  parameter Real R_decel = -4.5;
  parameter Modelica.Units.SI.Velocity maxVelocity = 200;
  parameter Modelica.Units.SI.Velocity minVelocity = 0;
  VirtualFCS.XInTheLoop.UserInTheLoop.JoystickRoadElectricVehicleControl joystickRoadElectricVehicleControl annotation (
    Placement(visible = true, transformation(origin = {-80, -9}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = R_decel) annotation (
    Placement(visible = true, transformation(origin = {-40, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = R_accel) annotation (
    Placement(visible = true, transformation(origin = {-40, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator annotation (
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation (
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation (
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = maxVelocity, uMin = minVelocity) annotation (
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = 3600 / 1000) annotation (
    Placement(visible = true, transformation(origin = {57, -1}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
equation
  connect(gain.y, add.u1) annotation (
    Line(points = {{-29, 16}, {-22, 16}, {-22, 11}, {-24, 11}, {-24, 8.5}, {-22, 8.5}, {-22, 6}}, color = {0, 0, 127}));
  connect(gain1.y, add.u2) annotation (
    Line(points = {{-29, -14}, {-22, -14}, {-22, -6}}, color = {0, 0, 127}));
  connect(add.y, integrator.u) annotation (
    Line(points = {{1, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(joystickRoadElectricVehicleControl.ctl_brake, gain.u) annotation (
    Line(points = {{-63.5, 3}, {-56, 3}, {-56, 9.5}, {-54, 9.5}, {-54, 12.75}, {-52, 12.75}, {-52, 16}}, color = {0, 0, 127}));
  connect(joystickRoadElectricVehicleControl.ctl_accelerate, gain1.u) annotation (
    Line(points = {{-63.5, -6}, {-56, -6}, {-56, -10}, {-54, -10}, {-54, -12}, {-52, -12}, {-52, -14}}, color = {0, 0, 127}));
  connect(limiter.y, y) annotation (
    Line(points = {{94, 0}, {104, 0}, {104, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(integrator.y, gain2.u) annotation (
    Line(points = {{42, 0}, {50, 0}, {50, 0}, {50, 0}}, color = {0, 0, 127}));
  connect(gain2.y, limiter.u) annotation (
    Line(points = {{62, 0}, {68, 0}, {68, 0}, {70, 0}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-6, Interval = 0.1),
    Icon(graphics = {Text(origin = {-5, 123}, textColor = {0, 0, 255}, extent = {{-121, 23}, {121, -23}}, textString = "%name"), Rectangle(lineColor = {95, 30, 27}, fillColor = {190, 60, 55}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Ellipse(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-49.5, 49.5}, {49.5, -49.5}}), Ellipse(fillColor = {190, 60, 55}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-39, 39}, {39, -39}}), Polygon(origin = {0, 29}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-5.1, 13}, {5.1, 13}, {9.9, -20}, {-9.9, -20}, {-5.1, 13}}), Polygon(origin = {25, -10}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-8, 12.85}, {15, -2}, {11, -11.8}, {-15, -3.9}, {-8, 12.85}}), Polygon(origin = {-26, -10}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-13, -1.4}, {8, 12.4}, {14, -4.4}, {-8, -11.1}, {-13, -1.4}}), Ellipse(fillColor = {190, 60, 55}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-19.5, 19.5}, {19.5, -19.5}}), Ellipse(fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.4, 14.4}, {14.4, -14.4}}), Ellipse(fillColor = {190, 60, 55}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-6.5, 6.5}, {6.5, -6.5}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Vehicle drive input that converts joystick commands into acceleration and braking requests and integrates them into a bounded velocity command.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>joystickRoadElectricVehicleControl</code> (VirtualFCS.XInTheLoop.UserInTheLoop.JoystickRoadElectricVehicleControl), <code>gain</code> (Modelica.Blocks.Math.Gain), <code>gain1</code> (Modelica.Blocks.Math.Gain), <code>integrator</code> (Modelica.Blocks.Continuous.Integrator), <code>add</code> (Modelica.Blocks.Math.Add), <code>limiter</code> (Modelica.Blocks.Nonlinear.Limiter), <code>gain2</code> (Modelica.Blocks.Math.Gain).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>R_accel</code></td><td>Real</td><td>1</td><td><code>6</code></td><td></td></tr>
<tr><td><code>R_decel</code></td><td>Real</td><td>1</td><td><code>-4.5</code></td><td></td></tr>
<tr><td><code>maxVelocity</code></td><td>Modelica.Units.SI.Velocity</td><td>m/s</td><td><code>200</code></td><td></td></tr>
<tr><td><code>minVelocity</code></td><td>Modelica.Units.SI.Velocity</td><td>m/s</td><td><code>0</code></td><td></td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>y</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end JoystickDriveInput;
