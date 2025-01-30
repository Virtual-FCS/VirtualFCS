within VirtualFCS.Control;
model DCMotorControlCompressor_new "Control the speed of a DC motor"
  //*** DEFINE REPLACEABLE PACKAGES ***//
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.DcdcInverter armatureInverter(fS = driveData.fS, Td = driveData.Td, Tmf = driveData.Tmf,
    VMax=driveData.VaMax)                                                                                                                                                             annotation (
    Placement(visible = true, transformation(extent={{-88,-18},{-52,18}},    rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput setSpeedInput annotation (
    Placement(visible = true, transformation(origin={-220,0},    extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin={-44,-100},  extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin={-96,-100},  extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pwr_pin_p annotation (
    Placement(visible = true, transformation(origin={-44,100},  extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pwr_pin_n annotation (
    Placement(visible = true, transformation(origin={-96,100},  extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable parameter Utilities.ParameterRecords.DriveDataDcPm            driveData           constrainedby
    Utilities.ParameterRecords.DriveDataDcPm                                                                                                                                                   annotation (
     Placement(transformation(extent={{8,-22},{28,-2}})));
equation
//*** DEFINE CONNECTIONS ***//
  connect(armatureInverter.pin_nMot, pin_n) annotation (
    Line(points={{-80.8,-18},{-80.8,-86},{-96,-86},{-96,-100}},
                                                     color = {0, 0, 255}));
  connect(armatureInverter.pin_pMot, pin_p) annotation (
    Line(points={{-59.2,-18},{-59.2,-86},{-44,-86},{-44,-100}},
                                                     color = {0, 0, 255}));
  connect(pwr_pin_n, armatureInverter.pin_nBat) annotation (
    Line(points={{-96,100},{-96,24},{-80.8,24},{-80.8,18}},
                                                  color = {0, 0, 255}));
  connect(pwr_pin_p, armatureInverter.pin_pBat) annotation (
    Line(points={{-44,100},{-44,24},{-59.2,24},{-59.2,18}},
                                                  color = {0, 0, 255}));
  connect(setSpeedInput, armatureInverter.vRef)
    annotation (Line(points={{-220,0},{-91.6,0}}, color={0,0,127}));
  annotation (
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
    Icon(coordinateSystem(initialScale = 0.1), graphics={  Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-87, 9}, textColor = {255, 255, 255}, extent = {{-19, 11}, {27, -21}}, textString = "s"), Text(origin = {-3, 73}, textColor = {255, 255, 255}, extent = {{-19, 11}, {27, -17}}, textString = "pwr"), Text(origin = {73, 9}, textColor = {255, 255, 255}, extent = {{-19, 11}, {35, -23}}, textString = "m"), Text(origin = {-5, -57}, textColor = {255, 255, 255}, extent = {{-19, 11}, {27, -19}}, textString = "out"), Text(origin = {161, 84}, textColor = {0, 0, 255}, extent = {{-55, 18}, {55, -18}}, textString = "%name")}));
end DCMotorControlCompressor_new;
