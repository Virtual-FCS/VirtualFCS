within VirtualFCS.Media;

package NH3Cracked

extends BaseShoMix(

  mediumName = "cracked_NH3",
  substanceNames = {"hydrogen", "nitrogen", "ammonia"}, 
  reference_X = {0.01, 0.01, 0.98},  // NB! These are MASS fractions, not molar.
  sh_params= {Shomate.H2, Shomate.N2, Shomate.NH3_G, Shomate.H2O_L},
  MMX = {
      Modelica.Media.IdealGases.Common.SingleGasesData.H2.MM, 
      Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM, 
      Modelica.Media.IdealGases.Common.SingleGasesData.NH3.MM} "Molar weights of the medium species",
      T_boil = 239.8 "Boiling temperature at atmospheric pressure of the condensing phase (ammonia)",
      L = 23400 "Latent heat of condensing phase (ammonia)"
);

 redeclare function densityOfLiquid
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.AbsolutePressure p;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.Density d_liq "Water density";
  algorithm
    d_liq := 682;
// Last "1" specifies liquid phase explicitly
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Density Of Liquid calculation, evaluating <code>d_liq</code> from <code>p</code>, <code>T</code>. The expressions below specify the implemented correlation and any bounds or branch conditions.</p>
<h2>Governing Equations</h2>
<pre>d_liq := 682;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
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

redeclare function enthalpyOfLiquid "Helper function for enthalpy of liquid water"
  extends Modelica.Icons.Function;
  input ThermodynamicState state "Thermodynamic state record";
  output Modelica.Units.SI.SpecificEnthalpy h_liq;
algorithm
  h_liq := -16e6; // J/kg
  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Helper function for enthalpy of liquid water.</p>
<h2>Governing Equations</h2>
<pre>h_liq := -16e6;</pre>
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

redeclare function specificHeatCapacityCpOfLiquid "Helper function for heat capacity of liquid ammonia"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T;
    output Modelica.Units.SI.SpecificHeatCapacity cp_liq;
  algorithm
    cp_liq := 4700; // J/(kg*K)

  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Helper function for heat capacity of liquid ammonia.</p>
<h2>Governing Equations</h2>
<pre>cp_liq := 4700;</pre>
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

//redeclare function extends dynamicViscosity
//      "Return dynamic viscosity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
//  algorithm
//    eta := 3e-5;
//  end dynamicViscosity;

redeclare function extends thermalConductivity
      "Return thermal conductivity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K"
  algorithm
    lambda :=0.09;
  
    annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>Return thermal conductivity as a function of the thermodynamic state record, valid from 123.15 K to 1273.15 K.</p>
<h2>Governing Equations</h2>
<pre>lambda :=0.09;</pre>
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


end NH3Cracked;
