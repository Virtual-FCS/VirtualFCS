within VirtualFCS.Fluid;

model RecirculationBlower
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2;
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.00365}, head_nominal = {15 * 10000, 10 * 10000}), N_nominal = 365, V(displayUnit = "l") = 1e-05, allowFlowReversal = false, checkValve = true, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, nParallel = 1, p_a_start = 200000, use_N_in = true) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-88, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(visible = true, transformation(origin = {-10, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(visible = true, transformation(extent = {{-62, -16}, {-42, 4}}, rotation = 0)));
  parameter VirtualFCS.Utilities.ParameterRecords.DriveDataDcPm driveData annotation(
    Placement(visible = true, transformation(extent = {{-90, -14}, {-70, 6}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {0, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain(k = 9.5493) annotation(
    Placement(visible = true, transformation(origin = {67, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(visible = true, transformation(origin = {20, -6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-40, 84}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-64, 84}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sen_H2_pump_speed annotation(
    Placement(visible = true, transformation(origin = {78, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  VirtualFCS.Control.DCMotorControl dCMotorControl annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput control annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain1(k = pump.N_nominal) annotation(
    Placement(visible = true, transformation(origin = {-87, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
equation
  torque.tau = -9.5488 * pump.W_total / pump.N;
  connect(Input, pump.port_a) annotation(
    Line(points = {{-88, -60}, {-10, -60}}));
  connect(pump.port_b, Output) annotation(
    Line(points = {{10, -60}, {90, -60}}, color = {0, 127, 255}));
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-42, -6}, {-20, -6}}));
  connect(gain.y, pump.N_in) annotation(
    Line(points = {{72.5, 41}, {80, 41}, {80, -40}, {0, -40}, {0, -50}}, color = {0, 0, 127}));
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{0, -6}, {10, -6}}));
  connect(speedSensor.flange, inertia.flange_b) annotation(
    Line(points = {{0, 12}, {0, -6}}));
  connect(pin_n, dCMotorControl.pwr_pin_n) annotation(
    Line(points = {{-64, 84}, {-62, 84}, {-62, 60}, {-55, 60}, {-55, 56}}, color = {0, 0, 255}));
  connect(pin_p, dCMotorControl.pwr_pin_p) annotation(
    Line(points = {{-40, 84}, {-40, 60}, {-45, 60}, {-45, 56}}, color = {0, 0, 255}));
  connect(speedSensor.w, dCMotorControl.measuredSpeedInput) annotation(
    Line(points = {{0, 34}, {0, 40}, {-28, 40}}, color = {0, 0, 127}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{0, 34}, {0, 34}, {0, 40}, {62, 40}, {62, 42}}, color = {0, 0, 127}));
  connect(speedSensor.w, sen_H2_pump_speed) annotation(
    Line(points = {{0, 34}, {0, 78}, {78, 78}}, color = {0, 0, 127}));
  connect(dCMotorControl.pin_n, dcpm.pin_an) annotation(
    Line(points = {{-56, 24}, {-58, 24}, {-58, 4}, {-58, 4}}, color = {0, 0, 255}));
  connect(dCMotorControl.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-44, 24}, {-46, 24}, {-46, 4}, {-46, 4}}, color = {0, 0, 255}));
  connect(control, gain1.u) annotation(
    Line(points = {{-110, 40}, {-94, 40}, {-94, 42}, {-92, 42}}, color = {0, 0, 127}));
  connect(gain1.y, dCMotorControl.setSpeedInput) annotation(
    Line(points = {{-82, 42}, {-72, 42}, {-72, 40}, {-72, 40}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Ellipse(origin = {-26, 26}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-54, 54}, {106, -106}}, endAngle = 360), Polygon(origin = {70, -5}, rotation = -90, lineThickness = 1, points = {{-6, 9}, {-18, -9}, {6, -9}, {6, -9}, {-6, 9}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The RecirculationBlower model is designed to maintain hydrogen gas circulation within the hydrogen subsystem.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the Recirculation Blower, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the blower. A <a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">DC motor</a> drives the recirculation blower and is connected to an inertia and torque source, which is linked to the resistance of the pump.</div></body></html>"));
end RecirculationBlower;