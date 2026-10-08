within VirtualFCS.XInTheLoop.UserInTheLoop;
block ThrottleKeys
  Modelica.Blocks.Continuous.Integrator integrator annotation (
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(unit = "km/h") annotation (
    Placement(visible = true, transformation(origin = {117, 1}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(extent = {{99, 25}, {133, 59}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToReal booleanToReal annotation (
    Placement(visible = true, transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1 annotation (
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation (
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation (
    Placement(visible = true, transformation(origin = {50, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1 annotation (
    Placement(visible = true, transformation(origin = {10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Gain(k = 1) annotation (
    Placement(visible = true, transformation(origin = {50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.InputDevices.KeyboardInput keyboardInput annotation (
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation (
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(integrator.y, add.u1) annotation (
    Line(points = {{21, 50}, {38, 50}, {38, 36}}, color = {0, 0, 127}));
  connect(add.y, product.u1) annotation (
    Line(points = {{61, 30}, {68, 30}, {68, 6}}, color = {0, 0, 127}));
  connect(booleanToReal1.y, integrator1.u) annotation (
    Line(points = {{-19, -50}, {-2, -50}}, color = {0, 0, 127}));
  connect(Gain.y, product.u2) annotation (
    Line(points = {{61, -30}, {68, -30}, {68, -6}}, color = {0, 0, 127}));
  connect(product.y, y) annotation (
    Line(points = {{91, 0}, {104, 0}, {104, 1}, {117, 1}}, color = {0, 0, 127}));
  connect(booleanToReal.y, integrator.u) annotation (
    Line(points = {{-19, 50}, {-2, 50}}, color = {0, 0, 127}));
  connect(keyboardInput.keyUp, booleanToReal.u) annotation (
    Line(points = {{-59, 6}, {-51, 6}, {-51, 50}, {-42, 50}}, color = {255, 0, 255}));
  connect(integrator1.y, add.u2) annotation (
    Line(points = {{21, -50}, {30, -50}, {30, 24}, {38, 24}}, color = {0, 0, 127}));
  connect(keyboardInput.keyDown, booleanToReal1.u) annotation (
    Line(points = {{-70, -10}, {-70, -10}, {-70, -50}, {-42, -50}, {-42, -50}}, color = {255, 0, 255}));
  annotation(
    Icon(graphics = {Rectangle(origin = {5, -49}, fillColor = {56, 56, 56}, fillPattern = FillPattern.Solid, extent = {{-35, 39}, {25, -21}}), Polygon(origin = {-7, -45}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-13, 13}, {27, 13}, {7, -7}, {-13, 13}}), Rectangle(origin = {5, 29}, fillColor = {56, 56, 56}, fillPattern = FillPattern.Solid, extent = {{-35, 39}, {25, -21}}), Polygon(origin = {7, 41}, rotation = 180, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-13, 13}, {27, 13}, {7, -9}, {-13, 13}}), Rectangle(origin = {71, -49}, fillColor = {56, 56, 56}, fillPattern = FillPattern.Solid, extent = {{-35, 39}, {25, -21}}), Rectangle(origin = {-61, -49}, fillColor = {56, 56, 56}, fillPattern = FillPattern.Solid, extent = {{-35, 39}, {25, -21}}), Polygon(origin = {-63, -31}, rotation = 180, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{17, 9}, {-3, 29}, {-3, -11}, {17, 9}}), Polygon(origin = {87, -7}, rotation = 180, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{27, 53}, {27, 13}, {7, 33}, {27, 53}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Keyboard-based user input block that integrates up and down commands into a bounded throttle signal.</p>
<h2>Governing Equations</h2>
<p>The assembly connects <code>integrator</code> (Modelica.Blocks.Continuous.Integrator), <code>booleanToReal</code> (Modelica.Blocks.Math.BooleanToReal), <code>booleanToReal1</code> (Modelica.Blocks.Math.BooleanToReal), <code>product</code> (Modelica.Blocks.Math.Product), <code>add</code> (Modelica.Blocks.Math.Add), <code>integrator1</code> (Modelica.Blocks.Continuous.Integrator), <code>Gain</code> (Modelica.Blocks.Sources.Constant), <code>keyboardInput</code> (Modelica_DeviceDrivers.Blocks.InputDevices.KeyboardInput), <code>realtimeSynchronize</code> (Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize).</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>keyboardInput</code></td><td>Observed variable</td><td>Modelica_DeviceDrivers.Blocks.InputDevices.KeyboardInput</td><td>-</td><td></td></tr>
<tr><td><code>y</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput</td><td>km/h</td><td>km/h</td></tr>
</table>
</body>
</html>"));
end ThrottleKeys;
