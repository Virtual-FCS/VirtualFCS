within VirtualFCS.Fluid;

model Compressor_30kW
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
//  replaceable package Medium = Modelica.Media.Air.MoistAir(reference_X={0.01,0.99});
  replaceable package Medium = VirtualFCS.Media.CathodeAir;
  // Parameters
  parameter Utilities.ParameterRecords.DriveDataComp driveData(motorData = Utilities.ParameterRecords.DCPMMCompressor_30kW(), JL = 0.15) annotation(
    Placement(transformation(origin = {16, 12}, extent = {{-90, -24}, {-70, -4}})));
  final parameter Real gamma_air = 1.4 "Moist air Cp/Cv";
  parameter Real rpm_nom = 11000 "Nominal compressor RPM";
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-104, -48}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {104, -48}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {-28, 104}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {20, 60}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-40, 104}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-16, 60}, extent = {{-6, -6}, {6, 6}})));
  // Control components
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation(
    Placement(transformation(origin = {-113, 37}, extent = {{-13, -13}, {13, 13}}), iconTransformation(origin = {-113, 61}, extent = {{-13, -13}, {13, 13}})));
  // Machines
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(start = 0.10471975511965978, fixed = true, displayUnit = "rpm"), wNominal = driveData.motorData.wNominal) annotation(
    Placement(transformation(origin = {16, 12}, extent = {{-62, -26}, {-42, -6}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = driveData.motorData.Jr) annotation(
    Placement(transformation(origin = {-4, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(transformation(origin = {24, -4}, extent = {{10, -10}, {-10, 10}})));
  // Sensors
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(transformation(origin = {22, 18}, extent = {{-10, -10}, {10, 10}})));
  // Other
  Modelica.Blocks.Math.Gain rad_s_to_rpm(k = 9.5493) annotation(
    Placement(transformation(origin = {49, 18}, extent = {{-6, -6}, {6, 6}})));
  // Power & Efficiencies
  Modelica.Units.SI.Power Power_Compressor "The power consumed by the Compressor";
  Modelica.Units.SI.Power Power_Compressor_2 "The power consumed by the Compressor";
  Modelica.Units.SI.Temperature T_out_is "Outlet temperature in isentropic compression";
  Modelica.Fluid.Sensors.Temperature temp_in_comp(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-62, -30}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Movers.SpeedControlled_y mov(redeclare Buildings.Fluid.Movers.Data.Generic per(etaHydMet = Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate,
  etaMotMet = Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
  efficiency(V_flow = {0}, eta = {0.75}),
  motorEfficiency(V_flow = {0}, eta = {1.}), pressure(V_flow = {0, 0.171, 0.21, 0.227, 0.238, 0.245}, dp = {252000, 249590, 243590, 211190, 183080, 154240})), use_riseTime = false, redeclare package Medium = Medium, allowFlowReversal = false, addPowerToMedium = true, tau = 0.001, show_T = false) annotation(
    Placement(transformation(origin = {-4, -48}, extent = {{-14, -14}, {14, 14}})));
  Control.DCMotorControlCompressor_2 dCMotorControlCompressor(driveData = driveData) annotation(
    Placement(transformation(origin = {-35, 45}, extent = {{-19, -19}, {19, 19}})));
  Modelica.Blocks.Math.Gain rpm_normalized(k = 1/rpm_nom) annotation(
    Placement(transformation(origin = {-87, 38}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Gain rpm_normalized2(k = 1/rpm_nom) annotation(
    Placement(transformation(origin = {71, 18}, extent = {{-6, -6}, {6, 6}})));
equation
  torque.tau = -9.5488*Power_Compressor_2/(mov.y*rpm_nom);
//  torque.tau = -9.5488*mov.P/(mov.y*rpm_nom);
  Power_Compressor = pin_p.i*pin_p.v;
  Power_Compressor_2 = mov.m_flow*287*temp_in_comp.T/mov.eta*log(mov.port_b.p/mov.port_a.p);
  T_out_is = (temp_in_comp.T) * (mov.port_b.p/mov.port_a.p)^((gamma_air - 1)/gamma_air);
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-26, -4}, {-14, -4}}));
  connect(speedSensor.w, rad_s_to_rpm.u) annotation(
    Line(points = {{33, 18}, {42, 18}}, color = {0, 0, 127}));
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{6, -4}, {14, -4}}));
  connect(inertia.flange_b, speedSensor.flange) annotation(
    Line(points = {{6, -4}, {6, 7}, {12, 7}, {12, 18}}));
  connect(Input, temp_in_comp.port) annotation(
    Line(points = {{-104, -48}, {-64, -48}, {-64, -40}, {-62, -40}}));
  connect(mov.port_b, Output) annotation(
    Line(points = {{10, -48}, {104, -48}}, color = {0, 127, 255}));
  connect(dcpm.pin_an, dCMotorControlCompressor.pin_n) annotation(
    Line(points = {{-42, 6}, {-40, 6}, {-40, 28}}, color = {0, 0, 255}));
  connect(dcpm.pin_ap, dCMotorControlCompressor.pin_p) annotation(
    Line(points = {{-30, 6}, {-30, 28}}, color = {0, 0, 255}));
  connect(dCMotorControlCompressor.pwr_pin_n, pin_n) annotation(
    Line(points = {{-40, 62}, {-40, 104}}, color = {0, 0, 255}));
  connect(dCMotorControlCompressor.pwr_pin_p, pin_p) annotation(
    Line(points = {{-30, 62}, {-30, 64}, {-28, 64}, {-28, 104}}, color = {0, 0, 255}));
  connect(Input, mov.port_a) annotation(
    Line(points = {{-104, -48}, {-18, -48}}));
  connect(rpm_normalized.y, dCMotorControlCompressor.setSpeedInput) annotation(
    Line(points = {{-80, 38}, {-66, 38}, {-66, 46}, {-58, 46}}, color = {0, 0, 127}));
  connect(rad_s_to_rpm.y, rpm_normalized2.u) annotation(
    Line(points = {{56, 18}, {64, 18}}, color = {0, 0, 127}));
  connect(rpm_normalized2.y, dCMotorControlCompressor.measuredSpeedInput) annotation(
    Line(points = {{78, 18}, {78.5, 18}, {78.5, 46}, {-12, 46}}, color = {0, 0, 127}));
  connect(rpm_normalized2.y, mov.y) annotation(
    Line(points = {{78, 18}, {78, -32}, {-4, -32}}, color = {0, 0, 127}));
  connect(controlInterface, rpm_normalized.u) annotation(
    Line(points = {{-112, 38}, {-94, 38}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Polygon(visible = false, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = false, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Polygon(visible = false, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(origin = {15, 0}, fillColor = {208, 208, 208}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-115, 80}, {-115, -80}, {85, -50}, {85, 50}, {85, 50}, {-115, 80}}), Line(origin = {5.2, 0.61}, points = {{-57, 0}, {47, 0}}, thickness = 1.5, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 20, smooth = Smooth.Bezier), Line(points = {{-100, 80}, {-100, -80}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{-100, -80}, {100, -50}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{-100, 80}, {100, 50}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{100, -50}, {100, 50}}, color = {0, 0, 0}, thickness = 0.5)}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The Compressor model is designed to compress air from the ambient environment to the desired pressure and maintain a sufficient mass flow rate to support the needs of the <a href=\"modelica:77VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">Fuel Cell Stack</a>.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the compressor, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the compressor. A <a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">DC Motor</a> drives the compressor and is connected to an inertia and torque source, which is linked to the resistance of the <a href=\"modelica://Modelica.Fluid.Machines.PrescribedPump\">Pump</a>.</div></body></html>"),
    Diagram);
end Compressor_30kW;
