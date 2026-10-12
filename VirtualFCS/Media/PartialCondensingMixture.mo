within VirtualFCS.Media;

partial model PartialCondensingMixture
  extends Modelica.Media.Interfaces.PartialMedium(
    final singleState=false,
    final ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pTX,
    reducedX = true,
    fixedX = false
  );
  
  constant Modelica.Units.SI.MolarMass MMX[nS] "Molar masses of substances";
  
  redeclare replaceable record extends ThermodynamicState "Thermodynamic state variables"
    Modelica.Units.SI.AbsolutePressure p "Absolute pressure of medium";
    Modelica.Units.SI.Temperature T "Temperature of medium";
    Modelica.Units.SI.MassFraction[nXi] Xi(start=reference_X[1:nXi]) "Mass fractions (= (component mass)/total mass  m_i/m)";
      annotation( Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<div>To keep things simple, we assume that pTX is a sufficient representation of the thermodynamic state.</div><div>Strictly speaking, it isn't, since there are corner cases like water at 0 or 100 C.</div><div>If we were to handle these cases correctly we should use h instead of T, but then we need to invert h(T), which is an onerous operation since Shomate equations are polynomials of T and would need to be solved iteratively:</div><div>this it possible but numerically onerous.</div><div>It would also be possible to calculate new direct correlations T(h), but this becomes rapidly a larger job.</div><div>Since pure freezing or boiling water is an extremely rare case in the systems we study, we use the more convenient option.</div>
<h2>Governing Equations</h2>
<p>Data record; the fields listed below carry the declared quantities. The record does not impose time-dependent balances.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Record field</td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td>Absolute pressure of medium</td></tr>
<tr><td><code>T</code></td><td>Record field</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>Temperature of medium</td></tr>
<tr><td><code>Xi</code></td><td>Record field</td><td>Modelica.Units.SI.MassFraction[nXi]</td><td>1</td><td>Mass fractions (= (component mass)/total mass  m_i/m)</td></tr>
</table>
</body>
</html>"));
  end ThermodynamicState;
  
  redeclare model extends BaseProperties(final standardOrderComponents = true,
    d = 1/(beta/d_gas + (1-beta)/d_liq),
    h = beta*h_gas + (1-beta)*h_liq,
    u = h - p*(beta/d_gas+(1-beta)/d_liq),
    MM = molarMass(state),
    R_s = Modelica.Constants.R / MM_gas,
    state.p = p,
    state.T = T,
    state.Xi = Xi
    ) "Base properties of medium"
    Modelica.Units.SI.MassFraction beta = max( min(beta_mol * MM_gas/MM, 1.0), 0.0) "Mass vaporisation rate";
    Modelica.Units.SI.MassFraction X_liq[nX] = moleToMassFractions(Xmol_liq) "Liquid mass fractions";
    Modelica.Units.SI.MassFraction X_gas[nX] = moleToMassFractions(Xmol_gas) "Gas mass fractions";
    Modelica.Units.SI.MolarMass MM_liq = MMX*Xmol_liq "Molar mass of liquid phase";
    Modelica.Units.SI.MolarMass MM_gas = MMX*Xmol_gas "Molar mass of gas phase";

// The following functions are specific to the fluid and need to be specified in child classes
    Modelica.Units.SI.Density d_liq = liquidDensity(state_liq) "Density of liquid phase";
    Modelica.Units.SI.Density d_gas = gasDensity(state_gas) "Density of gas phase";
    Modelica.Units.SI.SpecificEnthalpy h_liq = liquidSpecificEnthalpy(state_liq) "Specific enthalpy of liquid phase";
    Modelica.Units.SI.SpecificEnthalpy h_gas = gasSpecificEnthalpy(state_gas) "Specific enthalpy of gas phase";
  
  protected // These helper variables are hidden to avoid cluttering the model
    Real iK[nX] = invertedKs(state) "Inverted equilibrium constants";
    Real beta_mol = flashVaporisation(Xmol, iK) "Generalised vaporisation ratio";
    Modelica.Units.SI.MoleFraction Xmol[nX] = massToMoleFractions(X);
    Modelica.Units.SI.MoleFraction Xmol_liq[nX] = liquidMolarFractions(beta_mol, Xmol, iK);
    Modelica.Units.SI.MoleFraction Xmol_gas[nX] = gasMolarFractions(beta_mol, Xmol, iK);
    ThermodynamicState state_gas = ThermodynamicState(p, T, X_gas[1:nXi]);
    ThermodynamicState state_liq = ThermodynamicState(p, T, X_liq[1:nXi]);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Calculates the medium&#x27;s bulk thermodynamic properties from pressure, temperature, and composition. The property bindings below define the gas/liquid mixture density, enthalpy, internal energy, and thermodynamic state used by connected fluid components.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>BaseProperties</code>.</p><pre>extends BaseProperties(final standardOrderComponents = true, d = 1/(beta/d_gas + (1-beta)/d_liq), h = beta*h_gas + (1-beta)*h_liq, u = h - p*(beta/d_gas+(1-beta)/d_liq), MM = molarMass(state), R_s = Modelica.Constants.R / MM_gas, state.p = p, state.T = T, state.Xi = Xi );
beta = max( min(beta_mol * MM_gas/MM, 1.0), 0.0);
X_liq[nX] = moleToMassFractions(Xmol_liq);
X_gas[nX] = moleToMassFractions(Xmol_gas);
MM_liq = MMX*Xmol_liq;
MM_gas = MMX*Xmol_gas;
d_liq = liquidDensity(state_liq);
d_gas = gasDensity(state_gas);
h_liq = liquidSpecificEnthalpy(state_liq);
h_gas = gasSpecificEnthalpy(state_gas);
iK[nX] = invertedKs(state);
beta_mol = flashVaporisation(Xmol, iK);
Xmol[nX] = massToMoleFractions(X);
Xmol_liq[nX] = liquidMolarFractions(beta_mol, Xmol, iK);
Xmol_gas[nX] = gasMolarFractions(beta_mol, Xmol, iK);
state_gas = ThermodynamicState(p, T, X_gas[1:nXi]);
state_liq = ThermodynamicState(p, T, X_liq[1:nXi]);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>beta</code></td><td>Mass vaporisation rate</td></tr>
<tr><td><code>X_liq</code></td><td>Liquid mass fractions</td></tr>
<tr><td><code>X_gas</code></td><td>Gas mass fractions</td></tr>
<tr><td><code>MM_liq</code></td><td>Molar mass of liquid phase</td></tr>
<tr><td><code>MM_gas</code></td><td>Molar mass of gas phase</td></tr>
<tr><td><code>d_liq</code></td><td>Density of liquid phase</td></tr>
<tr><td><code>d_gas</code></td><td>Density of gas phase</td></tr>
<tr><td><code>h_liq</code></td><td>Specific enthalpy of liquid phase</td></tr>
<tr><td><code>h_gas</code></td><td>Specific enthalpy of gas phase</td></tr>
<tr><td><code>iK</code></td><td>Inverted equilibrium constants</td></tr>
<tr><td><code>beta_mol</code></td><td>Generalised vaporisation ratio</td></tr>
</table>
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


  function moleToMassFractions "Return mass fractions X from mole fractions"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MoleFraction Xmol[nX] "Mole fractions of mixture";
    output Modelica.Units.SI.MassFraction X[nX] "Mass fractions of mixture";
  algorithm
    X := Xmol.*MMX/(Xmol*MMX);
    annotation (smoothOrder=5);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Return mass fractions X from mole fractions.</p>
<h2>Governing Equations</h2>
<pre>X := Xmol.*MMX/(Xmol*MMX);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>Xmol</code></td><td>Mole fractions of mixture</td></tr>
<tr><td><code>X</code></td><td>Mass fractions of mixture</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>Xmol</code></td><td>Input signal</td><td>Modelica.Units.SI.MoleFraction[nX]</td><td>1</td><td>Mole fractions of mixture</td></tr>
<tr><td><code>X</code></td><td>Output signal</td><td>Modelica.Units.SI.MassFraction[nX]</td><td>1</td><td>Mass fractions of mixture</td></tr>
</table>
</body>
</html>"));
end moleToMassFractions;

  function massToMoleFractions "Return mole fractions from mass fractions X"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MassFraction X[nX] "Mass fractions of mixture";
    output Modelica.Units.SI.MoleFraction Xmol[nX] "Mole fractions of mixture";
  algorithm
    Xmol := (X./MMX)/(X*(1.0./MMX));
    annotation (smoothOrder=5);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Return mole fractions from mass fractions X.</p>
<h2>Governing Equations</h2>
<pre>Xmol := (X./MMX)/(X*(1.0./MMX));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>X</code></td><td>Mass fractions of mixture</td></tr>
<tr><td><code>Xmol</code></td><td>Mole fractions of mixture</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>X</code></td><td>Input signal</td><td>Modelica.Units.SI.MassFraction[nX]</td><td>1</td><td>Mass fractions of mixture</td></tr>
<tr><td><code>Xmol</code></td><td>Output signal</td><td>Modelica.Units.SI.MoleFraction[nX]</td><td>1</td><td>Mole fractions of mixture</td></tr>
</table>
</body>
</html>"));
end massToMoleFractions;
  
  function antoine "Vapour pressure according to the Antoine equation"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T;
    input Real A;
    input Modelica.Units.SI.TemperatureDifference B, C;
    output Modelica.Units.SI.AbsolutePressure p;
  algorithm
    p := 10^(A - B/(T + C));
    annotation(smoothOrder(normallyConstant = A, normallyConstant = B, normallyConstant = C) = 100);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Vapour pressure according to the Antoine equation.</p>
<h2>Governing Equations</h2>
<pre>p := 10^(A - B/(T + C));</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>-</td></tr>
<tr><td><code>A</code></td><td>Input signal</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>B</code></td><td>Input signal</td><td>Modelica.Units.SI.TemperatureDifference</td><td>K</td><td>-</td></tr>
<tr><td><code>p</code></td><td>Output signal</td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td>-</td></tr>
</table>
</body>
</html>"));
end antoine;
  
  function clausiusClapeyron "Vapour pressure according to the Clausius Clapeyron equation"
    extends Modelica.Icons.Function;
    import Modelica.Constants.R;
    input Modelica.Units.SI.Temperature T, T_boil;
    input Modelica.Units.SI.MolarEnergy L;
    output Modelica.Units.SI.AbsolutePressure p;
  algorithm
    p := reference_p * exp(-L/R * (1/T - 1/T_boil));
    annotation(smoothOrder(normallyConstant = T_boil, normallyConstant = L) = 100);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Vapour pressure according to the Clausius Clapeyron equation.</p>
<h2>Governing Equations</h2>
<pre>p := reference_p * exp(-L/R * (1/T - 1/T_boil));</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>-</td></tr>
<tr><td><code>L</code></td><td>Input signal</td><td>Modelica.Units.SI.MolarEnergy</td><td>J/mol</td><td>-</td></tr>
<tr><td><code>p</code></td><td>Output signal</td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td>-</td></tr>
</table>
</body>
</html>"));
end clausiusClapeyron;

  redeclare function extends temperature
  algorithm
    T := state.T;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Temperature calculation, evaluating <code>T</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>T := state.T;</pre>
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
end temperature;
  
  redeclare function extends pressure
  algorithm
    p := state.p;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Pressure calculation, evaluating <code>p</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>p := state.p;</pre>
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
end pressure;
  
  redeclare function extends massFraction
  algorithm
    Xi := state.Xi;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Mass Fraction calculation, evaluating <code>Xi</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>Xi := state.Xi;</pre>
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
end massFraction;

  redeclare function extends molarMass
  protected
    Modelica.Units.SI.MassFraction X[nX];
  algorithm
    X  := cat(1, state.Xi, {1-sum(state.Xi)});
    MM := 1 / sum(X ./ MMX);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Molar Mass calculation, evaluating <code>X</code>, <code>MM</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X := cat(1, state.Xi, {1-sum(state.Xi)});
MM := 1 / sum(X ./ MMX);</pre>
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
end molarMass;


  redeclare function extends setState_pTX "Set state with pressure, temperature, composition"
  algorithm
    state.p := p;
    state.T := T;
    state.Xi := X[1:nXi];
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Set state with pressure, temperature, composition.</p>
<h2>Governing Equations</h2>
<pre>state.p := p;
state.T := T;
state.Xi := X[1:nXi];</pre>
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
end setState_pTX;

  redeclare function extends setState_phX "Set state with pressure, enthalpy, composition"
  protected
    function h_offset "Solve h = specificEnthalpy_pTX(p, T, X) for T with given h"
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input AbsolutePressure p "Pressure";
      input SpecificEnthalpy h "Specific enthalpy";
      input MassFraction X[:] "Mass fractions of composition";
    algorithm
      y := specificEnthalpy_pTX(p, u, X) - h;
      annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Solve h = specificEnthalpy_pTX(p, T, X) for T with given h.</p>
<h2>Governing Equations</h2>
<pre>y := specificEnthalpy_pTX(p, u, X) - h;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Pressure</td></tr>
<tr><td><code>h</code></td><td>Specific enthalpy</td></tr>
<tr><td><code>X</code></td><td>Mass fractions of composition</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Input signal</td><td>AbsolutePressure</td><td>Pa</td><td>Pressure</td></tr>
<tr><td><code>h</code></td><td>Input signal</td><td>SpecificEnthalpy</td><td>J/kg</td><td>Specific enthalpy</td></tr>
<tr><td><code>X</code></td><td>Input signal</td><td>MassFraction[:]</td><td>1</td><td>Mass fractions of composition</td></tr>
</table>
</body>
</html>"));
end h_offset;
    
    Modelica.Units.SI.Temperature T_min = 273;
    Modelica.Units.SI.Temperature T_max = 500;
    Integer counter = 0 "Keep track of how many times we widened the window";
  algorithm
    state.p := p;
    state.Xi := X[1:nXi];
// Debugging code,
/*if h_offset(T_min, p, h, X)*h_offset(T_max, p, h, X) >= 0 then
      Modelica.Utilities.Streams.print("Same-sign error in setState_phX");
      Modelica.Utilities.Streams.print("p="+String(p)+", h="+String(h));
      for i in 1:nXi loop
        Modelica.Utilities.Streams.print("X["+String(i)+"]="+String(X[i]));
      end for;
    end if;*/
    while h_offset(T_min, p, h, X)*h_offset(T_max, p, h, X) >= 0 and counter < 20 loop
      T_min := T_min/1.1;
      T_max := T_max*1.1;
      counter := counter + 1;
    end while;
    state.T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function h_offset(p=p, h=h, X=X), u_min = T_min, u_max = T_max);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Set state with pressure, enthalpy, composition.</p>
<h2>Governing Equations</h2>
<pre>T_min = 273;
T_max = 500;
counter = 0;
state.p := p;
state.Xi := X[1:nXi];
while h_offset(T_min, p, h, X)*h_offset(T_max, p, h, X) &gt;= 0 and counter &lt; 20 loop T_min := T_min/1.1;
T_max := T_max*1.1;
counter := counter + 1;
end while;
state.T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function h_offset(p=p, h=h, X=X), u_min = T_min, u_max = T_max);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>counter</code></td><td>Keep track of how many times we widened the window</td></tr>
</table>
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
end setState_phX;


  replaceable function flashVaporisation
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MoleFraction Xmol[nX] "Mole Fractions";
    input Real iK[nX] "Inverted equilibrium constants, XL[i] = iK[i]*XG[i]";
    output Real beta_mol "Generalised gas fraction";
  protected
    Real beta_max "Upper bound for Rachford-Rice";
    Real beta_min "Lower bound for Rachford-Rice";
    Real beta_eps "Numerical assistance";

    function rachford_rice
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input Modelica.Units.SI.MoleFraction Xmol[nX] "Mole Fractions";
      input Real iK[nX] "Inverted equilibrium constants";
    algorithm
      y := sum({Xmol[i]*(1-iK[i])/(iK[i] + u*(1-iK[i])) for i in 1:nX});
      annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Rachford rice calculation, evaluating <code>y</code> from <code>Xmol</code> (Mole Fractions), <code>iK</code> (Inverted equilibrium constants). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>y := sum({Xmol[i]*(1-iK[i])/(iK[i] + u*(1-iK[i])) for i in 1:nX});</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>Xmol</code></td><td>Mole Fractions</td></tr>
<tr><td><code>iK</code></td><td>Inverted equilibrium constants</td></tr>
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
<tr><td><code>iK</code></td><td>Input signal</td><td>Real[nX]</td><td>1</td><td>Inverted equilibrium constants</td></tr>
</table>
</body>
</html>"));
end rachford_rice;
  
  algorithm
    beta_max := max(iK)/(max(iK)-1);
    beta_min := min(iK)/(min(iK)-1);
    beta_eps := 1E-9*(beta_max - beta_min);
    beta_mol := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function rachford_rice(Xmol=Xmol, iK=iK), u_min = beta_min+beta_eps, u_max = beta_max-beta_eps);
    annotation(derivative = flashVaporisation_der);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Flash Vaporisation calculation, evaluating <code>beta_mol</code> from <code>Xmol</code> (Mole Fractions), <code>iK</code> (Inverted equilibrium constants, XL[i] = iK[i]*XG[i]). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>beta_max := max(iK)/(max(iK)-1);
beta_min := min(iK)/(min(iK)-1);
beta_eps := 1E-9*(beta_max - beta_min);
beta_mol := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function rachford_rice(Xmol=Xmol, iK=iK), u_min = beta_min+beta_eps, u_max = beta_max-beta_eps);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>Xmol</code></td><td>Mole Fractions</td></tr>
<tr><td><code>iK</code></td><td>Inverted equilibrium constants, XL[i] = iK[i]*XG[i]</td></tr>
<tr><td><code>beta_mol</code></td><td>Generalised gas fraction</td></tr>
<tr><td><code>beta_max</code></td><td>Upper bound for Rachford-Rice</td></tr>
<tr><td><code>beta_min</code></td><td>Lower bound for Rachford-Rice</td></tr>
<tr><td><code>beta_eps</code></td><td>Numerical assistance</td></tr>
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
  
  replaceable function flashVaporisation_der
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.MoleFraction Xmol[nX];
    input Real iK[nX];
    input Real dXmol[nX];
    input Real diK[nX];
    output Real dbeta_mol;
  protected
    Real beta_mol = flashVaporisation(Xmol, iK);
    Real D[nX] = {iK[i] + beta_mol*(1-iK[i]) for i in 1:nX} "Convenience variable";
    Real S = sum(Xmol[i]*(1-iK[i])^2/D[i]^2 for i in 1:nX) "Convenience variable";
  algorithm
    dbeta_mol := (sum((1-iK[i])/D[i]*dXmol[i] - Xmol[i]/D[i]^2*diK[i] for i in 1:nX)) / S;
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Differential of the Rachford-Rice relation for flash equilibria:<div>h(β) = Σ<sub>i</sub> z<sub>i</sub>/(iK<sub>i</sub>+β(1-iK<sub>i</sub>) = 0</div><div><br></div><div>Having defined the convenience variables:</div><div>D<sub>i</sub>=iK<sub>i</sub>+β(1-iK<sub>i</sub>)</div><div>S = Σ<sub>i</sub> (1-iK<sub>i</sub>)<sup>2</sup>z<sub>i</sub>/D<sub>i</sub></div><div><sub><br></sub></div><div>The differential is then dβ = Σ<sub>i</sub>(1-iK<sub>i</sub>)/(S*D<sub>i</sub>) dz<sub>i</sub> - z<sub>i</sub>/(S*D<sub>i</sub><sup>2</sup>) diK<sub>i</sub></div><div><sub><br></sub></div><div>If you need to verify this, either find pen and paper, or use Maxima and enter <pre>diff( z*(1-iK)/(iK+b*(1-iK)));</pre></div>
<h2>Governing Equations</h2>
<pre>beta_mol = flashVaporisation(Xmol, iK);
D[nX] = {iK[i] + beta_mol*(1-iK[i]) for i in 1:nX};
S = sum(Xmol[i]*(1-iK[i])^2/D[i]^2 for i in 1:nX);
dbeta_mol := (sum((1-iK[i])/D[i]*dXmol[i] - Xmol[i]/D[i]^2*diK[i] for i in 1:nX)) / S;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>D</code></td><td>Convenience variable</td></tr>
<tr><td><code>S</code></td><td>Convenience variable</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>Xmol</code></td><td>Input signal</td><td>Modelica.Units.SI.MoleFraction[nX]</td><td>1</td><td>-</td></tr>
<tr><td><code>iK</code></td><td>Input signal</td><td>Real[nX]</td><td>1</td><td>-</td></tr>
<tr><td><code>dXmol</code></td><td>Input signal</td><td>Real[nX]</td><td>1</td><td>-</td></tr>
<tr><td><code>diK</code></td><td>Input signal</td><td>Real[nX]</td><td>1</td><td>-</td></tr>
<tr><td><code>dbeta_mol</code></td><td>Output signal</td><td>Real</td><td>1</td><td>-</td></tr>
</table>
</body>
</html>"));
end flashVaporisation_der;

  function vaporisationRatio
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MassFraction beta_mass;
  protected
    Modelica.Units.SI.MoleFraction[nX] Xmol = massToMoleFractions(cat(1, state.Xi, {1-sum(state.Xi)}));
    Real iK[nX] = invertedKs(state);
    Real beta_mol = flashVaporisation(Xmol, iK);
    Modelica.Units.SI.MoleFraction[nX] Xmol_gas;
    Modelica.Units.SI.MolarMass MM_gas "Molar mass for gas phase";
  algorithm
    if beta_mol <= 0 then
      beta_mass := 0;
    elseif beta_mol >= 1 then
      beta_mass := 1;
    else
      Xmol_gas := gasMolarFractions(beta_mol, Xmol, iK);
      MM_gas := Xmol_gas*MMX;
      beta_mass := beta_mol * MM_gas/molarMass(state);
    end if;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Vaporisation Ratio calculation, evaluating <code>beta_mass</code> from <code>state</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>Xmol[nX] = massToMoleFractions(cat(1, state.Xi, {1-sum(state.Xi)}));
iK[nX] = invertedKs(state);
beta_mol = flashVaporisation(Xmol, iK);
if beta_mol &lt;= 0 then beta_mass := 0;
elseif beta_mol &gt;= 1 then beta_mass := 1;
else Xmol_gas := gasMolarFractions(beta_mol, Xmol, iK);
MM_gas := Xmol_gas*MMX;
beta_mass := beta_mol * MM_gas/molarMass(state);
end if;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>MM_gas</code></td><td>Molar mass for gas phase</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>-</td></tr>
<tr><td><code>beta_mass</code></td><td>Output signal</td><td>Modelica.Units.SI.MassFraction</td><td>1</td><td>-</td></tr>
</table>
</body>
</html>"));
end vaporisationRatio;


  partial function invertedKs "Inverted equilibrium constants"
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Real iK[nX](each min=0.0);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Inverted equilibrium constants.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Function</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>-</td></tr>
<tr><td><code>iK</code></td><td>Output signal</td><td>Real[nX]</td><td>1</td><td>-</td></tr>
</table>
</body>
</html>"));
end invertedKs;


  function gasMolarFractions
    extends Modelica.Icons.Function;
    import Modelica.Constants.eps;
    input Real beta_mol "Generalised vaporisation ratio";
    input Modelica.Units.SI.MoleFraction[nX] Xmol "Overall molar compositions";
    input Real[nX] iK "Inverted equilibrium constants";
    output Modelica.Units.SI.MoleFraction[nX] Xmol_gas "Gas molar compositions";
  protected
    Modelica.Units.SI.MoleFraction beta_real = min(max(beta_mol, 0.0), 1.0) "Physically true vaporisation ratio";
  algorithm
    Xmol_gas := {Xmol[i] / max(iK[i] + beta_real*(1.0 - iK[i]), eps) for i in 1:nX};
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Given a generalised molar vaporisation ratio β, molar fractions X<sub>mol</sub>&nbsp;and inverted equilibrium constants iK, the function returns the corresponding molar fractions in the gas phase.<div>Note that, if β≥1 (i.e. only gas), the gas concentrations are simply the overall ones.</div><div><br></div><div>The case of β≤0 is a bit more thorny since no gas phase exist, and the gas fractions do not have a physical meaning, but must be defined nevertheless to ensure continuity of variables.</div><div>The main problem occurs when β=0, since the denominator of the main formula would collapse to zero for all incondensables, which already have iK=0 by definition of incondensables. Of course there cannot be incondensables present if β=0, but 0/0 would still produce an error.</div>
<h2>Governing Equations</h2>
<pre>if beta_mol &gt;= 1 then Xmol_gas := Xmol;
elseif abs(beta_mol) &lt; eps then // If both iK and beta_mol = 0, I get a division by zero with the general formula // beta = 0 means only liquid, so Xmol=0 for all non-condensables Xmol_gas := {if iK[i] &gt; eps then Xmol[i]/(iK[i] + beta_mol*(1.0.-iK[i])) else 0.0 for i in 1:nX};
else Xmol_gas := Xmol ./ (iK + beta_mol*(1.0.-iK));
end if;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>beta_mol</code></td><td>Generalised vaporisation ratio</td></tr>
<tr><td><code>Xmol</code></td><td>Overall molar compositions</td></tr>
<tr><td><code>iK</code></td><td>Inverted equilibrium constants</td></tr>
<tr><td><code>Xmol_gas</code></td><td>Gas molar compositions</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>beta_mol</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Generalised vaporisation ratio</td></tr>
<tr><td><code>Xmol</code></td><td>Input signal</td><td>Modelica.Units.SI.MoleFraction[nX]</td><td>1</td><td>Overall molar compositions</td></tr>
<tr><td><code>iK</code></td><td>Input signal</td><td>Real[nX]</td><td>1</td><td>Inverted equilibrium constants</td></tr>
<tr><td><code>Xmol_gas</code></td><td>Output signal</td><td>Modelica.Units.SI.MoleFraction[nX]</td><td>1</td><td>Gas molar compositions</td></tr>
</table>
</body>
</html>"));
end gasMolarFractions;
  
  function liquidMolarFractions
    extends Modelica.Icons.Function;
    import Modelica.Constants.eps;
    input Real beta_mol "Generalised vaporisation ratio";
    input Modelica.Units.SI.MoleFraction[nX] Xmol "Overall molar compositions";
    input Real[nX] iK "Inverted equilibrium constants";
    output Modelica.Units.SI.MoleFraction[nX] Xmol_liq "Liquid molar compositions";
  protected
    Modelica.Units.SI.MoleFraction beta_real = min(max(beta_mol, 0.0), 1.0) "Physically true vaporisation ratio";
  algorithm
    Xmol_liq :=  {iK[i]*(Xmol[i] + eps) / max(iK[i] + beta_real*(1.0 - iK[i]), eps) for i in 1:nX};
    Xmol_liq := Xmol_liq / sum(Xmol_liq);
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Given a generalised molar vaporisation ratio β, molar fractions X<sub>mol</sub> and inverted equilibrium constants iK, the function returns the corresponding molar fractions in the liquid phase.<div>Note that, if β≤0 (i.e. only liquid), the liquid concentrations are simply the overall ones.</div><div><br></div><div>The case of β≥1 is a bit more thorny since no liquid phase exist, and the liquid fractions do not have a physical meaning, but must be defined nevertheless to ensure continuity of variables.</div><div>The algorithm first attempts to use iK*X<sub>mol</sub>&nbsp;as the composition of the first droplet to form, but before normalising by dividing by Σ iK*X<sub>mol</sub>, it checks whether the array is zero: this happens in corner cases such as dry air. In that case, it assumes a liquid composition of iK/Σ iK, which is the limit for the overall fractions of all condensable species tending to zero at the same rate.</div>
<h2>Governing Equations</h2>
<pre>if beta_mol &gt;= 1 then Xmol_liq := iK.*Xmol;
if max(Xmol_liq) &lt; eps then Xmol_liq := iK / sum(iK) &quot;Handle corner case with no condensables in mixture&quot;;
else Xmol_liq := Xmol_liq / sum(Xmol_liq) &quot;Normalise if we know it is nonzero&quot;;
end if;
elseif beta_mol &lt;= 0 then Xmol_liq := Xmol;
else Xmol_liq := (iK.*Xmol) ./ (iK + beta_mol*(1.0.-iK));
end if;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>beta_mol</code></td><td>Generalised vaporisation ratio</td></tr>
<tr><td><code>Xmol</code></td><td>Overall molar compositions</td></tr>
<tr><td><code>iK</code></td><td>Inverted equilibrium constants</td></tr>
<tr><td><code>Xmol_liq</code></td><td>Liquid molar compositions</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>beta_mol</code></td><td>Input signal</td><td>Real</td><td>1</td><td>Generalised vaporisation ratio</td></tr>
<tr><td><code>Xmol</code></td><td>Input signal</td><td>Modelica.Units.SI.MoleFraction[nX]</td><td>1</td><td>Overall molar compositions</td></tr>
<tr><td><code>iK</code></td><td>Input signal</td><td>Real[nX]</td><td>1</td><td>Inverted equilibrium constants</td></tr>
<tr><td><code>Xmol_liq</code></td><td>Output signal</td><td>Modelica.Units.SI.MoleFraction[nX]</td><td>1</td><td>Liquid molar compositions</td></tr>
</table>
</body>
</html>"));
end liquidMolarFractions;


  function gasConstant "Gas constant for the gas phase"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.SpecificHeatCapacity R_s "Gas constant of the gas phase";
  protected
    import Modelica.Constants.R;
    Real iK[nX] = invertedKs(state) "Inverted equilibrium constants";
    Modelica.Units.SI.MoleFraction Xmol[nX] = massToMoleFractions(cat(1, state.Xi, {1-sum(state.Xi)})) "Molar fractions";
    Real beta_mol = flashVaporisation(Xmol, iK) "Generalised vaporisation ratio";
    Modelica.Units.SI.MoleFraction[nX] Xmol_gas = gasMolarFractions(beta_mol, Xmol, iK) "Molar fractions in gas phase";
    Modelica.Units.SI.MolarMass MM_gas = MMX*Xmol_gas "Average molar mass of gas phase";
  algorithm
    R_s := R / MM_gas;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas constant for the gas phase.</p>
<h2>Governing Equations</h2>
<pre>iK[nX] = invertedKs(state);
Xmol[nX] = massToMoleFractions(cat(1, state.Xi, {1-sum(state.Xi)}));
beta_mol = flashVaporisation(Xmol, iK);
Xmol_gas[nX] = gasMolarFractions(beta_mol, Xmol, iK);
MM_gas = MMX*Xmol_gas;
R_s := R / MM_gas;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Thermodynamic state record</td></tr>
<tr><td><code>R_s</code></td><td>Gas constant of the gas phase</td></tr>
<tr><td><code>iK</code></td><td>Inverted equilibrium constants</td></tr>
<tr><td><code>Xmol</code></td><td>Molar fractions</td></tr>
<tr><td><code>beta_mol</code></td><td>Generalised vaporisation ratio</td></tr>
<tr><td><code>Xmol_gas</code></td><td>Molar fractions in gas phase</td></tr>
<tr><td><code>MM_gas</code></td><td>Average molar mass of gas phase</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>Thermodynamic state record</td></tr>
<tr><td><code>R_s</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>Gas constant of the gas phase</td></tr>
</table>
</body>
</html>"));
end gasConstant;

  
  function flashEquilibrium
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MassFraction beta;
    output ThermodynamicState state_gas;
    output ThermodynamicState state_liq;
  protected
    Real iK[nX] = invertedKs(state);
    Modelica.Units.SI.MoleFraction Xmol[nX] = massToMoleFractions(cat(1, state.Xi, {1 - sum(state.Xi)}));
    Real beta_mol = flashVaporisation(Xmol, iK);
    Modelica.Units.SI.MoleFraction Xmol_gas[nX] = gasMolarFractions(beta_mol, Xmol, iK);
    Modelica.Units.SI.MoleFraction Xmol_liq[nX] = liquidMolarFractions(beta_mol, Xmol, iK);
    Modelica.Units.SI.MolarMass MM_gas = MMX*Xmol_gas;
    Modelica.Units.SI.MassFraction X_gas[nX] = moleToMassFractions(Xmol_gas);
    Modelica.Units.SI.MassFraction X_liq[nX] = moleToMassFractions(Xmol_liq);
  algorithm
    beta := max(0.0, min(1.0, beta_mol * MM_gas/molarMass(state)));
    state_gas := ThermodynamicState(state.p, state.T, X_gas[1:nXi]);
    state_liq := ThermodynamicState(state.p, state.T, X_liq[1:nXi]);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Flash Equilibrium calculation, evaluating <code>beta</code>, <code>state_gas</code>, <code>state_liq</code> from <code>state</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>iK[nX] = invertedKs(state);
Xmol[nX] = massToMoleFractions(cat(1, state.Xi, {1 - sum(state.Xi)}));
beta_mol = flashVaporisation(Xmol, iK);
Xmol_gas[nX] = gasMolarFractions(beta_mol, Xmol, iK);
Xmol_liq[nX] = liquidMolarFractions(beta_mol, Xmol, iK);
MM_gas = MMX*Xmol_gas;
X_gas[nX] = moleToMassFractions(Xmol_gas);
X_liq[nX] = moleToMassFractions(Xmol_liq);
beta := max(0.0, min(1.0, beta_mol * MM_gas/molarMass(state)));
state_gas := ThermodynamicState(state.p, state.T, X_gas[1:nXi]);
state_liq := ThermodynamicState(state.p, state.T, X_liq[1:nXi]);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>-</td></tr>
<tr><td><code>beta</code></td><td>Output signal</td><td>Modelica.Units.SI.MassFraction</td><td>1</td><td>-</td></tr>
<tr><td><code>state_gas</code></td><td>Output signal</td><td>ThermodynamicState</td><td>-</td><td>-</td></tr>
<tr><td><code>state_liq</code></td><td>Output signal</td><td>ThermodynamicState</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end flashEquilibrium;


  partial function gasSpecificHeatCapacityCp
    extends Modelica.Icons.Function;
    input ThermodynamicState state_gas "State of the gas phase, with gas compositions";
    output Modelica.Units.SI.SpecificHeatCapacity cp_gas;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas Specific Heat Capacity Cp calculation, evaluating <code>cp_gas</code> from <code>state_gas</code> (State of the gas phase, with gas compositions). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Function</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state_gas</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>State of the gas phase, with gas compositions</td></tr>
<tr><td><code>cp_gas</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>-</td></tr>
</table>
</body>
</html>"));
end gasSpecificHeatCapacityCp;
  
  partial function liquidSpecificHeatCapacityCp
    extends Modelica.Icons.Function;
    input ThermodynamicState state_liq "State of the liquid phase, with liquid compositions";
    output Modelica.Units.SI.SpecificHeatCapacity cp_liq;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Liquid Specific Heat Capacity Cp calculation, evaluating <code>cp_liq</code> from <code>state_liq</code> (State of the liquid phase, with liquid compositions). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Function</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state_liq</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>State of the liquid phase, with liquid compositions</td></tr>
<tr><td><code>cp_liq</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>-</td></tr>
</table>
</body>
</html>"));
end liquidSpecificHeatCapacityCp;
  
  redeclare function extends specificHeatCapacityCp
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    cp := beta*gasSpecificHeatCapacityCp(state_gas) + (1-beta)*liquidSpecificHeatCapacityCp(state_liq);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Heat Capacity Cp calculation, evaluating <code>cp</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>(beta, state_gas, state_liq) := flashEquilibrium(state);
cp := beta*gasSpecificHeatCapacityCp(state_gas) + (1-beta)*liquidSpecificHeatCapacityCp(state_liq);</pre>
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
end specificHeatCapacityCp;
  
  redeclare function extends specificHeatCapacityCv
    import Modelica.Constants.R;
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
    Modelica.Units.SI.MolarMass MM_gas;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    MM_gas := MMX*massToMoleFractions(cat(1, state_gas.Xi, {1-sum(state_gas.Xi)}));
    cv := beta*(gasSpecificHeatCapacityCp(state_gas)-R/MM_gas) + (1-beta)*liquidSpecificHeatCapacityCp(state_liq);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Heat Capacity Cv calculation, evaluating <code>MM_gas</code>, <code>cv</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>(beta, state_gas, state_liq) := flashEquilibrium(state);
MM_gas := MMX*massToMoleFractions(cat(1, state_gas.Xi, {1-sum(state_gas.Xi)}));
cv := beta*(gasSpecificHeatCapacityCp(state_gas)-R/MM_gas) + (1-beta)*liquidSpecificHeatCapacityCp(state_liq);</pre>
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
end specificHeatCapacityCv;


  partial function gasSpecificEnthalpy
    extends Modelica.Icons.Function;
    input ThermodynamicState state_gas "State of the gas phase, with gas compositions";
    output Modelica.Units.SI.SpecificEnthalpy h_gas;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas Specific Enthalpy calculation, evaluating <code>h_gas</code> from <code>state_gas</code> (State of the gas phase, with gas compositions). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Function</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state_gas</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>State of the gas phase, with gas compositions</td></tr>
<tr><td><code>h_gas</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificEnthalpy</td><td>J/kg</td><td>-</td></tr>
</table>
</body>
</html>"));
end gasSpecificEnthalpy;

  partial function liquidSpecificEnthalpy
    extends Modelica.Icons.Function;
    input ThermodynamicState state_liq "State of the liquid phase, with liquid compositions";
    output Modelica.Units.SI.SpecificEnthalpy h_liq;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Liquid Specific Enthalpy calculation, evaluating <code>h_liq</code> from <code>state_liq</code> (State of the liquid phase, with liquid compositions). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Function</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state_liq</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>State of the liquid phase, with liquid compositions</td></tr>
<tr><td><code>h_liq</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificEnthalpy</td><td>J/kg</td><td>-</td></tr>
</table>
</body>
</html>"));
end liquidSpecificEnthalpy;
  
  redeclare function extends specificEnthalpy
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    h := beta*gasSpecificEnthalpy(state_gas) + (1-beta)*liquidSpecificEnthalpy(state_liq);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Enthalpy calculation, evaluating <code>h</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>(beta, state_gas, state_liq) := flashEquilibrium(state);
h := beta*gasSpecificEnthalpy(state_gas) + (1-beta)*liquidSpecificEnthalpy(state_liq);</pre>
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
end specificEnthalpy;


  partial function gasSpecificEntropy
    extends Modelica.Icons.Function;
    input ThermodynamicState state_gas "State of the gas phase, with gas compositions";
    output Modelica.Units.SI.SpecificEntropy s_gas;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas Specific Entropy calculation, evaluating <code>s_gas</code> from <code>state_gas</code> (State of the gas phase, with gas compositions). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Function</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state_gas</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>State of the gas phase, with gas compositions</td></tr>
<tr><td><code>s_gas</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificEntropy</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end gasSpecificEntropy;

  partial function liquidSpecificEntropy
    extends Modelica.Icons.Function;
    input ThermodynamicState state_liq "State of the liquid phase, with liquid compositions";
    output Modelica.Units.SI.SpecificEntropy s_liq;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Liquid Specific Entropy calculation, evaluating <code>s_liq</code> from <code>state_liq</code> (State of the liquid phase, with liquid compositions). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Function</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state_liq</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>State of the liquid phase, with liquid compositions</td></tr>
<tr><td><code>s_liq</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificEntropy</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end liquidSpecificEntropy;
  
  redeclare function extends specificEntropy
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    s := beta*gasSpecificEntropy(state_gas) + (1-beta)*liquidSpecificEntropy(state_liq);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Entropy calculation, evaluating <code>s</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>(beta, state_gas, state_liq) := flashEquilibrium(state);
s := beta*gasSpecificEntropy(state_gas) + (1-beta)*liquidSpecificEntropy(state_liq);</pre>
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
end specificEntropy;


  partial function gasDensity
    extends Modelica.Icons.Function;
    input ThermodynamicState state_gas "State of the gas phase, with gas compositions";
    output Modelica.Units.SI.Density d_gas;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas Density calculation, evaluating <code>d_gas</code> from <code>state_gas</code> (State of the gas phase, with gas compositions). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Function</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state_gas</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>State of the gas phase, with gas compositions</td></tr>
<tr><td><code>d_gas</code></td><td>Output signal</td><td>Modelica.Units.SI.Density</td><td>kg/m3</td><td>-</td></tr>
</table>
</body>
</html>"));
end gasDensity;

  partial function liquidDensity
    extends Modelica.Icons.Function;
    input ThermodynamicState state_liq "State of the liquid phase, with liquid compositions";
    output Modelica.Units.SI.Density d_liq;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Liquid Density calculation, evaluating <code>d_liq</code> from <code>state_liq</code> (State of the liquid phase, with liquid compositions). The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<p>The behavior is defined by <code>Modelica.Icons.Function</code>.</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>state_liq</code></td><td>Input signal</td><td>ThermodynamicState</td><td>-</td><td>State of the liquid phase, with liquid compositions</td></tr>
<tr><td><code>d_liq</code></td><td>Output signal</td><td>Modelica.Units.SI.Density</td><td>kg/m3</td><td>-</td></tr>
</table>
</body>
</html>"));
end liquidDensity;

  redeclare function extends density
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    d := 1/(beta/gasDensity(state_gas) + (1-beta)/liquidDensity(state_liq));
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Density calculation, evaluating <code>d</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>(beta, state_gas, state_liq) := flashEquilibrium(state);
d := 1/(beta/gasDensity(state_gas) + (1-beta)/liquidDensity(state_liq));</pre>
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
end density;


  redeclare function extends specificInternalEnergy
  protected
    Modelica.Units.SI.MassFraction beta;
    ThermodynamicState state_gas;
    ThermodynamicState state_liq;
  algorithm
    (beta, state_gas, state_liq) := flashEquilibrium(state);
    u := specificEnthalpy(state) - state.p*(beta/gasDensity(state_gas) + (1-beta)/liquidDensity(state_liq));
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Internal Energy calculation, evaluating <code>u</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>(beta, state_gas, state_liq) := flashEquilibrium(state);
u := specificEnthalpy(state) - state.p*(beta/gasDensity(state_gas) + (1-beta)/liquidDensity(state_liq));</pre>
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
end specificInternalEnergy;


  redeclare function extends isentropicEnthalpy
  protected
    Modelica.Units.SI.SpecificEntropy s_ref = specificEntropy(refState);

    function s_offset "Find offset from isentropic conditions, u is T_out"
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input Modelica.Units.SI.SpecificEntropy s_in;
      input Modelica.Units.SI.Pressure p_out;
      input Modelica.Units.SI.MassFraction[nXi] Xi;
    algorithm
      y := specificEntropy(setState_pTX(p_out, u, Xi)) - s_in;
      annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Find offset from isentropic conditions, u is T_out.</p>
<h2>Governing Equations</h2>
<pre>y := specificEntropy(setState_pTX(p_out, u, Xi)) - s_in;</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>s_in</code></td><td>Input signal</td><td>Modelica.Units.SI.SpecificEntropy</td><td>-</td><td>-</td></tr>
<tr><td><code>p_out</code></td><td>Input signal</td><td>Modelica.Units.SI.Pressure</td><td>Pa</td><td>-</td></tr>
<tr><td><code>Xi</code></td><td>Input signal</td><td>Modelica.Units.SI.MassFraction[nXi]</td><td>1</td><td>-</td></tr>
</table>
</body>
</html>"));
end s_offset;

    Modelica.Units.SI.Temperature T_is "Temperature after isentropic change of pressure";
  algorithm
    T_is := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function s_offset(s_in=s_ref, p_out=p_downstream, Xi=refState.Xi), u_min = 200, u_max = 1000);
    h_is := specificEnthalpy(setState_pTX(p_downstream, T_is, refState.Xi));
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Isentropic Enthalpy calculation, evaluating <code>T_is</code>, <code>h_is</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>s_ref = specificEntropy(refState);
T_is := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function s_offset(s_in=s_ref, p_out=p_downstream, Xi=refState.Xi), u_min = 200, u_max = 1000);
h_is := specificEnthalpy(setState_pTX(p_downstream, T_is, refState.Xi));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>T_is</code></td><td>Temperature after isentropic change of pressure</td></tr>
</table>
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
end isentropicEnthalpy;


  redeclare function extends setSmoothState "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(
          p=Modelica.Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
          T=Modelica.Media.Common.smoothStep(x, state_a.T, state_b.T, x_small),
          Xi=Modelica.Media.Common.smoothStep(x, state_a.Xi, state_b.Xi, x_small));
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Return thermodynamic state so that it smoothly approximates: if x &gt; 0 then state_a else state_b.</p>
<h2>Governing Equations</h2>
<pre>state := ThermodynamicState( p=Modelica.Media.Common.smoothStep(x, state_a.p, state_b.p, x_small), T=Modelica.Media.Common.smoothStep(x, state_a.T, state_b.T, x_small), Xi=Modelica.Media.Common.smoothStep(x, state_a.Xi, state_b.Xi, x_small));</pre>
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
end setSmoothState;

  annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Partial medium model for a gas/liquid mixture described by pressure, temperature, and independent mass fractions. Phase equilibrium is calculated with inverted equilibrium constants and a Rachford-Rice flash fraction. Gas and liquid compositions are converted between mole and mass fractions, and bulk density, enthalpy, and internal energy are obtained by phase-weighted mixing. Concrete media must supply saturation, density, and caloric property functions. The pTX state representation does not resolve the non-unique phase fraction at a pure substance's boiling point.</p>
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
end PartialCondensingMixture;
