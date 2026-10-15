within VirtualFCS.Control.ECMS;

function efficiencyFC
  // Function which returns FC system efficiency based on polynomial expression.
  // RETHINK THIS ONE
  input Modelica.Units.SI.Power fcPower;
  output Real fcEfficiency;
algorithm

  fcEfficiency := max(-2.3552811729255974*10^(-28)*fcPower^6 + 6.1665632981341745*10^(-23) * fcPower^5 - 6.4445034579814230*10^(-18) * fcPower^4 + 3.4025968585605853*10^(-13)*fcPower^3 - 9.4483485991363506*10^(-9) * fcPower^2 + 1.2521983494464165*10^(-4) * fcPower -1.9991461078281599*10^(-2), 0.1);

  annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Empirical fuel-cell-system efficiency approximation used by the ECMS cost function. A sixth-order polynomial in fuel-cell power (W) is evaluated and limited from below to 0.1. There is no upper efficiency clamp in this implementation; the fit should only be used over its calibrated operating range.</p><p>Note: Must rethink this approach.&nbsp;</p>
<h2>Governing Equations</h2>
<pre>fcEfficiency := max(-2.3552811729255974*10^(-28)*fcPower^6 + 6.1665632981341745*10^(-23) * fcPower^5 - 6.4445034579814230*10^(-18) * fcPower^4 + 3.4025968585605853*10^(-13)*fcPower^3 - 9.4483485991363506*10^(-9) * fcPower^2 + 1.2521983494464165*10^(-4) * fcPower -1.9991461078281599*10^(-2), 0.1);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>fcPower</code></td><td>Input signal</td><td>Modelica.Units.SI.Power</td><td>W</td><td>Fuel-cell system power</td></tr>
<tr><td><code>fcEfficiency</code></td><td>Output signal</td><td>Real</td><td>1</td><td>Empirical fuel-cell-system efficiency</td></tr>
</tbody></table>

</body></html>"));
end efficiencyFC;
