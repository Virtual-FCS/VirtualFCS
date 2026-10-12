within VirtualFCS.Control.ECMS;

function bruteForceMinimization
  input Integer numIterations "Number of iterations to perform";
  input Modelica.Units.SI.Power minFCPower "Minimum allowable FC power value";
  input Modelica.Units.SI.Power MaxFCPower "Maximum allowable fuel cell power";
  input Modelica.Units.SI.Power powerDemand "Power demand of the powertrain";
  input Modelica.Units.SI.Power batteryPowerMin "Minimum battery power";
  input Modelica.Units.SI.Power batteryPowerMax "Maximum battery power";
  input Real LHVH2(unit = "Ws/g") "Lower heating value hydrogen";
  input Real mu "ECMS parameter";
  input Real SOC "SOC of battery";
  input Real SOC_min "Minimum SOC of battery";
  input Real SOC_max "Maximum SOC of battery";
  input Real sigma "Parameter for ECMS";
  output Modelica.Units.SI.Power optimalParameter "The parameter value that minimizes the function";
  output Real minimumValue(unit="g/s") "The minimum function value found";
protected
  Real stepSize "Step size between iterations";
  //Real currentFc "Current parameter value being tested";
  Modelica.Units.SI.Power powerFC "Current power level for FC being tested";
  Modelica.Units.SI.Power batteryPower "Battery power from current evaluated FC power";
  //Real currentBatt "Battery current from current fc current";
  Real currentFunctionValue(unit="g/s") "Current function value being evaluated";
  Real bestValue(unit="g/s") "Best function value found so far";
  Modelica.Units.SI.Power bestParameter "Parameter corresponding to the best value";
  Integer i "Loop counter";
  Boolean checkConstraint "Store if the battery constraint is fulfilled and skips solution if its not";
algorithm
  stepSize := (MaxFCPower - minFCPower) / (numIterations - 1);
  bestValue := Modelica.Constants.inf; // Initialize to infinity
  bestParameter := minFCPower; // Initialize to the minimum value
  for i in 1:numIterations loop
    powerFC := minFCPower + (i - 1) * stepSize;
    
    batteryPower := powerDemand - powerFC;
        
    if (batteryPower > batteryPowerMin) and (batteryPower < batteryPowerMax) then
      checkConstraint := true;
    else
      checkConstraint := false;
    end if;
    
    currentFunctionValue := costFunction(powerFC, LHVH2, mu, SOC, SOC_min, SOC_max, sigma, batteryPower);

    if (currentFunctionValue < bestValue) and checkConstraint then
      bestValue := currentFunctionValue;
      bestParameter := powerFC;
    end if;
  end for;

  optimalParameter := bestParameter;
  minimumValue := bestValue;

  annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Searches numIterations equally spaced fuel-cell power candidates between minFCPower and MaxFCPower. Battery power is powerDemand minus candidate fuel-cell power. A candidate is feasible only when batteryPowerMin &lt; batteryPower &lt; batteryPowerMax; the bounds are strict. The candidate with the lowest costFunction value is returned. numIterations must exceed one. If no feasible candidate improves the initial value, optimalParameter remains minFCPower and minimumValue remains infinity.</p>
<h2>Governing Equations</h2>
<pre>-</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>numIterations</code></td><td>Number of iterations to perform</td></tr>
<tr><td><code>minFCPower</code></td><td>Minimum allowable FC power value</td></tr>
<tr><td><code>MaxFCPower</code></td><td>Maximum allowable fuel cell power</td></tr>
<tr><td><code>powerDemand</code></td><td>Power demand of the powertrain</td></tr>
<tr><td><code>batteryPowerMin</code></td><td>Minimum battery power</td></tr>
<tr><td><code>batteryPowerMax</code></td><td>Maximum battery power</td></tr>
<tr><td><code>LHVH2</code></td><td>Lower heating value hydrogen</td></tr>
<tr><td><code>mu</code></td><td>ECMS parameter</td></tr>
<tr><td><code>SOC</code></td><td>SOC of battery</td></tr>
<tr><td><code>SOC_min</code></td><td>Minimum SOC of battery</td></tr>
<tr><td><code>SOC_max</code></td><td>Maximum SOC of battery</td></tr>
<tr><td><code>sigma</code></td><td>Parameter for ECMS</td></tr>
<tr><td><code>optimalParameter</code></td><td>The parameter value that minimizes the function</td></tr>
<tr><td><code>minimumValue</code></td><td>The minimum function value found</td></tr>
<tr><td><code>stepSize</code></td><td>Step size between iterations</td></tr>
<tr><td><code>powerFC</code></td><td>Current power level for FC being tested</td></tr>
<tr><td><code>batteryPower</code></td><td>Battery power from current evaluated FC power</td></tr>
<tr><td><code>currentFunctionValue</code></td><td>Current function value being evaluated</td></tr>
<tr><td><code>bestValue</code></td><td>Best function value found so far</td></tr>
<tr><td><code>bestParameter</code></td><td>Parameter corresponding to the best value</td></tr>
<tr><td><code>i</code></td><td>Loop counter</td></tr>
<tr><td><code>checkConstraint</code></td><td>Store if the battery constraint is fulfilled and skips solution if its not</td></tr>
</tbody></table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>numIterations</code></td><td>Input signal</td><td>Integer</td><td>1</td><td>Number of iterations to perform</td></tr>
<tr><td><code>minFCPower</code></td><td>Input signal</td><td>Modelica.Units.SI.Power</td><td>W</td><td>Minimum allowable FC power value</td></tr>
<tr><td><code>MaxFCPower</code></td><td>Input signal</td><td>Modelica.Units.SI.Power</td><td>W</td><td>Maximum allowable fuel cell power</td></tr>
<tr><td><code>powerDemand</code></td><td>Input signal</td><td>Modelica.Units.SI.Power</td><td>W</td><td>Power demand of the powertrain</td></tr>
<tr><td><code>batteryPowerMin</code></td><td>Input signal</td><td>Modelica.Units.SI.Power</td><td>W</td><td>Minimum battery power</td></tr>
<tr><td><code>batteryPowerMax</code></td><td>Input signal</td><td>Modelica.Units.SI.Power</td><td>W</td><td>Maximum battery power</td></tr>
<tr><td><code>LHVH2</code></td><td>Input signal</td><td>Real</td><td>Ws/g</td><td>Lower heating value hydrogen</td></tr>
<tr><td><code>mu</code></td><td>Input signal</td><td>Real</td><td>1</td><td>ECMS parameter</td></tr>
<tr><td><code>SOC</code></td><td>Input signal</td><td>Real</td><td>1</td><td>SOC of battery</td></tr>
<tr><td><code>SOC_min</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Minimum SOC of battery</td></tr>
<tr><td><code>SOC_max</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Maximum SOC of battery</td></tr>
<tr><td><code>sigma</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Parameter for ECMS</td></tr>
<tr><td><code>optimalParameter</code></td><td>Output signal</td><td>Modelica.Units.SI.Power</td><td>W</td><td>The parameter value that minimizes the function</td></tr>
<tr><td><code>minimumValue</code></td><td>Output signal</td><td>Real</td><td>g/s</td><td>The minimum function value found</td></tr>
</tbody></table>

</body></html>"));
end bruteForceMinimization;
