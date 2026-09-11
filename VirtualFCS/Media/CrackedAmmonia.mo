within VirtualFCS.Media;

model CrackedAmmonia
  extends PartialCondensingMixture(
    final mediumName = "Cracked ammonia",
    final substanceNames = {"ammonia", "hydrogen", "nitrogen"}, 
    final reference_X = {0.8, 0.1, 0.1},
    Temperature(min = 195.5, max = 405.4, start = 298),
    AbsolutePressure(min = 3E4, max = 5E6, start = 1E5),
    MMX={Modelica.Media.IdealGases.Common.SingleGasesData.NH3.MM, 
         Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM, 
         Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM}
  );
  
  // Parameters from Stull (1947) as quoted in NIST
  //function saturationPressure = antoine(A=5+4.86886, B=1113.928, C=-10.409);
  function saturationPressure = clausiusClapeyron(T_boil=239.8, L=23400);

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
    beta_mol := (1-Xmol[Ammonia])*iK[Ammonia]/max((iK[Ammonia]-1), eps);
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

  redeclare function extends liquidSpecificHeatCapacityCp
  algorithm
    cp_liq := Shomate.heat_capacity(state_liq.T, Shomate.NH3_L) / MMX[Ammonia];
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

  redeclare function extends liquidSpecificEnthalpy
  algorithm
    h_liq := Shomate.enthalpy(state_liq.T, Shomate.NH3_L) / MMX[Ammonia];
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

  redeclare function extends liquidSpecificEntropy
  algorithm
    s_liq := Shomate.entropy(state_liq.T, Shomate.NH3_L) / MMX[Ammonia];
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
  protected
    constant Real C[4] = {3.5383, 0.25443, 653.15, 0.1898};
  algorithm
    d_liq := C[1]/C[2]^(1+(max(1e-6,1-state_liq.T/C[3]))^C[4]) / 1000 * MMX[Ammonia];
  annotation(
      Documentation(info = "<html><head></head><body>Correlation from Perry's Chemical Engineer's Handbook, 7th edition, table 2-30.<div>The original formula produces results in kmol/m<sup>3</sup>&nbsp;as a function of temperatures only, which are corrected to kg/m<sup>3</sup>&nbsp;in the code.</div></body></html>"));
end liquidDensity;

redeclare function extends dynamicViscosity
      "Return dynamic viscosity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
  algorithm
    eta := 3.5e-5;
  end dynamicViscosity;

end CrackedAmmonia;
