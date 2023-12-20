within VirtualFCS.Control;

model DCMotorControlRecirculationBlower "Control the speed of a DC motor"
  //*** DEFINE REPLACEABLE PACKAGES ***//
  replaceable parameter VirtualFCS.Utilities.ParameterRecords.DriveDataRBlower driveData annotation(
    Placement(visible = true, transformation(extent = {{-248, 44}, {-228, 64}}, rotation = 0))) constrainedby Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.DriveDataDCPM annotation(
     Placement(transformation(extent = {{20, -80}, {40, -60}})));
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.DcdcInverter armatureInverter(fS = driveData.fS, Td = driveData.Td, Tmf = driveData.Tmf, VMax = driveData.VaMax) annotation(
    Placement(visible = true, transformation(extent = {{30, -10}, {50, 10}}, rotation = 0)));
  Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.LimitedPI currentController(Ti = driveData.TiI, constantLimits = false, initType = Modelica.Blocks.Types.Init.InitialOutput, k = driveData.kpI, useFF = true) annotation(
    Placement(visible = true, transformation(extent = {{-22, -10}, {-2, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain tau2i(k = 1/driveData.kPhi) annotation(
    Placement(visible = true, transformation(origin = {-42, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.LimitedPI speedController(Ti = driveData.Tiw, constantLimits = true, initType = Modelica.Blocks.Types.Init.InitialOutput, k = driveData.kpw, yMax = driveData.tauMax + 100) annotation(
    Placement(visible = true, transformation(extent = {{-92, -10}, {-72, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder preFilter(k = 1, T = driveData.Tfw, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
    Placement(visible = true, transformation(extent = {{-132, -10}, {-112, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput setSpeedInput annotation(
    Placement(visible = true, transformation(origin = {-164, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput measuredSpeedInput annotation(
    Placement(visible = true, transformation(origin = {-88, -64}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {120, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {60, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {20, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pwr_pin_p annotation(
    Placement(visible = true, transformation(origin = {60, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pwr_pin_n annotation(
    Placement(visible = true, transformation(origin = {20, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(armatureInverter.vDC, currentController.yMaxVar) annotation(
    Line(points = {{29, 6}, {0, 6}}, color = {0, 0, 127}));
  connect(armatureInverter.vRef, currentController.y) annotation(
    Line(points = {{28, 0}, {-1, 0}}, color = {0, 0, 127}));
  connect(armatureInverter.iMot, currentController.u_m) annotation(
    Line(points = {{29, -6}, {10, -6}, {10, -30}, {-18, -30}, {-18, -12}}, color = {0, 0, 127}));
  connect(tau2i.y, currentController.u) annotation(
    Line(points = {{-31, 0}, {-24, 0}}, color = {0, 0, 127}));
  connect(preFilter.y, speedController.u) annotation(
    Line(points = {{-111, 0}, {-94, 0}}, color = {0, 0, 127}));
  connect(speedController.y, tau2i.u) annotation(
    Line(points = {{-71, 0}, {-54, 0}}, color = {0, 0, 127}));
  connect(setSpeedInput, preFilter.u) annotation(
    Line(points = {{-164, 0}, {-134, 0}}, color = {0, 0, 127}));
  connect(armatureInverter.pin_nMot, pin_n) annotation(
    Line(points = {{34, -10}, {20, -10}, {20, -72}}, color = {0, 0, 255}));
  connect(armatureInverter.pin_pMot, pin_p) annotation(
    Line(points = {{46, -10}, {60, -10}, {60, -72}}, color = {0, 0, 255}));
  connect(pwr_pin_n, armatureInverter.pin_nBat) annotation(
    Line(points = {{20, 52}, {20, 10}, {34, 10}}, color = {0, 0, 255}));
  connect(pwr_pin_p, armatureInverter.pin_pBat) annotation(
    Line(points = {{60, 52}, {60, 10}, {46, 10}}, color = {0, 0, 255}));
  connect(measuredSpeedInput, speedController.u_m) annotation(
    Line(points = {{-88, -64}, {-88, -12}}, color = {0, 0, 127}));
  connect(currentController.feedForward, measuredSpeedInput) annotation(
    Line(points = {{-12, -12}, {-12, -36}, {-88, -36}, {-88, -64}}, color = {0, 0, 127}));
  annotation(
    Documentation(info = "<html><head></head><body><p>This is a partial model of a controlled DC PM drive.</p>
<p>
Electrical power is fed to the motor via a DC-DC inverter.
The level of detail of the DC-DC inverter may be chosen from ideal averaging or switching.
The DC-DC inverter is commanded by the current controller.
The current controller is parameterized according to the absolute optimum.
</p>
<p>
Further reading:
<a href=\"modelica://Modelica/Resources/Documentation/Electrical/Machines/DriveControl.pdf\">Tutorial at the Modelica Conference 2017</a>
</p><p>This model is adapted from the DC PM drive control model used in the Modelica Standard Library.</p>
</body></html>"),
    Diagram(coordinateSystem(extent = {{-200, -100}, {100, 100}})),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-87, 9}, textColor = {255, 255, 255}, extent = {{-19, 11}, {27, -21}}, textString = "s"), Text(origin = {-3, 73}, textColor = {255, 255, 255}, extent = {{-19, 11}, {27, -17}}, textString = "pwr"), Text(origin = {73, 9}, textColor = {255, 255, 255}, extent = {{-19, 11}, {35, -23}}, textString = "m"), Text(origin = {-5, -57}, textColor = {255, 255, 255}, extent = {{-19, 11}, {27, -19}}, textString = "out"), Text(origin = {161, 84}, textColor = {0, 0, 255}, extent = {{-55, 18}, {55, -18}}, textString = "%name")}));
end DCMotorControlRecirculationBlower;
