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

end bruteForceMinimization;
