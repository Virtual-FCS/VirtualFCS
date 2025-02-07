within VirtualFCS.Control;
block ChargeCounter "Determine the state-of-charge of a battery using a charge counting algorithm"
  input Modelica.Blocks.Interfaces.RealInput SOC_init "Initial state of charge of the battery." annotation (
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  input Modelica.Blocks.Interfaces.RealInput chargeCapacity "Nominal capacity of the battery." annotation (
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  input Modelica.Blocks.Interfaces.RealInput electricCurrent "Measured electric current to/from the battery." annotation (
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  output Modelica.Blocks.Interfaces.RealOutput SOC "Battery state of charge at the current time step." annotation (
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Modelica.Units.NonSI.ElectricCharge_Ah chargeCapacity_Cou=1 "Battery Cell Capacity";
  Modelica.Blocks.Math.Add add(k2 = -1) annotation (
    Placement(visible = true, transformation(origin = {39, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(initType = Modelica.Blocks.Types.Init.InitialState, y_start = 0) annotation (
    Placement(visible = true, transformation(origin = {-10, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation (
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 1 - 1e-6, uMin = 1e-6) annotation (
    Placement(visible = true, transformation(origin = {76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{0,-84},{20,-64}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{24,-48},{44,-28}})));
  output Modelica.Blocks.Interfaces.RealOutput ChargeCapacity_current annotation (
      Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Continuous.Integrator integrator1
    annotation (Placement(transformation(extent={{76,-46},{96,-26}})));
  Modelica.Blocks.Nonlinear.Limiter limiterCC(uMax=chargeCapacity_Cou,      uMin=1e-6)
    annotation (Placement(visible=true, transformation(
        origin={64,-78},
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation

  connect(integrator.y, add.u2) annotation (
    Line(points = {{1, -30}, {12, -30}, {12, -6}, {27, -6}}, color = {0, 0, 127}));
  connect(SOC_init, add.u1) annotation (
    Line(points = {{-120, 80}, {12, 80}, {12, 6}, {27, 6}}, color = {0, 0, 127}));
  connect(integrator.u, division.y) annotation (
    Line(points = {{-22, -30}, {-29, -30}}, color = {0, 0, 127}));
  connect(electricCurrent, division.u1) annotation (
    Line(points={{-120,0},{-60,0},{-60,-24},{-52,-24}},          color = {0, 0, 127}));
  connect(chargeCapacity, division.u2) annotation (
    Line(points = {{-120, -80}, {-60, -80}, {-60, -36}, {-52, -36}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation (
    Line(points = {{50, 0}, {62, 0}, {62, 0}, {64, 0}}, color = {0, 0, 127}));
  connect(limiter.y, SOC) annotation (
    Line(points={{87,0},{102,0},{102,0},{110,0}},          color = {0, 0, 127}));
  connect(SOC_init, product1.u1) annotation (Line(points={{-120,80},{12,80},{12,
          6},{18,6},{18,-44},{-2,-44},{-2,-68}}, color={0,0,127}));
  connect(chargeCapacity, product1.u2)
    annotation (Line(points={{-120,-80},{-2,-80}}, color={0,0,127}));
  connect(product1.y, add1.u2)
    annotation (Line(points={{21,-74},{26,-74},{26,-52},{22,-52},{22,-44}},
                                                          color={0,0,127}));
  connect(add1.u1, division.u1) annotation (Line(points={{22,-32},{8,-32},{8,0},
          {-60,0},{-60,-24},{-52,-24}}, color={0,0,127}));
  connect(limiterCC.u, add1.y) annotation (Line(points={{52,-78},{44,-78},{44,
          -52},{45,-52},{45,-38}}, color={0,0,127}));
  connect(ChargeCapacity_current, integrator1.y) annotation (Line(points={{110,
          -80},{96,-80},{96,-50},{97,-50},{97,-36}}, color={0,0,127}));
  connect(limiterCC.y, integrator1.u) annotation (Line(points={{75,-78},{80,-78},
          {80,-50},{66,-50},{66,-36},{74,-36}}, color={0,0,127}));
  annotation (
    Icon(graphics={  Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-38, 149}, lineColor = {0, 0, 255}, extent = {{-34, 19}, {106, -71}}, textString = "%name"), Text(origin = {-56, 85}, lineColor = {255, 255, 255}, extent = {{-34, 19}, {30, -25}}, textString = "SOC_init"), Text(origin = {-58, 5}, lineColor = {255, 255, 255}, extent = {{-34, 19}, {30, -25}}, textString = "Current"), Text(origin = {-60, -73}, lineColor = {255, 255, 255}, extent = {{-34, 19}, {38, -31}}, textString = "Capacity"), Text(origin = {88, -7}, lineColor = {255, 255, 255}, extent = {{-34, 19}, {2, -5}}, textString = "SOC"),
        Text(
          extent={{42,-84},{42,-74}},
          textColor={255,255,255},
          fontSize=26,
          textString="Capacity_current ")},                                                                                                                                                                                                        coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><!--StartFragment--><div class=\"SCXW49888958 BCX0\" style=\"margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><b>What it does</b></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\">The ChargeCounter model is designed to calculate the state-of-charge of a battery using a simple charge counting algorithm.&nbsp;</div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><br></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><b>Description</b></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\">The ChargeCounter model can be used together with a battery model (e.g. VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped). It may be implement either on its own or as a component in a larger battery management system (BMS) block (e.g. VirtualFCS.Control.BatteryManagementSystem). ChargeCounter builds on components from the Modelica Standard Library.</div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><br></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><b>Assumptions</b></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\">The inital version assumes a faradaic efficiency of 100%.</div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><br></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><b>Formula</b></div>
<div><br></div></div>


<div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\">SOC = SOC_init -  int_0^t{i/C dt}</div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><br></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><b>Operation</b></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><br></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><br></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\">

<b>Main Authors</b></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><a href=\"https://scholar.google.no/citations?user=YyXXh8UAAAAJ&amp;hl=en\">Dr. Simon Clark</a></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><br></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\"><b>List of Updates</b></div><div class=\"SCXW49888958 BCX0\" style=\"orphans: auto; widows: auto; margin: 0px; padding: 0px; -webkit-user-drag: none; -webkit-tap-highlight-color: transparent;\">30.06.2021 <span class=\"Apple-tab-span\" style=\"white-space:pre\">        </span>Initial Version</div><!--EndFragment--></body></html>", __OpenModelica_infoHeader = "<html><head></head><body><br></body></html>"));
end ChargeCounter;
