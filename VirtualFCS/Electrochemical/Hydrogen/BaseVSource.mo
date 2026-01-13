within VirtualFCS.Electrochemical.Hydrogen;

partial model BaseVSource
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  //extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T=343.15);
  extends Modelica.Electrical.Analog.Icons.VoltageSource;
  outer parameter Integer N_cells "number of cells in the stack";

  annotation(
    Icon(graphics = {Text(origin = {84, -102}, extent = {{0, 0}, {30, 30}}, textString = "A"), Text(origin = {-86, -104}, extent = {{-30, 0}, {0, 30}}, textString = "C")}),
  Documentation(info = "<html><head></head><body>This unit calculates the reversible voltage of a hydrogen fuel cell as a function of temperature (either set directly with <i>T</i>, or through the <i>heatPort</i>) and partial pressures in anode and cathode.<div>In case of relative humidity φ below 100%, the unit automatically switches to using the ΔG<sup>0</sup><sub>f</sub> of water vapour instead of liquid (reducing voltage); also, φ is used as an estimate of water activity, so the reversible voltage will increase with lower humidity (this effect will be weak and more than compensated for by increases ohmic resistance).</div><div>The anode and cathode <i>FluidPort</i>s use the <i>inStream</i> operator to estimate properties on the other side, so care must be taken in connecting them properly, to avoid reading the wrong numbers.</div></body></html>"));

end BaseVSource;
