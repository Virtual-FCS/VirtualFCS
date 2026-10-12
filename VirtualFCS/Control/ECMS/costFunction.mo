within VirtualFCS.Control.ECMS;

function costFunction
  input Modelica.Units.SI.Power powerFC "Fuel cell power";
  input Real LHVH2(unit = "Ws/g") "Lower heating value for hydrogen";
  input Real mu "ECMS parameter";
  input Real SOC "Battery SOC";
  input Real SOC_min "Battery min SOC";
  input Real SOC_max "Battery max SOC";
  input Real sigma "Sigma parameter for ECMS";
  input Modelica.Units.SI.Power powerBatt "Battery power";
  output Real cost(unit = "g/s") "Cost at the current instance";

algorithm
  cost := ((powerFC)/(LHVH2 * efficiencyFC(powerFC))) + ((1-2*mu*((SOC - 0.5*(SOC_min+SOC_max))/(SOC_max+SOC_min))) * ((sigma * powerBatt)/(LHVH2 * efficiencyFC(powerFC))));

  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Evaluates the ECMS equivalent hydrogen-consumption rate in g/s for a candidate fuel-cell/battery power split. Fuel-cell consumption is estimated from the lower heating value and the empirical efficiencyFC function. The battery contribution is weighted by sigma and corrected by the battery state of charge through mu. The implementation uses SOC_max + SOC_min in the state-of-charge normalization denominator. Positive battery power contributes a positive equivalent-consumption term.</p>
<h2>Governing Equations</h2>
<pre>cost := ((powerFC)/(LHVH2 * efficiencyFC(powerFC))) + ((1-2*mu*((SOC - 0.5*(SOC_min+SOC_max))/(SOC_max+SOC_min))) * ((sigma * powerBatt)/(LHVH2 * efficiencyFC(powerFC))));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>powerFC</code></td><td>Fuel cell power</td></tr>
<tr><td><code>LHVH2</code></td><td>Lower heating value for hydrogen</td></tr>
<tr><td><code>mu</code></td><td>ECMS parameter</td></tr>
<tr><td><code>SOC</code></td><td>Battery SOC</td></tr>
<tr><td><code>SOC_min</code></td><td>Battery min SOC</td></tr>
<tr><td><code>SOC_max</code></td><td>Battery max SOC</td></tr>
<tr><td><code>sigma</code></td><td>Sigma parameter for ECMS</td></tr>
<tr><td><code>powerBatt</code></td><td>Battery power</td></tr>
<tr><td><code>cost</code></td><td>Cost at the current instance</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>powerFC</code></td><td>Input signal</td><td>Modelica.Units.SI.Power</td><td>W</td><td>Fuel cell power</td></tr>
<tr><td><code>LHVH2</code></td><td>Input signal</td><td>Real</td><td>Ws/g</td><td>Lower heating value for hydrogen</td></tr>
<tr><td><code>mu</code></td><td>Input signal</td><td>Real</td><td>1</td><td>ECMS parameter</td></tr>
<tr><td><code>SOC</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Battery SOC</td></tr>
<tr><td><code>SOC_min</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Battery min SOC</td></tr>
<tr><td><code>SOC_max</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Battery max SOC</td></tr>
<tr><td><code>sigma</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Sigma parameter for ECMS</td></tr>
<tr><td><code>powerBatt</code></td><td>Input signal</td><td>Modelica.Units.SI.Power</td><td>W</td><td>Battery power</td></tr>
<tr><td><code>cost</code></td><td>Output signal</td><td>Real</td><td>g/s</td><td>Cost at the current instance</td></tr>
</table>
</body>
</html>"));
end costFunction;
