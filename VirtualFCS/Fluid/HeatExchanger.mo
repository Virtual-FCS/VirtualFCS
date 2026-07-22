within VirtualFCS.Fluid;

model HeatExchanger
  extends VirtualFCS.Fluid.HeatExchangerInterface;
  
  parameter Integer n = 5 "Number of discretisation steps";
  parameter Modelica.Units.SI.Volume V_1 = 1E-3 "Total volume of side 1";
  parameter Modelica.Units.SI.Volume V_2 = V_1 "Total volume of side 2";
  parameter Modelica.Units.SI.ThermalConductance UA = 1000 "Thermal conductance between 1 and 2 sides";
  
  parameter Boolean seriesArrangement_1 = true "Whether the mixing volumes on side 1 are arranged in series rather than parallel";
  parameter Boolean seriesArrangement_2 = true "Whether the mixing volumes on side 2 are arranged in series rather than parallel";
  parameter Boolean counterCurrent = true "Whether the flows are arranged countercurrent rather than cocurrent";
  
  MixingVolume mixvols_1[n](each final V=V_1/n, each useHeatPort=true, redeclare each package Medium = Medium_1) "Mixing volumes on side 1";
  MixingVolume mixvols_2[n](each final V=V_2/n, each useHeatPort=true, redeclare each package Medium = Medium_2) "Mixing volumes on side 2";
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conductors[n](each final G=UA/n) "Conductances between pairs of mixing volumes of both sides";
  
  Modelica.Units.SI.Temperature T_1[n](each displayUnit="degC") = {conductors[i].port_a.T for i in 1:n} "Temperature profile of side 1";
  Modelica.Units.SI.Temperature T_2[n](each displayUnit="degC") = {conductors[i].port_b.T for i in 1:n} "Temperature profile of side 2";
  Modelica.Units.SI.TemperatureDifference DeltaT[n] = {conductors[i].dT for i in 1:n} "Temperature difference profile";
  Modelica.Units.SI.HeatFlowRate Q_flows[n] = {conductors[i].Q_flow for i in 1:n} "Heat flow profile";
  Modelica.Units.SI.HeatFlowRate Q_flow = sum(Q_flows) "Total heat exchanged";

protected
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifices_1[n](each use_zeta=false, each m_flow_nominal=1, each dp_nominal=1, each diameter=1, each zeta=1, redeclare each final package Medium = Medium_1) if not seriesArrangement_1;
  Modelica.Fluid.Fittings.SimpleGenericOrifice orifices_2[n](each use_zeta=false, each m_flow_nominal=1, each dp_nominal=1, each diameter=1, each zeta=1, redeclare each final package Medium = Medium_2) if not seriesArrangement_2;

equation
  if seriesArrangement_1 then
    for i in 1:(n-1) loop
      connect(mixvols_1[i].port_b, mixvols_1[i+1].port_a);
    end for;
    connect(mixvols_1[1].port_a, port_a1);
    connect(mixvols_1[n].port_b, port_b1);
  else
    for i in 1:n loop
      connect(mixvols_1[i].port_a, port_a1);
      connect(mixvols_1[i].port_b, orifices_1[i].port_a);
      connect(orifices_1[i].port_b, port_b1);
    end for;
  end if;

  if seriesArrangement_2 then
    for i in 1:(n-1) loop
      connect(mixvols_2[i].port_b, mixvols_2[i+1].port_a);
    end for;
    if counterCurrent then
      connect(mixvols_2[1].port_a, port_b2);
      connect(mixvols_2[n].port_b, port_a2);
    else
      connect(mixvols_2[1].port_a, port_a2);
      connect(mixvols_2[n].port_b, port_b2);
    end if;
  else
    for i in 1:n loop
      connect(mixvols_2[i].port_a, port_a2);
      connect(mixvols_2[i].port_b, orifices_2[i].port_a);
      connect(orifices_2[i].port_b, port_b2);
    end for;
  end if;

  for i in 1:n loop
    connect(mixvols_1[i].heatPort, conductors[i].port_a);
    connect(mixvols_2[i].heatPort, conductors[i].port_b);
  end for;


end HeatExchanger;
