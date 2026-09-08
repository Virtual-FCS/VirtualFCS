within VirtualFCS.Electrochemical.Examples;

model PEMElectrolyserTest
  extends Modelica.Icons.Example;
  Hydrogen.PEMElectrolyser ely annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Fluid.Sources.Boundary_pT cathode_outlet(nPorts = 1, redeclare package Medium = VirtualFCS.Media.WetHydrogen, p = 3e6) annotation(
    Placement(transformation(origin = {-70, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sources.Boundary_pT anode_outlet(nPorts = 1, redeclare package Medium = VirtualFCS.Media.CathodeAir, p (displayUnit = "bar") = 2e5) annotation(
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
  Modelica.Units.SI.EnthalpyFlowRate H_out_anode = abs(anode_outlet.ports[1].m_flow)*ely.anode_b.h_outflow;
  Modelica.Units.SI.EnthalpyFlowRate H_out_cathode = abs(cathode_outlet.ports[1].m_flow)*ely.cathode_b.h_outflow;
equation
  connect(ely.anode_b, anode_outlet.ports[1]) annotation(
    Line(points = {{14, -10}, {60, -10}}, color = {0, 127, 255}));
  connect(ely.cathode_b, cathode_outlet.ports[1]) annotation(
    Line(points = {{-14, -10}, {-60, -10}}, color = {0, 127, 255}));
  connect(anode_inlet.ports[1], ely.anode_a) annotation(
    Line(points = {{60, 30}, {42, 30}, {42, 10}, {14, 10}}, color = {0, 127, 255}));
  connect(stepCurrent.n, ely.pin_p) annotation(
    Line(points = {{10, 50}, {10, 14}}, color = {0, 0, 255}));
  connect(stepCurrent.p, ely.pin_n) annotation(
    Line(points = {{-10, 50}, {-10, 14}}, color = {0, 0, 255}));
  connect(ground.p, stepCurrent.p) annotation(
    Line(points = {{-30, 40}, {-30, 50}, {-10, 50}}, color = {0, 0, 255}));
annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2));
end PEMElectrolyserTest;
