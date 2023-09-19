within VirtualFCS.Utilities.ParameterRecords;

record DriveDataComp
  extends Modelica.Icons.Record;
  import Modelica.Electrical.Machines.Thermal.convertResistance;
  //Motor
  parameter VirtualFCS.Utilities.ParameterRecords.DCPMMCompressor motorData( Js = 0.15, VaNominal = 24)  "Motor data" annotation(
    Dialog(group = "Motor"),
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  parameter Modelica.Units.SI.Resistance Ra = convertResistance(motorData.Ra, motorData.TaRef, motorData.alpha20a, motorData.TaNominal) "Armature resistance at nominal temperature" annotation(
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.Time Ta = motorData.La / Ra "Armature time constant" annotation(
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.Power PNominal = motorData.ViNominal * motorData.IaNominal - motorData.frictionParameters.PRef - motorData.coreParameters.PRef - motorData.strayLoadParameters.PRef "Nominal mechanical output" annotation(
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.Torque tauNominal = PNominal / motorData.wNominal "Nominal torque" annotation(
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.ElectricalTorqueConstant kPhi = tauNominal / motorData.IaNominal "Torque constant" annotation(
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.AngularVelocity w0 = motorData.wNominal * motorData.VaNominal / motorData.ViNominal "No-load speed" annotation(
    Dialog(group = "Motor", enable = false));
  //Inverter
  parameter Modelica.Units.SI.Frequency fS = 2e3 "Switching frequency" annotation(
    Dialog(tab = "Inverter", group = "Armature inverter"));
  parameter Modelica.Units.SI.Voltage VBat = VaMax "DC no-load voltage" annotation(
    Dialog(tab = "Inverter", group = "Armature inverter"));
  parameter Modelica.Units.SI.Time Td = 0.5 / fS "Dead time of inverter" annotation(
    Dialog(tab = "Inverter", group = "Armature inverter", enable = false));
  parameter Modelica.Units.SI.Time Tmf = 4 * Td "Measurement filter time constant" annotation(
    Dialog(tab = "Inverter", group = "Armature inverter", enable = false));
  parameter Modelica.Units.SI.Time Tsigma = Td + Tmf "Sum of small time constants" annotation(
    Dialog(tab = "Inverter", group = "Armature inverter", enable = false));
  //Load
  parameter Modelica.Units.SI.Inertia JL = motorData.Jr "Load inertia" annotation(
    Dialog(group = "Load"));
  //Limits
  parameter Modelica.Units.SI.Voltage VaMax = 1.2 * motorData.VaNominal "Maximum Voltage" annotation(
    Dialog(tab = "Controller", group = "Limits"));
  parameter Modelica.Units.SI.Current IaMax = 1.5 * motorData.IaNominal "Maximum current" annotation(
    Dialog(tab = "Controller", group = "Limits"));
  parameter Modelica.Units.SI.Torque tauMax = kPhi * IaMax "Maximum torque" annotation(
    Dialog(tab = "Controller", group = "Limits", enable = false));
  parameter Modelica.Units.SI.AngularVelocity wMax = motorData.wNominal * motorData.VaNominal / motorData.ViNominal "Maximum speed" annotation(
    Dialog(tab = "Controller", group = "Limits"));
  parameter Modelica.Units.SI.AngularAcceleration aMax = tauMax / (JL + motorData.Jr) "Maximum acceleration" annotation(
    Dialog(tab = "Controller", group = "Limits", enable = false));
  //Current controller: absolute optimum
  parameter Real kpI = motorData.La / (2 * Tsigma) "Proportional gain" annotation(
    Dialog(tab = "Controller", group = "Current controller", enable = false));
  parameter Modelica.Units.SI.Time TiI = Ta "Integral time constant" annotation(
    Dialog(tab = "Controller", group = "Current controller", enable = false));
  parameter Modelica.Units.SI.Time Tsub = 2 * Tsigma "Substitute time constant" annotation(
    Dialog(tab = "Controller", group = "Current controller", enable = false));
  //Speed controller: symmetrical optimum
  parameter Real kpw = (JL + motorData.Jr) / (2 * Tsub) "Proportional gain" annotation(
    Dialog(tab = "Controller", group = "Speed controller", enable = false));
  parameter Modelica.Units.SI.Time Tiw = 4 * Tsub "Integral time constant" annotation(
    Dialog(tab = "Controller", group = "Speed controller", enable = false));
  parameter Modelica.Units.SI.Time Tfw = Tiw "Filter time constant" annotation(
    Dialog(tab = "Controller", group = "Speed controller", enable = false));
  //Position controller
  parameter Real kpP = 1 / (16 * Tsub) "Proportional gain" annotation(
    Dialog(tab = "Controller", group = "Position controller", enable = false));
  annotation(
    defaultComponentName = "dcpmDriveData",
    defaultComponentPrefixes = "parameter",
    Documentation(info = "<html>
<p>
Calculates controller parameters of a DC permanent magnet drive:
Current controller according to absolute optimum, speed controller according to symmetric optimum.
</p>
</html>"));
end DriveDataComp;
