within VirtualFCS.Electrochemical.Hydrogen.ECM;

model ActivationLossNone
  extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseActivationLoss;
equation
  v = 0;
  annotation(
    Icon(graphics = {Text(textColor = {0, 0, 255}, extent = {{20, -20}, {-20, 20}}, textString = "None")}),
  Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No user-settable parameters are declared.</td></tr></tbody></table><h2>2. Model description</h2>Trivial implementation of mass transport element with no mass transport losses.<div>Voltage across the item is simply set to zero.</div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>v = 0;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));

end ActivationLossNone;
