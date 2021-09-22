within VirtualFCS.Electrical;

model SpeedControlledDCMotor
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {40, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-40, 98}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {60, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput contol_input annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain1(k = 123 / 9.5493) annotation(
    Placement(visible = true, transformation(origin = {-84, -1}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(visible = true, transformation(origin = {-2, -30}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.LimitedPI currentController(Ti = 100, constantLimits = false, initType = Modelica.Blocks.Types.Init.InitialOutput, k = driveData.kpI, useFF = true) annotation(
    Placement(visible = true, transformation(extent = {{20, 28}, {40, 48}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder preFilter(T = driveData.Tfw, initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1) annotation(
    Placement(visible = true, transformation(extent = {{-90, 28}, {-70, 48}}, rotation = 0)));
  Modelica.Blocks.Math.Gain tau2i(k = 1 / driveData.kPhi) annotation(
    Placement(visible = true, transformation(origin = { 0, 38}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.DcdcInverter armatureInverter(Td = driveData.Td, Tmf = driveData.Tmf, VMax = driveData.VaMax, fS = driveData.fS) annotation(
    Placement(visible = true, transformation(extent = {{72, 28}, {92, 48}}, rotation = 0)));
  Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.LimitedPI speedController(Ti = driveData.Tiw, constantLimits = true, initType = Modelica.Blocks.Types.Init.InitialOutput, k = driveData.kpw, yMax = driveData.tauMax) annotation(
    Placement(visible = true, transformation(extent = {{-50, 28}, {-30, 48}}, rotation = 0)));
  parameter Utilities.ParameterRecords.EVDriveData driveData annotation(
    Placement(visible = true, transformation(origin = {-58, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(dcpm.flange, speedSensor.flange) annotation(
    Line(points = {{12, -30}, {60, -30}}));
  connect(armatureInverter.vRef, currentController.y) annotation(
    Line(points = {{70, 38}, {41, 38}}, color = {0, 0, 127}));
  connect(speedController.y, tau2i.u) annotation(
    Line(points = {{-29, 38}, {-12, 38}}, color = {0, 0, 127}));
  connect(armatureInverter.vDC, currentController.yMaxVar) annotation(
    Line(points = {{71, 44}, {42, 44}}, color = {0, 0, 127}));
  connect(preFilter.y, speedController.u) annotation(
    Line(points = {{-69, 38}, {-52, 38}}, color = {0, 0, 127}));
  connect(tau2i.y, currentController.u) annotation(
    Line(points = {{11, 38}, {18, 38}}, color = {0, 0, 127}));
  connect(armatureInverter.iMot, currentController.u_m) annotation(
    Line(points = {{72, 32}, {60, 32}, {60, 16}, {24, 16}, {24, 26}, {24, 26}}, color = {0, 0, 127}));
  connect(pin_p, armatureInverter.pin_pBat) annotation(
    Line(points = {{40, 100}, {88, 100}, {88, 48}, {88, 48}}, color = {0, 0, 255}));
  connect(pin_n, armatureInverter.pin_nBat) annotation(
    Line(points = {{-40, 98}, {-44, 98}, {-44, 66}, {76, 66}, {76, 48}, {76, 48}}, color = {0, 0, 255}));
  connect(contol_input, gain1.u) annotation(
    Line(points = {{-110, 0}, {-90, 0}, {-90, 0}, {-90, 0}}, color = {0, 0, 127}));
  connect(gain1.y, preFilter.u) annotation(
    Line(points = {{-78, 0}, {-60, 0}, {-60, 18}, {-122, 18}, {-122, 36}, {-92, 36}, {-92, 38}}, color = {0, 0, 127}));
  connect(speedSensor.w, speedController.u_m) annotation(
    Line(points = {{60, -8}, {60, -8}, {60, 10}, {-46, 10}, {-46, 26}, {-46, 26}}, color = {0, 0, 127}));
  connect(speedSensor.w, currentController.feedForward) annotation(
    Line(points = {{60, -8}, {60, -8}, {60, 10}, {30, 10}, {30, 26}, {30, 26}}, color = {0, 0, 127}));
  connect(armatureInverter.pin_nMot, dcpm.pin_an) annotation(
    Line(points = {{76, 28}, {76, 28}, {76, 0}, {-10, 0}, {-10, -16}, {-10, -16}}, color = {0, 0, 255}));
  connect(armatureInverter.pin_pMot, dcpm.pin_ap) annotation(
    Line(points = {{88, 28}, {88, 28}, {88, -6}, {6, -6}, {6, -16}, {6, -16}}, color = {0, 0, 255}));
end SpeedControlledDCMotor;
