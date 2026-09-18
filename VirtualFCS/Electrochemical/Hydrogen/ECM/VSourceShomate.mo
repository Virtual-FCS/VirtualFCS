within VirtualFCS.Electrochemical.Hydrogen.ECM;

model VSourceShomate
  extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseVSource;
  
  import Modelica.Math.log;
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  import VirtualFCS.Media.Shomate;
  import VirtualFCS.Media.CathodeAir.Oxygen;
  import VirtualFCS.Media.CathodeAir.MMs;
  
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
  Documentation(info = "<html><head></head><body>This unit calculates the reversible voltage of a hydrogen fuel cell as a function of temperature (either set directly with <i>T</i>, or through the <i>heatPort</i>) and partial pressures in anode and cathode.<div>In case of relative humidity φ below 100%, the unit automatically switches to using the ΔG<sup>0</sup><sub>f</sub> of water vapour instead of liquid (reducing voltage); also, φ is used as an estimate of water activity, so the reversible voltage will increase with lower humidity (this effect will be weak and more than compensated for by increases ohmic resistance).</div></body></html>"));
end VSourceShomate;
