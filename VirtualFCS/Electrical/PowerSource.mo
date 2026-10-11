within VirtualFCS.Electrical;

model PowerSource
  extends Modelica.Electrical.Analog.Interfaces.TwoPin;
  extends Modelica.Electrical.Analog.Icons.VoltageSource;
  Modelica.Blocks.Interfaces.RealInput P annotation(
    Placement(transformation(origin = {-4, -100}, extent = {{-12, -12}, {12, 12}}), iconTransformation(origin = {0, -64}, extent = {{-14, -14}, {14, 14}}, rotation = 90)));
protected
  Real v "Voltage across component";
  Real i "Current from p to n";
equation
// Pin currents
  p.i = i;
  n.i = -i;
// Constant power relation
  P = v*i;
  annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No user-settable parameters are declared.</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>P</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><p>Electrical source component providing a prescribed power input through a voltage and current interface.</p><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>p.i = i;
n.i = -i;
P = v*i;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end PowerSource;
