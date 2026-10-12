within VirtualFCS.Media;

model CrackedAmmonia
  extends PartialCondensingMixture(
    final mediumName = "Cracked ammonia",
    final substanceNames = {"ammonia", "hydrogen", "nitrogen"}, 
    final reference_X = {0.8, 0.1, 0.1},
    Temperature(min = 195.5, max = 405.4, start = 298),
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
    beta_mol := (1-Xmol[Ammonia])*iK[Ammonia]/max((iK[Ammonia]-1), eps);
    annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
We redeclare this function to use the fact that there is a single condensing phase in this model, making it possible to obtain a direct solution to the Rachford-Rice equation.
<h2>Governing Equations</h2>
<pre>assert(abs(iK[Ammonia]-1) &gt; eps, &quot;flashVaporisation: boiling point reached, Rachford-Rice is indetermined.&quot;);
beta_mol := (1-Xmol[Ammonia])*iK[Ammonia]/max((iK[Ammonia]-1), eps);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
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
    iK := {state.p/saturationPressure(state.T), 0.0, 0.0};
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Inverted Ks calculation, evaluating <code>iK</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>iK := {state.p/saturationPressure(state.T), 0.0, 0.0};</pre>
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


  redeclare function extends gasSpecificHeatCapacityCp
  protected
    constant Shomate.Parameters sh[nX] = {Shomate.NH3_G, Shomate.H2, Shomate.N2};
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
    cp_liq := Shomate.heat_capacity(state_liq.T, Shomate.NH3_L) / MMX[Ammonia];
    annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div>
<h2>Governing Equations</h2>
<pre>cp_liq := Shomate.heat_capacity(state_liq.T, Shomate.NH3_L) / MMX[Ammonia];</pre>
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
    constant Shomate.Parameters sh[nX] = {Shomate.NH3_G, Shomate.H2, Shomate.N2};
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
    h_liq := Shomate.enthalpy(state_liq.T, Shomate.NH3_L) / MMX[Ammonia];
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div>
<h2>Governing Equations</h2>
<pre>h_liq := Shomate.enthalpy(state_liq.T, Shomate.NH3_L) / MMX[Ammonia];</pre>
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
    constant Shomate.Parameters sh[nX] = {Shomate.NH3_G, Shomate.H2, Shomate.N2};
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
    s_liq := Shomate.entropy(state_liq.T, Shomate.NH3_L) / MMX[Ammonia];
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div>
<h2>Governing Equations</h2>
<pre>s_liq := Shomate.entropy(state_liq.T, Shomate.NH3_L) / MMX[Ammonia];</pre>
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
  protected
    constant Real C[4] = {3.5383, 0.25443, 653.15, 0.1898};
  algorithm
    d_liq := C[1]/C[2]^(1+(1-state_liq.T/C[3])^C[4]) / 1000 * MMX[Ammonia];
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Correlation from Perry's Chemical Engineer's Handbook, 7th edition, table 2-30.<div>The original formula produces results in kmol/m<sup>3</sup>&nbsp;as a function of temperatures only, which are corrected to kg/m<sup>3</sup>&nbsp;in the code.</div>
<h2>Governing Equations</h2>
<pre>d_liq := C[1]/C[2]^(1+(1-state_liq.T/C[3])^C[4]) / 1000 * MMX[Ammonia];</pre>
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

  annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Condensing ammonia/hydrogen/nitrogen mixture. Ammonia is the only condensable species; hydrogen and nitrogen remain in the gas phase. The reference composition is given as mass fractions. Saturation pressure uses the Antoine correlation, and gas and liquid caloric properties use Shomate correlations. A direct single-condensable solution replaces the iterative Rachford-Rice flash calculation. The medium inherits its phase balance and state definition from PartialCondensingMixture.</p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end CrackedAmmonia;
