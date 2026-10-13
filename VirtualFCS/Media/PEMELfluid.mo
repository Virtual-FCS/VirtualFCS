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
      Documentation(info = "<html><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below. Units are explicit; <code>1</code> denotes a dimensionless quantity.</p><table border=&quot;1&quot; cellspacing=&quot;0&quot; cellpadding=&quot;4&quot;><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td colspan=&quot;5&quot;>No user-settable parameters are declared.</td></tr></table><h3>Inputs and input-side interfaces</h3><table border=&quot;1&quot; cellspacing=&quot;0&quot; cellpadding=&quot;4&quot;><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>Xmol[nX]</code></td><td>input</td><td>Modelica.Units.SI.MoleFraction</td><td>1</td><td>Mole Fractions</td></tr>
<tr><td><code>iK[nX]</code></td><td>input</td><td>Real</td><td>1</td><td>Inverted equilibrium constants, XL[i] = iK[i]*XG[i]</td></tr>
<tr><td><code>state</code></td><td>input</td><td>ThermodynamicState</td><td>-</td><td></td></tr></table><h2>2. Model description</h2>We redeclare this function to use the fact that there is a single condensing phase in this model, making it possible to obtain a direct solution to the Rachford-Rice equation.<h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>.&lt;h2&gt;3. Governing equations and references&lt;/h2&gt;&lt;p&gt;The following representative equations are implemented directly. Equations inherited through &lt;code&gt;extends&lt;/code&gt; and component connections also contribute to the complete model balance.&lt;/p&gt;&lt;pre&gt;.&amp;lt;h2&amp;gt;3. Governing equations and references&amp;lt;/h2&amp;gt;&amp;lt;p&amp;gt;This model delegates its governing equations to the components and models it extends or instantiates. The connected components enforce the relevant conservation laws and constitutive relations.&amp;lt;/p&amp;gt;&amp;lt;h2&amp;gt;4. Outputs&amp;lt;/h2&amp;gt;&amp;lt;p&amp;gt;Output connectors and public calculated quantities are listed below. Physical connector values are determined by the connected network and the equations in this model.&amp;lt;/p&amp;gt;&amp;lt;table border=&amp;amp;quot;1&amp;amp;quot; cellspacing=&amp;amp;quot;0&amp;amp;quot; cellpadding=&amp;amp;quot;4&amp;amp;quot;&amp;gt;&amp;lt;tr&amp;gt;&amp;lt;th&amp;gt;Name&amp;lt;/th&amp;gt;&amp;lt;th&amp;gt;Direction&amp;lt;/th&amp;gt;&amp;lt;th&amp;gt;Connector&amp;lt;/th&amp;gt;&amp;lt;th&amp;gt;Unit&amp;lt;/th&amp;gt;&amp;lt;/tr&amp;gt;&amp;lt;tr&amp;gt;&amp;lt;td colspan=&amp;amp;quot;4&amp;amp;quot;&amp;gt;No external signal or physical connectors are declared.&amp;lt;/td&amp;gt;&amp;lt;/tr&amp;gt;&amp;lt;/table&amp;gt;&amp;lt;/html&amp;gt;&amp;quot;));&lt;/pre&gt;&lt;p&gt;References retained from the original model documentation are included in the description above.&lt;/p&gt;&lt;h2&gt;4. Outputs&lt;/h2&gt;&lt;p&gt;Declared signal outputs and output-side physical interfaces are listed below.&lt;/p&gt;&lt;table border=&quot;1&quot; cellspacing=&quot;0&quot; cellpadding=&quot;4&quot;&gt;&lt;tr&gt;&lt;th&gt;Name&lt;/th&gt;&lt;th&gt;Direction&lt;/th&gt;&lt;th&gt;Interface&lt;/th&gt;&lt;th&gt;Unit&lt;/th&gt;&lt;th&gt;Description&lt;/th&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;&lt;code&gt;beta_mol&lt;/code&gt;&lt;/td&gt;&lt;td&gt;output&lt;/td&gt;&lt;td&gt;Real&lt;/td&gt;&lt;td&gt;1&lt;/td&gt;&lt;td&gt;Generalised gas fraction&lt;/td&gt;&lt;/tr&gt;</pre><p>References retained from the original model documentation are included in the description above.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=&quot;1&quot; cellspacing=&quot;0&quot; cellpadding=&quot;4&quot;><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>beta_mol</code></td><td>output</td><td>Real</td><td>1</td><td>Generalised gas fraction</td></tr>
<tr><td><code>phi</code></td><td>output</td><td>Modelica.Units.SI.MoleFraction</td><td>1</td><td></td></tr></table></html>"));
  end flashVaporisation;


  redeclare function extends invertedKs
    import Modelica.Constants.eps;
  algorithm
    iK := {0.0, 0.0, 0.0, state.p/saturationPressure(state.T)};
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
    constant Shomate.Parameters sh[nX] = {Shomate.O2, Shomate.N2, Shomate.H2, Shomate.H2O_G};
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
    constant Shomate.Parameters sh[nX] = {Shomate.O2, Shomate.N2, Shomate.H2, Shomate.H2O_G};
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
    constant Shomate.Parameters sh[nX] = {Shomate.O2, Shomate.N2, Shomate.H2, Shomate.H2O_G};
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
  end liquidDensity;annotation(
    Documentation(info = "<html><head></head><body>This medium is an extension of <tt>MoistAir</tt> in which also hydrogen is included in the gas phase.<div>This allows this medium to model hydrogen contamination and cross-over through PEM membranes.</div></body></html>"));

end PEMELfluid;
