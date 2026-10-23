within VirtualFCS.Media;

package Shomate
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Parameters "Shomate equation parameters"
    extends Modelica.Icons.Record;
    
    Real A;
    Real B;
    Real C;
    Real D;
    Real E;
    Real F;
    Real G;
    Real H;
  
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Shomate equation parameters.</p>
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
<tr><td><code>A</code></td><td>Record field</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>B</code></td><td>Record field</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>C</code></td><td>Record field</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>D</code></td><td>Record field</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>E</code></td><td>Record field</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>F</code></td><td>Record field</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>G</code></td><td>Record field</td><td>Real</td><td>1</td><td>-</td></tr>
<tr><td><code>H</code></td><td>Record field</td><td>Real</td><td>1</td><td>-</td></tr>
</table>
</body>
</html>"));
end Parameters;
  
  /* Validity range 100 K - 700 K. Original data Chase et al. (1998)
   * https://webbook.nist.gov/cgi/cbook.cgi?ID=C7782447&amp;Units=SI&amp;Mask=1#Thermo-Gas
   */
  constant Parameters O2(
    A = 31.32234, 
    B = -20.23531, 
    C = 57.86644, 
    D = -36.50624, 
    E = -0.007374, 
    F = -8.903471, 
    G = 246.7945, 
    H = 0.0);
  
  /* Validity range 100 K - 500 K. Original data Chase et al. (1998)
   * https://webbook.nist.gov/cgi/cbook.cgi?ID=C7727379&Units=SI&Mask=1#Thermo-Gas
   */
  constant Parameters N2(
    A = 28.98641, 
    B = 1.853978, 
    C = -9.647459, 
    D = 16.63537, 
    E = 0.000117, 
    F = -8.671914, 
    G = 226.4168, 
    H = 0.0);
  
  /* Validity range 500 K - 1700 K. Original data Chase et al. (1998)
   * https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Units=SI&Mask=1#Thermo-Gas
   */
  constant Parameters H2O_G(
      A = 30.09200, 
      B = 6.832514,
      C = 6.793435,
      D = -2.534480, 
      E = 0.082139, 
      F = -250.8810, 
      G = 223.3967, 
      H = -241.8264);

  /* Validity range 298 K - 500 K. Original data Chase et al. (1998)
   * https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Units=SI&Mask=2#Thermo-Condensed
   */
  constant Parameters H2O_L(
      A = -203.6060, 
      B = 1523.290,
      C = -3196.413,
      D = 2474.455, 
      E = 3.855326, 
      F = -256.5478,
      G = -488.7163,
      H = -285.8304);
  
  
  /* Validity range 298 K - 1000 K. Original data Chase et al. (1998)
   * https://webbook.nist.gov/cgi/cbook.cgi?ID=C1333740&Units=SI&Mask=1#Thermo-Gas
   */
  constant Parameters H2(
      A = 33.066178, 
      B = -11.363417, 
      C = 11.432816, 
      D = -2.772874, 
      E = -0.158558, 
      F = -9.980797, 
      G = 172.707974, 
      H = 0.0);
  
   /* Validity range 298 K - 1400 K. Original data Chase et al. (1998)
    * https://webbook.nist.gov/cgi/cbook.cgi?ID=C7664417&Units=SI&Mask=1#Thermo-Gas
    */
  constant Parameters NH3_G(
      A = 19.99563, 
      B = 49.77119, 
      C = -15.37599, 
      D = 1.921168, 
      E = 0.189174, 
      F = -53.30667, 
      G = 203.8591, 
      H = -45.89806);
    
   /* Validity range 195.5 - 405.4 K. Data from Perry's 7th ed., table 2-232
    * Data fits well up to 390, after that degrades a bit but still usable.
    * See attached script Utilities/ammoniaregression.py for how these values
    * were calculated.
    */
   constant Parameters NH3_L(
      A = -5161.92,
      B = 39412.44,
      C = -110391.57,
      D = 109486.5,
      E = 35.896,
      F = 598.047,
      G = -13739.695, 
      H = -68.6);
  
  function heat_capacity "Molar constant-pressure heat capacity"
    extends Modelica.Icons.Function;
    
    input Modelica.Units.SI.Temperature T;
    input Parameters sh;
    output Modelica.Units.SI.MolarHeatCapacity cp;
    
  protected
    Real t;
  
  algorithm
    t := T/1000;
    cp := sh.A + sh.B*t + sh.C*t^2 + sh.D*t^3 + sh.E/t^2;
  
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Molar constant-pressure heat capacity.</p>
<h2>Governing Equations</h2>
<pre>t := T/1000;
cp := sh.A + sh.B*t + sh.C*t^2 + sh.D*t^3 + sh.E/t^2;</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>-</td></tr>
<tr><td><code>sh</code></td><td>Input signal</td><td>Parameters</td><td>-</td><td>-</td></tr>
<tr><td><code>cp</code></td><td>Output signal</td><td>Modelica.Units.SI.MolarHeatCapacity</td><td>J/(mol.K)</td><td>-</td></tr>
</table>
</body>
</html>"));
end heat_capacity;
  
  
  function enthalpy "Standard molar enthalpy, including enthalpy of formation"
    extends Modelica.Icons.Function;
    
    input Modelica.Units.SI.Temperature T;
    input Parameters sh;
    output Modelica.Units.SI.MolarEnthalpy H;

  protected
    Real t, h;
  
  algorithm
    t := T/1000;
    h := sh.A*t + sh.B*t^2/2 + sh.C*t^3/3 + sh.D*t^4/4 - sh.E/t + sh.F;
    H := h*1000;
  
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Standard molar enthalpy, including enthalpy of formation.</p>
<h2>Governing Equations</h2>
<pre>t := T/1000;
h := sh.A*t + sh.B*t^2/2 + sh.C*t^3/3 + sh.D*t^4/4 - sh.E/t + sh.F;
H := h*1000;</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>-</td></tr>
<tr><td><code>sh</code></td><td>Input signal</td><td>Parameters</td><td>-</td><td>-</td></tr>
<tr><td><code>H</code></td><td>Output signal</td><td>Modelica.Units.SI.MolarEnthalpy</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end enthalpy;
  
  
  function entropy "Standard molar entropy"
    extends Modelica.Icons.Function;
    
    input Modelica.Units.SI.Temperature T;
    input Parameters sh;
    output Modelica.Units.SI.MolarEntropy s;
  
  protected
    Real t;
  
  algorithm
    t := T/1000;
    s := sh.A*log(t) + sh.B*t + sh.C*t^2/2 + sh.D*t^3/3 - sh.E/(2*t^2) + sh.G;
  
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Standard molar entropy.</p>
<h2>Governing Equations</h2>
<pre>t := T/1000;
s := sh.A*log(t) + sh.B*t + sh.C*t^2/2 + sh.D*t^3/3 - sh.E/(2*t^2) + sh.G;</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>-</td></tr>
<tr><td><code>sh</code></td><td>Input signal</td><td>Parameters</td><td>-</td><td>-</td></tr>
<tr><td><code>s</code></td><td>Output signal</td><td>Modelica.Units.SI.MolarEntropy</td><td>-</td><td>-</td></tr>
</table>
</body>
</html>"));
end entropy;


  function gibbs_free_energy "Standard molar Gibbs free energy"
    extends Modelica.Icons.Function;
    
    input Modelica.Units.SI.Temperature T;
    input Parameters sh;
    output Modelica.Units.SI.MolarEnergy g;

  algorithm
    g := enthalpy(T, sh) - T*entropy(T, sh);
  
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Standard molar Gibbs free energy.</p>
<h2>Governing Equations</h2>
<pre>g := enthalpy(T, sh) - T*entropy(T, sh);</pre>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>T</code></td><td>Input signal</td><td>Modelica.Units.SI.Temperature</td><td>K</td><td>-</td></tr>
<tr><td><code>sh</code></td><td>Input signal</td><td>Parameters</td><td>-</td><td>-</td></tr>
<tr><td><code>g</code></td><td>Output signal</td><td>Modelica.Units.SI.MolarEnergy</td><td>J/mol</td><td>-</td></tr>
</table>
</body>
</html>"));
end gibbs_free_energy;

annotation(Documentation(info = "<html><p>Media and thermodynamic-property functions based on Shomate polynomial correlations.</p></html>"));
end Shomate;
