within VirtualFCS.Fluid;

model PumpElectricDC
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  // DC motor data
  // Instantiate permanent magnate DC motor
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {0, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation(
    Placement(visible = true, transformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {99, -60}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-101, -60}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sensors.VolumeFlowRate volumeFlowRate(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-79, -60}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2(n1 = 1, n2 = 1) annotation(
    Placement(visible = true, transformation(origin = {82, 90}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput contol_input annotation(
    Placement(visible = true, transformation(origin = {-72, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  VirtualFCS.Control.DCMotorControl dCMotorControl annotation(
    Placement(visible = true, transformation(origin = {-20, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  inner Modelica.Fluid.System system "System wide properties";
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {40, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(visible = true, transformation(origin = {-20, -6}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(visible = true, transformation(origin = {50, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter VirtualFCS.Utilities.ParameterRecords.DriveDataDcPm driveData annotation(
    Placement(visible = true, transformation(extent = {{-64, -16}, {-44, 4}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(visible = true, transformation(origin = {80, -6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.0021333}, head_nominal = {13.05, 7.138}), N_nominal = 1200, V = 0.005, checkValve = true, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, nParallel = 1, p_a_start = 102502, use_N_in = true) annotation(
    Placement(visible = true, transformation(origin = {20, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 9.5493) annotation(
    Placement(visible = true, transformation(origin = {21, -32}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain1(k = pump.N_nominal / 9.5493) annotation(
    Placement(visible = true, transformation(origin = {-60, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
equation
  torque.tau = -9.5488 * pump.W_total / pump.N;
//*** DEFINE CONNECTIONS ***//
  connect(multiplex2.y, sensors) annotation(
    Line(points = {{91, 90}, {110, 90}}, color = {0, 0, 127}));
  connect(volumeFlowRate.port_a, Input) annotation(
    Line(points = {{-90, -60}, {-101, -60}}, color = {0, 127, 255}));
  connect(volumeFlowRate.V_flow, multiplex2.u1[1]) annotation(
    Line(points = {{-79, -48}, {-80, -48}, {-80, 94}, {72, 94}}, color = {0, 0, 127}));
  connect(pin_n, dCMotorControl.pwr_pin_n) annotation(
    Line(points = {{-30, 80}, {-26, 80}, {-26, 58}}, color = {0, 0, 255}));
  connect(pin_p, dCMotorControl.pwr_pin_p) annotation(
    Line(points = {{0, 80}, {-14, 80}, {-14, 58}}, color = {0, 0, 255}));
  connect(multiplex2.u2[1], speedSensor.w) annotation(
    Line(points = {{72, 85}, {40, 85}, {40, 31}}, color = {0, 0, 127}));
  connect(dCMotorControl.pin_n, dcpm.pin_an) annotation(
    Line(points = {{-26, 22}, {-26, 15}, {-28, 15}, {-28, 8}}, color = {0, 0, 255}));
  connect(dCMotorControl.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-14, 22}, {-14, 16}, {-12, 16}, {-12, 8}}, color = {0, 0, 255}));
  connect(speedSensor.flange, dcpm.flange) annotation(
    Line(points = {{40, 10}, {40, -6}, {-6, -6}}));
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-6, -6}, {40, -6}}));
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{60, -6}, {70, -6}}));
  connect(volumeFlowRate.port_b, pump.port_a) annotation(
    Line(points = {{-68, -60}, {10, -60}}, color = {0, 127, 255}));
  connect(pump.port_b, Output) annotation(
    Line(points = {{30, -60}, {100, -60}}, color = {0, 127, 255}));
  connect(gain.y, pump.N_in) annotation(
    Line(points = {{22, -38}, {20, -38}, {20, -50}, {20, -50}}, color = {0, 0, 127}));
  connect(gain.u, speedSensor.w) annotation(
    Line(points = {{22, -24}, {20, -24}, {20, 34}, {40, 34}, {40, 32}}, color = {0, 0, 127}));
  connect(gain1.y, dCMotorControl.setSpeedInput) annotation(
    Line(points = {{-54.5, 41}, {-46, 41}, {-46, 40}, {-44, 40}}, color = {0, 0, 127}));
  connect(contol_input, gain1.u) annotation(
    Line(points = {{-72, 66}, {-56, 66}, {-56, 54}, {-76, 54}, {-76, 41}, {-66, 41}}, color = {0, 0, 127}));
  connect(dCMotorControl.measuredSpeedInput, speedSensor.w) annotation(
    Line(points = {{4, 40}, {40, 40}, {40, 32}, {40, 32}}, color = {0, 0, 127}));
protected
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Ellipse(origin = {-2, -15}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-78, 95}, {82, -65}}, endAngle = 360), Line(origin = {40, 40}, points = {{-40, 40}, {40, -40}, {40, -40}}, thickness = 3), Line(origin = {40, -40}, points = {{-40, -40}, {40, 40}, {40, 40}}, thickness = 3)}),
    Diagram);
end PumpElectricDC;
