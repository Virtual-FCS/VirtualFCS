within VirtualFCS.Electrochemical.Hydrogen;

model ReversibleVoltage
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T=343.15);
  extends Modelica.Electrical.Analog.Icons.VoltageSource;
  
  import Modelica.Math.log;
  import Modelica.Constants.F;
  import Modelica.Constants.R;
  import VirtualFCS.Media.Shomate;
  import VirtualFCS.Media.CathodeAir.Oxygen;
  import VirtualFCS.Media.CathodeAir.MMs;
  
  parameter Integer N_cell = 42 "Number of cells in the stack";
  replaceable package Cathode_Medium = Media.CathodeAir;
  replaceable package Anode_Medium = Modelica.Media.IdealGases.SingleGases.H2;
  Modelica.Fluid.Interfaces.FluidPort_b anode(redeclare package Medium = Anode_Medium) annotation(
    Placement(transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b cathode(redeclare package Medium = Cathode_Medium) annotation(
    Placement(transformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {70, -70}, extent = {{-10, -10}, {10, 10}})));

protected
  constant Modelica.Units.SI.AbsolutePressure p_atm = 101325;
  Modelica.Units.SI.AbsoluteActivity a_H2, a_O2;
  Modelica.Units.SI.MolarEnergy DeltaG0;
  Cathode_Medium.BaseProperties medium_cathode;
  Modelica.Units.SI.MolarMass MM_gas_cathode = 1/sum(medium_cathode.Y ./ MMs);

equation
  anode.m_flow = 0;
  anode.h_outflow = Anode_Medium.h_default;
  anode.Xi_outflow = Anode_Medium.X_default[1:Anode_Medium.nXi];
  anode.C_outflow = zeros(Anode_Medium.nC);

  cathode.m_flow = 0;
  cathode.h_outflow = Cathode_Medium.h_default;
  cathode.Xi_outflow = Cathode_Medium.X_default[1:Cathode_Medium.nXi];
  cathode.C_outflow = zeros(Cathode_Medium.nC);
  
  medium_cathode.p = cathode.p;
  medium_cathode.T = T_heatPort;
  medium_cathode.Xi = inStream(cathode.Xi_outflow);
  
  a_H2 = anode.p / Anode_Medium.reference_p;
  a_O2 = MM_gas_cathode/MMs[Oxygen] * medium_cathode.Y[Oxygen] * cathode.p / Cathode_Medium.reference_p;
  
  LossPower = -v*i;
  DeltaG0 = Shomate.gibbs_free_energy(T_heatPort, Shomate.H2O_L)
          - Shomate.gibbs_free_energy(T_heatPort, Shomate.H2)
          - 0.5*Shomate.gibbs_free_energy(T_heatPort, Shomate.O2);

  v = N_cell * (-DeltaG0/2/F) + R*T_heatPort/(2*F)*log(a_H2 * a_O2^0.5);

  annotation(
    Icon(graphics = {Text(origin = {-100, -100}, extent = {{0, 0}, {30, 30}}, textString = "A"), 
                     Text(origin = {100, -100}, extent = {{-30, 0}, {0, 30}}, textString = "C")}));
end ReversibleVoltage;
