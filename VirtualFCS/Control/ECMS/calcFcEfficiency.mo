within VirtualFCS.Control.ECMS;
function calcFcEfficiency
  // Function which returns FC system efficiency based on polynomial expression.
  input Real fcCurrent;
  output Real fcEfficiency;
algorithm
  fcEfficiency := -2.28032634348 * 10^(-16)* fcCurrent^6 + 5.29567212538 * 10^(-13) * fcCurrent^5 - 4.83584705561 * 10^(-10) * fcCurrent^4 + 2.19811746997 * 10^(-7) * fcCurrent^3 -5.08697130216 * 10^(-5) * fcCurrent^2 + 4.7311314221 * 10^(-3) * fcCurrent + 0.427083655202;
end calcFcEfficiency;
