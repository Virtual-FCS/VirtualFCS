within VirtualFCS.Utilities.ParameterRecords;
record DriveDataCpump
  extends Modelica.Icons.Record;
  import Modelica.Electrical.Machines.Thermal.convertResistance;
  //Motor
  parameter VirtualFCS.Utilities.ParameterRecords.DCPMMCoolingPump motorData "Motor data" annotation (
    Dialog(group = "Motor"),
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  parameter Modelica.Units.SI.Resistance Ra = convertResistance(motorData.Ra, motorData.TaRef, motorData.alpha20a, motorData.TaNominal) "Armature resistance at nominal temperature" annotation (
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.Time Ta = motorData.La / Ra "Armature time constant" annotation (
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.Power PNominal = motorData.ViNominal * motorData.IaNominal - motorData.frictionParameters.PRef - motorData.coreParameters.PRef - motorData.strayLoadParameters.PRef "Nominal mechanical output" annotation (
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.Torque tauNominal = PNominal / motorData.wNominal "Nominal torque" annotation (
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.ElectricalTorqueConstant kPhi = tauNominal / motorData.IaNominal "Torque constant" annotation (
    Dialog(group = "Motor", enable = false));
  parameter Modelica.Units.SI.AngularVelocity w0 = motorData.wNominal * motorData.VaNominal / motorData.ViNominal "No-load speed" annotation (
    Dialog(group = "Motor", enable = false));
  //Inverter
  parameter Modelica.Units.SI.Frequency fS = 2e3 "Switching frequency" annotation (
    Dialog(tab = "Inverter", group = "Armature inverter"));
  parameter Modelica.Units.SI.Voltage VBat = VaMax "DC no-load voltage" annotation (
    Dialog(tab = "Inverter", group = "Armature inverter"));
  parameter Modelica.Units.SI.Time Td = 0.5 / fS "Dead time of inverter" annotation (
    Dialog(tab = "Inverter", group = "Armature inverter", enable = false));
  parameter Modelica.Units.SI.Time Tmf = 4 * Td "Measurement filter time constant" annotation (
    Dialog(tab = "Inverter", group = "Armature inverter", enable = false));
  parameter Modelica.Units.SI.Time Tsigma = Td + Tmf "Sum of small time constants" annotation (
    Dialog(tab = "Inverter", group = "Armature inverter", enable = false));
  //Load
  parameter Modelica.Units.SI.Inertia JL = motorData.Jr "Load inertia" annotation (
    Dialog(group = "Load"));
  //Limits
  parameter Modelica.Units.SI.Voltage VaMax = 1.2 * motorData.VaNominal "Maximum Voltage" annotation (
    Dialog(tab = "Controller", group = "Limits"));
  parameter Modelica.Units.SI.Current IaMax = 1.5 * motorData.IaNominal "Maximum current" annotation (
    Dialog(tab = "Controller", group = "Limits"));
  parameter Modelica.Units.SI.Torque tauMax = kPhi * IaMax "Maximum torque" annotation (
    Dialog(tab = "Controller", group = "Limits", enable = false));
  parameter Modelica.Units.SI.AngularVelocity wMax = motorData.wNominal * motorData.VaNominal / motorData.ViNominal "Maximum speed" annotation (
    Dialog(tab = "Controller", group = "Limits"));
  parameter Modelica.Units.SI.AngularAcceleration aMax = tauMax / (JL + motorData.Jr) "Maximum acceleration" annotation (
    Dialog(tab = "Controller", group = "Limits", enable = false));
  //Current controller: absolute optimum
  parameter Real kpI = motorData.La / (2 * Tsigma) "Proportional gain" annotation (
    Dialog(tab = "Controller", group = "Current controller", enable = false));
  parameter Modelica.Units.SI.Time TiI = Ta "Integral time constant" annotation (
    Dialog(tab = "Controller", group = "Current controller", enable = false));
  parameter Modelica.Units.SI.Time Tsub = 2 * Tsigma "Substitute time constant" annotation (
    Dialog(tab = "Controller", group = "Current controller", enable = false));
  //Speed controller: symmetrical optimum
  parameter Real kpw = (JL + motorData.Jr) / (2 * Tsub) "Proportional gain" annotation (
    Dialog(tab = "Controller", group = "Speed controller", enable = false));
  parameter Modelica.Units.SI.Time Tiw = 4 * Tsub "Integral time constant" annotation (
    Dialog(tab = "Controller", group = "Speed controller", enable = false));
  parameter Modelica.Units.SI.Time Tfw = Tiw "Filter time constant" annotation (
    Dialog(tab = "Controller", group = "Speed controller", enable = false));
  //Position controller
  parameter Real kpP = 1 / (16 * Tsub) "Proportional gain" annotation (
    Dialog(tab = "Controller", group = "Position controller", enable = false));
  annotation (
    defaultComponentName = "dcpmDriveData",
    defaultComponentPrefixes = "parameter",
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>
Calculates controller parameters of a DC permanent magnet drive:
Current controller according to absolute optimum, speed controller according to symmetric optimum.
</p>
<h2>Governing Equations</h2>
<p>Parameter record; the default expressions in the parameter table define the configured data. There are no time-dependent balances.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>motorData</code></td><td>VirtualFCS.Utilities.ParameterRecords.DCPMMCoolingPump</td><td>-</td><td><code>-</code></td><td>Motor data</td></tr>
<tr><td><code>Ra</code></td><td>Modelica.Units.SI.Resistance</td><td>Ohm</td><td><code>convertResistance(motorData.Ra, motorData.TaRef, motorData.alpha20a, motorData.TaNominal)</code></td><td>Armature resistance at nominal temperature</td></tr>
<tr><td><code>Ta</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>motorData.La / Ra</code></td><td>Armature time constant</td></tr>
<tr><td><code>PNominal</code></td><td>Modelica.Units.SI.Power</td><td>W</td><td><code>motorData.ViNominal * motorData.IaNominal - motorData.frictionParameters.PRef - motorData.coreParameters.PRef - motorData.strayLoadParameters.PRef</code></td><td>Nominal mechanical output</td></tr>
<tr><td><code>tauNominal</code></td><td>Modelica.Units.SI.Torque</td><td>N.m</td><td><code>PNominal / motorData.wNominal</code></td><td>Nominal torque</td></tr>
<tr><td><code>kPhi</code></td><td>Modelica.Units.SI.ElectricalTorqueConstant</td><td>-</td><td><code>tauNominal / motorData.IaNominal</code></td><td>Torque constant</td></tr>
<tr><td><code>w0</code></td><td>Modelica.Units.SI.AngularVelocity</td><td>rad/s</td><td><code>motorData.wNominal * motorData.VaNominal / motorData.ViNominal</code></td><td>No-load speed</td></tr>
<tr><td><code>fS</code></td><td>Modelica.Units.SI.Frequency</td><td>Hz</td><td><code>2e3</code></td><td>Switching frequency</td></tr>
<tr><td><code>VBat</code></td><td>Modelica.Units.SI.Voltage</td><td>V</td><td><code>VaMax</code></td><td>DC no-load voltage</td></tr>
<tr><td><code>Td</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>0.5 / fS</code></td><td>Dead time of inverter</td></tr>
<tr><td><code>Tmf</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>4 * Td</code></td><td>Measurement filter time constant</td></tr>
<tr><td><code>Tsigma</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>Td + Tmf</code></td><td>Sum of small time constants</td></tr>
<tr><td><code>JL</code></td><td>Modelica.Units.SI.Inertia</td><td>kg.m2</td><td><code>motorData.Jr</code></td><td>Load inertia</td></tr>
<tr><td><code>VaMax</code></td><td>Modelica.Units.SI.Voltage</td><td>V</td><td><code>1.2 * motorData.VaNominal</code></td><td>Maximum Voltage</td></tr>
<tr><td><code>IaMax</code></td><td>Modelica.Units.SI.Current</td><td>A</td><td><code>1.5 * motorData.IaNominal</code></td><td>Maximum current</td></tr>
<tr><td><code>tauMax</code></td><td>Modelica.Units.SI.Torque</td><td>N.m</td><td><code>kPhi * IaMax</code></td><td>Maximum torque</td></tr>
<tr><td><code>wMax</code></td><td>Modelica.Units.SI.AngularVelocity</td><td>rad/s</td><td><code>motorData.wNominal * motorData.VaNominal / motorData.ViNominal</code></td><td>Maximum speed</td></tr>
<tr><td><code>aMax</code></td><td>Modelica.Units.SI.AngularAcceleration</td><td>-</td><td><code>tauMax / (JL + motorData.Jr)</code></td><td>Maximum acceleration</td></tr>
<tr><td><code>kpI</code></td><td>Real</td><td>1</td><td><code>motorData.La / (2 * Tsigma)</code></td><td>Proportional gain</td></tr>
<tr><td><code>TiI</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>Ta</code></td><td>Integral time constant</td></tr>
<tr><td><code>Tsub</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>2 * Tsigma</code></td><td>Substitute time constant</td></tr>
<tr><td><code>kpw</code></td><td>Real</td><td>1</td><td><code>(JL + motorData.Jr) / (2 * Tsub)</code></td><td>Proportional gain</td></tr>
<tr><td><code>Tiw</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>4 * Tsub</code></td><td>Integral time constant</td></tr>
<tr><td><code>Tfw</code></td><td>Modelica.Units.SI.Time</td><td>s</td><td><code>Tiw</code></td><td>Filter time constant</td></tr>
<tr><td><code>kpP</code></td><td>Real</td><td>1</td><td><code>1 / (16 * Tsub)</code></td><td>Proportional gain</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end DriveDataCpump;
