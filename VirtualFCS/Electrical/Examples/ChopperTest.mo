within VirtualFCS.Electrical.Examples;

model ChopperTest "Step up chopper with resistive load"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Frequency f = 1000 "Switching frequency";
  parameter Modelica.Units.SI.Voltage Vsource = 60 "Source voltage";
  parameter Modelica.Units.SI.Inductance L = 25e-3 "Chopper internal inductance";
  parameter Modelica.Units.SI.Capacitance C = 20e-6 "Smoothing capacitance";
  parameter Real dutyCycle = 0.20 "Duty cycle";
  parameter Modelica.Units.SI.Current ILoad = 1.2 "Load current";
  parameter Modelica.Units.SI.Resistance RLoad = V0/ILoad "Load resistance";
  parameter Modelica.Units.SI.Voltage V0 = Vsource*dutyCycle "No-load output voltage";
  Modelica.Electrical.Analog.Sources.ConstantVoltage source(final V = Vsource) annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Electrical.ChopperStepUpDown chopper(L = L)  annotation(
    Placement(transformation(extent = {{-60, -10}, {-40, 10}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(transformation(extent = {{30, -20}, {10, 0}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
    Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = 270, origin = {60, 10})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(extent = {{-90, -40}, {-70, -20}})));
  Modelica.Electrical.PowerConverters.DCDC.Control.SignalPWM signalPWM(constantDutyCycle = dutyCycle, f = f, useConstantDutyCycle = false) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {-30, -40})));
  Modelica.Blocks.Math.Mean meanCurrent(f = f, x0 = 0) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {90, -40})));
  Modelica.Blocks.Math.Mean meanVoltage(f = f, x0 = 0) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {90, 10})));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C = C, v(fixed = true, start = V0)) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Basic.Resistor loadResistor(R = RLoad) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {40, 40})));
  Modelica.Blocks.Sources.Ramp dutycycle(height = 0.8, duration = 0.5, offset = 0.1, startTime = 0.1) annotation(
    Placement(transformation(extent = {{-100, -90}, {-80, -70}}, rotation = -0)));
 
equation
  connect(source.p, chopper.dc_p1) annotation(
    Line(points = {{-80, 10}, {-70, 10}, {-70, 6}, {-60, 6}}, color = {0, 0, 255}));
  connect(source.n, chopper.dc_n1) annotation(
    Line(points = {{-80, -10}, {-70, -10}, {-70, -6}, {-60, -6}}, color = {0, 0, 255}));
  connect(voltageSensor.n, currentSensor.p) annotation(
    Line(points = {{60, 0}, {60, -10}, {30, -10}}, color = {0, 0, 255}));
  connect(source.n, ground.p) annotation(
    Line(points = {{-80, -10}, {-80, -20}}, color = {0, 0, 255}));
  connect(voltageSensor.v, meanVoltage.u) annotation(
    Line(points = {{71, 10}, {78, 10}}, color = {0, 0, 127}));
  connect(currentSensor.i, meanCurrent.u) annotation(
    Line(points = {{20, -21}, {20, -40}, {78, -40}}, color = {0, 0, 127}));
  connect(signalPWM.fire, chopper.fire_p) annotation(
    Line(points = {{-36, -29}, {-36, -20}, {-56, -20}, {-56, -12}}, color = {255, 0, 255}));
  connect(voltageSensor.p, capacitor.p) annotation(
    Line(points = {{60, 20}, {60, 60}, {1.77636e-15, 60}, {1.77636e-15, 10}}, color = {0, 0, 255}));
  connect(chopper.dc_n2, capacitor.n) annotation(
    Line(points = {{-40, -6}, {-20, -6}, {-20, -10}, {-1.77636e-15, -10}}, color = {0, 0, 255}));
  connect(capacitor.n, currentSensor.n) annotation(
    Line(points = {{-1.77636e-15, -10}, {10, -10}}, color = {0, 0, 255}));
  connect(loadResistor.n, currentSensor.p) annotation(
    Line(points = {{40, 30}, {40, -10}, {30, -10}}, color = {0, 0, 255}));
  connect(loadResistor.p, capacitor.p) annotation(
    Line(points = {{40, 50}, {40, 60}, {1.77636e-15, 60}, {1.77636e-15, 10}}, color = {0, 0, 255}));
  connect(dutycycle.y, signalPWM.dutyCycle) annotation(
    Line(points = {{-78, -80}, {-60, -80}, {-60, -40}, {-42, -40}}, color = {0, 0, 127}));
  connect(chopper.dc_p2, capacitor.p) annotation(
    Line(points = {{-40, 6}, {-20, 6}, {-20, 10}, {0, 10}}, color = {0, 0, 255}));
  annotation(
    experiment(StopTime = 1, Interval = 1e-05, Tolerance = 1e-06, StartTime = 0),
    Documentation(info = "<html>
<p>This example demonstrates the switching on of a resistive load operated by a step up chopper.
DC output voltage is equal to <code>1/(1 - dutyCycle)</code> times the input voltage.
Plot current <code>currentSensor.i</code>, averaged current <code>meanCurrent.y</code>, total voltage <code>voltageSensor.v</code> and voltage <code>meanVoltage.v</code>.</p>
</html>"));
end ChopperTest;
