within VirtualFCS.Electrical;

model AveragedCommutator
  extends VirtualFCS.Electrical.AbstractCommutator;
  Modelica.Blocks.Interfaces.RealInput D(min = 0, max = 1) "Duty ratio" annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}})));
equation
  p1.v - n.v = (1 - D)*(p2.v - n.v);
  p1.i + p2.i + n.i = 0;
// Charge balance
  n.i = -D*p1.i;
// Current fraction going straight back to source
  LossPower = 0;
  annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No user-settable parameters are declared.</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>D</code></td><td>Input</td><td>RealInput</td><td>-</td><td>Duty ratio</td></tr></tbody></table><h2>2. Model description</h2>An averaged commutator for boost converters. The unit is implemented completely in code.<div>The equations state that, given an input duty ratio <i>D</i>:</div><div><ul><li>The input voltage is <i>(1-D)</i> times the output voltage;</li><li>The sum of entering currents is zero;</li><li>The current exiting from the negative pin is <i>D</i> times the input positive pin;</li><li>No power dissipation occurs.</li></ul></div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>p1.v - n.v = (1 - D)*(p2.v - n.v);
p1.i + p2.i + n.i = 0;
n.i = -D*p1.i;
LossPower = 0;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end AveragedCommutator;
