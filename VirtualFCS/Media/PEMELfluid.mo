within VirtualFCS.Media;

model PEMELfluid "Generic fluid on anode and cathode of a PEM electrolyser"
   extends PartialCondensingMixture(
    final mediumName = "PEMEL fluid",
    final substanceNames = {"oxygen", "nitrogen", "hydrogen", "water"}, 
    final reference_X = {0.78, 0.01, 0.01, 0.2},
    Temperature(min = 273.15, max = 500, start = 333),
    AbsolutePressure(min = 3E4, max = 1E6, start = 1E5),
    MMX={Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM,
         Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, 
         Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, 
         Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM}
  );
  
  import saturationPressure = Modelica.Media.Air.ReferenceMoistAir.Utilities.Water95_Utilities.psat;
  //function saturationPressure = antoine(A=5+4.6543, B=1435.264, C=-64.848);

  // Convenience variables to index arrays within class
  constant Integer Oxygen = 1 "Index of oxygen (in substanceNames, massFractions X, etc.)";
  constant Integer Nitrogen = 2 "Index of nitrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Hydrogen = 3 "Index of hydrogen (in substanceNames, massFractions X, etc.)";
  constant Integer Water = 4 "Index of water (in substanceNames, massFractions X, etc.)";

  redeclare model extends BaseProperties "Base properties of cathodic air"
      Modelica.Units.SI.MoleFraction phi = Xmol_gas[Water] / (saturationPressure(state.T)/state.p);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Base properties of cathodic air.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>BaseProperties</code>.</p><pre>phi = Xmol_gas[Water] / (saturationPressure(state.T)/state.p);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
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
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
We redeclare this function to use the fact that there is a single condensing phase in this model, making it possible to obtain a direct solution to the Rachford-Rice equation.
<h2>Governing Equations</h2>
<pre>assert(abs(iK[Water]-1) &gt; eps, &quot;flashVaporisation: boiling point reached, Rachford-Rice is indetermined.&quot;);
beta_mol := (1-Xmol[Water])*iK[Water]/max((iK[Water]-1), eps);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>Xmol</code></td><td>Mole Fractions</td></tr>
<tr><td><code>iK</code></td><td>Inverted equilibrium constants, XL[i] = iK[i]*XG[i]</td></tr>
<tr><td><code>beta_mol</code></td><td>Generalised gas fraction</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>Xmol</code></td><td>Input signal</td><td>Modelica.Units.SI.MoleFraction[nX]</td><td>1</td><td>Mole Fractions</td></tr>
<tr><td><code>iK</code></td><td>Input signal</td><td>Real[nX]</td><td>1</td><td>Inverted equilibrium constants, XL[i] = iK[i]*XG[i]</td></tr>
<tr><td><code>beta_mol</code></td><td>Output signal</td><td>Real</td><td>1</td><td>Generalised gas fraction</td></tr>
</table>
</body>
</html>"));
  end flashVaporisation;


  redeclare function extends invertedKs
    import Modelica.Constants.eps;
  algorithm
    iK := {0.0, 0.0, 0.0, state.p/saturationPressure(state.T)};
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Inverted Ks calculation, evaluating <code>iK</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>iK := {0.0, 0.0, 0.0, state.p/saturationPressure(state.T)};</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
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
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Relative Humidity calculation, evaluating <code>phi</code> from <code>state</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X[nX] = cat(1, state.Xi, {1-sum(state.Xi)});
Xmol[nX] = massToMoleFractions(X);
iK[nX] = invertedKs(state);
beta_mol = flashVaporisation(Xmol, iK);
Xmol_gas[nX] = gasMolarFractions(beta_mol, Xmol, iK);
phi := Xmol_gas[Water]*state.p/saturationPressure(state.T);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>-</td></tr>
<tr><td><code>phi</code></td><td>Output signal</td><td>Modelica.Units.SI.MoleFraction</td><td>1</td><td>Hydration factor in the ohmic-loss correlation</td></tr>
</table>
</body>
</html>"));
end relativeHumidity;


  redeclare function extends gasSpecificHeatCapacityCp
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.O2, Shomate.N2, Shomate.H2, Shomate.H2O_G};
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
  algorithm
    cp_gas := sum(X_gas[i] * Shomate.heat_capacity(state_gas.T, sh[i]) / MMX[i] for i in 1:nX);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas Specific Heat Capacity Cp calculation, evaluating <code>cp_gas</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
cp_gas := sum(X_gas[i] * Shomate.heat_capacity(state_gas.T, sh[i]) / MMX[i] for i in 1:nX);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end gasSpecificHeatCapacityCp;

  redeclare function extends liquidSpecificHeatCapacityCp
  algorithm
    cp_liq := Shomate.heat_capacity(state_liq.T, Shomate.H2O_L) / MMX[Water];
    annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div>
<h2>Governing Equations</h2>
<pre>cp_liq := Shomate.heat_capacity(state_liq.T, Shomate.H2O_L) / MMX[Water];</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
  end liquidSpecificHeatCapacityCp;


  redeclare function extends gasSpecificEnthalpy
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.O2, Shomate.N2, Shomate.H2, Shomate.H2O_G};
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
  algorithm
    h_gas := sum(X_gas[i] * Shomate.enthalpy(state_gas.T, sh[i]) / MMX[i] for i in 1:nX);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas Specific Enthalpy calculation, evaluating <code>h_gas</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
h_gas := sum(X_gas[i] * Shomate.enthalpy(state_gas.T, sh[i]) / MMX[i] for i in 1:nX);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end gasSpecificEnthalpy;

  redeclare function extends liquidSpecificEnthalpy
  algorithm
    h_liq := Shomate.enthalpy(state_liq.T, Shomate.H2O_L) / MMX[Water];
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div>
<h2>Governing Equations</h2>
<pre>h_liq := Shomate.enthalpy(state_liq.T, Shomate.H2O_L) / MMX[Water];</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
  end liquidSpecificEnthalpy;
  

  redeclare function extends gasSpecificEntropy
    import Modelica.Constants.R;
    import Modelica.Constants.eps;
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.O2, Shomate.N2, Shomate.H2, Shomate.H2O_G};
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
  algorithm
    s_gas := X_gas*{Shomate.entropy(state_gas.T, sh[i])/MMX[i] for i in 1:nX}
           - R*(X_gas./MMX)*{log(max(X_gas[i], eps))+log(state_gas.p/reference_p) for i in 1:nX};
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas Specific Entropy calculation, evaluating <code>s_gas</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
s_gas := X_gas*{Shomate.entropy(state_gas.T, sh[i])/MMX[i] for i in 1:nX} - R*(X_gas./MMX)*{log(max(X_gas[i], eps))+log(state_gas.p/reference_p) for i in 1:nX};</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end gasSpecificEntropy;

  redeclare function extends liquidSpecificEntropy
  algorithm
    s_liq := Shomate.entropy(state_liq.T, Shomate.H2O_L) / MMX[Water];
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div>
<h2>Governing Equations</h2>
<pre>s_liq := Shomate.entropy(state_liq.T, Shomate.H2O_L) / MMX[Water];</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
  end liquidSpecificEntropy;

  
  redeclare function extends gasDensity
  protected
    import Modelica.Constants.R;
    Modelica.Units.SI.MassFraction X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
    Modelica.Units.SI.MolarMass MM_gas = 1/sum(X_gas./MMX);
  algorithm
    d_gas := state_gas.p/((R/MM_gas)*state_gas.T);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas Density calculation, evaluating <code>d_gas</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X_gas[nX] = cat(1, state_gas.Xi, {1-sum(state_gas.Xi)});
MM_gas = 1/sum(X_gas./MMX);
d_gas := state_gas.p/((R/MM_gas)*state_gas.T);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end gasDensity;
  
  redeclare function extends liquidDensity
    import Modelica.Media.Water.IF97_Utilities.rho_pT;
  algorithm
    d_liq := rho_pT(state_liq.p, state_liq.T, 1); // Last "1" specifies liquid phase explicitly
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Liquid Density calculation, evaluating <code>d_liq</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>d_liq := rho_pT(state_liq.p, state_liq.T, 1);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end liquidDensity;

  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Condensing hydrogen/oxygen/water mixture for PEM electrolyser fluid calculations. Water is the condensable species, while hydrogen and oxygen remain gaseous. Gas and liquid heat capacity, enthalpy, and entropy are calculated from Shomate correlations. The flash calculation uses the single-condensable form of the Rachford-Rice equation; phase and mixture balances are provided by PartialCondensingMixture.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>PartialCondensingMixture</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end PEMELfluid;
