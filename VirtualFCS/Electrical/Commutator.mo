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
    Line(points = {{-20, 20}, {-20, 60}, {0, 60}, {0, 100}, {-100, 100}}, color = {0, 0, 255}));
  connect(diode_gate.n, p2) annotation(
    Line(points = {{20, 20}, {20, 60}, {0, 60}, {0, 100}, {100, 100}}, color = {0, 0, 255}));
end Commutator;
