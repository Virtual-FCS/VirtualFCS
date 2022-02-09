within VirtualFCS.Electrochemical.Battery;

package Parameters "Parameters for battery models"
  extends Modelica.Icons.UtilitiesPackage;

  package Functions
    extends Modelica.Icons.FunctionsPackage;

    function getOCP_NMC
      extends Modelica.Icons.Function;
      input Real SOC "State of Charge";
      output SI.ElectricPotential OCP "Open-Circuit Potential";
      // Coefficients for open-circuit voltage calculation
      // NMC
      Real A0 = 2.951;
      Real A1 = 1;
      Real A2 = -0.05;
      Real A3 = -0.4;
      Real A4 = -0.085;
    algorithm
      OCV := A0 + A1 * SOC + A2 / SOC + A3 * log(SOC + 0.001) + A4 * log(1.01 - SOC);
    end getOCP_NMC;
  end Functions;
  annotation(
    Documentation(info = "<html><head></head><body>This package includes functions to calculate the battery's open-circuit potential for various chemistries based on state of charge, SOC.&nbsp;<div><br></div><div>As of February 2022, it is not used in any other Virtual-FCS model or component, but is included in the releases anyway as a placeholder for future development. Ideally, this framework can be used to select between different battery chemistries in a vehicle model.</div></body></html>"));
end Parameters;
