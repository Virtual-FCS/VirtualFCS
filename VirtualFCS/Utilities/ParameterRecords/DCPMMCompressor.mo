within VirtualFCS.Utilities.ParameterRecords;
record DCPMMCompressor
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Inertia Jr = 0.15 "Rotor's moment of inertia";
  parameter Modelica.Units.SI.Inertia Js = 0.29 "Stator's moment of inertia";
  parameter Modelica.Units.SI.Voltage VaNominal = 100 "Nominal armature voltage" annotation (
    Dialog(tab = "Nominal parameters"));
  parameter Modelica.Units.SI.Current IaNominal = 30 "Nominal armature current (>0..Motor, <0..Generator)" annotation (
    Dialog(tab = "Nominal parameters"));
  parameter Modelica.Units.SI.AngularVelocity wNominal= 1200 * 2 * Modelica.Constants.pi / 60 "Nominal speed" annotation (
    Dialog(tab = "Nominal parameters"));
  parameter Modelica.Units.SI.Temperature TaNominal = 293.15 "Nominal armature temperature" annotation (
    Dialog(tab = "Nominal parameters"));
  parameter Modelica.Units.SI.Resistance Ra = 0.05 "Armature resistance at TRef" annotation (
    Dialog(tab = "Nominal resistances and inductances"));
  parameter Modelica.Units.SI.Temperature TaRef = 293.15 "Reference temperature of armature resistance" annotation (
    Dialog(tab = "Nominal resistances and inductances"));
  parameter Modelica.Electrical.Machines.Thermal.LinearTemperatureCoefficient20 alpha20a = 0 "Temperature coefficient of armature resistance" annotation (
    Dialog(tab = "Nominal resistances and inductances"));
  parameter Modelica.Units.SI.Inductance La = 0.0015 "Armature inductance" annotation (
    Dialog(tab = "Nominal resistances and inductances"));
  parameter Modelica.Electrical.Machines.Losses.FrictionParameters frictionParameters(PRef = 0, wRef = wNominal) "Friction loss parameter record" annotation (
    Dialog(tab = "Losses"));
  parameter Modelica.Units.SI.Voltage ViNominal = VaNominal - Modelica.Electrical.Machines.Thermal.convertResistance(Ra, TaRef, alpha20a, TaNominal) * IaNominal - Modelica.Electrical.Machines.Losses.DCMachines.brushVoltageDrop(brushParameters, IaNominal);
  parameter Modelica.Electrical.Machines.Losses.CoreParameters coreParameters(final m = 1, PRef = 0, VRef = ViNominal, wRef = wNominal) "Armature core loss parameter record" annotation (
    Dialog(tab = "Losses"));
  parameter Modelica.Electrical.Machines.Losses.StrayLoadParameters strayLoadParameters(PRef = 0, IRef = IaNominal, wRef = wNominal) "Stray load losses" annotation (
    Dialog(tab = "Losses"));
  parameter Modelica.Electrical.Machines.Losses.BrushParameters brushParameters(V = 0, ILinear = 0.01 * IaNominal) "Brush loss parameter record" annotation (
    Dialog(tab = "Losses"));
  annotation (
    defaultComponentName = "dcpmData",
    defaultComponentPrefixes = "parameter",
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Basic parameters of DC machines are predefined with default values.</p>
<h2>Governing Equations</h2>
<p>Parameter record; the default expressions in the parameter table define the configured data. There are no time-dependent balances.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>Jr</code></td><td>Modelica.Units.SI.Inertia</td><td>kg.m2</td><td><code>0.15</code></td><td>Rotor&#x27;s moment of inertia</td></tr>
<tr><td><code>Js</code></td><td>Modelica.Units.SI.Inertia</td><td>kg.m2</td><td><code>0.29</code></td><td>Stator&#x27;s moment of inertia</td></tr>
<tr><td><code>VaNominal</code></td><td>Modelica.Units.SI.Voltage</td><td>V</td><td><code>100</code></td><td>Nominal armature voltage</td></tr>
<tr><td><code>IaNominal</code></td><td>Modelica.Units.SI.Current</td><td>A</td><td><code>30</code></td><td>Nominal armature current (&gt;0..Motor, &lt;0..Generator)</td></tr>
<tr><td><code>wNominal</code></td><td>Modelica.Units.SI.AngularVelocity</td><td>rad/s</td><td><code>1200 * 2 * Modelica.Constants.pi / 60</code></td><td>Nominal speed</td></tr>
<tr><td><code>TaNominal</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Nominal armature temperature</td></tr>
<tr><td><code>Ra</code></td><td>Modelica.Units.SI.Resistance</td><td>Ohm</td><td><code>0.05</code></td><td>Armature resistance at TRef</td></tr>
<tr><td><code>TaRef</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Reference temperature of armature resistance</td></tr>
<tr><td><code>alpha20a</code></td><td>Modelica.Electrical.Machines.Thermal.LinearTemperatureCoefficient20</td><td>-</td><td><code>0</code></td><td>Temperature coefficient of armature resistance</td></tr>
<tr><td><code>La</code></td><td>Modelica.Units.SI.Inductance</td><td>H</td><td><code>0.0015</code></td><td>Armature inductance</td></tr>
<tr><td><code>frictionParameters</code></td><td>Modelica.Electrical.Machines.Losses.FrictionParameters</td><td>-</td><td><code>(PRef = 0, wRef = wNominal)</code></td><td>Friction loss parameter record</td></tr>
<tr><td><code>ViNominal</code></td><td>Modelica.Units.SI.Voltage</td><td>V</td><td><code>VaNominal - Modelica.Electrical.Machines.Thermal.convertResistance(Ra, TaRef, alpha20a, TaNominal) * IaNominal - Modelica.Electrical.Machines.Losses.DCMachines.brushVoltageDrop(brushParameters, IaNominal)</code></td><td>-</td></tr>
<tr><td><code>coreParameters</code></td><td>Modelica.Electrical.Machines.Losses.CoreParameters</td><td>-</td><td><code>(final m = 1, PRef = 0, VRef = ViNominal, wRef = wNominal)</code></td><td>Armature core loss parameter record</td></tr>
<tr><td><code>strayLoadParameters</code></td><td>Modelica.Electrical.Machines.Losses.StrayLoadParameters</td><td>-</td><td><code>(PRef = 0, IRef = IaNominal, wRef = wNominal)</code></td><td>Stray load losses</td></tr>
<tr><td><code>brushParameters</code></td><td>Modelica.Electrical.Machines.Losses.BrushParameters</td><td>-</td><td><code>(V = 0, ILinear = 0.01 * IaNominal)</code></td><td>Brush loss parameter record</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end DCPMMCompressor;
