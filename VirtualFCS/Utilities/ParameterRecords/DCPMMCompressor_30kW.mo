within VirtualFCS.Utilities.ParameterRecords;
record DCPMMCompressor_30kW
  extends Modelica.Icons.Record;
  extends VirtualFCS.Utilities.ParameterRecords.DCPMMCompressor(
    Jr = 0.15,
    Js = 0.29,
    VaNominal = 400,
    IaNominal = 75,
    wNominal = 15000 * 2 * Modelica.Constants.pi / 60,
    TaNominal = 293.15,
    Ra = 0.01,
    TaRef = 293.15,
    alpha20a = 0.004,
    La = 0.002,
    frictionParameters = Modelica.Electrical.Machines.Losses.FrictionParameters(
      PRef = 10,
      wRef = wNominal * 2 * Modelica.Constants.pi / 60),
    brushParameters = Modelica.Electrical.Machines.Losses.BrushParameters(
      V = 0.5,
      ILinear = 0.01 * IaNominal),
    ViNominal = VaNominal - Modelica.Electrical.Machines.Thermal.convertResistance(Ra, TaRef, alpha20a, TaNominal) * IaNominal - Modelica.Electrical.Machines.Losses.DCMachines.brushVoltageDrop(brushParameters, IaNominal),
    coreParameters = Modelica.Electrical.Machines.Losses.CoreParameters(
      m = 1,
      PRef = 10,
      VRef = 75,
      wRef = wNominal * 2 * Modelica.Constants.pi / 60),
    strayLoadParameters = Modelica.Electrical.Machines.Losses.StrayLoadParameters(PRef = 0, IRef = IaNominal, wRef = wNominal));

annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Parameter record containing the nominal data for a 30 kW permanent-magnet compressor motor.</p>
<h2>Governing Equations</h2>
<p>Parameter record; the default expressions in the parameter table define the configured data. There are no time-dependent balances.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>Jr</code></td><td>Modelica.Units.SI.Inertia</td><td>kg.m2</td><td><code>0.15</code></td><td>Rotor&#x27;s moment of inertia (inherited)</td></tr>
<tr><td><code>Js</code></td><td>Modelica.Units.SI.Inertia</td><td>kg.m2</td><td><code>0.29</code></td><td>Stator&#x27;s moment of inertia (inherited)</td></tr>
<tr><td><code>VaNominal</code></td><td>Modelica.Units.SI.Voltage</td><td>V</td><td><code>100</code></td><td>Nominal armature voltage (inherited)</td></tr>
<tr><td><code>IaNominal</code></td><td>Modelica.Units.SI.Current</td><td>A</td><td><code>30</code></td><td>Nominal armature current (&gt;0..Motor, &lt;0..Generator) (inherited)</td></tr>
<tr><td><code>wNominal</code></td><td>Modelica.Units.SI.AngularVelocity</td><td>rad/s</td><td><code>15000*2*Modelica.Constants.pi/60</code></td><td>Nominal speed (inherited)</td></tr>
<tr><td><code>TaNominal</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Nominal armature temperature (inherited)</td></tr>
<tr><td><code>Ra</code></td><td>Modelica.Units.SI.Resistance</td><td>Ohm</td><td><code>0.05</code></td><td>Armature resistance at TRef (inherited)</td></tr>
<tr><td><code>TaRef</code></td><td>Modelica.Units.SI.Temperature</td><td>K</td><td><code>293.15</code></td><td>Reference temperature of armature resistance (inherited)</td></tr>
<tr><td><code>alpha20a</code></td><td>Modelica.Electrical.Machines.Thermal.LinearTemperatureCoefficient20</td><td>-</td><td><code>0</code></td><td>Temperature coefficient of armature resistance (inherited)</td></tr>
<tr><td><code>La</code></td><td>Modelica.Units.SI.Inductance</td><td>H</td><td><code>0.0015</code></td><td>Armature inductance (inherited)</td></tr>
<tr><td><code>frictionParameters</code></td><td>Modelica.Electrical.Machines.Losses.FrictionParameters</td><td>-</td><td><code>Modelica.Electrical.Machines.Losses.FrictionParameters(PRef = 10, wRef = wNominal*2*Modelica.Constants.pi/60)</code></td><td>Friction loss parameter record (inherited)</td></tr>
<tr><td><code>ViNominal</code></td><td>Modelica.Units.SI.Voltage</td><td>V</td><td><code>VaNominal - Modelica.Electrical.Machines.Thermal.convertResistance(Ra, TaRef, alpha20a, TaNominal)*IaNominal - Modelica.Electrical.Machines.Losses.DCMachines.brushVoltageDrop(brushParameters, IaNominal)</code></td><td>- (inherited)</td></tr>
<tr><td><code>coreParameters</code></td><td>Modelica.Electrical.Machines.Losses.CoreParameters</td><td>-</td><td><code>Modelica.Electrical.Machines.Losses.CoreParameters(m = 1, PRef = 10, VRef = 75, wRef = wNominal*2*Modelica.Constants.pi/60)</code></td><td>Armature core loss parameter record (inherited)</td></tr>
<tr><td><code>strayLoadParameters</code></td><td>Modelica.Electrical.Machines.Losses.StrayLoadParameters</td><td>-</td><td><code>Modelica.Electrical.Machines.Losses.StrayLoadParameters(PRef = 0, IRef = IaNominal, wRef = wNominal)</code></td><td>Stray load losses (inherited)</td></tr>
<tr><td><code>brushParameters</code></td><td>Modelica.Electrical.Machines.Losses.BrushParameters</td><td>-</td><td><code>Modelica.Electrical.Machines.Losses.BrushParameters(V = 0.5, ILinear = 0.01*IaNominal)</code></td><td>Brush loss parameter record (inherited)</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end DCPMMCompressor_30kW;
