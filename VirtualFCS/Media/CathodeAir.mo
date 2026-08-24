within VirtualFCS.Media;

package CathodeAir "Medium model for cathodic air in PEM fuel cells"
  extends PartialCondensingMixture(
    final mediumName = "Cathode air",
    final substanceNames = {"oxygen", "nitrogen", "water"}, 
    final reference_X = {0.23, 0.76, 0.01},  // NB! These are MASS fractions, not molar. Oxygen is heavier, water is lighter.
    Temperature(min = 273.15, max = 500, start = 333),
    AbsolutePressure(min = 3E4, max = 1E6, start = 1E5),
    MMX={Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM,
         Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, 
         Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM}
  );
  
  import saturationPressure = Modelica.Media.Air.ReferenceMoistAir.Utilities.Water95_Utilities.psat;
  //function saturationPressure = antoine(A=5+4.6543, B=1435.264, C=-64.848);

  // Convenience variables to index arrays within class
  constant Integer Oxygen = 1 "Index of oxygen (in substanceNames, massFractions X, etc.)";
  constant Integer Nitrogen = 2 "Index of nitrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Water = 3 "Index of water (in substanceNames, massFractions X, etc.)";


  redeclare record extends ThermodynamicState "Thermodynamic state variables"
    extends Modelica.Icons.Record;
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
    MassFraction[nXi] Xi(start = reference_X[1:nXi]) "Independent mass fractions";
    annotation(
      Documentation(info = "<html><head></head><body><div>To keep things simple, we assume that pTX is a sufficient representation of the thermodynamic state.</div><div>Strictly speaking, it isn't, since there are corner cases like water at 0 or 100 C.</div><div>If we were to handle these cases correctly we should use h instead of T, but then we need to invert h(T), which is an onerous operation since Shomate equations are polynomials of T and would need to be solved iteratively:</div><div>this it possible but numerically onerous.</div><div>It would also be possible to calculate new direct correlations T(h), but this becomes rapidly a larger job.</div><div>Since pure freezing or boiling water is an extremely rare case in fuel cells, we use the more convenient option.</div></body></html>"));
  end ThermodynamicState;

  redeclare model extends BaseProperties "Base properties of cathodic air"
      Modelica.Units.SI.MoleFraction phi = Xmol_gas[Water] / (saturationPressure(state.T)/state.p);
  end BaseProperties;


  redeclare function flashVaporisation
    extends Modelica.Icons.Function;
    import Modelica.Constants.eps;
    input Modelica.Units.SI.MoleFraction Xmol[nX] "Mole Fractions";
    input Real iK[nX] "Inverted equilibrium constants, XL[i] = iK[i]*XG[i]";
    output Real beta_mol "Generalised gas fraction";
  algorithm
    assert(abs(iK[Water]-1) > eps, "flashVaporisation: boiling point reached, Rachford-Rice is indetermined.");
    beta_mol := (1-Xmol[Water])*iK[Water]/max((iK[Water]-1), eps);
    annotation(
      Documentation(info = "<html><head></head><body>We redeclare this function to use the fact that there is a single condensing phase in this model, making it possible to obtain a direct solution to the Rachford-Rice equation.</body></html>"));
  end flashVaporisation;


  redeclare function extends invertedKs
    import Modelica.Constants.eps;
  algorithm
    iK := {0.0, 0.0, state.p/saturationPressure(state.T)};
  end invertedKs;

  function relativeHumidity
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MoleFraction phi;
  protected
    Modelica.Units.SI.MassFraction X[nX] = cat(1, state.Xi, {1-sum(state.Xi)});
    Modelica.Units.SI.MoleFraction Xmol[nX] = massToMoleFractions(X);
    Real iK[nX] = invertedKs(state);
    Real beta_mol = flashVaporisation(Xmol, iK);
    Modelica.Units.SI.MoleFraction Xmol_gas[nX] = gasMolarFractions(beta_mol, Xmol, iK);
  algorithm
    phi := Xmol_gas[Water]*state.p/saturationPressure(state.T);
  end relativeHumidity;


  redeclare function extends gasSpecificHeatCapacityCp
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.O2, Shomate.N2, Shomate.H2O_G};
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
  algorithm
    cp_gas := sum(X_gas[i] * Shomate.heat_capacity(state_gas.T, sh[i]) / MMX[i] for i in 1:nX);
  end gasSpecificHeatCapacityCp;

  redeclare function extends liquidSpecificHeatCapacityCp
  algorithm
    cp_liq := Shomate.heat_capacity(state_liq.T, Shomate.H2O_L) / MMX[Water];
    annotation(
    Documentation(info = "<html><head></head><body>Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div></body></html>"));
  end liquidSpecificHeatCapacityCp;


  redeclare function extends gasSpecificEnthalpy
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.O2, Shomate.N2, Shomate.H2O_G};
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
  algorithm
    h_gas := sum(X_gas[i] * Shomate.enthalpy(state_gas.T, sh[i]) / MMX[i] for i in 1:nX);
  end gasSpecificEnthalpy;

  redeclare function extends liquidSpecificEnthalpy
  algorithm
    h_liq := Shomate.enthalpy(state_liq.T, Shomate.H2O_L) / MMX[Water];
  annotation(
      Documentation(info = "<html><head></head><body>Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div></body></html>"));
  end liquidSpecificEnthalpy;
  

  redeclare function extends gasSpecificEntropy
    import Modelica.Constants.R;
    import Modelica.Constants.eps;
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.O2, Shomate.N2, Shomate.H2O_G};
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
  algorithm
    s_gas := X_gas*{Shomate.entropy(state_gas.T, sh[i])/MMX[i] for i in 1:nX}
           - R*(X_gas./MMX)*{log(max(X_gas[i], eps))+log(state_gas.p/reference_p) for i in 1:nX};
  end gasSpecificEntropy;

  redeclare function extends liquidSpecificEntropy
  algorithm
    s_liq := Shomate.entropy(state_liq.T, Shomate.H2O_L) / MMX[Water];
  annotation(
      Documentation(info = "<html><head></head><body>Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div></body></html>"));
  end liquidSpecificEntropy;

  
  redeclare function extends gasDensity
  protected
    import Modelica.Constants.R;
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
    Modelica.Units.SI.MolarMass MM_gas = 1/sum(X_gas./MMX);
  algorithm
    d_gas := state_gas.p/((R/MM_gas)*state_gas.T);
  end gasDensity;
  
  redeclare function extends liquidDensity
    import Modelica.Media.Water.IF97_Utilities.rho_pT;
  algorithm
    d_liq := rho_pT(state_liq.p, state_liq.T, 1); // Last "1" specifies liquid phase explicitly
  end liquidDensity;


  redeclare function extends dynamicViscosity
      "Return dynamic viscosity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
  algorithm
    eta := 1e-6*Modelica.Math.Polynomials.evaluateWithRange(
        {9.7391102886305869E-15,-3.1353724870333906E-11,4.3004876595642225E-08,
        -3.8228016291758240E-05,5.0427874367180762E-02,1.7239260139242528E+01},
        Modelica.Units.Conversions.to_degC(123.15),
        Modelica.Units.Conversions.to_degC(1273.15),
        Modelica.Units.Conversions.to_degC(state.T));
    annotation (smoothOrder=2, Documentation(info="<html>
  <p>Dynamic viscosity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure and moisture is neglected.</p>
  <p>Source: VDI Waermeatlas, 8th edition.</p>
  <p>Imported from Modelica.Media.Air.MoistAir, since a variable nitrogen-oxygen ratio will not have a major impact.</p>
  </html>"));
  end dynamicViscosity;
  
  redeclare function extends thermalConductivity
      "Return thermal conductivity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
  algorithm
    lambda := 1e-3*Modelica.Math.Polynomials.evaluateWithRange(
        {6.5691470817717812E-15,-3.4025961923050509E-11,5.3279284846303157E-08,
        -4.5340839289219472E-05,7.6129675309037664E-02,2.4169481088097051E+01},
        Modelica.Units.Conversions.to_degC(123.15),
        Modelica.Units.Conversions.to_degC(1273.15),
        Modelica.Units.Conversions.to_degC(state.T));
  
    annotation (smoothOrder=2, Documentation(info="<html>
  <p>Thermal conductivity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure and moisture is neglected.</p>
  <p>Source: VDI Waermeatlas, 8th edition.</p>
  <p>Imported from Modelica.Media.Air.MoistAir, since a variable nitrogen-oxygen ratio will not have a major impact.</p>
  </html>"));
  end thermalConductivity;

  annotation(
    Documentation(info = "<html><head></head><body><p>
This medium models air in fuel cells. This includes separate accounts of oxygen and nitrogen, in addition to tracking humidity and condensation.</p>
</body></html>"));
end CathodeAir;
