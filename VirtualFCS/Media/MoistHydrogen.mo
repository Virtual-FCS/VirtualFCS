within VirtualFCS.Media;

package MoistHydrogen "Media model for hydrogen containing water vapour"
  extends PartialCondensingMixture(
    final mediumName = "Wet hydrogen",
    final substanceNames = {"hydrogen", "water"}, 
    final reference_X = {0.9, 0.1},
    Temperature(min = 273.15, max = 500, start = 333),
    AbsolutePressure(min = 3E4, max = 90E6, start = 1E5),
    MMX={Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM, 
         Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM}
  );
  
  import saturationPressure = Modelica.Media.Air.ReferenceMoistAir.Utilities.Water95_Utilities.psat;
  //function saturationPressure = antoine(A=5+4.6543, B=1435.264, C=-64.848);

  // Convenience variables to index arrays within class
  constant Integer Hydrogen = 1 "Index of hydrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Water = 2 "Index of water (in substanceNames, massFractions X, etc.)";

  redeclare model extends BaseProperties "Base properties of wet hydrogen"
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
    iK := {0.0, state.p/saturationPressure(state.T)};
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
    constant Shomate.Parameters sh[nX] = {Shomate.H2, Shomate.H2O_G};
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
    constant Shomate.Parameters sh[nX] = {Shomate.H2, Shomate.H2O_G};
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
    constant Shomate.Parameters sh[nX] = {Shomate.H2, Shomate.H2O_G};
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

end MoistHydrogen;
