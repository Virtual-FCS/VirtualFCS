within VirtualFCS.Media;

model CrackedAmmonia
  extends PartialCondensingMixture(
    final mediumName = "Cracked ammonia",
    final substanceNames = {"ammonia", "hydrogen", "nitrogen"}, 
    final reference_X = {0.9, 0.1},
    Temperature(min = 273.15, max = 500, start = 333),// TODO check
    AbsolutePressure(min = 3E4, max = 1E6, start = 1E5),
    MMX={Modelica.Media.IdealGases.Common.SingleGasesData.NH3.MM, 
         Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM, 
         Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM}
  );
  
  // Parameters from Stull (1947) as quoted in NIST
  function saturationPressure = antoine(A=5+4.86886, B=1113.928, C=-10.409);

  // Convenience variables to index arrays within class
  constant Integer Ammonia = 1 "Index of ammonia (in substanceNames, massFractions X, etc.)";
  constant Integer Hydrogen = 2 "Index of hydrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Nitrogen = 3 "Index of nitrogen (in substanceNames, massFractions X, etc.)";


  redeclare function flashVaporisation
    extends Modelica.Icons.Function;
    import Modelica.Constants.eps;
    input Modelica.Units.SI.MoleFraction Xmol[nX] "Mole Fractions";
    input Real iK[nX] "Inverted equilibrium constants, XL[i] = iK[i]*XG[i]";
    output Real beta_mol "Generalised gas fraction";
  algorithm
    assert(abs(iK[Ammonia]-1) > eps, "flashVaporisation: boiling point reached, Rachford-Rice is indetermined.");
    beta_mol := (1-Xmol[Ammonia])*iK[Water]/max((iK[Ammonia]-1), eps);
    annotation(
      Documentation(info = "<html><head></head><body>We redeclare this function to use the fact that there is a single condensing phase in this model, making it possible to obtain a direct solution to the Rachford-Rice equation.</body></html>"));
  end flashVaporisation;


  redeclare function extends invertedKs
    import Modelica.Constants.eps;
  algorithm
    iK := {state.p/saturationPressure(state.T), 0.0, 0.0};
  end invertedKs;


  redeclare function extends gasSpecificHeatCapacityCp
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.NH3_G, Shomate.H2, Shomate.N2};
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
  algorithm
    cp_gas := sum(X_gas[i] * Shomate.heat_capacity(state_gas.T, sh[i]) / MMX[i] for i in 1:nX);
  end gasSpecificHeatCapacityCp;

  redeclare function extends liquidSpecificHeatCapacityCp // FIXME Perry 2-214
  algorithm
    cp_liq := Shomate.heat_capacity(state_liq.T, Shomate.H2O_L) / MMX[Water];
    annotation(
    Documentation(info = "<html><head></head><body>Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div></body></html>"));
  end liquidSpecificHeatCapacityCp;


  redeclare function extends gasSpecificEnthalpy
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.NH3_G, Shomate.H2, Shomate.N2};
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
  algorithm
    h_gas := sum(X_gas[i] * Shomate.enthalpy(state_gas.T, sh[i]) / MMX[i] for i in 1:nX);
  end gasSpecificEnthalpy;

  redeclare function extends liquidSpecificEnthalpy // FIXME Perry 2-214
  algorithm
    h_liq := Shomate.enthalpy(state_liq.T, Shomate.H2O_L) / MMX[Water];
  annotation(
      Documentation(info = "<html><head></head><body>Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div></body></html>"));
  end liquidSpecificEnthalpy;
  

  redeclare function extends gasSpecificEntropy
    import Modelica.Constants.R;
    import Modelica.Constants.eps;
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.NH3_G, Shomate.H2, Shomate.N2};
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
  algorithm
    s_gas := X_gas*{Shomate.entropy(state_gas.T, sh[i])/MMX[i] for i in 1:nX}
           - R*(X_gas./MMX)*{log(max(X_gas[i], eps))+log(state_gas.p/reference_p) for i in 1:nX};
  end gasSpecificEntropy;

  redeclare function extends liquidSpecificEntropy // FIXME Perry 2-214
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
  
  redeclare function extends liquidDensity // FIXME Perry 2-97
    import Modelica.Media.Water.IF97_Utilities.rho_pT;
  algorithm
    d_liq := rho_pT(state_liq.p, state_liq.T, 1); // Last "1" specifies liquid phase explicitly
  end liquidDensity;

end CrackedAmmonia;
