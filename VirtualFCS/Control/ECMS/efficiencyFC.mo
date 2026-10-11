within VirtualFCS.Control.ECMS;

function efficiencyFC
// Function which returns FC system efficiency based on polynomial expression.
// RETHINK THIS ONE
  input Modelica.Units.SI.Power fcPower;
  output Real fcEfficiency;
algorithm

  fcEfficiency := max(-2.3552811729255974*10^(-28)*fcPower^6 + 6.1665632981341745*10^(-23) * fcPower^5 - 6.4445034579814230*10^(-18) * fcPower^4 + 3.4025968585605853*10^(-13)*fcPower^3 - 9.4483485991363506*10^(-9) * fcPower^2 + 1.2521983494464165*10^(-4) * fcPower -1.9991461078281599*10^(-2), 0.1);

end efficiencyFC;
