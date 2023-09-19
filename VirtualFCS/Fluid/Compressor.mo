within VirtualFCS.Fluid;

model Compressor
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Medium = Modelica.Media.Air.MoistAir(Temperature(start = system.T_start), AbsolutePressure(start = system.p_start));
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
  Modelica.Blocks.Math.Gain gain1(k = pump.N_nominal) annotation(
    Placement(visible = true, transformation(origin = {-87, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  VirtualFCS.Control.DCMotorControlCompressor dCMotorControlCompressor annotation(
    Placement(visible = true, transformation(origin = {-53, 39}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  // Machines
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(visible = true, transformation(extent = {{-62, -26}, {-42, -6}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(visible = true, transformation(origin = {-20, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter VirtualFCS.Utilities.ParameterRecords.DriveDataComp driveData annotation(
    Placement(visible = true, transformation(extent = {{-90, -24}, {-70, -4}}, rotation = 0)));
   //  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.00365}, head_nominal = {150000, 100000}) ,   N_nominal = 1425, T_start = 298.15, V(displayUnit = "l") = 0.006, allowFlowReversal = false, checkValve = true, checkValveHomotopy = Modelica.Fluid.Types.CheckValveHomotopyType.Closed, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, medium(preferredMediumStates = false), nParallel = 1, use_N_in = true, use_T_start = true, use_powerCharacteristic = false) annotation(
  //   Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(V_flow_nominal = {0, 0.0025, 0.005}, head_nominal = {200000, 150000, 100000})

Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.00365}, head_nominal = {150000, 100000}), redeclare function efficiencyCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.constantEfficiency(eta_nominal =0.62),N_nominal = 1400, T_start = 298.15, V(displayUnit = "l") = 0.006, allowFlowReversal = false, checkValve = true, checkValveHomotopy = Modelica.Fluid.Types.CheckValveHomotopyType.Closed, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, m_flow_start = 0.01, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, medium(preferredMediumStates = false), nParallel = 1, use_N_in = true, use_T_start = true, use_powerCharacteristic = false) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

 
 
 
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(visible = true, transformation(origin = {8, -16}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Sensors
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {24, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Other
  Modelica.Blocks.Math.Gain gain(k = 9.5493) annotation(
    Placement(visible = true, transformation(origin = {67, -16}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  // Power & Efficiencies
  Modelica.Units.SI.Power Power_Compressor "The power consumed by the Compressor";
  Modelica.Blocks.Continuous.LimPID limPID(Td = 100, Ti = 230, k = 450, xd_start = 0.01, xi_start = 0.01, yMax = 2.4, yMin = -2.4, y_start = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-26, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = Medium, m_flow_nominal = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-12, -186}, extent = {{40, 90}, {60, 110}}, rotation = 0)));
  AixLib.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(redeclare package Medium = Medium, m_flow_nominal = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-12, -186}, extent = {{74, 90}, {94, 110}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant3(k = 0.8) annotation(
    Placement(visible = true, transformation(origin = {-72.5, -83.5}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Buildings.Fluid.Humidifiers.Humidifier_u hum(redeclare package Medium = Medium, dp_nominal = 1200, mWat_flow_nominal = 0.1*0.003, m_flow_nominal = 0.1) annotation(
    Placement(visible = true, transformation(origin = {36, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  torque.tau = -9.5488*pump.W_total/pump.N;
  Power_Compressor = pin_p.i*pin_p.v;
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-42, -16}, {-30, -16}}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{35, 6}, {40, 6}, {40, -16}, {60, -16}}, color = {0, 0, 127}));
  connect(pump.port_a, Input) annotation(
    Line(points = {{-10, -60}, {-78, -60}}, color = {0, 170, 255}, thickness = 1));
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{-10, -16}, {-2, -16}}));
  connect(speedSensor.flange, inertia.flange_b) annotation(
    Line(points = {{14, 6}, {-10, 6}, {-10, -16}}));
  connect(sen_Air_comp_speed, speedSensor.w) annotation(
    Line(points = {{72, 6}, {35, 6}}, color = {0, 0, 127}));
  connect(controlInterface, gain1.u) annotation(
    Line(points = {{-112, 42}, {-94, 42}, {-94, 42}, {-92, 42}}, color = {0, 0, 127}));
  connect(speedSensor.w, dCMotorControlCompressor.measuredSpeedInput) annotation(
    Line(points = {{36, 6}, {40, 6}, {40, 39}, {-33, 39}}, color = {0, 0, 127}));
  connect(gain1.y, dCMotorControlCompressor.setSpeedInput) annotation(
    Line(points = {{-82, 42}, {-76, 42}, {-76, 39}, {-73, 39}}, color = {0, 0, 127}));
  connect(pin_n, dCMotorControlCompressor.pwr_pin_n) annotation(
    Line(points = {{-62, 96}, {-62, 76}, {-58, 76}, {-58, 54}}, color = {0, 0, 255}));
  connect(pin_p, dCMotorControlCompressor.pwr_pin_p) annotation(
    Line(points = {{-38, 96}, {-38, 76}, {-48, 76}, {-48, 54}}, color = {0, 0, 255}));
  connect(dCMotorControlCompressor.pin_n, dcpm.pin_an) annotation(
    Line(points = {{-58, 24}, {-58, -6}}, color = {0, 0, 255}));
  connect(dCMotorControlCompressor.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-48, 24}, {-46, 24}, {-46, -6}}, color = {0, 0, 255}));
  connect(pump.N_in, gain.y) annotation(
    Line(points = {{0, -50}, {84, -50}, {84, -16}, {74, -16}}, color = {0, 0, 127}));
  connect(senTem.port_b, senRelHum.port_a) annotation(
    Line(points = {{48, -86}, {62, -86}}));
  connect(senRelHum.port_b, Output) annotation(
    Line(points = {{82, -86}, {84, -86}, {84, -60}}, color = {0, 127, 255}));
  connect(senRelHum.phi, limPID.u_m) annotation(
    Line(points = {{72, -74}, {14, -74}, {14, -96}, {-26, -96}}, color = {0, 0, 127}));
  connect(constant3.y, limPID.u_s) annotation(
    Line(points = {{-64, -84}, {-38, -84}}, color = {0, 0, 127}));
  connect(hum.port_a, pump.port_b) annotation(
    Line(points = {{26, -60}, {10, -60}}, color = {0, 127, 255}));
  connect(hum.port_b, senTem.port_a) annotation(
    Line(points = {{46, -60}, {50, -60}, {50, -72}, {24, -72}, {24, -86}, {28, -86}}, color = {0, 127, 255}));
  connect(hum.u, limPID.y) annotation(
    Line(points = {{26, -54}, {20, -54}, {20, -84}, {-14, -84}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Polygon(visible = false, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = false, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Polygon(visible = false, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(origin = {15, 0}, fillColor = {208, 208, 208}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-115, 80}, {-115, -80}, {85, -50}, {85, 50}, {85, 50}, {-115, 80}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The Compressor model is designed to compress air from the ambient environment to the desired pressure and maintain a sufficient mass flow rate to support the needs of the <a href=\"modelica:77VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the compressor, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the compressor. A <a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">DC Motor</a> drives the compressor and is connected to an inertia and torque source, which is linked to the resistance of the <a href=\"modelica://Modelica.Fluid.Machines.PrescribedPump\">Pump</a>.</div></body></html>"));
end Compressor;
