within VirtualFCS.Fluid;

model Compressor
  import Modelica.Constants.pi;
  outer Modelica.Fluid.System system "System properties";
  replaceable package Medium = VirtualFCS.Media.CathodeAir;
  
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-100, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {-20, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {20, 60}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-60, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-16, 60}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Interfaces.RealInput setMassFlow annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-113, 61}, extent = {{-13, -13}, {13, 13}})));
  Modelica.Blocks.Math.Gain gain1(k = pump.N_nominal) annotation(
    Placement(transformation(origin = {-82, 40}, extent = {{-10, -10}, {10, 10}})));
  VirtualFCS.Control.DCMotorControlCompressor dCMotorControlCompressor annotation(
    Placement(transformation(origin = {-40, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(transformation(origin = {12, 6}, extent = {{-62, -26}, {-42, -6}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(transformation(origin = {-10, -10}, extent = {{-10, -10}, {10, 10}})));
  parameter VirtualFCS.Utilities.ParameterRecords.DriveDataComp driveData annotation(
    Placement(visible = true, transformation(extent = {{-90, -24}, {-70, -4}}, rotation = 0)));
  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.1}, head_nominal = {500000, 300000}), redeclare function efficiencyCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.constantEfficiency(eta_nominal = 0.62), N_nominal = 1200, T_start = 298.15, V(displayUnit = "l") = 0.006, allowFlowReversal = false, checkValve = true, checkValveHomotopy = Modelica.Fluid.Types.CheckValveHomotopyType.Closed, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, m_flow_start = 0.0001, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, medium(preferredMediumStates = false), nParallel = 1, use_N_in = true, use_T_start = true, use_powerCharacteristic = false) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(transformation(origin = {30, -10}, extent = {{10, -10}, {-10, 10}})));

  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(transformation(origin = {10, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain rad_s_to_rpm(k = 60/2/pi) annotation(
    Placement(transformation(origin = {70, 10}, extent = {{-10, -10}, {10, 10}})));
  // Reference: https://www.mdpi.com/1996-1073/15/6/2113

equation
  torque.tau = -60/2/pi*pump.W_total/pump.N;
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-30, -10}, {-20, -10}}));
  connect(speedSensor.w, rad_s_to_rpm.u) annotation(
    Line(points = {{21, 10}, {58, 10}}, color = {0, 0, 127}));
  connect(pump.port_a, Input) annotation(
    Line(points = {{-10, -60}, {-100, -60}}, color = {0, 170, 255}, thickness = 1));
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{0, -10}, {20, -10}}));
  connect(speedSensor.flange, inertia.flange_b) annotation(
    Line(points = {{0, 10}, {0, -10}}));
  connect(setMassFlow, gain1.u) annotation(
    Line(points = {{-110, 40}, {-94, 40}}, color = {0, 0, 127}));
  connect(speedSensor.w, dCMotorControlCompressor.measuredSpeedInput) annotation(
    Line(points = {{21, 10}, {40, 10}, {40, 40}, {-16, 40}}, color = {0, 0, 127}));
  connect(gain1.y, dCMotorControlCompressor.setSpeedInput) annotation(
    Line(points = {{-71, 40}, {-64, 40}}, color = {0, 0, 127}));
  connect(pin_n, dCMotorControlCompressor.pwr_pin_n) annotation(
    Line(points = {{-60, 100}, {-60, 80}, {-46, 80}, {-46, 58}}, color = {0, 0, 255}));
  connect(pin_p, dCMotorControlCompressor.pwr_pin_p) annotation(
    Line(points = {{-20, 100}, {-20, 80}, {-34, 80}, {-34, 58}}, color = {0, 0, 255}));
  connect(dCMotorControlCompressor.pin_n, dcpm.pin_an) annotation(
    Line(points = {{-46, 22}, {-46, 0}}, color = {0, 0, 255}));
  connect(dCMotorControlCompressor.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-34, 22}, {-34, 0}}, color = {0, 0, 255}));
  connect(Output, pump.port_b) annotation(
    Line(points = {{100, -60}, {10, -60}}, color = {0, 170, 255}, thickness = 1));
  connect(rad_s_to_rpm.y, pump.N_in) annotation(
    Line(points = {{82, 10}, {90, 10}, {90, -40}, {0, -40}, {0, -50}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Polygon(visible = false, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = false, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Polygon(visible = false, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(origin = {15, 0}, fillColor = {208, 208, 208}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-115, 80}, {-115, -80}, {85, -50}, {85, 50}, {85, 50}, {-115, 80}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier), Line(points = {{-100, 80}, {-100, -80}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{-100, -80}, {100, -50}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{-100, 80}, {100, 50}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{100, -50}, {100, 50}}, color = {0, 0, 0}, thickness = 0.5)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The Compressor model is designed to compress air from the ambient environment to the desired pressure and maintain a sufficient mass flow rate to support the needs of the <a href=\"modelica:77VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the compressor, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the compressor. A <a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">DC Motor</a> drives the compressor and is connected to an inertia and torque source, which is linked to the resistance of the <a href=\"modelica://Modelica.Fluid.Machines.PrescribedPump\">Pump</a>.</div></body></html>"));
end Compressor;
