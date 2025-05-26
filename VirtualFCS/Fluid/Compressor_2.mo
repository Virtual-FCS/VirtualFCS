within VirtualFCS.Fluid;

model Compressor_2
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  //replaceable package Medium = Modelica.Media.Air.MoistAir(reference_X={0.01,0.99});//(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
  replaceable package Medium = Buildings.Media.Air;
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-78, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {84, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-38, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {20, 60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-62, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-16, 60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  // Control components
  Modelica.Blocks.Interfaces.RealOutput sen_Air_comp_speed annotation(
    Placement(visible = true, transformation(origin = {72, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation(
    Placement(visible = true, transformation(origin = {-113, 41}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-113, 61}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = pump.N_nominal/mf_nom) "mass flow to RPM (if linear flow eq)" annotation(
    Placement(visible = true, transformation(origin = {-87, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Control.DCMotorControlCompressor dCMotorControlCompressor annotation(
    Placement(transformation(origin = {-35, 41}, extent = {{-17, -17}, {17, 17}})));
  // Machines
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-62, -26}, {-42, -6}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(transformation(origin = {0, -16}, extent = {{-10, -10}, {10, 10}})));
  parameter Utilities.ParameterRecords.DriveDataComp driveData annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-90, -24}, {-70, -4}})));
  parameter Modelica.Units.SI.MassFlowRate mf_nom = 0.1 "Nominal compressor mass flow";
  //  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.05}, head_nominal = {200000, 100000}) ,   N_nominal = 2000, T_start = 298.15, V(displayUnit = "l") = 0.006, allowFlowReversal = false, checkValve = true, checkValveHomotopy = Modelica.Fluid.Types.CheckValveHomotopyType.Closed, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, medium(preferredMediumStates = false), nParallel = 1, use_N_in = true, use_T_start = true, use_powerCharacteristic = false) annotation(
  //   Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(V_flow_nominal = {0, 0.025, 0.05}, head_nominal = {250000, 150000, 100000})
  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, mf_nom}, head_nominal = {500000, 300000}), redeclare function efficiencyCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.constantEfficiency(eta_nominal = 0.75), N_nominal = 150, T_start = 298.15, V(displayUnit = "l") = 0.006, allowFlowReversal = false, checkValve = true, checkValveHomotopy = Modelica.Fluid.Types.CheckValveHomotopyType.Closed, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, m_flow_start = 0.0001, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, medium(preferredMediumStates = false), nParallel = 1, use_N_in = true, use_T_start = true, use_powerCharacteristic = false) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(transformation(origin = {28, -16}, extent = {{10, -10}, {-10, 10}})));
  // Sensors
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(transformation(origin = {44, 6}, extent = {{-10, -10}, {10, 10}})));
  // Other
  Modelica.Blocks.Math.Gain gain(k = 9.5493) annotation(
    Placement(visible = true, transformation(origin = {67, -16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  // Power & Efficiencies
  Modelica.Units.SI.Power Power_Compressor "The power consumed by the Compressor";
  // Reference: https://www.mdpi.com/1996-1073/15/6/2113
  Modelica.Blocks.Math.Gain gain2(k = 9.5493) annotation(
    Placement(transformation(origin = {33, 40}, extent = {{-6, -6}, {6, 6}})));
equation
  torque.tau = -9.5488*pump.W_total/pump.N;
  Power_Compressor = pin_p.i*pin_p.v;
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-22, -16}, {-10, -16}}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{55, 6}, {58, 6}, {58, -16}, {59.8, -16}}, color = {0, 0, 127}));
  connect(pump.port_a, Input) annotation(
    Line(points = {{-10, -60}, {-78, -60}}, color = {0, 170, 255}, thickness = 1));
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{10, -16}, {18, -16}}));
  connect(speedSensor.flange, inertia.flange_b) annotation(
    Line(points = {{34, 6}, {10, 6}, {10, -16}}));
  connect(sen_Air_comp_speed, speedSensor.w) annotation(
    Line(points = {{72, 6}, {55, 6}}, color = {0, 0, 127}));
  connect(controlInterface, gain1.u) annotation(
    Line(points = {{-113, 41}, {-94, 41}, {-94, 41}, {-93, 41}}, color = {0, 0, 127}));
  connect(gain1.y, dCMotorControlCompressor.setSpeedInput) annotation(
    Line(points = {{-81.5, 41}, {-55, 41}}, color = {0, 0, 127}));
  connect(pin_n, dCMotorControlCompressor.pwr_pin_n) annotation(
    Line(points = {{-62, 96}, {-62, 76}, {-40, 76}, {-40, 56}}, color = {0, 0, 255}));
  connect(pin_p, dCMotorControlCompressor.pwr_pin_p) annotation(
    Line(points = {{-38, 96}, {-38, 76}, {-30, 76}, {-30, 56}}, color = {0, 0, 255}));
  connect(dCMotorControlCompressor.pin_n, dcpm.pin_an) annotation(
    Line(points = {{-40, 26}, {-40, 10}, {-38, 10}, {-38, -6}}, color = {0, 0, 255}));
  connect(dCMotorControlCompressor.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-30, 26}, {-30, 8}, {-26, 8}, {-26, -6}}, color = {0, 0, 255}));
  connect(pump.port_b, Output) annotation(
    Line(points = {{10, -60}, {84, -60}}, color = {0, 127, 255}));
  connect(speedSensor.w, gain2.u) annotation(
    Line(points = {{55, 6}, {55, 23}, {26, 23}, {26, 40}}, color = {0, 0, 127}));
  connect(dCMotorControlCompressor.measuredSpeedInput, gain2.y) annotation(
    Line(points = {{-15, 41}, {-15, 52}, {42, 52}, {42, 43}, {40, 43}, {40, 40}}, color = {0, 0, 127}));
  connect(gain.y, pump.N_in) annotation(
    Line(points = {{74, -16}, {88, -16}, {88, -38}, {0, -38}, {0, -50}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Polygon(visible = false, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = false, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Polygon(visible = false, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(origin = {15, 0}, fillColor = {208, 208, 208}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-115, 80}, {-115, -80}, {85, -50}, {85, 50}, {85, 50}, {-115, 80}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier), Line(points = {{-100, 80}, {-100, -80}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{-100, -80}, {100, -50}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{-100, 80}, {100, 50}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{100, -50}, {100, 50}}, color = {0, 0, 0}, thickness = 0.5)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The Compressor model is designed to compress air from the ambient environment to the desired pressure and maintain a sufficient mass flow rate to support the needs of the <a href=\"modelica:77VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the compressor, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the compressor. A <a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">DC Motor</a> drives the compressor and is connected to an inertia and torque source, which is linked to the resistance of the <a href=\"modelica://Modelica.Fluid.Machines.PrescribedPump\">Pump</a>.</div></body></html>"),
    Diagram);
end Compressor_2;
