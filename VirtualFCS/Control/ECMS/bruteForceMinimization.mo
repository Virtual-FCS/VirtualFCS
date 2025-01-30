within VirtualFCS.Control.ECMS;
function bruteForceMinimization
  input Integer numIterations "Number of iterations to perform";
  input Real minFCCurrent "Minimum allowable value for the parameter";
  input Real maxFCCurrent "Maximum allowable value for the parameter";
  input Real powerDemand "Power demand of the powertrain";
  input Real n_cell "Number of fuel cell stacks";
  input Real tempFC "Fuel cell temperature";
  input Real P_H2 "Hydrogen pressure";
  input Real P_O2 "Oxygen pressure";
  input Real R_O_FC_stack "Ohmic resistance";
  input Real A_FC_surf "Surface area FC stack";
  input Real i_0_FC_stack "FC stack cell exchange curren";
  input Real i_L_FC_stack "Maximum FC current";
  input Real batteryVoltage "Battery voltage";
  input Real I_min_batt "Minimum battery current";
  input Real I_max_batt "Maximum battery current";
  input Real LHVH2 "Lower heating value hydrogen";
  input Real mu "ECMS parameter";
  input Real SOC "SOC of battery";
  input Real SOC_min "Minimum SOC of battery";
  input Real SOC_max "Maximum SOC of battery";
  input Real sigma "Parameter for ECMS";
  output Real optimalParameter "The parameter value that minimizes the function";
  output Real minimumValue "The minimum function value found";
protected
  Real stepSize "Step size between iterations";
  Real currentFc "Current parameter value being tested";
  Real currentBatt "Battery current from current fc current";
  Real currentFunctionValue "Current function value being evaluated";
  Real bestValue "Best function value found so far";
  Real bestParameter "Parameter corresponding to the best value";
  Integer i "Loop counter";
  Boolean checkConstraint "Store if the battery constraint is fulfilled and skips solution if its not";
algorithm
  stepSize := (maxFCCurrent - minFCCurrent) / (numIterations - 1);
  bestValue := Modelica.Constants.inf; // Initialize to infinity
  bestParameter := minFCCurrent; // Initialize to the minimum value

  for i in 1:numIterations loop
    currentFc := minFCCurrent + (i - 1) * stepSize;

    currentBatt :=(powerDemand - (currentFc*calcFCV(n_cell, tempFC, P_H2, P_O2, R_O_FC_stack, A_FC_surf, i_0_FC_stack, i_L_FC_stack, currentFc)))/(batteryVoltage);
    if (currentBatt > I_min_batt) and (currentBatt < I_max_batt) then
      checkConstraint := true;
    else
      checkConstraint := false;
    end if;

    currentFunctionValue := calcCost(currentFc, calcFCV(n_cell, tempFC, P_H2, P_O2, R_O_FC_stack, A_FC_surf, i_0_FC_stack, i_L_FC_stack, currentFc), LHVH2, mu, SOC, SOC_min, SOC_max, sigma, batteryVoltage, currentBatt);





    if (currentFunctionValue < bestValue) and checkConstraint then
      bestValue := currentFunctionValue;
      bestParameter := currentFc;
    end if;
  end for;

  optimalParameter := bestParameter;
  minimumValue := bestValue;
end bruteForceMinimization;
