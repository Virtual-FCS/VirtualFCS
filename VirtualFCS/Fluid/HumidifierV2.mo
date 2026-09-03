within VirtualFCS.Fluid;

model HumidifierV2 "Discretised hollow-fiber membrane humidifier"
  extends VirtualFCS.Fluid.HumidifierInterface(
    redeclare package wet_medium = wet_medium,
    redeclare package dry_medium = dry_medium);

  replaceable package dry_medium = Modelica.Media.Interfaces.PartialMedium
    "Dry gas (shell side)" annotation(choicesAllMatching = true);
  replaceable package wet_medium = Modelica.Media.Interfaces.PartialMedium
    "Wet gas (fiber side)" annotation(choicesAllMatching = true);
  import SI = Modelica.Units.SI;

  parameter Integer n(min = 1) = 10 "Number of axial control volumes";
  parameter SI.Volume V_wet = 1E-4 "Total wet-side gas volume";
  parameter SI.Volume V_dry = V_wet "Total dry-side gas volume";
  parameter SI.ThermalConductance UA = 1000 "Total fluid-to-fluid conductance";
  parameter SI.DiffusionCoefficient D_mem = 3.6e-7
    "Membrane diffusion coefficient";
  parameter Integer waterIndex(min = 1) = 3
    "Index of water in the medium; water must be the dependent species";
  parameter Integer nFibers = 488 "Number of hollow fibers";
  parameter SI.Diameter dFiber_i = 0.9e-3 "Inner fiber diameter";
  parameter SI.Diameter dFiber_o = 1.0e-3 "Outer fiber diameter";
  parameter SI.Diameter dHousing = 39.2e-3 "Inner shell diameter";
  parameter SI.Length L_fiber = 150.8e-3 "Fiber length";
  parameter SI.DiffusionCoefficient D_H2O_Air_ref = 2.6e-5
    "Reference binary diffusion coefficient";
  parameter SI.Pressure atm_P = 101325 "Reference pressure";
  parameter SI.Temperature atm_T = 298.15 "Reference temperature";
  parameter SI.MassFlowRate m_flow_min = 1e-9 "Regularisation flow rate";
  parameter SI.PressureDifference dp_nominal = 100
    "Nominal pressure drop of each control volume";

  MembraneMixingVolume wetVolume[n](
    redeclare each package Medium = wet_medium,
    each V = V_wet/n,
    each R_flow = 2*dp_nominal/0.0004,
    each useHeatPort = true,
    each p_start = wet_p_start,
    each T_start = wet_T_start,
    each X_start = wet_X_start);
  
  MembraneMixingVolume dryVolume[n](
    redeclare each package Medium = dry_medium,
    each V = V_dry/n,
    each R_flow = 2*dp_nominal/0.0004,
    each useHeatPort = true,
    each p_start = dry_p_start,
    each T_start = dry_T_start,
    each X_start = dry_X_start);
  
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conductors[n](each G = UA/n);

  SI.MassFlowRate m_transfer[n] "Positive from wet side to dry side";
  SI.MassFlowRate wetFlow[n] "Local wet-side flow";
  SI.MassFlowRate dryFlow[n] "Local dry-side flow";
  SI.VolumeFlowRate wetVolumeFlow[n];
  SI.VolumeFlowRate dryVolumeFlow[n];
  SI.Velocity wetVelocity[n];
  SI.Velocity dryVelocity[n];
  SI.DiffusionCoefficient D_H2O_Air[n];
  Real Re_wet[n];
  Real Sc_wet[n];
  Real Re_dry[n];
  Real Sc_dry[n];
  Real Sh_wet[n];
  Real Sh_dry[n];
  SI.VolumeFlowRate beta_eff[n];
  SI.Efficiency effectiveness[n];
  SI.DimensionlessRatio NTU[n];
  SI.SpecificEnthalpy transfer_h[n];
  SI.MassFraction transfer_Xi_wet[wet_medium.nXi];
  SI.MassFraction transfer_Xi_dry[dry_medium.nXi];
  SI.MoleFraction phi_A_out = wet_medium.relativeHumidity(wetVolume[n].medium.state);
  SI.MoleFraction phi_B_out = dry_medium.relativeHumidity(dryVolume[n].medium.state);
  
  // Initial conditions
  parameter SI.Pressure wet_p_start = wet_medium.p_default "Initial wet-side pressure";

  parameter SI.Pressure dry_p_start = dry_medium.p_default "Initial dry-side pressure";

  parameter SI.Temperature wet_T_start = wet_medium.T_default "Initial wet-side temperature";

  parameter SI.Temperature dry_T_start = dry_medium.T_default "Initial dry-side temperature";

  parameter SI.MassFraction wet_X_start[wet_medium.nX] = wet_medium.X_default "Initial wet-side full mass-fraction vector";

  parameter SI.MassFraction dry_X_start[dry_medium.nX] = dry_medium.X_default "Initial dry-side full mass-fraction vector";


protected
  SI.Area A_mem = nFibers*L_fiber*Modelica.Constants.pi*dFiber_o;
  SI.Area A_c_fibers = nFibers*Modelica.Constants.pi*dFiber_i^2/4;
  SI.Area A_c_shell = Modelica.Constants.pi*dHousing^2/4;
  SI.Area A_c_shell_gap = A_c_shell - nFibers*Modelica.Constants.pi*dFiber_o^2/4;
  SI.Diameter d_hyd_dry = 4*A_c_shell_gap/(Modelica.Constants.pi*nFibers*dFiber_o);

equation
  connect(wetVolume[1].port_a, portA_in);
  connect(wetVolume[n].port_b, portA_out);
  connect(dryVolume[n].port_b, portB_in);
  connect(dryVolume[1].port_a, portB_out);
  for i in 1:n-1 loop
    connect(wetVolume[i].port_b, wetVolume[i + 1].port_a);
    connect(dryVolume[i].port_b, dryVolume[i + 1].port_a);
  end for;
  for i in 1:n loop
    connect(wetVolume[i].heatPort, conductors[i].port_a);
    connect(dryVolume[i].heatPort, conductors[i].port_b);
  end for;

  transfer_Xi_wet = zeros(wet_medium.nXi);
  transfer_Xi_dry = zeros(dry_medium.nXi);
  for i in 1:n loop
    wetFlow[i] = max(abs(wetVolume[i].port_a.m_flow), m_flow_min);
    dryFlow[i] = max(abs(dryVolume[i].port_a.m_flow), m_flow_min);
    wetVolumeFlow[i] = wetFlow[i]/wetVolume[i].medium.d;
    dryVolumeFlow[i] = dryFlow[i]/dryVolume[i].medium.d;
    wetVelocity[i] = wetVolumeFlow[i]/A_c_fibers;
    dryVelocity[i] = dryVolumeFlow[i]/A_c_shell_gap;
    D_H2O_Air[i] = D_H2O_Air_ref*(((wetVolume[i].medium.T + dryVolume[i].medium.T)/2)/atm_T)^1.75
      *(atm_P/((wetVolume[i].medium.p + dryVolume[i].medium.p)/2));
    Re_wet[i] = wetVolume[i].medium.d*wetVelocity[i]*dFiber_i
      /wet_medium.dynamicViscosity(wetVolume[i].medium.state);
    Sc_wet[i] = wet_medium.dynamicViscosity(wetVolume[i].medium.state)
      /(wetVolume[i].medium.d*D_H2O_Air[i]);
    Re_dry[i] = dryVolume[i].medium.d*dryVelocity[i]*d_hyd_dry
      /dry_medium.dynamicViscosity(dryVolume[i].medium.state);
    Sc_dry[i] = dry_medium.dynamicViscosity(dryVolume[i].medium.state)
      /(dryVolume[i].medium.d*D_H2O_Air[i]);
    Sh_wet[i] = (3.66^3 + 0.7^3
      + (1.615*(Re_wet[i]*Sc_wet[i]*dFiber_i/L_fiber)^(1/3) - 0.7)^3)^(1/3);
    Sh_dry[i] = (0.53 - 0.58*nFibers*dFiber_o^2/dHousing^2)
      *Re_dry[i]^0.53*Sc_dry[i]^0.33;
    beta_eff[i] = 1/(1/(max(Sh_wet[i]*D_H2O_Air[i]/dFiber_i, m_flow_min)*A_mem/n)
      + (dFiber_o - dFiber_i)/(2*D_mem*A_mem/n)
      + 1/(max(Sh_dry[i]*D_H2O_Air[i]/d_hyd_dry, m_flow_min)*A_mem/n));
    NTU[i] = beta_eff[i]/max(wetVolumeFlow[i], m_flow_min);
    effectiveness[i] = NTU[i]/(1 + NTU[i]);
    m_transfer[i] = wet_medium.MMs[waterIndex]*effectiveness[i]
      *(wetVolume[i].medium.d*(1 - sum(wetVolume[i].medium.Xi))/wet_medium.MMs[waterIndex]
      - dryVolume[i].medium.d*(1 - sum(dryVolume[i].medium.Xi))/dry_medium.MMs[waterIndex])
      *wetVolumeFlow[i];
    transfer_h[i] = if m_transfer[i] >= 0 then
      Media.Shomate.enthalpy(wetVolume[i].medium.T, Media.Shomate.H2O_G)/wet_medium.MMs[waterIndex]
      else Media.Shomate.enthalpy(dryVolume[i].medium.T, Media.Shomate.H2O_G)/dry_medium.MMs[waterIndex];
    wetVolume[i].membrane_m_flow = -m_transfer[i];
    wetVolume[i].membrane_h_outflow = transfer_h[i];
    wetVolume[i].membrane_Xi = transfer_Xi_wet;
    dryVolume[i].membrane_m_flow = m_transfer[i];
    dryVolume[i].membrane_h_outflow = transfer_h[i];
    dryVolume[i].membrane_Xi = transfer_Xi_dry;
  end for;
annotation(Documentation(info = "<html><head></head><body>
<h1>Discretised hollow-fiber membrane humidifier</h1>
<p><code>HumidifierV2</code> models a hollow-fiber membrane humidifier as two
axial trains of fluid volumes. The wet gas flows through the fiber bores from
<code>portA_in</code> to <code>portA_out</code>. The dry gas flows through the
shell-side train in the opposite direction, from <code>portB_in</code> to
<code>portB_out</code>. Each pair of axial cells exchanges water vapor and
heat.</p>
<h2>Model structure</h2>
<p>Each side is represented by <code>n</code> instances of
<code>MembraneMixingVolume</code>. The volumes provide fluid holdup and compute
their outlet streams from the standard Modelica fluid balance equations. The
paired cells are thermally coupled with conductances whose total value is
<code>UA</code>. The default connection arrangement is counter-current.</p>
<h2>Mass-transfer calculation</h2>
<p>The model follows the correlations used in Pollak et al.,
<i>Steady state and dynamic simulation of a small-scale hollow fiber membrane
humidifier</i>. For every cell:</p>
<ul>
<li>The local Reynolds and Schmidt numbers are calculated from the cell state,
flow, geometry, and temperature/pressure-dependent water-air diffusivity.</li>
<li>Gnielinski-type and Costello correlations provide the wet- and dry-side
Sherwood numbers.</li>
<li>Wet-side convection, membrane diffusion, and dry-side convection are
combined as resistances in series to obtain <code>beta_eff</code>.</li>
<li>The counter-current NTU effectiveness relation is evaluated and the water
vapor transfer is driven by the difference in water-vapor concentration.</li>
</ul>
<p>The transfer rate <code>m_transfer[i]</code> is positive from the wet train
to the dry train. The transfer is applied as a selective mass, species, and
enthalpy source to the paired volumes. There is no artificial first-order
permeation state and no direct assignment to a port's outlet stream.</p>
<h2>Geometry and parameters</h2>
<p><code>nFibers</code>, <code>dFiber_i</code>, <code>dFiber_o</code>,
<code>dHousing</code>, and <code>L_fiber</code> define the membrane area,
fiber flow area, shell flow area, and shell hydraulic diameter. <code>V_wet</code>
and <code>V_dry</code> are total gas volumes and are divided equally among the
cells. <code>UA</code> is the total fluid-to-fluid heat conductance.
<code>D_mem</code> is the effective membrane diffusion coefficient.</p>
<h2>Medium requirements and limitations</h2>
<p>The implementation follows the existing VirtualFCS air-medium convention:
water must be the dependent species, normally the last entry in the medium
composition. Set <code>waterIndex</code> to its species index. The medium must
provide density, dynamic viscosity, molar masses, relative humidity, and a
compatible thermodynamic state record. The current enthalpy calculation uses
the VirtualFCS Shomate water-vapor correlation.</p>
<p>The model assumes gas-phase water transfer, no liquid-water transport, and
no explicit membrane pressure drop. Increase <code>n</code> when axial
temperature or humidity gradients need more resolution. The model is a
dynamic finite-volume model because the gas holdup is physical, not because a
permeation relaxation time is imposed.</p>
<h2>Reference</h2>
<p>Pollak et al., <i>Steady state and dynamic simulation of a small-scale
hollow fiber membrane humidifier</i>.</p>
</body></html>"));
end HumidifierV2;
