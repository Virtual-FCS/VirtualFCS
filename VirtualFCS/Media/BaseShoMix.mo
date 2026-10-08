within VirtualFCS.Media;

partial package BaseShoMix
  
  extends Modelica.Media.Interfaces.PartialMedium(
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pTX,
      
      final singleState = false,
      final reducedX = true,
      final fixedX = false);
  
  replaceable constant Shomate.Parameters[nX+1] sh_params;
  replaceable constant Modelica.Units.SI.MolarMass MMX[nX] "Molar weights of the medium species";
  replaceable constant Modelica.Units.SI.Temperature T_boil "Boiling temperature at atmospheric pressure of the condensing phase";
  replaceable constant Modelica.Units.SI.MolarEnergy L "Latent heat of condensing phase";
    
  redeclare record extends ThermodynamicState "Thermodynamic state variables"
    extends Modelica.Icons.Record;
    /* To keep things simple, we assume that pTX is a sufficient representation of the thermodynamic state.
     * Strictly speaking, it isn't, since there are corner cases like water at 0 or 100 C.
     * If we were to handle these cases correctly we should use h instead of T, but then we need to invert h(T).
     * Since pure freezing or boiling water is an extremely rare case in fuel cells, we use the more convenient option.
     */
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
    MassFraction[nXi] Xi(start = reference_X[1:nXi]) "Independent mass fractions";
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Thermodynamic state variables.</p>
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
<tr><td><code>p</code></td><td>Record field</td><td>AbsolutePressure</td><td>Pa</td><td>Absolute pressure of medium</td></tr>
<tr><td><code>T</code></td><td>Record field</td><td>Temperature</td><td>K</td><td>Temperature of medium</td></tr>
<tr><td><code>Xi</code></td><td>Record field</td><td>MassFraction[nXi]</td><td>1</td><td>Independent mass fractions</td></tr>
</table>
</body>
</html>"));
end ThermodynamicState;

  redeclare model extends BaseProperties(final standardOrderComponents = true) "Base properties of medium"
      Modelica.Units.SI.MoleFraction phi = relativeHumidity(state) "Relative humidity of gas phase";
      Modelica.Units.SI.MassFraction X_l = liquidMassFraction(state) "Mass fraction in liquid phase";
      Modelica.Units.SI.MassFraction Y[nX] = cat(1, Yi, {1-sum(Yi)}) "Full gas-phase compositions";
      Modelica.Units.SI.AbsolutePressure p_sat = saturationPressure(state.T, T_boil, L);
      Modelica.Units.SI.SpecificEnthalpy h_gas = enthalpyOfGas(state);
      Modelica.Units.SI.SpecificEnthalpy h_liq = enthalpyOfLiquid(state);
    protected
      Modelica.Units.SI.MassFraction Yi[nXi] = gasMassFraction(state) "Independent gas-phase compositions";
    equation
      d = density(state);
      h = specificEnthalpy(state);
      u = specificInternalEnergy(state);
      
      MM = molarMass(state); // Weighed average for all species, both phases
      R_s = gasConstant(state); // Gas constant valid only for gas phase

      state.p = p;
      state.T = T;
      state.Xi = Xi;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Calculates the medium&#x27;s bulk thermodynamic properties from pressure, temperature, and composition. The property bindings below define the gas/liquid mixture density, enthalpy, internal energy, and thermodynamic state used by connected fluid components.</p>
<h2>Governing Equations</h2>
<pre>extends BaseProperties(final standardOrderComponents = true);
phi = relativeHumidity(state);
X_l = liquidMassFraction(state);
Y[nX] = cat(1, Yi, {1-sum(Yi)});
p_sat = saturationPressure(state.T, T_boil, L);
h_gas = enthalpyOfGas(state);
h_liq = enthalpyOfLiquid(state);
Yi[nXi] = gasMassFraction(state);
d = density(state);
h = specificEnthalpy(state);
u = specificInternalEnergy(state);
MM = molarMass(state);
R_s = gasConstant(state);
state.p = p;
state.T = T;
state.Xi = Xi;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>phi</code></td><td>Relative humidity of gas phase</td></tr>
<tr><td><code>X_l</code></td><td>Mass fraction in liquid phase</td></tr>
<tr><td><code>Y</code></td><td>Full gas-phase compositions</td></tr>
<tr><td><code>Yi</code></td><td>Independent gas-phase compositions</td></tr>
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

  function saturationPressure "Vapour pressure of a species using Clausius-Clapeyron equaiton"
    extends Modelica.Icons.Function;
    import Modelica.Math.exp;
    import Modelica.Constants.R "J/(mol.K)";
    input Modelica.Units.SI.Temperature T "K";
    input Modelica.Units.SI.Temperature T_boil "(K) Boiling temperature at atmospheric pressure";
    input Modelica.Units.SI.MolarEnergy L "Latent heat (J/mol)";
    output Modelica.Units.SI.AbsolutePressure p;
    
    protected
    constant Modelica.Units.SI.AbsolutePressure p_ref = 1e5 "Reference pressure";
  
  algorithm
    p := p_ref * exp(-L/R * (1/T - 1/T_boil));
    annotation(
      derivative = saturationPressure_der);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Vapour pressure of a species using Clausius-Clapeyron equaiton.</p>
<h2>Governing Equations</h2>
<pre>p := p_ref * exp(-L/R * (1/T - 1/T_boil));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>K</td></tr>
<tr><td><code>T_boil</code></td><td>(K) Boiling temperature at atmospheric pressure</td></tr>
<tr><td><code>L</code></td><td>Latent heat (J/mol)</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>K</td></tr>
<tr><td><code>T_boil</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>(K) Boiling temperature at atmospheric pressure</td></tr>
<tr><td><code>L</code></td><td>Input signal</td><td>Modelica.Units.SI.MolarEnergy</td><td>J/mol</td><td>Latent heat (J/mol)</td></tr>
<tr><td><code>p</code></td><td>Output signal</td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td>-</td></tr>
</table>
</body>
</html>"));
end saturationPressure;

  function saturationPressure_der
    extends Modelica.Icons.Function;
    import Modelica.Math.exp;
    import Modelica.Constants.R "J/(mol.K)";
    input Modelica.Units.SI.Temperature T;
    input Modelica.Units.SI.Temperature T_boil "(K) Boiling temperature at atmospheric pressure";
    input Modelica.Units.SI.MolarEnergy L "Latent heat (J/mol)";
    input Modelica.Units.SI.TemperatureSlope dT;
    output Modelica.Units.SI.PressureSlope dp;
    
  protected
  constant Modelica.Units.SI.AbsolutePressure p_ref = 1e5 "Reference pressure";

    Modelica.Units.SI.Pressure p;
  
  algorithm
    p := p_ref * exp(-L/R * (1/T - 1/T_boil));
    dp := p*L/(R*T^2)*dT;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Saturation Pressure der calculation, evaluating <code>dp</code> from <code>T</code>, <code>T_boil</code> ((K) Boiling temperature at atmospheric pressure), <code>L</code> (Latent heat (J/mol)), <code>dT</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>p := p_ref * exp(-L/R * (1/T - 1/T_boil));
dp := p*L/(R*T^2)*dT;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>T_boil</code></td><td>(K) Boiling temperature at atmospheric pressure</td></tr>
<tr><td><code>L</code></td><td>Latent heat (J/mol)</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>-</td></tr>
<tr><td><code>T_boil</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>(K) Boiling temperature at atmospheric pressure</td></tr>
<tr><td><code>L</code></td><td>Input signal</td><td>Modelica.Units.SI.MolarEnergy</td><td>J/mol</td><td>Latent heat (J/mol)</td></tr>
<tr><td><code>dT</code></td><td>Input signal</td><td>Modelica.Units.SI.TemperatureSlope</td><td>-</td><td>-</td></tr>
<tr><td><code>dp</code></td><td>Output signal</td><td>Modelica.Units.SI.PressureSlope</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end saturationPressure_der;


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
  
  
  redeclare function extends molarMass
  protected
    Modelica.Units.SI.MolarMass X[nX];
  algorithm
    X := cat(1, state.Xi, {1-sum(state.Xi)});
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

  redeclare function extends setState_phX "Set state with pressure, enthalpy, composition"
  protected
    function h_offset "Solve h = specificEnthalpy_pTX(p, T, X) for T with given h"
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input AbsolutePressure p "Pressure";
      input SpecificEnthalpy h "Specific enthalpy";
      input MassFraction[:] X "Mass fractions of composition";
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
  algorithm
    state.p := p;
    state.Xi := X[1:nXi];
    state.T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function h_offset(p=p, h=h, X=X), u_min = 273.15, u_max = 1000);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Set state with pressure, enthalpy, composition.</p>
<h2>Governing Equations</h2>
<pre>state.p := p;
state.Xi := X[1:nXi];
state.T := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function h_offset(p=p, h=h, X=X), u_min = 273.15, u_max = 1000);</pre>
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
  
  
  function liquidMassFraction "Fraction of mass in liquid phase, assumed only water."
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.MassFraction X_l "Mass fraction in liquid phase";
    protected

    algorithm
    X_l := max(0.0, (1-sum(state.Xi)) - MMX[nX]/molarMass(state)*saturationPressure(state.T, T_boil, L)/state.p);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Fraction of mass in liquid phase, assumed only water..</p>
<h2>Governing Equations</h2>
<pre>X_l := max(0.0, (1-sum(state.Xi)) - MMX[nX]/molarMass(state)*saturationPressure(state.T, T_boil, L)/state.p);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Thermodynamic state record</td></tr>
<tr><td><code>X_l</code></td><td>Mass fraction in liquid phase</td></tr>
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
<tr><td><code>X_l</code></td><td>Output signal</td><td>Modelica.Units.SI.MassFraction</td><td>1</td><td>Mass fraction in liquid phase</td></tr>
</table>
</body>
</html>"));
end liquidMassFraction;


function gasMassFraction "Independent mass fractions in gas phase"
  extends Modelica.Icons.Function;
  input ThermodynamicState state "Thermodynamic state record";
  output Modelica.Units.SI.MassFraction[nXi] Yi "Mass fractions in gas phase";
  protected
  Real denom;
algorithm
  denom := 1-liquidMassFraction(state);
  assert(denom > 1e-8, "Gas phase vanished → model invalid");
  Yi := state.Xi[1:nXi] / denom;
  
  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Independent mass fractions in gas phase.</p>
<h2>Governing Equations</h2>
<pre>denom := 1-liquidMassFraction(state);
assert(denom &gt; 1e-8, &quot;Gas phase vanished → model invalid&quot;);
Yi := state.Xi[1:nXi] / denom;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Thermodynamic state record</td></tr>
<tr><td><code>Yi</code></td><td>Mass fractions in gas phase</td></tr>
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
<tr><td><code>Yi</code></td><td>Output signal</td><td>Modelica.Units.SI.MassFraction[nXi]</td><td>1</td><td>Mass fractions in gas phase</td></tr>
</table>
</body>
</html>"));
end gasMassFraction;



function gasConstant "Gas constant for the gas phase"
  extends Modelica.Icons.Function;
  input ThermodynamicState state "Thermodynamic state record";
  output Modelica.Units.SI.SpecificHeatCapacity R_s "Gas constant of the gas phase";
protected
  import Modelica.Constants.R;
  Modelica.Units.SI.MassFraction[nXi] Yi "Independent mass fractions in gas phase";
  Modelica.Units.SI.MolarMass MM_gas "Average molar mass of gas phase";
algorithm
  Yi := gasMassFraction(state); 
  MM_gas := sum(Yi./MMX[1:nX-1]) + (1-sum(Yi))/MMX[nX];
  R_s := R * MM_gas;
  
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Gas constant for the gas phase.</p>
<h2>Governing Equations</h2>
<pre>Yi := gasMassFraction(state);
MM_gas := sum(Yi./MMX[1:nX-1]) + (1-sum(Yi))/MMX[nX];
R_s := R * MM_gas;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Thermodynamic state record</td></tr>
<tr><td><code>R_s</code></td><td>Gas constant of the gas phase</td></tr>
<tr><td><code>Yi</code></td><td>Independent mass fractions in gas phase</td></tr>
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

 
  redeclare function extends specificEnthalpy
  protected
    Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";

  algorithm
    X_l := liquidMassFraction(state);
    h := X_l*enthalpyOfLiquid(state) + (1-X_l)*enthalpyOfGas(state);
    
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Enthalpy calculation, evaluating <code>X_l</code>, <code>h</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X_l := liquidMassFraction(state);
h := X_l*enthalpyOfLiquid(state) + (1-X_l)*enthalpyOfGas(state);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>X_l</code></td><td>Liquid mass fraction</td></tr>
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
end specificEnthalpy;
  
  
  
  redeclare function extends specificInternalEnergy
  protected
    Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
  algorithm
    X_l := liquidMassFraction(state);
    u := specificEnthalpy(state) - state.p*(X_l/densityOfLiquid(state.p, state.T) + (1-X_l)/densityOfGas(state));
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Internal Energy calculation, evaluating <code>X_l</code>, <code>u</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X_l := liquidMassFraction(state);
u := specificEnthalpy(state) - state.p*(X_l/densityOfLiquid(state.p, state.T) + (1-X_l)/densityOfGas(state));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>X_l</code></td><td>Liquid mass fraction</td></tr>
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
end specificInternalEnergy;
  
  function enthalpyOfLiquid "Helper function for enthalpy of liquid water"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.SpecificEnthalpy h_liq;
  algorithm
    h_liq := Shomate.enthalpy(state.T, Shomate.H2O_L) / Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div>
<h2>Governing Equations</h2>
<pre>h_liq := Shomate.enthalpy(state.T, Shomate.H2O_L) / Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Thermodynamic state record</td></tr>
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
<tr><td><code>h_liq</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificEnthalpy</td><td>J/kg</td><td>-</td></tr>
</table>
</body>
</html>"));
end enthalpyOfLiquid;
  
  
  impure function enthalpyOfGas
    extends Modelica.Icons.Function;    
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.SpecificEnthalpy h_gas;
    
    protected
      Modelica.Units.SI.MassFraction Yi[nXi] "Independent gas-phase compositions";
      Modelica.Units.SI.MassFraction Y[nX] "Independent gas-phase compositions";
    algorithm
    Yi := gasMassFraction(state);
    Y := cat(1, Yi, {1 - sum(Yi)});
    h_gas := 0;
  
    for i in 1:nX loop
      h_gas := h_gas + Y[i] * Shomate.enthalpy(state.T, sh_params[i]) / MMX[i];
    end for;
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<b><u>Important note!</u></b> To avoid confusing the compiler, we provide 2 scalars instead of an array Yi as it would seem simpler.<div>This nonsense does not always appear and is devilishly difficult to track back to this point. Noticed first in ManifoldTest.</div><div>It might not happen at all in Dymola or future OpenModelica compilers.</div><div><i>Modify at your peril!</i></div>
<h2>Governing Equations</h2>
<pre>Yi := gasMassFraction(state);
Y := cat(1, Yi, {1 - sum(Yi)});
h_gas := 0;
for i in 1:nX loop h_gas := h_gas + Y[i] * Shomate.enthalpy(state.T, sh_params[i]) / MMX[i];
end for;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Thermodynamic state record</td></tr>
<tr><td><code>Yi</code></td><td>Independent gas-phase compositions</td></tr>
<tr><td><code>Y</code></td><td>Independent gas-phase compositions</td></tr>
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
<tr><td><code>h_gas</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificEnthalpy</td><td>J/kg</td><td>-</td></tr>
</table>
</body>
</html>"));
end enthalpyOfGas;
  

redeclare function extends specificEntropy
  protected
    Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
  algorithm
    X_l := liquidMassFraction(state);
    s := X_l*entropyOfWater(state) + (1-X_l)*entropyOfGas(state);
    
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Entropy calculation, evaluating <code>X_l</code>, <code>s</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X_l := liquidMassFraction(state);
s := X_l*entropyOfWater(state) + (1-X_l)*entropyOfGas(state);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>X_l</code></td><td>Liquid mass fraction</td></tr>
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
end specificEntropy;
  
  function entropyOfWater "Helper function for entropy of liquid water"
    extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.SpecificEntropy s_liq;
  algorithm
    s_liq := Shomate.entropy(state.T, Shomate.H2O_L) / Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;
  
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div>
<h2>Governing Equations</h2>
<pre>s_liq := Shomate.entropy(state.T, Shomate.H2O_L) / Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Thermodynamic state record</td></tr>
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
<tr><td><code>s_liq</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificEntropy</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
  end entropyOfWater;
  
  function entropyOfGas
    extends Modelica.Icons.Function;
    import Modelica.Constants.R;
    import Modelica.Constants.eps;
    
    input ThermodynamicState state "Thermodynamic state record";
    output Modelica.Units.SI.SpecificEntropy s_gas;
  
  protected
      Modelica.Units.SI.MassFraction Yi[nXi] "Independent gas-phase compositions";
      Modelica.Units.SI.MassFraction Y[nX] "Independent gas-phase compositions";
      
  
  algorithm
    Yi := gasMassFraction(state);
    Y := cat(1, Yi, {1 - sum(Yi)});
    
    s_gas := 0;
  
    for i in 1:nX loop
  
    s_gas := s_gas + Y[i]*Shomate.entropy(state.T, sh_params[i])/MMX[i]
           - R*(Y[i]/MMX[i])*(log(max(Y[i], eps))+log(state.p/reference_p));
  
    end for;
    
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<b><u>Important note!</u></b> To avoid confusing the compiler, we provide 2 scalars instead of an array Yi as it would seem simpler.<div>This nonsense does not always appear and is devilishly difficult to track back to this point. Noticed first in ManifoldTest.</div><div>It might not happen at all in Dymola or future OpenModelica compilers.</div><div><i>Modify at your peril!</i></div>
<h2>Governing Equations</h2>
<pre>Yi := gasMassFraction(state);
Y := cat(1, Yi, {1 - sum(Yi)});
s_gas := 0;
for i in 1:nX loop s_gas := s_gas + Y[i]*Shomate.entropy(state.T, sh_params[i])/MMX[i] - R*(Y[i]/MMX[i])*(log(max(Y[i], eps))+log(state.p/reference_p));
end for;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>state</code></td><td>Thermodynamic state record</td></tr>
<tr><td><code>Yi</code></td><td>Independent gas-phase compositions</td></tr>
<tr><td><code>Y</code></td><td>Independent gas-phase compositions</td></tr>
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
<tr><td><code>s_gas</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificEntropy</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
  end entropyOfGas;
  
redeclare function extends isentropicEnthalpy
  protected
    function s_offset "Find offset from isoentropic conditions, u is h_out"
      extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
      input Modelica.Units.SI.SpecificEntropy s_in;
      input Modelica.Units.SI.Pressure p_out;
      input Modelica.Units.SI.MassFraction[nXi] Xi;
    protected
      Modelica.Units.SI.SpecificEntropy s_out;
    algorithm
      s_out := specificEntropy(setState_phX(p_out, u, Xi));
      y := s_out - s_in;
      annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Find offset from isoentropic conditions, u is h_out.</p>
<h2>Governing Equations</h2>
<pre>s_out := specificEntropy(setState_phX(p_out, u, Xi));
y := s_out - s_in;</pre>
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

    Modelica.Units.SI.SpecificEntropy s_ref;
    Modelica.Units.SI.SpecificEnthalpy h_min, h_max;
  algorithm
    h_min := specificEnthalpy(setState_pTX(refState.p, 273.15, refState.Xi));
    h_max := specificEnthalpy(setState_pTX(refState.p, 1000, refState.Xi));
    s_ref := specificEntropy(refState);
    h_is := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function s_offset(s_in=s_ref, p_out=p_downstream, Xi=refState.Xi), u_min = h_min, u_max = h_max);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Isentropic Enthalpy calculation, evaluating <code>h_min</code>, <code>h_max</code>, <code>s_ref</code>, <code>h_is</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>h_min := specificEnthalpy(setState_pTX(refState.p, 273.15, refState.Xi));
h_max := specificEnthalpy(setState_pTX(refState.p, 1000, refState.Xi));
s_ref := specificEntropy(refState);
h_is := Modelica.Math.Nonlinear.solveOneNonlinearEquation(f = function s_offset(s_in=s_ref, p_out=p_downstream, Xi=refState.Xi), u_min = h_min, u_max = h_max);</pre>
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

  replaceable function densityOfLiquid
    extends Modelica.Icons.Function;
    import Modelica.Media.Water.IF97_Utilities.rho_pT;

    input Modelica.Units.SI.AbsolutePressure p;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.Density d_liq "Water density";
  algorithm
    d_liq := rho_pT(p, T, 1); // Last "1" specifies liquid phase explicitly
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Density Of Liquid calculation, evaluating <code>d_liq</code> from <code>p</code>, <code>T</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>d_liq := rho_pT(p, T, 1);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>d_liq</code></td><td>Water density</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Input signal</td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td>-</td></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>-</td></tr>
<tr><td><code>d_liq</code></td><td>Output signal</td><td>Modelica.Units.SI.Density</td><td>kg/m3</td><td>Water density</td></tr>
</table>
</body>
</html>"));
end densityOfLiquid;
  
  function densityOfGas
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.Density d_gas "Gas density";
  algorithm
    d_gas := state.p/(gasConstant(state)*state.T);
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Density Of Gas calculation, evaluating <code>d_gas</code> from <code>state</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>d_gas := state.p/(gasConstant(state)*state.T);</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>d_gas</code></td><td>Gas density</td></tr>
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
<tr><td><code>d_gas</code></td><td>Output signal</td><td>Modelica.Units.SI.Density</td><td>kg/m3</td><td>Gas density</td></tr>
</table>
</body>
</html>"));
end densityOfGas;
  
  redeclare function extends density
  extends Modelica.Icons.Function;
  protected
    Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
  algorithm
    X_l := liquidMassFraction(state);
    d := 1 / (X_l/densityOfLiquid(state.p, state.T) + (1-X_l)/densityOfGas(state)); // NOTE non-linear combination
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Density calculation, evaluating <code>X_l</code>, <code>d</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X_l := liquidMassFraction(state);
d := 1 / (X_l/densityOfLiquid(state.p, state.T) + (1-X_l)/densityOfGas(state));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>X_l</code></td><td>Liquid mass fraction</td></tr>
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
end density;

  function relativeHumidity
    extends Modelica.Icons.Function;
    input ThermodynamicState state;
    output Modelica.Units.SI.MoleFraction phi;
  algorithm
    phi := ((1-sum(state.Xi))-liquidMassFraction(state)) * (molarMass(state)/MMX[nX]) * (state.p/saturationPressure(state.T, T_boil, L));
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Relative Humidity calculation, evaluating <code>phi</code> from <code>state</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>phi := ((1-sum(state.Xi))-liquidMassFraction(state)) * (molarMass(state)/MMX[nX]) * (state.p/saturationPressure(state.T, T_boil, L));</pre>
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


  replaceable function specificHeatCapacityCpOfLiquid "Helper function for heat capacity of liquid water"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.SpecificHeatCapacity cp_liq;
  algorithm
    cp_liq := Shomate.heat_capacity(T, Shomate.H2O_L) / Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;
    annotation(
    Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
Calculated from <a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&amp;Units=SI&amp;Mask=2&amp;Type=JANAFL&amp;Table=on#JANAFL\">NIST Shomate equation</a>.<div>Note we did not include the H parameter, since we want to include the enthalpy of formation.</div>
<h2>Governing Equations</h2>
<pre>cp_liq := Shomate.heat_capacity(T, Shomate.H2O_L) / Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM;</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>-</td></tr>
<tr><td><code>cp_liq</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>-</td></tr>
</table>
</body>
</html>"));
  end specificHeatCapacityCpOfLiquid;
  
  function specificHeatCapacityCpOfGas
    extends Modelica.Icons.Function;  
    input Modelica.Units.SI.Temperature T "Vapour temperature";
    input Modelica.Units.SI.MassFraction Yi[nX-1] "Gas fraction";
    output Modelica.Units.SI.SpecificHeatCapacity cp_gas;
  protected
     Modelica.Units.SI.MassFraction Y[nX] "Gas fraction";
  
  algorithm
    Y := cat(1, Yi, {1 - sum(Yi)});
  
    cp_gas := 0;
  
    for i in 1:nX loop
      cp_gas := cp_gas + Y[i] * Shomate.heat_capacity(T, sh_params[i]) / MMX[i];
    end for;
  
  annotation(
      Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<b><u>Important note!</u></b> To avoid confusing the compiler, we provide 2 scalars instead of an array Yi as it would seem simpler.<div>This nonsense does not always appear and is devilishly difficult to track back to this point. Noticed first in ManifoldTest.</div><div>It might not happen at all in Dymola or future OpenModelica compilers.</div><div><i>Modify at your peril!</i></div>
<h2>Governing Equations</h2>
<pre>Y := cat(1, Yi, {1 - sum(Yi)});
cp_gas := 0;
for i in 1:nX loop cp_gas := cp_gas + Y[i] * Shomate.heat_capacity(T, sh_params[i]) / MMX[i];
end for;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Vapour temperature</td></tr>
<tr><td><code>Yi</code></td><td>Gas fraction</td></tr>
<tr><td><code>Y</code></td><td>Gas fraction</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>Vapour temperature</td></tr>
<tr><td><code>Yi</code></td><td>Input signal</td><td>Modelica.Units.SI.MassFraction[nX-1]</td><td>1</td><td>Gas fraction</td></tr>
<tr><td><code>cp_gas</code></td><td>Output signal</td><td>Modelica.Units.SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>-</td></tr>
</table>
</body>
</html>"));
  end specificHeatCapacityCpOfGas;
  
  redeclare function extends specificHeatCapacityCp
  protected
    Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
    Modelica.Units.SI.MassFraction Yi[nXi] "Independent gas-phase compositions";
    Modelica.Units.SI.MassFraction Y[nX] "Independent gas-phase compositions";
    
  algorithm
    Y := cat(1, Yi, {1 - sum(Yi)});
    X_l := liquidMassFraction(state);
    Yi := gasMassFraction(state);
    cp := specificHeatCapacityCpOfGas(state.T, Yi)*(1-X_l) + specificHeatCapacityCpOfLiquid(state.T)*X_l;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Heat Capacity Cp calculation, evaluating <code>Y</code>, <code>X_l</code>, <code>Yi</code>, <code>cp</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>Y := cat(1, Yi, {1 - sum(Yi)});
X_l := liquidMassFraction(state);
Yi := gasMassFraction(state);
cp := specificHeatCapacityCpOfGas(state.T, Yi)*(1-X_l) + specificHeatCapacityCpOfLiquid(state.T)*X_l;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>X_l</code></td><td>Liquid mass fraction</td></tr>
<tr><td><code>Yi</code></td><td>Independent gas-phase compositions</td></tr>
<tr><td><code>Y</code></td><td>Independent gas-phase compositions</td></tr>
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
end specificHeatCapacityCp;
  
  redeclare function extends specificHeatCapacityCv
  protected
    Modelica.Units.SI.MassFraction X_l "Liquid mass fraction";
    Modelica.Units.SI.MassFraction Yi[nXi] "Independent gas-phase compositions";
  algorithm
    X_l := liquidMassFraction(state);
    Yi := gasMassFraction(state);
    cv := (specificHeatCapacityCpOfGas(state.T, Yi)-gasConstant(state))*(1-X_l) + specificHeatCapacityCpOfLiquid(state.T)*X_l;
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Specific Heat Capacity Cv calculation, evaluating <code>X_l</code>, <code>Yi</code>, <code>cv</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>X_l := liquidMassFraction(state);
Yi := gasMassFraction(state);
cv := (specificHeatCapacityCpOfGas(state.T, Yi)-gasConstant(state))*(1-X_l) + specificHeatCapacityCpOfLiquid(state.T)*X_l;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>X_l</code></td><td>Liquid mass fraction</td></tr>
<tr><td><code>Yi</code></td><td>Independent gas-phase compositions</td></tr>
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
end specificHeatCapacityCv;


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
<body>
<h2>Model Description and References</h2>
<p>Dynamic viscosity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure and moisture is neglected.</p>
  <p>Source: VDI Waermeatlas, 8th edition.</p>
  <p>Imported from Modelica.Media.Air.MoistAir, since a variable nitrogen-oxygen ratio will not have a major impact.</p>
<h2>Governing Equations</h2>
<pre>eta := 1e-6*Modelica.Math.Polynomials.evaluateWithRange( {9.7391102886305869E-15,-3.1353724870333906E-11,4.3004876595642225E-08, -3.8228016291758240E-05,5.0427874367180762E-02,1.7239260139242528E+01}, Modelica.Units.Conversions.to_degC(123.15), Modelica.Units.Conversions.to_degC(1273.15), Modelica.Units.Conversions.to_degC(state.T));</pre>
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
<body>
<h2>Model Description and References</h2>
<p>Thermal conductivity is computed from temperature using a simple polynomial for dry air. Range of validity is from 123.15 K to 1273.15 K. The influence of pressure and moisture is neglected.</p>
  <p>Source: VDI Waermeatlas, 8th edition.</p>
  <p>Imported from Modelica.Media.Air.MoistAir, since a variable nitrogen-oxygen ratio will not have a major impact.</p>
<h2>Governing Equations</h2>
<pre>lambda := 1e-3*Modelica.Math.Polynomials.evaluateWithRange( {6.5691470817717812E-15,-3.4025961923050509E-11,5.3279284846303157E-08, -4.5340839289219472E-05,7.6129675309037664E-02,2.4169481088097051E+01}, Modelica.Units.Conversions.to_degC(123.15), Modelica.Units.Conversions.to_degC(1273.15), Modelica.Units.Conversions.to_degC(state.T));</pre>
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
  end thermalConductivity;

  redeclare function extends setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
  algorithm
    state := ThermodynamicState(
          p=Media.Common.smoothStep(x, state_a.p, state_b.p, x_small),
          T=Media.Common.smoothStep(x, state_a.T, state_b.T, x_small),
          X=Media.Common.smoothStep(x, state_a.X, state_b.X, x_small));
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Return thermodynamic state so that it smoothly approximates: if x &gt; 0 then state_a else state_b.</p>
<h2>Governing Equations</h2>
<pre>state := ThermodynamicState( p=Media.Common.smoothStep(x, state_a.p, state_b.p, x_small), T=Media.Common.smoothStep(x, state_a.T, state_b.T, x_small), X=Media.Common.smoothStep(x, state_a.X, state_b.X, x_small));</pre>
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

  annotation(
    Documentation(info = "<html>
<p>
This package is a <strong>template</strong> for <strong>new medium</strong> models. For a new
medium model just make a copy of this package, remove the
\"partial\" keyword from the package and provide
the information that is requested in the comments of the
Modelica source.
</p>
</html>"));

end BaseShoMix;
