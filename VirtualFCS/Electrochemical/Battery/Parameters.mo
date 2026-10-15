within VirtualFCS.Electrochemical.Battery;
package Parameters "Parameters for battery models"
  extends Modelica.Icons.UtilitiesPackage;

  package Functions
    extends Modelica.Icons.FunctionsPackage;

    function getOCP_NMC
      extends Modelica.Icons.Function;
      input Real SOC "State of Charge";
      output Modelica.Units.SI.ElectricPotential OCP "Open-Circuit Potential";
      // Coefficients for open-circuit voltage calculation
      // NMC
      Real A0 = 2.951;
      Real A1 = 1;
      Real A2 = -0.05;
      Real A3 = -0.4;
      Real A4 = -0.085;
    algorithm
      OCV := A0 + A1 * SOC + A2 / SOC + A3 * log(SOC + 0.001) + A4 * log(1.01 - SOC);
      annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Get OCP NMC calculation, evaluating <code>OCP</code> from <code>SOC</code> (State of Charge). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>A0 = 2.951;
A1 = 1;
A2 = -0.05;
A3 = -0.4;
A4 = -0.085;
OCV := A0 + A1 * SOC + A2 / SOC + A3 * log(SOC + 0.001) + A4 * log(1.01 - SOC);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>SOC</code></td><td>State of Charge</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>SOC</code></td><td>Input signal</td><td>Real</td><td>1</td><td>State of Charge</td></tr>
<tr><td><code>OCP</code></td><td>Output signal</td><td>Modelica.Units.SI.ElectricPotential</td><td>-</td><td>Open-Circuit Potential</td></tr>
</table>
</body>
</html>"));
end getOCP_NMC;
  end Functions;
  annotation (
    Documentation(info = "<html><head></head><body>This package includes functions to calculate the battery's open-circuit potential for various chemistries based on state of charge, SOC.&nbsp;<div><br></div><div>As of February 2022, it is not used in any other Virtual-FCS model or component, but is included in the releases anyway as a placeholder for future development. Ideally, this framework can be used to select between different battery chemistries in a vehicle model.</div></body></html>"));
end Parameters;
