within VirtualFCS.Electrical;

model BoostConverter
  extends VirtualFCS.Electrical.AbstractBoostConverter(redeclare Commutator commutator_A(useHeatPort=useHeatPort),
                                                       redeclare Commutator commutator_B(useHeatPort=useHeatPort));
  extends Modelica.Electrical.PowerConverters.Interfaces.Enable.Enable2;
equation
  connect(andCondition_n.y, commutator_A.fire) annotation(
    Line(points = {{60, -68}, {60, 40}, {0, 40}, {0, 50}, {8, 50}}, color = {255, 0, 255}));
  connect(andCondition_p.y, commutator_B.fire) annotation(
    Line(points = {{-60, -68}, {-60, -14}, {-20, -14}, {-20, -10}, {0, -10}}, color = {255, 0, 255}));
annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No user-settable parameters are declared.</td></tr></tbody></table><h2>2. Model description</h2>A rigorous model for DC-DC boost converters. The two boolean inputs allow firing the gates separately.<div>Note that the rate of simulation is directly dependent on the PWM frequency, since at each change an event is triggered. In practice, this model can be used for detailed simulations in the sub-second range.</div><h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended model or enforced by instantiated components and their connected physical networks.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end BoostConverter;
