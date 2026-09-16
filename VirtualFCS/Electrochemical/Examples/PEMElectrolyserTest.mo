within VirtualFCS.Electrochemical.Examples;

model PEMElectrolyserTest
  extends Modelica.Icons.Example;
  Hydrogen.PEMElectrolyser ely annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.Boundary_pT cathode_outlet(nPorts = 1, redeclare package Medium = VirtualFCS.Media.WetHydrogen, p = 3e6) annotation(
    Placement(transformation(origin = {-70, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.Boundary_pT anode_outlet(nPorts = 1, redeclare package Medium = VirtualFCS.Media.CathodeAir, use_p_in = true, p = 1e5, X = {0, 0, 1}) annotation(
    Placement(transformation(origin = {70, -10}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Fluid.Sources.MassFlowSource_T anode_inlet(nPorts = 1, redeclare package Medium = VirtualFCS.Media.CathodeAir, m_flow = 3e-3, X = {0, 0, 1}, T = 323.15) annotation(
    Placement(transformation(origin = {70, 30}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Electrical.Analog.Sources.StepCurrent stepCurrent(I = 50, startTime = 0.5) annotation(
    Placement(transformation(origin = {0, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-30, 30}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Fluid.System system annotation(
    Placement(transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Units.SI.EnthalpyFlowRate H_in = abs(anode_inlet.ports[1].m_flow)*anode_inlet.ports[1].h_outflow;
  Modelica.Units.SI.EnthalpyFlowRate H_out = H_out_anode + H_out_cathode;
  Modelica.Units.SI.EnthalpyFlowRate H_out_anode = abs(anode_outlet.ports[1].m_flow)*ely.port_anode_b.h_outflow;
  Modelica.Units.SI.EnthalpyFlowRate H_out_cathode = abs(cathode_outlet.ports[1].m_flow)*ely.port_cathode_b.h_outflow;
  Modelica.Blocks.Sources.Ramp ramp(height = 29e5, duration = 100, offset = 1e5, startTime = 5)  annotation(
    Placement(transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(ely.port_anode_b, anode_outlet.ports[1]) annotation(
    Line(points = {{14, -10}, {60, -10}}, color = {0, 127, 255}));
  connect(ely.port_cathode_b, cathode_outlet.ports[1]) annotation(
    Line(points = {{-14, -10}, {-60, -10}}, color = {0, 127, 255}));
  connect(anode_inlet.ports[1], ely.port_anode_a) annotation(
    Line(points = {{60, 30}, {42, 30}, {42, 10}, {14, 10}}, color = {0, 127, 255}));
  connect(stepCurrent.n, ely.pin_p) annotation(
    Line(points = {{10, 50}, {10, 14}}, color = {0, 0, 255}));
  connect(stepCurrent.p, ely.pin_n) annotation(
    Line(points = {{-10, 50}, {-10, 14}}, color = {0, 0, 255}));
  connect(ground.p, stepCurrent.p) annotation(
    Line(points = {{-30, 40}, {-30, 50}, {-10, 50}}, color = {0, 0, 255}));
  connect(ramp.y, anode_outlet.p_in) annotation(
    Line(points = {{62, -50}, {92, -50}, {92, -2}, {82, -2}}, color = {0, 0, 127}));

annotation(
    experiment(StartTime = 0, StopTime = 150, Tolerance = 1e-06, Interval = 0.1),
  Documentation(info = "<html><head></head><body>This is a simple test of a PEM electrolyser with variable current pushed through it while undergoing pressurisation.<div>Note that the sources and sinks are implemented with \"hard\" constraints rather than physical valves to simplify the example; it is easy to realise non-physical conditions if e.g. the pressure ramp is too fast (producing backflow into the stack).</div></body></html>"));
end PEMElectrolyserTest;
