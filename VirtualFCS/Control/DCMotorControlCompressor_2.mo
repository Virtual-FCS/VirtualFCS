within VirtualFCS.Control;

model DCMotorControlCompressor_2 "Control the speed of a DC motor"
  //*** DEFINE REPLACEABLE PACKAGES ***//
  replaceable parameter Utilities.ParameterRecords.DriveDataDcPm driveData annotation(
    Placement(transformation(origin = {0, 14}, extent = {{-30, -96}, {-10, -76}}))) constrainedby Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.DriveDataDCPM annotation(
     Placement(transformation(extent = {{-30, -96}, {-10, -76}})));
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.DcdcInverter armatureInverter(fS = driveData.fS, Td = driveData.Td, Tmf = driveData.Tmf, VMax = driveData.VaMax) annotation(
    Placement(transformation(origin = {-44, 0}, extent = {{30, -10}, {50, 10}})));
  Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.LimitedPI speedController(Ti = driveData.Tiw*10, symmetricLimits = false, yMax = driveData.VaMax, yMin = 0, initType = Modelica.Blocks.Types.Init.InitialOutput, k = 25, useFF = false) annotation(
    Placement(transformation(origin = {-2, 0}, extent = {{-92, -10}, {-72, 10}})));
  Modelica.Blocks.Interfaces.RealInput setSpeedInput annotation(
    Placement(transformation(origin = {-152, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput measuredSpeedInput annotation(
    Placement(transformation(origin = {-90, -62}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {120, 0}, extent = {{20, -20}, {-20, 20}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {16, -58}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-24, -58}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pwr_pin_p annotation(
    Placement(transformation(origin = {16, 52}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {30, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pwr_pin_n annotation(
    Placement(transformation(origin = {-24, 52}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-30, 90}, extent = {{-10, -10}, {10, 10}})));
equation
//*** DEFINE CONNECTIONS ***//
  connect(armatureInverter.pin_nMot, pin_n) annotation(
    Line(points = {{-10, -10}, {-24, -10}, {-24, -58}}, color = {0, 0, 255}));
  connect(armatureInverter.pin_pMot, pin_p) annotation(
    Line(points = {{2, -10}, {16, -10}, {16, -58}}, color = {0, 0, 255}));
  connect(pwr_pin_n, armatureInverter.pin_nBat) annotation(
    Line(points = {{-24, 52}, {-24, 10}, {-10, 10}}, color = {0, 0, 255}));
  connect(pwr_pin_p, armatureInverter.pin_pBat) annotation(
    Line(points = {{16, 52}, {16, 10}, {2, 10}}, color = {0, 0, 255}));
  connect(measuredSpeedInput, speedController.u_m) annotation(
    Line(points = {{-90, -62}, {-90, -12}}, color = {0, 0, 127}));
  connect(speedController.y, armatureInverter.vRef) annotation(
    Line(points = {{-73, 0}, {-16, 0}}, color = {0, 0, 127}));
  connect(setSpeedInput, speedController.u) annotation(
    Line(points = {{-152, 0}, {-96, 0}}, color = {0, 0, 127}));
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
end DCMotorControlCompressor_2;
