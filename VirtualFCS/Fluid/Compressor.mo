within VirtualFCS.Fluid;

model Compressor

//*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Air.MoistAir;
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(visible = true, transformation(extent = {{-62, -26}, {-42, -6}}, rotation = 0)));
  
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(visible = true, transformation(origin = {-20, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  parameter VirtualFCS.Utilities.ParameterRecords.DriveDataDcPm driveData annotation(
    Placement(visible = true, transformation(extent = {{-90, -24}, {-70, -4}}, rotation = 0)));
  
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-78, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {84, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 9.5493) annotation(
    Placement(visible = true, transformation(origin = {67, -16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {24, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Machines.PrescribedPump pump(
    redeclare package Medium = Medium,
    redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.00365}, head_nominal = {15 * 10000, 10 * 10000}),
    N_nominal = 365, 
    V(displayUnit = "l") = 1e-05, 
    checkValve = true, 
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, 
    massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, 
    nParallel = 1, 
    p_a_start = 150000, 
    use_N_in = true) 
    annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(visible = true, transformation(origin = {8, -16}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-38, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {20, 60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-62, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-16, 60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sen_Air_comp_speed annotation(
    Placement(visible = true, transformation(origin = {72, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  VirtualFCS.Control.DCMotorControl dCMotorControl annotation(
    Placement(visible = true, transformation(origin = {-52, 40}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation(
    Placement(visible = true, transformation(origin = {-113, 41}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-113, 61}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = pump.N_nominal) annotation(
    Placement(visible = true, transformation(origin = {-87, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
equation
  torque.tau = -9.5488 * pump.W_total / pump.N;
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-42, -16}, {-30, -16}}));
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
  connect(sen_Air_comp_speed, speedSensor.w) annotation(
    Line(points = {{72, 6}, {35, 6}}, color = {0, 0, 127}));
  connect(dCMotorControl.pin_n, dcpm.pin_an) annotation(
    Line(points = {{-58, 24}, {-58, 24}, {-58, -6}, {-58, -6}}, color = {0, 0, 255}));
  connect(dCMotorControl.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-46, 24}, {-46, 24}, {-46, -6}, {-46, -6}}, color = {0, 0, 255}));
  connect(pin_n, dCMotorControl.pwr_pin_n) annotation(
    Line(points = {{-62, 96}, {-58, 96}, {-58, 56}, {-58, 56}}, color = {0, 0, 255}));
  connect(dCMotorControl.pwr_pin_p, pin_p) annotation(
    Line(points = {{-46, 56}, {-40, 56}, {-40, 96}, {-38, 96}}, color = {0, 0, 255}));
  connect(speedSensor.w, dCMotorControl.measuredSpeedInput) annotation(
    Line(points = {{36, 6}, {40, 6}, {40, 40}, {-30, 40}, {-30, 40}}, color = {0, 0, 127}));
  connect(controlInterface, gain1.u) annotation(
    Line(points = {{-112, 42}, {-94, 42}, {-94, 42}, {-92, 42}}, color = {0, 0, 127}));
  connect(gain1.y, dCMotorControl.setSpeedInput) annotation(
    Line(points = {{-82, 42}, {-76, 42}, {-76, 40}, {-74, 40}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Polygon(visible = false, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = false, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Polygon(visible = false, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(origin = {15, 0}, fillColor = {208, 208, 208}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-115, 80}, {-115, -80}, {85, -50}, {85, 50}, {85, 50}, {-115, 80}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The Compressor model is designed to compress air from the ambient environment to the desired pressure and maintain a sufficient mass flow rate to support the needs of the fuel cell stack. The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the compressor, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the compressor. A DC motor drives the compressor and is connected to an inertia and torque source, which is linked to the resistance of the pump.</body></html>"));
end Compressor;
