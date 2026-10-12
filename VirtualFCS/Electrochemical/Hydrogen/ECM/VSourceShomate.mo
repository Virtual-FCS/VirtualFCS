within VirtualFCS.Electrochemical.Hydrogen.ECM;

model VSourceShomate
  extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseVSource;
  
  import Modelica.Math.log;
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  import VirtualFCS.Media.Shomate;
  
  parameter Integer N_cell = 42 "Number of cells in the stack"; 
  final parameter Modelica.Units.SI.AbsolutePressure p_reference = 1.013e5 "Pa";

  outer Modelica.Units.SI.AbsolutePressure p_H2 "Hydrogen pressure";
  outer Modelica.Units.SI.AbsolutePressure p_O2 "Oxygen pressure";
  outer Modelica.Units.SI.Temperature T_stack "stack temperature";
  // Got error when trying to get cathode humidity from FuelCell using cathode.Medium.BaseProperties.phi
  final parameter Real cathode_phi = 1.0 "cathode humidity";
  
protected
  Modelica.Units.SI.AbsoluteActivity a_H2, a_O2, a_H2O;
  Modelica.Units.SI.MolarEnergy DeltaG0;
  Shomate.Parameters H2O = if cathode_phi < 1 then Shomate.H2O_G else Shomate.H2O_L;
  
equation

  a_H2 = p_H2 / p_reference;
  a_O2 = p_O2 / p_reference;
  a_H2O = max(cathode_phi, Modelica.Constants.eps);

  DeltaG0 = Shomate.gibbs_free_energy(T_stack, H2O)
          - Shomate.gibbs_free_energy(T_stack, Shomate.H2)
          - 0.5*Shomate.gibbs_free_energy(T_stack, Shomate.O2);

  v = N_cell * (-DeltaG0/2/F + R*T_stack/(2*F)*log(max(a_H2 * max(a_O2,1)^0.5 / a_H2O, 1)));

  annotation(
    Icon(graphics = {Text(origin = {-100, -100}, extent = {{0, 0}, {30, 30}}, textString = "A"), Text(origin = {100, -100}, extent = {{-30, 0}, {0, 30}}, textString = "C")}),
  Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
This unit calculates the reversible voltage of a hydrogen fuel cell as a function of temperature (either set directly with <i>T</i>, or through the <i>heatPort</i>) and partial pressures in anode and cathode.<div>In case of relative humidity φ below 100%, the unit automatically switches to using the ΔG<sup>0</sup><sub>f</sub> of water vapour instead of liquid (reducing voltage); also, φ is used as an estimate of water activity, so the reversible voltage will increase with lower humidity (this effect will be weak and more than compensated for by increases ohmic resistance).</div>
<h2>Governing Equations</h2>
<pre>H2O = if cathode_phi &lt; 1 then Shomate.H2O_G else Shomate.H2O_L;
a_H2 = p_H2 / p_reference;
a_O2 = p_O2 / p_reference;
a_H2O = max(cathode_phi, Modelica.Constants.eps);
DeltaG0 = Shomate.gibbs_free_energy(T_stack, H2O) - Shomate.gibbs_free_energy(T_stack, Shomate.H2) - 0.5*Shomate.gibbs_free_energy(T_stack, Shomate.O2);
v = N_cell * (-DeltaG0/2/F + R*T_stack/(2*F)*log(max(a_H2 * max(a_O2,1)^0.5 / a_H2O, 1)));</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>p_H2</code></td><td>Hydrogen pressure</td></tr>
<tr><td><code>p_O2</code></td><td>Oxygen pressure</td></tr>
<tr><td><code>T_stack</code></td><td>stack temperature</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>-</code></td><td>number of cells in the stack (inherited)</td></tr>
<tr><td><code>N_cell</code></td><td>Integer</td><td>1</td><td><code>42</code></td><td>Number of cells in the stack</td></tr>
<tr><td><code>p_reference</code></td><td>Modelica.Units.SI.AbsolutePressure</td><td>Pa</td><td><code>1.013e5</code></td><td>Pa</td></tr>
<tr><td><code>cathode_phi</code></td><td>Real</td><td>1</td><td><code>1.0</code></td><td>cathode humidity</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
</table>
</body>
</html>"));
end VSourceShomate;
