within VirtualFCS.Control;

model ChargeCounter
  Modelica.Blocks.Interfaces.RealInput SOC_init annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput chargeCapacity annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput electricCurrent annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput SOC annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {39, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(initType = Modelica.Blocks.Types.Init.InitialState, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = 1 - 1e-6, uMin = 1e-6)  annotation(
    Placement(visible = true, transformation(origin = {76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(integrator.y, add.u2) annotation(
    Line(points = {{1, -30}, {12, -30}, {12, -6}, {27, -6}}, color = {0, 0, 127}));
  connect(SOC_init, add.u1) annotation(
    Line(points = {{-120, 80}, {12, 80}, {12, 6}, {27, 6}}, color = {0, 0, 127}));
  connect(integrator.u, division.y) annotation(
    Line(points = {{-22, -30}, {-29, -30}}, color = {0, 0, 127}));
  connect(electricCurrent, division.u1) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, -24}, {-52, -24}}, color = {0, 0, 127}));
  connect(chargeCapacity, division.u2) annotation(
    Line(points = {{-120, -80}, {-60, -80}, {-60, -36}, {-52, -36}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{50, 0}, {62, 0}, {62, 0}, {64, 0}}, color = {0, 0, 127}));
  connect(limiter.y, SOC) annotation(
    Line(points = {{88, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  annotation(
    Diagram,
    Icon(graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-38, 149}, lineColor = {0, 0, 255}, extent = {{-34, 19}, {106, -71}}, textString = "%name"), Text(origin = {-56, 85}, lineColor = {255, 255, 255}, extent = {{-34, 19}, {30, -25}}, textString = "SOC_init"), Text(origin = {-58, 5}, lineColor = {255, 255, 255}, extent = {{-34, 19}, {30, -25}}, textString = "Current"), Text(origin = {-60, -73}, lineColor = {255, 255, 255}, extent = {{-34, 19}, {38, -31}}, textString = "Capacity"), Text(origin = {88, -7}, lineColor = {255, 255, 255}, extent = {{-34, 19}, {2, -5}}, textString = "SOC")}, coordinateSystem(initialScale = 0.1)));
end ChargeCounter;
