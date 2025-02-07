within VirtualFCS.Control.ECMS;
function calcCost
  input Real currentFc "Fuel cell current";
  input Real voltageFc "Fuel cell voltage";
  input Real LHVH2 "Lower heating value for hydrogen";
  input Real mu "ECMS parameter";
  input Real SOC "Battery SOC";
  input Real SOC_min "Battery min SOC";
  input Real SOC_max "Battery max SOC";
  input Real sigma "Sigma parameter for ECMS";
  input Real voltageBattery "Battery voltage";
  input Real currentBattery "Battery current";
  output Real cost "Cost at the current instance";

algorithm
  cost := ((currentFc * voltageFc)/(LHVH2 * calcFcEfficiency(currentFc))) + ((1-mu*((SOC - 0.5*(SOC_min+SOC_max))/(0.5*(SOC_min+SOC_max)))) * ((sigma * currentBattery * voltageBattery)/(LHVH2 * calcFcEfficiency(currentFc))));
end calcCost;
