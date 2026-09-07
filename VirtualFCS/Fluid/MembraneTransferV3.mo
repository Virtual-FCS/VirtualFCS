within VirtualFCS.Fluid;

model MembraneTransferV3 "Calculates membrane mass and enthalpy transfer for one cell pair"

  replaceable package wet_medium =
      Modelica.Media.Interfaces.PartialMedium
      annotation(choicesAllMatching=true);

  replaceable package dry_medium =
      Modelica.Media.Interfaces.PartialMedium
      annotation(choicesAllMatching=true);

  import SI = Modelica.Units.SI;

  parameter Integer waterIndex(min=1)=3;
  parameter Integer nFibers=488;
  parameter SI.Diameter dFiber_i=0.9e-3;
  parameter SI.Diameter dFiber_o=1.0e-3;
  parameter SI.Diameter dHousing=39.2e-3;
  parameter SI.Length L_fiber=150.8e-3;
  parameter SI.DiffusionCoefficient D_mem=3.6e-7;

  parameter SI.DiffusionCoefficient D_H2O_Air_ref=2.6e-5;
  parameter SI.Pressure atm_P=101325;
  parameter SI.Temperature atm_T=298.15;

  parameter SI.MassFlowRate m_flow_min=1e-9;
  parameter SI.VolumeFlowRate V_flow_min=1e-12;
  parameter SI.Velocity k_mass_min=1e-12;

  parameter Integer n = 10 "Total number of humidifier cells";

  input wet_medium.ThermodynamicState wetState;
  input dry_medium.ThermodynamicState dryState;

  input SI.Density wetDensity;
  input SI.Density dryDensity;

  input SI.Pressure wetPressure;
  input SI.Pressure dryPressure;

  input SI.Temperature wetTemperature;
  input SI.Temperature dryTemperature;

  input SI.MassFraction wetXi[wet_medium.nXi];
  input SI.MassFraction dryXi[dry_medium.nXi];

  input SI.MassFlowRate wetFlow;
  input SI.MassFlowRate dryFlow;

  output SI.MassFlowRate m_transfer
    "Mass flow from wet to dry side";

  output SI.SpecificEnthalpy h_transfer
    "Specific enthalpy of transferred water";

  output SI.MassFraction Xi_transfer[wet_medium.nXi];

protected
  SI.Area A_mem;
  SI.Area A_c_fibers;
  SI.Area A_c_shell;
  SI.Area A_c_shell_gap;
  SI.Diameter d_hyd_dry;

  SI.VolumeFlowRate wetVolumeFlow;
  SI.VolumeFlowRate dryVolumeFlow;

  SI.Velocity wetVelocity;
  SI.Velocity dryVelocity;

  SI.DiffusionCoefficient D_H2O_Air;

  Real Re_wet;
  Real Sc_wet;
  Real Re_dry;
  Real Sc_dry;

  Real Sh_wet;
  Real Sh_dry;

  SI.VolumeFlowRate beta_eff;
  SI.DimensionlessRatio NTU;
  SI.Efficiency effectiveness;

equation

  A_mem = nFibers*L_fiber*Modelica.Constants.pi*dFiber_o;

  A_c_fibers = nFibers*Modelica.Constants.pi*dFiber_i^2/4;

  A_c_shell = Modelica.Constants.pi*dHousing^2/4;

  A_c_shell_gap = A_c_shell - nFibers*Modelica.Constants.pi*dFiber_o^2/4;

  d_hyd_dry = 4*A_c_shell_gap/(Modelica.Constants.pi*nFibers*dFiber_o);

  Xi_transfer = zeros(wet_medium.nXi);

  wetVolumeFlow = max(abs(wetFlow),m_flow_min)/wetDensity;

  dryVolumeFlow = max(abs(dryFlow),m_flow_min)/dryDensity;

  wetVelocity = wetVolumeFlow/A_c_fibers;

  dryVelocity = dryVolumeFlow/A_c_shell_gap;

  D_H2O_Air = D_H2O_Air_ref*((0.5*(wetTemperature + dryTemperature))/atm_T)^1.75*(atm_P/(0.5*(wetPressure + dryPressure)));

  Re_wet = wetDensity*wetVelocity*dFiber_i/wet_medium.dynamicViscosity(wetState);

  Sc_wet = wet_medium.dynamicViscosity(wetState)/(wetDensity*D_H2O_Air);

  Re_dry = dryDensity*dryVelocity*d_hyd_dry/dry_medium.dynamicViscosity(dryState);

  Sc_dry = dry_medium.dynamicViscosity(dryState)/(dryDensity*D_H2O_Air);

  Sh_wet = (3.66^3 + 0.7^3+(1.615*(Re_wet*Sc_wet*dFiber_i/L_fiber)^(1/3)-0.7)^3)^(1/3);

  Sh_dry = (0.53-0.58*nFibers*dFiber_o^2/dHousing^2)*Re_dry^0.53*Sc_dry^0.33;

  beta_eff = 1/(1/(max(Sh_wet*D_H2O_Air/dFiber_i,k_mass_min)*A_mem/n)+(dFiber_o - dFiber_i)/(2*D_mem*A_mem/n)+1/(max(Sh_dry*D_H2O_Air/d_hyd_dry,k_mass_min)*A_mem/n));

  NTU = beta_eff/max(wetVolumeFlow,V_flow_min);

  effectiveness = NTU/(1 + NTU);

  m_transfer = wet_medium.MMs[waterIndex]*effectiveness*(wetDensity*(1 - sum(wetXi))/wet_medium.MMs[waterIndex]-dryDensity*(1 - sum(dryXi))/dry_medium.MMs[waterIndex])*wetVolumeFlow;

  h_transfer =
      if m_transfer >= 0 then
        Media.Shomate.enthalpy(
          wetTemperature,
          Media.Shomate.H2O_G)
        /wet_medium.MMs[waterIndex]
      else
        Media.Shomate.enthalpy(
          dryTemperature,
          Media.Shomate.H2O_G)
        /dry_medium.MMs[waterIndex];

end MembraneTransferV3;
