within VirtualFCS.XInTheLoop.UserInTheLoop;

block ThrottleKeys
  extends Modelica.Icons.VariantsPackage;


 Modelica.Blocks.Continuous.Integrator integrator annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(unit = "km/h") annotation(
    Placement(visible = true, transformation(origin = {117, 1}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(extent = {{99, -17}, {133, 17}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToReal booleanToReal annotation(
    Placement(visible = true, transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1 annotation(
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.SynchronizeRealtime synchronizeRealtime(enable = true) annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1 annotation(
    Placement(visible = true, transformation(origin = {10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Gain(k = 10) annotation(
    Placement(visible = true, transformation(origin = {50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.InputDevices.KeyboardInput keyboardInput annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
 connect(integrator.y, add.u1) annotation(
    Line(points = {{21, 50}, {38, 50}, {38, 36}}, color = {0, 0, 127}));
  connect(add.y, product.u1) annotation(
    Line(points = {{61, 30}, {68, 30}, {68, 6}}, color = {0, 0, 127}));
  connect(booleanToReal1.y, integrator1.u) annotation(
    Line(points = {{-19, -50}, {-2, -50}}, color = {0, 0, 127}));
  connect(Gain.y, product.u2) annotation(
    Line(points = {{61, -30}, {68, -30}, {68, -6}}, color = {0, 0, 127}));
  connect(product.y, y) annotation(
    Line(points = {{91, 0}, {104, 0}, {104, 1}, {117, 1}}, color = {0, 0, 127}));
 connect(booleanToReal.y, integrator.u) annotation(
    Line(points = {{-19, 50}, {-2, 50}}, color = {0, 0, 127}));
 connect(keyboardInput.keyUp, booleanToReal.u) annotation(
    Line(points = {{-59, 6}, {-51, 6}, {-51, 50}, {-42, 50}}, color = {255, 0, 255}));
  connect(integrator1.y, add.u2) annotation(
    Line(points = {{21, -50}, {30, -50}, {30, 24}, {38, 24}}, color = {0, 0, 127}));
 connect(keyboardInput.keyDown, booleanToReal1.u) annotation(
    Line(points = {{-70, -10}, {-70, -10}, {-70, -50}, {-42, -50}, {-42, -50}}, color = {255, 0, 255}));
  annotation(
    uses(Modelica(version = "3.2.3"), Modelica_DeviceDrivers(version = "1.7.1")),
    Icon(graphics = {Rectangle(fillColor = {79, 188, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {5, -57}, fillColor = {56, 56, 56}, fillPattern = FillPattern.Solid, extent = {{-35, 39}, {25, -21}}), Polygon(origin = {-7, -41}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-13, 13}, {27, 13}, {7, -27}, {-13, 13}}), Rectangle(origin = {5, 39}, fillColor = {56, 56, 56}, fillPattern = FillPattern.Solid, extent = {{-35, 39}, {25, -21}}), Polygon(origin = {7, 43}, rotation = 180, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-13, 13}, {27, 13}, {7, -27}, {-13, 13}})}, coordinateSystem(initialScale = 0.1)));


end ThrottleKeys;
