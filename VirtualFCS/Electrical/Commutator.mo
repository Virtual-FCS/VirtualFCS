within VirtualFCS.Electrical;

model Commutator
  extends VirtualFCS.Electrical.AbstractCommutator;
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch gate(Ron = 3E-3/4) annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{20, 20}, {-20, -20}}, rotation = -90)));
  Modelica.Electrical.Analog.Semiconductors.Diode diode_gate(useHeatPort = useHeatPort) annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput fire annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(gate.p, n) annotation(
    Line(points = {{-20, -20}, {-20, -40}, {0, -40}, {0, -100}}, color = {0, 0, 255}));
  connect(diode_gate.p, n) annotation(
    Line(points = {{20, -20}, {20, -40}, {0, -40}, {0, -100}}, color = {0, 0, 255}));
  connect(fire, gate.control) annotation(
    Line(points = {{-100, 0}, {-44, 0}}, color = {255, 0, 255}));
  if useHeatPort then
    connect(heatPort, diode_gate.heatPort) annotation(
      Line(points = {{96, 0}, {40, 0}}, color = {191, 0, 0}));
  else
    LossPower = 0;
  end if;
  connect(p1, p2) annotation(
    Line(points = {{-100, 100}, {100, 100}}, color = {0, 0, 255}));
  connect(gate.n, p1) annotation(
    Line(points = {{-20, 20}, {-20, 40}, {0, 40}, {0, 100}, {-100, 100}}, color = {0, 0, 255}));
  connect(diode_gate.n, p2) annotation(
    Line(points = {{20, 20}, {20, 40}, {0, 40}, {0, 100}, {100, 100}}, color = {0, 0, 255}));
annotation(
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No user-settable parameters are declared.</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>fire</code></td><td>Input</td><td>BooleanInput</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2>A full-blown commutator with a PWM-controlled gate. The unit is realised completely graphically.<h2>3. Governing equations and references</h2><p>Governing equations are inherited from the extended model or enforced by instantiated components and their connected physical networks.</p><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td colspan=\"&quot;5&quot;\">No matching inputs are declared.</td></tr></tbody></table></body></html>"));
end Commutator;
