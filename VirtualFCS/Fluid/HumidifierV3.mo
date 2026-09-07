within VirtualFCS.Fluid;

model HumidifierV3 "Discretised hollow-fiber membrane humidifier with fluid holdup"
  extends VirtualFCS.Fluid.HumidifierInterface(
    redeclare package wet_medium = wet_medium,
    redeclare package dry_medium = dry_medium);

  replaceable package dry_medium = Modelica.Media.Interfaces.PartialMedium
    "Dry gas on the shell side" annotation(choicesAllMatching = true);
  replaceable package wet_medium = Modelica.Media.Interfaces.PartialMedium
    "Wet gas in the fiber bores" annotation(choicesAllMatching = true);
  import SI = Modelica.Units.SI;

  parameter Integer n(min = 1) = 10 "Number of axial control volumes";
  parameter SI.Volume V_wet = 1E-4 "Total wet-side gas volume";
  parameter SI.Volume V_dry = V_wet "Total dry-side gas volume";
  parameter SI.ThermalConductance UA = 1000 "Total fluid-to-fluid conductance";
  parameter SI.DiffusionCoefficient D_mem = 3.6e-7 "Membrane diffusion coefficient";
  parameter Integer waterIndex(min = 1) = 3
    "Water species index; water must be the dependent species";
  parameter Integer nFibers = 488 "Number of hollow fibers";
  parameter SI.Diameter dFiber_i = 0.9e-3 "Inner fiber diameter";
  parameter SI.Diameter dFiber_o = 1.0e-3 "Outer fiber diameter";
  parameter SI.Diameter dHousing = 39.2e-3 "Inner shell diameter";
  parameter SI.Length L_fiber = 150.8e-3 "Fiber length";
  parameter SI.DiffusionCoefficient D_H2O_Air_ref = 2.6e-5
    "Reference water-air diffusion coefficient";
  parameter SI.Pressure atm_P = 101325 "Reference pressure";
  parameter SI.Temperature atm_T = 298.15 "Reference temperature";
  parameter SI.MassFlowRate m_flow_min = 1e-9 "Regularisation flow rate";
  parameter SI.VolumeFlowRate V_flow_min = 1e-12 "Regularisation volume flow rate";
  parameter SI.Velocity k_mass_min = 1e-12 "Minimum mass-transfer coefficient";
  parameter SI.MassFlowRate m_flow_nom = 0.0004 "Nominal mass flow per train";
  parameter SI.PressureDifference dp_nominal = 100
    "Nominal pressure drop of each control volume";

  parameter SI.Pressure wet_p_start = wet_medium.p_default "Initial wet-side pressure";
  parameter SI.Pressure dry_p_start = dry_medium.p_default "Initial dry-side pressure";
  parameter SI.Temperature wet_T_start = wet_medium.T_default "Initial wet-side temperature";
  parameter SI.Temperature dry_T_start = dry_medium.T_default "Initial dry-side temperature";
  parameter SI.MassFraction wet_X_start[wet_medium.nX] = wet_medium.X_default
    "Initial wet-side composition";
  parameter SI.MassFraction dry_X_start[dry_medium.nX] = dry_medium.X_default
    "Initial dry-side composition";

  MembraneManifoldV3 wetVolume[n](
    redeclare each package Medium = wet_medium,
    each nu = zeros(wet_medium.nX),
    each MMs = wet_medium.MMs,
    each V = V_wet/n,
    each R_flow = dp_nominal/(n*m_flow_nom),
    each useHeatPort = true,
    each p_start = wet_p_start,
    each T_start = wet_T_start,
    each X_start = wet_X_start);
  MembraneManifoldV3 dryVolume[n](
    redeclare each package Medium = dry_medium,
    each nu = zeros(dry_medium.nX),
    each MMs = dry_medium.MMs,
    each V = V_dry/n,
    each R_flow = dp_nominal/(n*m_flow_nom),
    each useHeatPort = true,
    each p_start = dry_p_start,
    each T_start = dry_T_start,
    each X_start = dry_X_start);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conductors[n](each G = UA/n);

  SI.MassFlowRate m_transfer[n] "Positive from wet side to dry side";
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
  SI.MassFraction transfer_Xi_wet[wet_medium.nXi] = zeros(wet_medium.nXi);
  SI.MassFraction transfer_Xi_dry[dry_medium.nXi] = zeros(dry_medium.nXi);
  output SI.MoleFraction phi_wet_out = wet_medium.relativeHumidity(wetVolume[n].medium.state);
  output SI.MoleFraction phi_dry_out = dry_medium.relativeHumidity(dryVolume[1].medium.state);

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
    wetVolume[i].r = 0;
    dryVolume[i].r = 0;
    connect(wetVolume[i].heatPort, conductors[i].port_a);
    connect(dryVolume[i].heatPort, conductors[i].port_b);

    wetVolumeFlow[i] = max(abs(wetVolume[i].port_a.m_flow)/wetVolume[i].medium.d, V_flow_min);
    dryVolumeFlow[i] = max(abs(dryVolume[i].port_a.m_flow)/dryVolume[i].medium.d, V_flow_min);
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
    beta_eff[i] = 1/(1/(max(Sh_wet[i]*D_H2O_Air[i]/dFiber_i, k_mass_min)*A_mem/n)
      + (dFiber_o - dFiber_i)/(2*D_mem*A_mem/n)
      + 1/(max(Sh_dry[i]*D_H2O_Air[i]/d_hyd_dry, k_mass_min)*A_mem/n));
    NTU[i] = beta_eff[i]/wetVolumeFlow[i];
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
<h1>Hollow-fiber membrane humidifier v3</h1>
<p><code>HumidifierV3</code> models the Pollak et al. hollow-fiber membrane
humidifier as two counter-current trains of <code>n</code> fluid volumes. Each
paired cell exchanges water vapor through a selective membrane and heat through
a thermal conductor. The physical gas volumes provide the only dynamic
holdup; there is no artificial first-order permeation state.</p>
<p>Positive <code>m_transfer[i]</code> moves water from the wet train to the dry
train. The signed transfer is connected to both cell volumes, where it enters
the standard mass, species, and enthalpy balances. Port outlet states are
therefore computed by the cell media rather than assigned by the humidifier.</p>
<h2>Assumptions</h2>
<ul><li>Gas-phase water is the dependent medium species.</li>
<li>The wet train flows from <code>portA_in</code> to <code>portA_out</code> and
the dry train counter-currently from <code>portB_in</code> to
<code>portB_out</code>.</li><li>Pressure drop is represented by the cell flow resistance.</li>
<li>The Pollak Sherwood correlations and membrane resistance are applied
locally to each axial cell.</li></ul>
<h2>Reference</h2>
<p>Pollak et al., <i>Steady state and dynamic simulation of a small-scale
hollow fiber membrane humidifier</i>.</p>
</body></html>"));
end HumidifierV3;