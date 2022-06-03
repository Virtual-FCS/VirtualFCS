within VirtualFCS.Control;

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
    Placement(visible = true, transformation(origin = {20, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = upperVoltageLimit)  annotation(
    Placement(visible = true, transformation(origin = {56, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {42, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n_load annotation(
    Placement(visible = true, transformation(origin = {-78, -140}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-130, -190}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p_load annotation(
    Placement(visible = true, transformation(origin = {80, -140}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {130, -190}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Ideal.IdealCommutingSwitch switchVotageSource annotation(
    Placement(visible = true, transformation(origin = {114, -54}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage upperVoltageSource(V = upperVoltageLimit) annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V = lowerVoltageLimit) annotation(
    Placement(visible = true, transformation(origin = {-142, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Ideal.IdealCommutingSwitch idealCommutingSwitch annotation(
    Placement(visible = true, transformation(origin = {-50, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold = lowerVoltageLimit) annotation(
    Placement(visible = true, transformation(origin = {-50, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealCommutingSwitch shuntSwitch annotation(
    Placement(visible = true, transformation(origin = {42, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor shuntResistor(R = 2000)  annotation(
    Placement(visible = true, transformation(origin = {-14, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor shuntCapacitor(C = 1e-7)  annotation(
    Placement(visible = true, transformation(origin = {-14, -146}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(voltageSensor.p, pin_p_battery) annotation(
    Line(points = {{10, 80}, {160, 80}, {160, 0}, {196, 0}}, color = {0, 0, 255}));
  connect(greaterThreshold.y, and1.u2) annotation(
    Line(points = {{20, 16}, {20, 2}, {34, 2}}, color = {255, 0, 255}));
  connect(and1.u1, lessThreshold.y) annotation(
    Line(points = {{42, 2}, {56, 2}, {56, 16}}, color = {255, 0, 255}));
  connect(voltageSensor.v, lessThreshold.u) annotation(
    Line(points = {{0, 68}, {0, 68}, {0, 60}, {56, 60}, {56, 40}, {56, 40}}, color = {0, 0, 127}));
  connect(voltageSensor.v, greaterThreshold.u) annotation(
    Line(points = {{0, 68}, {0, 68}, {0, 60}, {20, 60}, {20, 40}, {20, 40}}, color = {0, 0, 127}));
  connect(voltageSensor.n, pin_n_battery) annotation(
    Line(points = {{-10, 80}, {-180, 80}, {-180, 0}, {-196, 0}, {-196, 0}}, color = {0, 0, 255}));
  connect(pin_n_battery, pin_n_load) annotation(
    Line(points = {{-196, 0}, {-196, 0}, {-196, -140}, {-78, -140}, {-78, -140}}, color = {0, 0, 255}));
  connect(pin_n_battery, upperVoltageSource.n) annotation(
    Line(points = {{-196, 0}, {-150, 0}, {-150, 0}, {-150, 0}}, color = {0, 0, 255}));
  connect(switchVotageSource.p, pin_p_battery) annotation(
    Line(points = {{124, -54}, {194, -54}, {194, 0}, {196, 0}}, color = {0, 0, 255}));
  connect(switchVotageSource.n2, pin_p_load) annotation(
    Line(points = {{104, -54}, {82, -54}, {82, -140}, {80, -140}}, color = {0, 0, 255}));
  connect(and1.y, switchVotageSource.control) annotation(
    Line(points = {{42, -21}, {42, -30}, {114, -30}, {114, -42}}, color = {255, 0, 255}));
  connect(pin_n_battery, constantVoltage.n) annotation(
    Line(points = {{-196, 0}, {-160, 0}, {-160, -80}, {-152, -80}, {-152, -80}}, color = {0, 0, 255}));
  connect(idealCommutingSwitch.p, switchVotageSource.n1) annotation(
    Line(points = {{-40, -50}, {104, -50}, {104, -50}, {104, -50}}, color = {0, 0, 255}));
  connect(idealCommutingSwitch.n1, upperVoltageSource.p) annotation(
    Line(points = {{-60, -46}, {-100, -46}, {-100, 0}, {-130, 0}, {-130, 0}}, color = {0, 0, 255}));
  connect(constantVoltage.p, idealCommutingSwitch.n2) annotation(
    Line(points = {{-132, -80}, {-100, -80}, {-100, -50}, {-60, -50}, {-60, -50}}, color = {0, 0, 255}));
  connect(lessThreshold1.y, idealCommutingSwitch.control) annotation(
    Line(points = {{-50, 20}, {-50, 20}, {-50, -38}, {-50, -38}}, color = {255, 0, 255}));
  connect(lessThreshold1.u, voltageSensor.v) annotation(
    Line(points = {{-50, 42}, {-50, 42}, {-50, 60}, {0, 60}, {0, 70}, {0, 70}}, color = {0, 0, 127}));
  connect(and1.y, shuntSwitch.control) annotation(
    Line(points = {{42, -20}, {42, -98}}, color = {255, 0, 255}));
  connect(pin_p_load, shuntSwitch.p) annotation(
    Line(points = {{80, -140}, {82, -140}, {82, -110}, {52, -110}, {52, -110}}, color = {0, 0, 255}));
  connect(shuntSwitch.n1, shuntResistor.p) annotation(
    Line(points = {{32, -106}, {-4, -106}, {-4, -110}, {-4, -110}}, color = {0, 0, 255}));
  connect(shuntResistor.p, shuntCapacitor.p) annotation(
    Line(points = {{-4, -110}, {-4, -110}, {-4, -146}, {-4, -146}}, color = {0, 0, 255}));
  connect(shuntCapacitor.n, shuntResistor.n) annotation(
    Line(points = {{-24, -146}, {-24, -146}, {-24, -110}, {-24, -110}}, color = {0, 0, 255}));
  connect(shuntResistor.n, pin_n_load) annotation(
    Line(points = {{-24, -110}, {-78, -110}, {-78, -140}, {-78, -140}}, color = {0, 0, 255}));
  annotation(
    Icon(graphics = {Rectangle(origin = {-100, 100}, fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {300, -300}}), Text(origin = {2, 137}, lineColor = {255, 255, 255}, extent = {{-74, 31}, {74, -31}}, textString = "Battery"), Text(origin = {-4, -101}, lineColor = {255, 255, 255}, extent = {{-74, 31}, {74, -31}}, textString = "Load"), Text(origin = {-7, 253}, lineColor = {0, 0, 255}, extent = {{-181, 45}, {181, -45}}, textString = "%name")}, coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
  Documentation(info = "<html><head></head><body>The voltage limiter block enforces user-defined upper and lower voltage limits for battery cells and packs.&nbsp;</body></html>"));
end VoltageLimiter;
