within VirtualFCS.Fluid;

model MembraneTransfer "Calculates membrane mass and enthalpy transfer for one cell pair"

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

  parameter SI.Time tau_flow = 0.5 "Time constant of the flow filter feeding the transfer correlations";
  parameter SI.MassFlowRate wetFlow_start = 1e-3 "Initial filtered wet-side flow";
  parameter SI.MassFlowRate dryFlow_start = 1e-3 "Initial filtered dry-side flow";

  input wet_medium.ThermodynamicState wetState;
  input dry_medium.ThermodynamicState dryState;

  input SI.MassFraction wetXi[wet_medium.nXi];
  input SI.MassFraction dryXi[dry_medium.nXi];

  input SI.MassFlowRate wetFlow;
  input SI.MassFlowRate dryFlow;

  output SI.MassFlowRate m_transfer
    "Mass flow from wet to dry side";

  output SI.SpecificEnthalpy h_transfer
    "Specific enthalpy of transferred water";

  output SI.MassFraction Xi_transfer[wet_medium.nXi];

  SI.MassFlowRate wetFlow_f(start = wetFlow_start, fixed = true) "Filtered wet-side flow";
  SI.MassFlowRate dryFlow_f(start = dryFlow_start, fixed = true) "Filtered dry-side flow";

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

  SI.Density wetDensity = wet_medium.density(wetState);
  SI.Density dryDensity = dry_medium.density(dryState);

  SI.Temperature wetTemperature = wet_medium.temperature(wetState);
  SI.Temperature dryTemperature = dry_medium.temperature(dryState);

  SI.Pressure wetPressure = wet_medium.pressure(wetState);
  SI.Pressure dryPressure = dry_medium.pressure(dryState);

equation

  tau_flow*der(wetFlow_f) = wetFlow - wetFlow_f;
  tau_flow*der(dryFlow_f) = dryFlow - dryFlow_f;

  A_mem = nFibers*L_fiber*Modelica.Constants.pi*dFiber_o;

  A_c_fibers = nFibers*Modelica.Constants.pi*dFiber_i^2/4;

  A_c_shell = Modelica.Constants.pi*dHousing^2/4;

  A_c_shell_gap = A_c_shell - nFibers*Modelica.Constants.pi*dFiber_o^2/4;

  d_hyd_dry = 4*A_c_shell_gap/(Modelica.Constants.pi*nFibers*dFiber_o);

  Xi_transfer = zeros(wet_medium.nXi);

  wetVolumeFlow = max(abs(wetFlow_f),m_flow_min)/wetDensity;

  dryVolumeFlow = max(abs(dryFlow_f),m_flow_min)/dryDensity;

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

  m_transfer = wet_medium.MMX[waterIndex]*effectiveness*(wetDensity*(1 - sum(wetXi))/wet_medium.MMX[waterIndex]-dryDensity*(1 - sum(dryXi))/dry_medium.MMX[waterIndex])*wetVolumeFlow;

  h_transfer =
      if m_transfer >= 0 then
        Media.Shomate.enthalpy(
          wetTemperature,
          Media.Shomate.H2O_G)
        /wet_medium.MMX[waterIndex]
      else
        Media.Shomate.enthalpy(
          dryTemperature,
          Media.Shomate.H2O_G)
        /dry_medium.MMX[waterIndex];

  annotation(Documentation(info = "<html>
<body>
<h2>Model Description and References</h2>
<p>This model calculates the water mass and enthalpy transfer across the membrane for a single paired wet/dry cell of the discretised <code>Humidifier</code>. It implements the Pollak et al. hollow-fiber correlations, computing the wet-side (fiber bore) and dry-side (shell gap) mass-transfer coefficients from Reynolds, Schmidt, and Sherwood numbers, then combines them with the membrane diffusion resistance into an overall mass-transfer coefficient <code>beta_eff</code>.</p><div><br></div><div>An NTU-effectiveness method converts <code>beta_eff</code> and the wet-side volumetric flow into a transfer effectiveness, which is applied to the wet/dry water-vapor density difference to obtain the signed water mass flow <code>m_transfer</code> (positive from wet to dry side). The membrane area, and therefore <code>beta_eff</code>, is divided by <code>n</code> since each instance only represents one of the <code>n</code> axial cells sharing the total fiber geometry.</div><div><br></div><div>The transferred enthalpy <code>h_transfer</code> is evaluated at the upstream side's temperature (wet side if <code>m_transfer &gt;= 0</code>, dry side otherwise) using the Shomate correlation for gaseous water. This model is instantiated once per axial cell, driven by the states of the paired <code>MembraneManifold</code> volumes.</div><p>The wet-side and dry-side mass flows are filtered independently by first-order states wetFlow_f and dryFlow_f with time constant tau_flow. Their initial values are wetFlow_start and dryFlow_start. The filtered flow magnitudes, rather than the instantaneous port flows, drive the volume-flow, Reynolds-number, and Sherwood-number correlations. This reduces rapid pressure-flow feedback into membrane transfer; it does not introduce a separate permeation-rate state.</p><h3>References</h3><p>Reference: Pollak et al., <i>Steady state and dynamic simulation of a small-scale hollow fiber membrane humidifier</i>.</p>
<h2>Governing Equations</h2>
<pre>wetDensity = wet_medium.density(wetState);
dryDensity = dry_medium.density(dryState);
wetTemperature = wet_medium.temperature(wetState);
dryTemperature = dry_medium.temperature(dryState);
wetPressure = wet_medium.pressure(wetState);
dryPressure = dry_medium.pressure(dryState);
tau_flow*der(wetFlow_f) = wetFlow - wetFlow_f;
tau_flow*der(dryFlow_f) = dryFlow - dryFlow_f;
A_mem = nFibers*L_fiber*Modelica.Constants.pi*dFiber_o;
A_c_fibers = nFibers*Modelica.Constants.pi*dFiber_i^2/4;
A_c_shell = Modelica.Constants.pi*dHousing^2/4;
A_c_shell_gap = A_c_shell - nFibers*Modelica.Constants.pi*dFiber_o^2/4;
d_hyd_dry = 4*A_c_shell_gap/(Modelica.Constants.pi*nFibers*dFiber_o);
Xi_transfer = zeros(wet_medium.nXi);
wetVolumeFlow = max(abs(wetFlow_f),m_flow_min)/wetDensity;
dryVolumeFlow = max(abs(dryFlow_f),m_flow_min)/dryDensity;
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
m_transfer = wet_medium.MMX[waterIndex]*effectiveness*(wetDensity*(1 - sum(wetXi))/wet_medium.MMX[waterIndex]-dryDensity*(1 - sum(dryXi))/dry_medium.MMX[waterIndex])*wetVolumeFlow;
h_transfer = if m_transfer &gt;= 0 then Media.Shomate.enthalpy( wetTemperature, Media.Shomate.H2O_G) /wet_medium.MMX[waterIndex] else Media.Shomate.enthalpy( dryTemperature, Media.Shomate.H2O_G) /dry_medium.MMX[waterIndex];</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>m_transfer</code></td><td>Mass flow from wet to dry side</td></tr>
<tr><td><code>h_transfer</code></td><td>Specific enthalpy of transferred water</td></tr>
<tr><td><code>wetFlow_f</code></td><td>Filtered wet-side flow</td></tr>
<tr><td><code>dryFlow_f</code></td><td>Filtered dry-side flow</td></tr>
</table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>waterIndex</code></td><td>Integer</td><td>1</td><td><code>3</code></td><td>Water species index; water must be the dependent species</td></tr>
<tr><td><code>nFibers</code></td><td>Integer</td><td>1</td><td><code>488</code></td><td>Number of hollow fibers</td></tr>
<tr><td><code>dFiber_i</code></td><td>SI.Diameter</td><td>m</td><td><code>0.9e-3</code></td><td>Inner fiber diameter</td></tr>
<tr><td><code>dFiber_o</code></td><td>SI.Diameter</td><td>m</td><td><code>1.0e-3</code></td><td>Outer fiber diameter</td></tr>
<tr><td><code>dHousing</code></td><td>SI.Diameter</td><td>m</td><td><code>39.2e-3</code></td><td>Inner shell diameter</td></tr>
<tr><td><code>L_fiber</code></td><td>SI.Length</td><td>m</td><td><code>150.8e-3</code></td><td>Fiber length</td></tr>
<tr><td><code>D_mem</code></td><td>SI.DiffusionCoefficient</td><td>m2/s</td><td><code>3.6e-7</code></td><td>Membrane diffusion coefficient</td></tr>
<tr><td><code>D_H2O_Air_ref</code></td><td>SI.DiffusionCoefficient</td><td>m2/s</td><td><code>2.6e-5</code></td><td>Reference water-air diffusion coefficient</td></tr>
<tr><td><code>atm_P</code></td><td>SI.Pressure</td><td>Pa</td><td><code>101325</code></td><td>Reference pressure for the diffusion coefficient correlation</td></tr>
<tr><td><code>atm_T</code></td><td>SI.Temperature</td><td>K</td><td><code>298.15</code></td><td>Reference temperature for the diffusion coefficient correlation</td></tr>
<tr><td><code>m_flow_min</code></td><td>SI.MassFlowRate</td><td>kg/s</td><td><code>1e-9</code></td><td>Minimum flow rate used to avoid division by zero</td></tr>
<tr><td><code>V_flow_min</code></td><td>SI.VolumeFlowRate</td><td>m3/s</td><td><code>1e-12</code></td><td>Minimum volume flow rate used to avoid division by zero</td></tr>
<tr><td><code>k_mass_min</code></td><td>SI.Velocity</td><td>m/s</td><td><code>1e-12</code></td><td>Minimum mass-transfer coefficient used to avoid division by zero</td></tr>
<tr><td><code>n</code></td><td>Integer</td><td>1</td><td><code>10</code></td><td>Total number of humidifier cells</td></tr>
<tr><td><code>tau_flow</code></td><td>SI.Time</td><td>s</td><td><code>0.5</code></td><td>Time constant of the flow filter feeding the transfer correlations</td></tr>
<tr><td><code>wetFlow_start</code></td><td>SI.MassFlowRate</td><td>kg/s</td><td><code>1e-3</code></td><td>Initial filtered wet-side flow</td></tr>
<tr><td><code>dryFlow_start</code></td><td>SI.MassFlowRate</td><td>kg/s</td><td><code>1e-3</code></td><td>Initial filtered dry-side flow</td></tr>
</table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>wetState</code></td><td>Input signal</td><td>wet_medium.ThermodynamicState</td><td>-</td><td>Thermodynamic state of the paired wet-side cell</td></tr>
<tr><td><code>dryState</code></td><td>Input signal</td><td>dry_medium.ThermodynamicState</td><td>-</td><td>Thermodynamic state of the paired dry-side cell</td></tr>
<tr><td><code>wetXi</code></td><td>Input signal</td><td>SI.MassFraction[wet_medium.nXi]</td><td>1</td><td>Independent composition of the wet-side cell</td></tr>
<tr><td><code>dryXi</code></td><td>Input signal</td><td>SI.MassFraction[dry_medium.nXi]</td><td>1</td><td>Independent composition of the dry-side cell</td></tr>
<tr><td><code>wetFlow</code></td><td>Input signal</td><td>SI.MassFlowRate</td><td>kg/s</td><td>Mass flow through the wet-side cell</td></tr>
<tr><td><code>dryFlow</code></td><td>Input signal</td><td>SI.MassFlowRate</td><td>kg/s</td><td>Mass flow through the dry-side cell</td></tr>
<tr><td><code>m_transfer</code></td><td>Output signal</td><td>SI.MassFlowRate</td><td>kg/s</td><td>Mass flow from wet to dry side</td></tr>
<tr><td><code>h_transfer</code></td><td>Output signal</td><td>SI.SpecificEnthalpy</td><td>J/kg</td><td>Specific enthalpy of transferred water</td></tr>
<tr><td><code>Xi_transfer</code></td><td>Output signal</td><td>SI.MassFraction[wet_medium.nXi]</td><td>1</td><td>Independent composition of transferred water (zero; water is the dependent species)</td></tr>
</table>
</body>
</html>"));
end MembraneTransfer;
