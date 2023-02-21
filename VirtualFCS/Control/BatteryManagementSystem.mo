within VirtualFCS.Control;

model BatteryManagementSystem "Implement algorithms for the control of battery systems."
  parameter Real N_s "Number of Cells in Series";
  parameter Modelica.Units.SI.Voltage lowerVoltageLimit = N_s * 2;
  parameter Modelica.Units.SI.Voltage upperVoltageLimit = N_s * 3.6;
  VirtualFCS.Control.ChargeCounter chargeCounter annotation(
    Placement(visible = true, transformation(origin = {25, -1}, extent = {{25, -25}, {-25, 25}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n_battery annotation(
    Placement(visible = true, transformation(origin = {-116, -96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n_load annotation(
    Placement(visible = true, transformation(origin = {-116, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p_battery annotation(
    Placement(visible = true, transformation(origin = {-44, -96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p_load annotation(
    Placement(visible = true, transformation(origin = {-44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {-64, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput SOC_init annotation(
    Placement(visible = true, transformation(origin = {150, 20}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput chargeCapacity annotation(
    Placement(visible = true, transformation(origin = {150, -20}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  VoltageLimiter voltageLimiter(lowerVoltageLimit = lowerVoltageLimit, upperVoltageLimit = upperVoltageLimit) annotation(
    Placement(visible = true, transformation(origin = {-78, -2}, extent = {{-26, 26}, {26, -26}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensorInterface annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(SOC_init, chargeCounter.SOC_init) annotation(
    Line(points = {{150, 20}, {56, 20}, {56, 20}, {56, 20}}, color = {0, 0, 127}));
  connect(chargeCapacity, chargeCounter.chargeCapacity) annotation(
    Line(points = {{150, -20}, {58, -20}, {58, -20}, {56, -20}}, color = {0, 0, 127}));
  connect(currentSensor.i, chargeCounter.electricCurrent) annotation(
    Line(points = {{-52, -64}, {80, -64}, {80, -2}, {56, -2}, {56, 0}}, color = {0, 0, 127}));
  connect(pin_n_battery, voltageLimiter.pin_n_battery) annotation(
    Line(points = {{-116, -96}, {-94, -96}, {-94, -26}, {-94, -26}}, color = {0, 0, 255}));
  connect(pin_n_load, voltageLimiter.pin_n_load) annotation(
    Line(points = {{-116, 96}, {-94, 96}, {-94, 22}, {-94, 22}}, color = {0, 0, 255}));
  connect(pin_p_load, voltageLimiter.pin_p_load) annotation(
    Line(points = {{-44, 96}, {-62, 96}, {-62, 22}, {-62, 22}}, color = {0, 0, 255}));
  connect(sensorInterface, chargeCounter.SOC) annotation(
    Line(points = {{-30, 0}, {-2, 0}, {-2, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(voltageLimiter.pin_p_battery, currentSensor.n) annotation(
    Line(points = {{-64, -26}, {-64, -54}}, color = {0, 0, 255}));
  connect(currentSensor.p, pin_p_battery) annotation(
    Line(points = {{-64, -74}, {-64, -96}, {-44, -96}}, color = {0, 0, 255}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 72}, lineColor = {255, 255, 255}, extent = {{-26, 22}, {26, -22}}, textString = "Load"), Text(origin = {0, -52}, lineColor = {255, 255, 255}, extent = {{-44, 34}, {48, -36}}, textString = "Battery"), Text(origin = {104, 146}, lineColor = {0, 0, 255}, extent = {{-26, 22}, {84, -80}}, textString = "%name"), Text(origin = {62, 24}, lineColor = {255, 255, 255}, extent = {{-44, 34}, {26, -24}}, textString = "SOC_init"), Text(origin = {106, -52}, lineColor = {255, 255, 255}, extent = {{-44, 34}, {-8, 10}}, textString = "Q")}, coordinateSystem(extent = {{-150, -100}, {150, 100}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}})),
    Documentation(info = "<html><head></head><body>The BatteryManagementSystem component is responsible for protecting the battery pack. It ensures that the pack is not overcharged or overdischarged to dangerous state-of-charge levels. It also limits the maximum charging and discharging current the battery pack can support.</body></html>"));
end BatteryManagementSystem;
