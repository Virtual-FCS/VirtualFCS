within VirtualFCS.Fluid;

model RecirculationBlower
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-78, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {84, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-38, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-62, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Control components
  Modelica.Blocks.Interfaces.RealOutput sen_H2_pump_speed annotation(
    Placement(visible = true, transformation(origin = {72, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation(
    Placement(visible = true, transformation(origin = {-113, 41}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain1(k = pump.N_nominal) annotation(
    Placement(visible = true, transformation(origin = {-87, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  // Machines
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-62, -26}, {-42, -6}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(visible = true, transformation(origin = {-20, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter VirtualFCS.Utilities.ParameterRecords.DriveDataRBlower driveData annotation(
    Placement(visible = true, transformation(extent = {{-90, -24}, {-70, -4}}, rotation = 0)));
  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.00365}, head_nominal = {150000, 100000}), N_nominal = 200, T_start = 323.15, V(displayUnit = "l") = 0.006, allowFlowReversal = false, checkValve = true, checkValveHomotopy = Modelica.Fluid.Types.CheckValveHomotopyType.Closed, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, medium(preferredMediumStates = false), nParallel = 1, use_N_in = true, use_T_start = true) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(visible = true, transformation(origin = {8, -16}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Sensors
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {24, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Other
  Modelica.Blocks.Math.Gain gain(k = 9.5493) annotation(
    Placement(visible = true, transformation(origin = {67, -16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  VirtualFCS.Control.DCMotorControlRecirculationBlower dCMotorControlRecirculationBlower annotation(
    Placement(visible = true, transformation(origin = {-50, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  // Power & Efficiencies
  Modelica.Units.SI.Power Power_RecirculationBlower "The power consumed by the RecirculationBlower";
equation
  torque.tau = -9.5488*pump.W_total/pump.N;
  Power_RecirculationBlower = pin_p.i*pin_p.v;
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-40, -16}, {-30, -16}}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{35, 6}, {40, 6}, {40, -16}, {60, -16}}, color = {0, 0, 127}));
  connect(gain.y, pump.N_in) annotation(
    Line(points = {{74, -16}, {82, -16}, {82, -40}, {0, -40}, {0, -50}}, color = {0, 0, 127}));
  connect(pump.port_b, Output) annotation(
    Line(points = {{10, -60}, {84, -60}}, color = {0, 170, 0}, thickness = 1));
  connect(pump.port_a, Input) annotation(
    Line(points = {{-10, -60}, {-78, -60}}, color = {0, 170, 0}, thickness = 1));
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{-10, -16}, {-2, -16}}));
  connect(speedSensor.flange, inertia.flange_b) annotation(
    Line(points = {{14, 6}, {-10, 6}, {-10, -16}}));
  connect(sen_H2_pump_speed, speedSensor.w) annotation(
    Line(points = {{72, 6}, {35, 6}}, color = {0, 0, 127}));
  connect(controlInterface, gain1.u) annotation(
    Line(points = {{-112, 42}, {-94, 42}, {-94, 42}, {-92, 42}}, color = {0, 0, 127}));
  connect(gain1.y, dCMotorControlRecirculationBlower.setSpeedInput) annotation(
    Line(points = {{-82, 42}, {-74, 42}}, color = {0, 0, 127}));
  connect(dcpm.pin_an, dCMotorControlRecirculationBlower.pin_n) annotation(
    Line(points = {{-56, -6}, {-56, 24}}, color = {0, 0, 255}));
  connect(dCMotorControlRecirculationBlower.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-44, 24}, {-44, -6}}, color = {0, 0, 255}));
  connect(pin_n, dCMotorControlRecirculationBlower.pwr_pin_n) annotation(
    Line(points = {{-62, 96}, {-62, 80}, {-56, 80}, {-56, 60}}, color = {0, 0, 255}));
  connect(pin_p, dCMotorControlRecirculationBlower.pwr_pin_p) annotation(
    Line(points = {{-38, 96}, {-38, 80}, {-44, 80}, {-44, 60}}, color = {0, 0, 255}));
  connect(speedSensor.w, dCMotorControlRecirculationBlower.measuredSpeedInput) annotation(
    Line(points = {{36, 6}, {40, 6}, {40, 42}, {-26, 42}}, color = {0, 0, 127}));
  connect(speedSensor.w, sen_H2_pump_speed) annotation(
    Line(points = {{36, 6}, {72, 6}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Polygon(visible = false, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = false, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Polygon(visible = false, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Ellipse(origin = {-26, 26}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-54, 54}, {106, -106}}), Polygon(origin = {70, -5}, rotation = -90, lineThickness = 1, points = {{-6, 9}, {-18, -9}, {6, -9}, {6, -9}, {-6, 9}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The RecirculationBlower model is designed to maintain hydrogen gas circulation within the hydrogen subsystem.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the Recirculation Blower, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the blower. A <a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">DC motor</a> drives the recirculation blower and is connected to an inertia and torque source, which is linked to the resistance of the pump.</div></body></html>"));
end RecirculationBlower;
