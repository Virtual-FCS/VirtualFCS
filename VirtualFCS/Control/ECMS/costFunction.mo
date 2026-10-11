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

end costFunction;
