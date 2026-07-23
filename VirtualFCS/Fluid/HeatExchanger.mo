within VirtualFCS.Fluid;

model HeatExchanger
  extends VirtualFCS.Fluid.HeatExchangerInterface;

  type Configuration = enumeration(counterCurrent, coCurrent);
  
  parameter Integer n = 5 "Discretisation steps";
  parameter Modelica.Units.SI.Volume V_1 = 1E-3 "Total volume of side 1";
  parameter Modelica.Units.SI.Volume V_2 = V_1 "Total volume of side 2";
  parameter Modelica.Units.SI.ThermalConductance UA = 1000 "Thermal conductance";
  
  parameter Configuration flow_c = Configuration.counterCurrent "Flow configuration";
  
  MixingVolume mixvols_1[n](each final V=V_1/n, each useHeatPort=true, redeclare each package Medium = Medium_1) "Mixing volumes on side 1";
  MixingVolume mixvols_2[n](each final V=V_2/n, each useHeatPort=true, redeclare each package Medium = Medium_2) "Mixing volumes on side 2";
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


end HeatExchanger;
