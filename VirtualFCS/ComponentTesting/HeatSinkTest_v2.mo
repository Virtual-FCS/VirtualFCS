within VirtualFCS.ComponentTesting;

model HeatSinkTest_v2
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  VirtualFCS.Fluid.PumpElectricDC pumpElectricDC annotation(
    Placement(visible = true, transformation(origin = {-36, -8.88178e-16}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, m_flow_start = 0.01, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial)  annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium = Medium, T = Medium.T_default + 100, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.FixedBoundary fixedBoundary(redeclare package Medium = Medium, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  VirtualFCS.Electrochemical.Battery.BatterySystem batterySystem annotation(
    Placement(visible = true, transformation(origin = {-36, 40}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 0.14, f = 0.01, offset = 0.15, startTime = 10)  annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-60, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature1(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-12, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Sensors.Temperature temperature2(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {62, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  
  Modelica.Fluid.Pipes.DynamicPipe pipe(
    use_T_start = true, 
    length = 0.2, 
    diameter = 0.01,
    nParallel = 5,
    redeclare package Medium = Medium, 
    modelStructure = Modelica.Fluid.Types.ModelStructure.av_vb, 
    use_HeatTransfer = true) 
  annotation(
    Placement(visible = true, transformation(origin = {26, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {26, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T(displayUnit = "K") = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {26, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 7200)  annotation(
    Placement(visible = true, transformation(origin = {68, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(batterySystem.pin_n, pumpElectricDC.pin_n) annotation(
    Line(points = {{-40, 30}, {-40, 11}}, color = {0, 0, 255}));
  connect(batterySystem.pin_p, pumpElectricDC.pin_p) annotation(
    Line(points = {{-32, 30}, {-32, 11}}, color = {0, 0, 255}));
  connect(boundary.ports[1], pumpElectricDC.Input) annotation(
    Line(points = {{-80, 0}, {-49, 0}}, color = {0, 127, 255}));
  connect(sine.y, pumpElectricDC.contol_input) annotation(
    Line(points = {{-79, -50}, {-40, -50}, {-40, -11}}, color = {0, 0, 127}));
  connect(temperature.port, pumpElectricDC.Input) annotation(
    Line(points = {{-60, -14}, {-60, 0}, {-48, 0}}, color = {0, 127, 255}));
  connect(pumpElectricDC.Output, pipe.port_a) annotation(
    Line(points = {{-24, 0}, {16, 0}}, color = {0, 127, 255}));
  connect(temperature1.port, pumpElectricDC.Output) annotation(
    Line(points = {{-12, -14}, {-12, 0}, {-24, 0}}, color = {0, 127, 255}));
  connect(pipe.port_b, fixedBoundary.ports[1]) annotation(
    Line(points = {{36, 0}, {80, 0}}, color = {0, 127, 255}));
  connect(temperature2.port, pipe.port_b) annotation(
    Line(points = {{62, -14}, {62, 0}, {36, 0}}, color = {0, 127, 255}));
  connect(pipe.heatPorts[1], convection.solid) annotation(
    Line(points = {{26, -4}, {26, -40}}, color = {191, 0, 0}));
  connect(convection.fluid, fixedTemperature.port) annotation(
    Line(points = {{26, -60}, {26, -74}}, color = {191, 0, 0}));
  connect(realExpression.y, convection.Gc) annotation(
    Line(points = {{58, -56}, {48, -56}, {48, -50}, {36, -50}}, color = {0, 0, 127}));
  annotation (experiment(StopTime = 600, Interval = 0.5, Tolerance = 1e-6));
end HeatSinkTest_v2;
