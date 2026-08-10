within VirtualFCS.Fluid;

model HeatExchanger
  extends VirtualFCS.Fluid.HeatExchangerInterface;

  type Configuration = enumeration(counterCurrent, coCurrent);
  
  parameter Integer n(min=1) = 5 "Discretisation steps";
  parameter Modelica.Units.SI.Volume V_1 = 1E-3 "Total volume of side 1";
  parameter Modelica.Units.SI.Volume V_2 = V_1 "Total volume of side 2";
  parameter Modelica.Units.SI.ThermalConductance UA = 1000 "Thermal conductance";
  
  parameter Configuration flow_c = Configuration.counterCurrent "Flow configuration";
  
  MixingVolume mixvols_1[n](each final V=V_1/n, each final useHeatPort=true, redeclare each final package Medium = Medium_1) "Mixing volumes on side 1";
  MixingVolume mixvols_2[n](each final V=V_2/n, each final useHeatPort=true, redeclare each final package Medium = Medium_2) "Mixing volumes on side 2";
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conductors[n](each final G=UA/n) "Conductances between pairs of mixing volumes of both sides";
  
  Modelica.Units.SI.Temperature T_1[n](each displayUnit="degC") = {conductors[i].port_a.T for i in 1:n} "Temperature profile of side 1";
  Modelica.Units.SI.Temperature T_2[n](each displayUnit="degC") = {conductors[i].port_b.T for i in 1:n} "Temperature profile of side 2";
  Modelica.Units.SI.TemperatureDifference DeltaT[n] = {conductors[i].dT for i in 1:n} "Temperature difference profile";
  Modelica.Units.SI.HeatFlowRate Q_flows[n] = {conductors[i].Q_flow for i in 1:n} "Heat flow profile";
  Modelica.Units.SI.HeatFlowRate Q_flow = sum(Q_flows) "Total heat exchanged";

equation
  for i in 1:(n-1) loop
    connect(mixvols_1[i].port_b, mixvols_1[i+1].port_a);
  end for;
  connect(mixvols_1[1].port_a, port_a1);
  connect(mixvols_1[n].port_b, port_b1);

  for i in 1:(n-1) loop
    connect(mixvols_2[i].port_b, mixvols_2[i+1].port_a);
  end for;
  if flow_c == Configuration.counterCurrent then
    connect(mixvols_2[1].port_a, port_b2);
    connect(mixvols_2[n].port_b, port_a2);
  else
    connect(mixvols_2[1].port_a, port_a2);
    connect(mixvols_2[n].port_b, port_b2);
  end if;
  
  for i in 1:n loop
    connect(mixvols_1[i].heatPort, conductors[i].port_a);
    connect(mixvols_2[i].heatPort, conductors[i].port_b);
  end for;


annotation(
    Documentation(info = "<html><head></head><body>This is a discretised, 1-D heat exchanger suitable for most purposes. Detail level can be adjusted by setting the n parameter for the discretisation steps.<div>The class is implemented as two trains of MixingVolumes, one on each side, thermally connected one by one through a thermal conductance. Volumes and thermal conductances are assumed to be equally split between the MixingVolumes.</div><div><br><div>Volumes of both sides 1 and 2 can be set separately, but the default is for V_2 to be equal to V_1. The thermal conductance UA is given as a single number, as neither U nor A are used elsewhere.</div><div><br></div><div>The exchanger can be configured as cocurrent or countercurrent (default), which is implemented by swapping the train inlet and outlet of side 2.</div></div><div>Note that it is fully possible to obtain a cocurrent setup by inverting flow in one of the sides compared to the expected direction (port_a to port_b); this is discouraged as it can be confusing to users.</div></body></html>"),
  Diagram(graphics = {Line(origin = {-37, 0}, points = {{1, 80}, {-3, 80}, {-3, -80}, {3, -80}, {3, -80}}, thickness = 0.5), Line(origin = {37, 0}, rotation = 180, points = {{1, 80}, {-3, 80}, {-3, -80}, {3, -80}, {3, -80}}, thickness = 0.5), Rectangle(origin = {0, 50}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 10}, {20, -10}}), Ellipse(origin = {-6, 50}, extent = {{-3, 3}, {3, -3}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Line(origin = {0, 50}, points = {{0, 0}, {0, 10}}), Ellipse(origin = {6, 50}, rotation = 180, extent = {{-3, 3}, {3, -3}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Line(origin = {0, 50}, points = {{6, 3}, {-6, -3}}), Line(origin = {0, 50}, points = {{6, -3}, {-6, 3}}), Rectangle(origin = {0, -50}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 10}, {20, -10}}), Ellipse(origin = {-6, -50}, extent = {{-3, 3}, {3, -3}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Line(origin = {0, -50}, points = {{0, 0}, {0, 10}}), Ellipse(origin = {6, -50}, rotation = 180, extent = {{-3, 3}, {3, -3}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Line(origin = {0, -50}, points = {{6, 3}, {-6, -3}}), Line(origin = {0, -50}, points = {{6, -3}, {-6, 3}}), Rectangle(fillColor = {192, 192, 192}, pattern = LinePattern.None, fillPattern = FillPattern.Backward, extent = {{-6, 10}, {6, -10}}), Line(origin = {0, -10}, points = {{-6, 0}, {6, 0}}), Line(origin = {0, 10}, points = {{6, 0}, {-6, 0}}), Line(origin = {0, -25}, points = {{0, -15}, {0, 15}}, color = {255, 0, 0}), Line(origin = {0, 25}, points = {{0, -15}, {0, 15}}, color = {255, 0, 0}), Line(origin = {-40, 50}, points = {{20, 0}, {-20, 0}}, color = {0, 170, 255}, pattern = LinePattern.Dash), Line(origin = {-80, 50}, points = {{20, 0}, {-20, 0}}, color = {0, 170, 255}), Line(origin = {-40, -50}, points = {{20, 0}, {-20, 0}}, color = {0, 170, 255}, pattern = LinePattern.Dash), Line(origin = {-80, -50}, points = {{20, 0}, {-20, 0}}, color = {0, 170, 255}), Line(origin = {40, -50}, points = {{20, 0}, {-20, 0}}, color = {0, 170, 255}, pattern = LinePattern.Dash), Line(origin = {80, -50}, points = {{20, 0}, {-20, 0}}, color = {0, 170, 255}), Line(origin = {40, 50}, points = {{20, 0}, {-20, 0}}, color = {0, 170, 255}, pattern = LinePattern.Dash), Line(origin = {80, 50}, points = {{20, 0}, {-20, 0}}, color = {0, 170, 255}), Text(origin = {0, -65}, extent = {{-20, 5}, {20, -5}}, textString = "V₂/n"), Text(origin = {0, 65}, extent = {{-20, 5}, {20, -5}}, textString = "V₁/n"), Text(origin = {20, 1}, extent = {{-12, 5}, {12, -5}}, textString = "UA/n", horizontalAlignment = TextAlignment.Left)}));
end HeatExchanger;
