model RecirculationBlower
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2;
 
 
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-88, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(visible = true, transformation(origin = {-10, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {0, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain(k = 9.5493)  annotation(
    Placement(visible = true, transformation(origin = {67, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(visible = true, transformation(origin = {20, -6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-36, 84}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-64, 84}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sen_H2_pump_speed annotation(
    Placement(visible = true, transformation(origin = {78, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  DCMotorControl dCMotorControl annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  
  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.00365}, head_nominal = {15 * 10000, 10 * 10000}), N_nominal = 365, V = 0.001, allowFlowReversal = false, checkValve = true, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, use_N_in = true, use_powerCharacteristic = true)  annotation(
    Placement(visible = true, transformation(origin = {6, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain1(k = pump.N_nominal) annotation(
    Placement(visible = true, transformation(origin = {-87, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(
    VaNominal=driveData.motorData.VaNominal,
    IaNominal=driveData.motorData.IaNominal,
    wNominal=driveData.motorData.wNominal,
    TaNominal=driveData.motorData.TaNominal,
    Ra=driveData.motorData.Ra,
    TaRef=driveData.motorData.TaRef,
    La=driveData.motorData.La,
    Jr=driveData.motorData.Jr,
    useSupport=false,
    Js=driveData.motorData.Js,
    frictionParameters=driveData.motorData.frictionParameters,
    coreParameters=driveData.motorData.coreParameters,
    strayLoadParameters=driveData.motorData.strayLoadParameters,
    brushParameters=driveData.motorData.brushParameters,
    alpha20a=driveData.motorData.alpha20a,
    phiMechanical(fixed=true),
    wMechanical(fixed=true),
    ia(fixed=true),
    TaOperational=368.15,
    core(v(start=0)))  annotation(
    Placement(visible = true, transformation(origin = {-48, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  parameter DriveDataDcPm driveData annotation(
    Placement(visible = true, transformation(origin = {-82, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput control annotation(
    Placement(visible = true, transformation(origin = {-134, 42}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-124, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  torque.tau = -9.5488 * pump.W_total / pump.N;
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{0, -6}, {10, -6}}));
  connect(speedSensor.flange, inertia.flange_b) annotation(
    Line(points = {{0, 12}, {0, -6}}));
  connect(speedSensor.w, dCMotorControl.measuredSpeedInput) annotation(
    Line(points = {{0, 34}, {0, 40}, {-28, 40}}, color = {0, 0, 127}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{0, 34}, {0, 34}, {0, 40}, {62, 40}, {62, 42}}, color = {0, 0, 127}));
  connect(speedSensor.w, sen_H2_pump_speed) annotation(
    Line(points = {{0, 34}, {0, 78}, {78, 78}}, color = {0, 0, 127}));
  connect(gain1.y, dCMotorControl.setSpeedInput) annotation(
    Line(points = {{-82, 42}, {-72, 42}, {-72, 40}, {-72, 40}}, color = {0, 0, 127}));
  connect(gain.y, pump.N_in) annotation(
    Line(points = {{72, 42}, {80, 42}, {80, -42}, {6, -42}, {6, -50}}, color = {0, 0, 127}));
  connect(Input, pump.port_a) annotation(
    Line(points = {{-88, -60}, {-4, -60}}));
  connect(pump.port_b, Output) annotation(
    Line(points = {{16, -60}, {90, -60}}, color = {0, 127, 255}));
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-38, -6}, {-20, -6}}));
  connect(dCMotorControl.pin_n, dcpm.pin_an) annotation(
    Line(points = {{-56, 24}, {-54, 24}, {-54, 4}}, color = {0, 0, 255}));
  connect(dCMotorControl.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-44, 24}, {-42, 24}, {-42, 4}}, color = {0, 0, 255}));
  connect(pin_n, dCMotorControl.pwr_pin_n) annotation(
    Line(points = {{-64, 84}, {-56, 84}, {-56, 56}}, color = {0, 0, 255}));
  connect(pin_p, dCMotorControl.pwr_pin_p) annotation(
    Line(points = {{-36, 84}, {-44, 84}, {-44, 56}}, color = {0, 0, 255}));
 connect(control, gain1.u) annotation(
    Line(points = {{-134, 42}, {-92, 42}}, color = {0, 0, 127}));
protected
  annotation(
    Icon(graphics = {Ellipse(origin = {-26, 26}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-54, 54}, {106, -106}}), Polygon(origin = {70, -5}, rotation = -90, lineThickness = 1, points = {{-6, 9}, {-18, -9}, {6, -9}, {6, -9}, {-6, 9}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The RecirculationBlower model is designed to maintain hydrogen gas circulation within the hydrogen subsystem.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the Recirculation Blower, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the blower. A <a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">DC motor</a> drives the recirculation blower and is connected to an inertia and torque source, which is linked to the resistance of the pump.</div></body></html>"),
    uses(Modelica(version = "4.0.0")));
end RecirculationBlower;
