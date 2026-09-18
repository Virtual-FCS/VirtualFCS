within VirtualFCS.Electrical;

model AveragedBoostConverter
  extends VirtualFCS.Electrical.AbstractBoostConverter(redeclare AveragedCommutator commutator_A(useHeatPort=useHeatPort),
                                                       redeclare AveragedCommutator commutator_B(useHeatPort=useHeatPort));
  Modelica.Blocks.Interfaces.RealInput D annotation(
    Placement(transformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(D, commutator_B.D) annotation(
    Line(points = {{-60, -120}, {-60, -20}, {-20, -20}, {-20, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(D, commutator_A.D) annotation(
    Line(points = {{-60, -120}, {-60, 40}, {-30, 40}, {-30, 50}, {6, 50}}, color = {0, 0, 127}));
annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No user-settable parameters are declared.</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>D</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2>An averaged model of a boost DC-DC converter with coupled inductors.<div>The usage of averaged units allows a far quicker simulation than with the rigorous model, but also loses track of details: the model is not reliable outside of continuous current mode (CCM).</div><h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended model or enforced by instantiated components and their connected physical networks.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end AveragedBoostConverter;
