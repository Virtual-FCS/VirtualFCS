within VirtualFCS.Electrochemical.Hydrogen;

model VSourceConstant
  extends Electrochemical.Hydrogen.BaseVSource;
  
  parameter Modelica.Units.SI.Voltage V_av = 0.1 "Average cell projected open-circuit voltage";

equation
  v = N_cells*V_av;

annotation(
    Documentation(info = "<html><head></head><body>This is a simple model of the <i>projected</i> open-circuit voltage of a fuel cell. This is one of the two components used for simple fuel-cell models, along with the internal ohmic resistance, which produces a classic Thévenin element (voltage generator and resistance).<div><br></div><div>Note that you should <i>not</i>&nbsp;use the actual open-circuit voltage of a cell for parameter V<sub>av</sub>: that will be far too high. You most probably want to use the extrapolation on the voltage axis of the stack operating points you are interested in, using a linear regression.</div><div><br></div><div>While this model will not be reliable at low currents, it is not meant to be: stacks are in any case not supposed to linger at low currents because of high voltages and the high degradation that they cause. As long as the simulation remains in the stack's normal operating envelope, such models are often satisfactory.</div><div><br></div><div>Thévenin models are useful if you are studying the balance of plant of a fuel-cell system, and want a fast model of the stack that will not slow down long-term calculations on e.g. temperature transients.</div></body></html>"));
end VSourceConstant;
