within VirtualFCS.Electrical;

model BoostConverter
  extends Modelica.Electrical.PowerConverters.Icons.Converter;
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin1;
  extends Modelica.Electrical.PowerConverters.Interfaces.DCDC.DCtwoPin2;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  extends Modelica.Electrical.PowerConverters.Interfaces.Enable.Enable2;
  
  Modelica.Electrical.Spice3.Basic.K_CoupledInductors L_coupling(k = 0.8) annotation(
    Placement(transformation(origin = {-16, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.L_Inductor inductor_B(L(displayUnit = "uH") = 8.5e-5) annotation(
    Placement(transformation(origin = {-16, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Spice3.Basic.L_Inductor inductor_A(L(displayUnit = "uH") = 8.5e-5) annotation(
    Placement(transformation(origin = {-16, 60}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor_B(R(displayUnit = "mOhm") = 0.004, useHeatPort = useHeatPort) annotation(
    Placement(transformation(origin = {-42, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor_A(R(displayUnit = "mOhm") = 0.004, useHeatPort = useHeatPort) annotation(
    Placement(transformation(origin = {-42, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Semiconductors.Diode diode_A(useHeatPort = useHeatPort)  annotation(
    Placement(transformation(origin = {40, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Semiconductors.Diode diode_B(useHeatPort = useHeatPort)  annotation(
    Placement(transformation(origin = {38, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor current_A annotation(
    Placement(transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.CurrentSensor current_B annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Spice3.Basic.C_Capacitor capacitor_in_p(C(displayUnit = "nF") = 1e-9) annotation(
    Placement(transformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.Ground case_in annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.C_Capacitor capacitor_in_n(C(displayUnit = "nF") = 1e-9) annotation(
    Placement(transformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.C_Capacitor capacitor_out_p(C(displayUnit = "nF") = 1e-9) annotation(
    Placement(transformation(origin = {100, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.Ground case_out annotation(
    Placement(transformation(origin = {110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Electrical.Spice3.Basic.C_Capacitor capacitor_out_n(C(displayUnit = "nF") = 1e-9) annotation(
    Placement(transformation(origin = {100, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Spice3.Basic.C_Capacitor C_out(C(displayUnit = "uF") = 8e-5)  annotation(
    Placement(transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealOpeningSwitch gate_A(Ron = 3E-3/4)  annotation(
    Placement(transformation(origin = {20, 30}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Electrical.Analog.Semiconductors.Diode diode_gA(useHeatPort = useHeatPort) annotation(
    Placement(transformation(origin = {10, 30}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealOpeningSwitch gate_B(Ron = 3E-3/4) annotation(
    Placement(transformation(origin = {-6, -30}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  Modelica.Electrical.Analog.Semiconductors.Diode diode_gB(useHeatPort = useHeatPort) annotation(
    Placement(transformation(origin = {5, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(inductor_B.ICP, L_coupling.inductiveCouplePin2) annotation(
    Line(points = {{-16, 8}, {-16, 20.4}}, color = {170, 85, 255}));
  connect(inductor_A.ICP, L_coupling.inductiveCouplePin1) annotation(
    Line(points = {{-16, 51.6}, {-16, 39.6}}, color = {170, 85, 255}));
  connect(resistor_A.n, inductor_A.p) annotation(
    Line(points = {{-32, 60}, {-26, 60}}, color = {0, 0, 255}));
  connect(resistor_B.n, inductor_B.p) annotation(
    Line(points = {{-32, 0}, {-26, 0}}, color = {0, 0, 255}));
  connect(dc_n1, dc_n2) annotation(
    Line(points = {{-100, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(diode_A.n, dc_p2) annotation(
    Line(points = {{52, 60}, {100, 60}}, color = {0, 0, 255}));
  connect(diode_A.p, inductor_A.n) annotation(
    Line(points = {{32, 60}, {-6, 60}}, color = {0, 0, 255}));
  connect(dc_p2, diode_B.n) annotation(
    Line(points = {{100, 60}, {66, 60}, {66, 0}, {48, 0}}, color = {0, 0, 255}));
  connect(current_A.p, dc_p1) annotation(
    Line(points = {{-80, 60}, {-100, 60}}, color = {0, 0, 255}));
  connect(dc_n1, capacitor_in_n.n) annotation(
    Line(points = {{-100, -60}, {-100, -40}}, color = {0, 0, 255}));
  connect(capacitor_in_n.p, case_in.p) annotation(
    Line(points = {{-100, -20}, {-100, 0}}, color = {0, 0, 255}));
  connect(case_in.p, capacitor_in_p.n) annotation(
    Line(points = {{-100, 0}, {-100, 20}}, color = {0, 0, 255}));
  connect(capacitor_in_p.p, dc_p1) annotation(
    Line(points = {{-100, 40}, {-100, 60}}, color = {0, 0, 255}));
  connect(dc_p1, current_A.p) annotation(
    Line(points = {{-100, 60}, {-80, 60}}, color = {0, 0, 255}));
  connect(dc_p2, capacitor_out_p.p) annotation(
    Line(points = {{100, 60}, {100, 40}}, color = {0, 0, 255}));
  connect(capacitor_out_p.n, case_out.p) annotation(
    Line(points = {{100, 20}, {100, 0}}, color = {0, 0, 255}));
  connect(case_out.p, capacitor_out_n.p) annotation(
    Line(points = {{100, 0}, {100, -20}}, color = {0, 0, 255}));
  connect(capacitor_out_n.n, dc_n2) annotation(
    Line(points = {{100, -40}, {100, -60}}, color = {0, 0, 255}));
  connect(C_out.n, dc_n2) annotation(
    Line(points = {{80, -10}, {80, -60}, {100, -60}}, color = {0, 0, 255}));
  connect(C_out.p, dc_p2) annotation(
    Line(points = {{80, 10}, {80, 60}, {100, 60}}, color = {0, 0, 255}));
  connect(current_B.p, dc_p1) annotation(
    Line(points = {{-80, 0}, {-88, 0}, {-88, 60}, {-100, 60}}, color = {0, 0, 255}));
  connect(current_B.n, resistor_B.p) annotation(
    Line(points = {{-60, 0}, {-52, 0}}, color = {0, 0, 255}));
  connect(current_A.n, resistor_A.p) annotation(
    Line(points = {{-60, 60}, {-52, 60}}, color = {0, 0, 255}));
  connect(inductor_B.n, diode_B.p) annotation(
    Line(points = {{-6, 0}, {28, 0}}, color = {0, 0, 255}));
  connect(gate_A.p, diode_gA.p) annotation(
    Line(points = {{20, 20}, {10, 20}}, color = {0, 0, 255}));
  connect(diode_gA.n, gate_A.n) annotation(
    Line(points = {{10, 40}, {20, 40}}, color = {0, 0, 255}));
  connect(gate_A.n, inductor_A.n) annotation(
    Line(points = {{20, 40}, {20, 60}, {-6, 60}}, color = {0, 0, 255}));
  connect(gate_A.p, dc_n1) annotation(
    Line(points = {{20, 20}, {20, -60}, {-100, -60}}, color = {0, 0, 255}));
  connect(diode_gB.n, gate_B.n) annotation(
    Line(points = {{5, -20}, {-6, -20}}, color = {0, 0, 255}));
  connect(gate_B.p, diode_gB.p) annotation(
    Line(points = {{-6, -40}, {5, -40}}, color = {0, 0, 255}));
  connect(gate_B.p, dc_n1) annotation(
    Line(points = {{-6, -40}, {-6, -60}, {-100, -60}}, color = {0, 0, 255}));
  connect(inductor_B.n, gate_B.n) annotation(
    Line(points = {{-6, 0}, {-6, -20}}, color = {0, 0, 255}));
  if useHeatPort then
    connect(heatPort, resistor_B.heatPort) annotation(
      Line(points = {{0, -100}, {-42, -100}, {-42, -10}}, color = {191, 0, 0}));
    connect(heatPort, resistor_A.heatPort) annotation(
      Line(points = {{0, -100}, {-56, -100}, {-56, 50}, {-42, 50}}, color = {191, 0, 0}));
    connect(heatPort, diode_B.heatPort) annotation(
      Line(points = {{0, -100}, {40, -100}, {40, -10}}, color = {191, 0, 0}));
    connect(heatPort, diode_A.heatPort) annotation(
    Line(points = {{0, -100}, {54, -100}, {54, 50}, {40, 50}}, color = {191, 0, 0}));
    connect(diode_gA.heatPort, heatPort) annotation(
    Line(points = {{0, 30}, {0, -100}}, color = {191, 0, 0}));
    connect(diode_gB.heatPort, heatPort) annotation(
    Line(points = {{16, -30}, {16, -100}, {0, -100}}, color = {191, 0, 0}));
  else
    LossPower = 0;
  end if;
  connect(andCondition_p.y, gate_B.control) annotation(
    Line(points = {{-60, -68}, {-60, -30}, {-18, -30}}, color = {255, 0, 255}));
  connect(andCondition_n.y, gate_A.control) annotation(
    Line(points = {{60, -68}, {60, 30}, {32, 30}}, color = {255, 0, 255}));
end BoostConverter;
