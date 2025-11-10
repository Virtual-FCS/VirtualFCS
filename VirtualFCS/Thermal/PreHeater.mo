within VirtualFCS.Thermal;

model PreHeater
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  //*** DECLARE PARAMETERS ***//
  parameter Modelica.Units.SI.Resistance R_eq = 1.75 "Equivalent Resistance";
  parameter Modelica.Units.SI.Diameter D_pipe = 0.015 "Pipe Diameter";
  parameter Modelica.Units.SI.Length L_pipe = 1 "Pipe Length";
  parameter Real N_pipe(unit = "1") = 10 "Number of Parallel Pipes";
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Fluid.Pipes.DynamicPipe pipe(redeclare package Medium = Medium, diameter = D_pipe, length = L_pipe, modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, nNodes = 1, nParallel = N_pipe, p_a_start = 102502, use_HeatTransfer = true) annotation(
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {80, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{40, 90}, {60, 110}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-80, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-60, 90}, {-40, 110}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G = 1777) annotation(
    Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = 100) annotation(
    Placement(visible = true, transformation(origin = {0, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R = R_eq) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation(
    Placement(visible = true, transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  prescribedHeatFlow.Q_flow = R1.LossPower;
  connect(port_a, pipe.port_a) annotation(
    Line(points = {{-100, 0}, {-91, 0}, {-91, -80}, {-10, -80}}, color = {0, 0, 255}, thickness = 1));
  connect(pipe.port_b, port_b) annotation(
    Line(points = {{10, -80}, {91, -80}, {91, 0}, {100, 0}}, color = {255, 0, 0}, thickness = 1));
  connect(thermalConductor.port_b, pipe.heatPorts[1]) annotation(
    Line(points = {{0, -60}, {0, -60}, {0, -76}, {0, -76}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, thermalConductor.port_a) annotation(
    Line(points = {{0, -22}, {0, -22}, {0, -40}, {0, -40}}, color = {191, 0, 0}));
  connect(pin_p, R1.p) annotation(
    Line(points = {{-80, 102}, {-80, 60}, {-10, 60}}, color = {0, 0, 255}));
  connect(R1.n, pin_n) annotation(
    Line(points = {{10, 60}, {80, 60}, {80, 100}}, color = {0, 0, 255}));
  connect(prescribedHeatFlow.port, heatCapacitor.port) annotation(
    Line(points = {{-40, -20}, {0, -20}, {0, -22}, {0, -22}}, color = {191, 0, 0}));
  annotation(
    Icon(graphics = {Line(origin = {29, 31.44}, points = {{-79, 68.562}, {-79, -71.438}, {-69, 8.56202}, {-59, -71.438}, {-49, 8.56202}, {-39, -71.438}, {-29, 8.56202}, {-19, -71.438}, {-9, 8.56202}, {1, -71.438}, {11, 8.56202}, {21, -71.438}, {21, 70.562}, {23, 72.562}}, color = {255, 0, 0}, thickness = 1.5), Line(origin = {-0.67, 27.14}, points = {{-98.9689, -27.1425}, {99.0311, -27.1425}, {101.031, -27.1425}}, color = {0, 85, 255}, thickness = 2)}));
end PreHeater;
