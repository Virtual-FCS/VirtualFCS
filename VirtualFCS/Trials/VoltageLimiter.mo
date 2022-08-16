model VoltageLimiter "Enforce voltage limits on battery cells."

  parameter Real upperVoltageLimit(unit = "V") = 3.6 "Upper Voltage Limit";
  parameter Real lowerVoltageLimit(unit = "V") = 2.0 "Lower Voltage Limit";

  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p_battery annotation(
    Placement(visible = true, transformation(origin = {196, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 190}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n_battery annotation(
    Placement(visible = true, transformation(origin = {-196, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-128, 190}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
    Placement(visible = true, transformation(origin = {0, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = lowerVoltageLimit)  annotation(
    Placement(visible = true, transformation(origin = {68, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = upperVoltageLimit)  annotation(
    Placement(visible = true, transformation(origin = {104, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {90, -8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n_load annotation(
    Placement(visible = true, transformation(origin = {-78, -140}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-130, -190}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p_load annotation(
    Placement(visible = true, transformation(origin = {80, -140}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {130, -190}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage upperVoltageSource(V = upperVoltageLimit) annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V = lowerVoltageLimit) annotation(
    Placement(visible = true, transformation(origin = {-142, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold = lowerVoltageLimit) annotation(
    Placement(visible = true, transformation(origin = {-50, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealTwoWaySwitch switch annotation(
    Placement(visible = true, transformation(origin = {-46, -42}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Ideal.IdealTwoWaySwitch idealTwoWaySwitch annotation(
    Placement(visible = true, transformation(origin = {90, -46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(voltageSensor.p, pin_p_battery) annotation(
    Line(points = {{10, 80}, {160, 80}, {160, 0}, {196, 0}}, color = {0, 0, 255}));
  connect(greaterThreshold.y, and1.u2) annotation(
    Line(points = {{68, 17}, {68, 17}, {68, 5}, {82, 5}, {82, 5}}, color = {255, 0, 255}));
  connect(and1.u1, lessThreshold.y) annotation(
    Line(points = {{90, 4}, {104, 4}, {104, 16}, {104, 16}}, color = {255, 0, 255}));
  connect(voltageSensor.v, lessThreshold.u) annotation(
    Line(points = {{0, 68}, {0, 60}, {104, 60}, {104, 40}}, color = {0, 0, 127}));
  connect(voltageSensor.v, greaterThreshold.u) annotation(
    Line(points = {{0, 68}, {0, 60}, {68, 60}, {68, 40}}, color = {0, 0, 127}));
  connect(voltageSensor.n, pin_n_battery) annotation(
    Line(points = {{-10, 80}, {-180, 80}, {-180, 0}, {-196, 0}, {-196, 0}}, color = {0, 0, 255}));
  connect(pin_n_battery, pin_n_load) annotation(
    Line(points = {{-196, 0}, {-196, 0}, {-196, -140}, {-78, -140}, {-78, -140}}, color = {0, 0, 255}));
  connect(pin_n_battery, upperVoltageSource.n) annotation(
    Line(points = {{-196, 0}, {-150, 0}, {-150, 0}, {-150, 0}}, color = {0, 0, 255}));
  connect(pin_n_battery, constantVoltage.n) annotation(
    Line(points = {{-196, 0}, {-160, 0}, {-160, -80}, {-152, -80}, {-152, -80}}, color = {0, 0, 255}));
  connect(lessThreshold1.u, voltageSensor.v) annotation(
    Line(points = {{-50, 42}, {-50, 42}, {-50, 60}, {0, 60}, {0, 70}, {0, 70}}, color = {0, 0, 127}));
  connect(upperVoltageSource.p, switch.n1) annotation(
    Line(points = {{-130, 0}, {-56, 0}, {-56, -38}}, color = {0, 0, 255}));
  connect(constantVoltage.p, switch.n2) annotation(
    Line(points = {{-132, -80}, {-56, -80}, {-56, -42}}, color = {0, 0, 255}));
  connect(switch.p, idealTwoWaySwitch.n1) annotation(
    Line(points = {{-36, -42}, {80, -42}}, color = {0, 0, 255}));
  connect(idealTwoWaySwitch.n2, pin_p_load) annotation(
    Line(points = {{80, -46}, {80, -140}}, color = {0, 0, 255}));
  connect(idealTwoWaySwitch.p, pin_p_battery) annotation(
    Line(points = {{100, -46}, {196, -46}, {196, 0}}, color = {0, 0, 255}));
  connect(lessThreshold1.y, switch.control) annotation(
    Line(points = {{-50, 20}, {-46, 20}, {-46, -30}}, color = {255, 0, 255}));
  connect(and1.y, idealTwoWaySwitch.control) annotation(
    Line(points = {{90, -19}, {90, -34}}, color = {255, 0, 255}));
  annotation(
    Icon(graphics = {Rectangle(origin = {-100, 100}, fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {300, -300}}), Text(origin = {2, 137}, lineColor = {255, 255, 255}, extent = {{-74, 31}, {74, -31}}, textString = "Battery"), Text(origin = {-4, -101}, lineColor = {255, 255, 255}, extent = {{-74, 31}, {74, -31}}, textString = "Load"), Text(origin = {-7, 253}, lineColor = {0, 0, 255}, extent = {{-181, 45}, {181, -45}}, textString = "%name")}, coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
  Documentation(info = "<html><head></head><body>The voltage limiter block enforces user-defined upper and lower voltage limits for battery cells and packs.&nbsp;</body></html>"),
  uses(Modelica(version = "4.0.0")));
end VoltageLimiter;
