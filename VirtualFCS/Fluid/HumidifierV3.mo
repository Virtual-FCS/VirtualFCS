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

  parameter Integer n(min = 1) = 10 "Number of axial volumes";
  parameter SI.Volume V_wet = 1E-4 "Wet-side gas volume" annotation (
    Dialog(group = "Physical parameters")); //Consider calculating this from the already input physical parameters
  parameter SI.Volume V_dry = V_wet "Dry-side gas volume" annotation (
    Dialog(group = "Physical parameters")); //Consider calculating this from the already input physical parameters
  parameter SI.ThermalConductance UA = 1000 "Specific fluid-to-fluid conductance" annotation (
    Dialog(group = "Physical parameters"));
  parameter SI.DiffusionCoefficient D_mem = 3.6e-7 "Membrane diffusion coefficient" annotation (
    Dialog(group = "Physical parameters"));
  parameter Integer waterIndex(min = 1) = 3 "Water species index; water must be the dependent species";
  parameter Integer nFibers = 488 "Number of hollow fibers" annotation (
    Dialog(group = "Physical parameters"));
  parameter SI.Diameter dFiber_i = 0.9e-3 "Inner fiber diameter" annotation (
    Dialog(group = "Physical parameters"));
  parameter SI.Diameter dFiber_o = 1.0e-3 "Outer fiber diameter" annotation (
    Dialog(group = "Physical parameters"));
  parameter SI.Diameter dHousing = 39.2e-3 "Inner shell diameter" annotation (
    Dialog(group = "Physical parameters"));
  parameter SI.Length L_fiber = 150.8e-3 "Fiber length" annotation (
    Dialog(group = "Physical parameters"));
  parameter SI.DiffusionCoefficient D_H2O_Air_ref = 2.6e-5"Reference water-air diffusion coefficient" annotation (
    Dialog(group = "Physical parameters"));
  constant SI.Pressure atm_P = 101325 "Reference pressure";
  constant SI.Temperature atm_T = 298.15 "Reference temperature";
  constant SI.MassFlowRate m_flow_min = 1e-9 "Minimum flow rate";
  constant SI.VolumeFlowRate V_flow_min = 1e-12 "Minimum volume flow rate";
  constant SI.Velocity k_mass_min = 1e-12 "Minimum mass-transfer coefficient";
  parameter SI.MassFlowRate m_flow_nom = 0.0004 "Nominal mass flow per train";
  parameter SI.PressureDifference dp_nominal = 100 "Nominal pressure drop";

  parameter SI.Pressure wet_p_start = wet_medium.p_default "Initial wet-side pressure" annotation (
    Dialog(tab = "Initialization", group = "Initialization"));
  parameter SI.Pressure dry_p_start = dry_medium.p_default "Initial dry-side pressure" annotation (
    Dialog(tab = "Initialization", group = "Initialization"));
  parameter SI.Temperature wet_T_start = wet_medium.T_default "Initial wet-side temperature" annotation (
    Dialog(tab = "Initialization", group = "Initialization"));
  parameter SI.Temperature dry_T_start = dry_medium.T_default "Initial dry-side temperature" annotation (
    Dialog(tab = "Initialization", group = "Initialization"));
  parameter SI.MassFraction wet_X_start[wet_medium.nX] = wet_medium.X_default "Initial wet-side composition" annotation (
    Dialog(tab = "Initialization", group = "Initialization"));
  parameter SI.MassFraction dry_X_start[dry_medium.nX] = dry_medium.X_default "Initial dry-side composition" annotation (
    Dialog(tab = "Initialization", group = "Initialization"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial "Formulation of mass balances" annotation (
    Dialog(group = "Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial "Formulation of energy balances" annotation (
    Dialog(group = "Dynamics"));
  
  SI.MassFlowRate m_permeation_total "Total net water permeatin rate, positive from wet to dry";

  MembraneManifoldV3 wetVolume[n](
    redeclare each package Medium = wet_medium,
    each nu = zeros(wet_medium.nX),
    each MMs = wet_medium.MMX,
    each V = V_wet/n,
    each R_flow = dp_nominal/(n*m_flow_nom),
    each useHeatPort = true,
    each p_start = wet_p_start,
    each T_start = wet_T_start,
    each X_start = wet_X_start,
    each massDynamics = massDynamics,
    each energyDynamics = energyDynamics);
  
  MembraneManifoldV3 dryVolume[n](
    redeclare each package Medium = dry_medium,
    each nu = zeros(dry_medium.nX),
    each MMs = dry_medium.MMX,
    each V = V_dry/n,
    each R_flow = dp_nominal/(n*m_flow_nom),
    each useHeatPort = true,
    each p_start = dry_p_start,
    each T_start = dry_T_start,
    each X_start = dry_X_start,
    each massDynamics = massDynamics,
    each energyDynamics = energyDynamics);
    
  MembraneTransferV3 transfer[n] (
    redeclare each package wet_medium = wet_medium,
    redeclare each package dry_medium = dry_medium,
    each waterIndex = waterIndex,
    each nFibers = nFibers,
    each dFiber_i = dFiber_i,
    each dFiber_o = dFiber_o,
    each L_fiber = L_fiber,
    each D_mem = D_mem,
    each D_H2O_Air_ref = D_H2O_Air_ref,
    each atm_P = atm_P,
    each atm_T = atm_T,
    each m_flow_min = m_flow_min,
    each V_flow_min = V_flow_min,
    each k_mass_min = k_mass_min,
    each n = n);
    
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conductors[n](each G = UA/n);

  SI.MassFraction transfer_Xi_wet[wet_medium.nXi] = zeros(wet_medium.nXi);
  SI.MassFraction transfer_Xi_dry[dry_medium.nXi] = zeros(dry_medium.nXi);
  output SI.MoleFraction phi_wet_out = wet_medium.relativeHumidity(wetVolume[n].medium.state);
  output SI.MoleFraction phi_dry_out = dry_medium.relativeHumidity(dryVolume[1].medium.state);

equation
  
  m_permeation_total = sum({transfer[c].m_transfer for c in 1:n});
  
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

    transfer[i].wetState = wetVolume[i].medium.state;
    transfer[i].dryState = dryVolume[i].medium.state;

    transfer[i].wetXi = wetVolume[i].medium.Xi;
    transfer[i].dryXi = dryVolume[i].medium.Xi;

    transfer[i].wetFlow = wetVolume[i].port_a.m_flow;
    transfer[i].dryFlow = dryVolume[i].port_a.m_flow;

    wetVolume[i].membrane_m_flow = -transfer[i].m_transfer;
    dryVolume[i].membrane_m_flow = transfer[i].m_transfer;

    wetVolume[i].membrane_h_outflow = transfer[i].h_transfer;
    dryVolume[i].membrane_h_outflow = transfer[i].h_transfer;

    wetVolume[i].membrane_Xi = transfer[i].Xi_transfer;
    dryVolume[i].membrane_Xi = transfer[i].Xi_transfer;
    
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
</body></html>"),

  Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-40, 80}, {-40, -80}}, thickness = 0.5), Line(points = {{40, 80}, {40, -80}}, thickness = 0.5), Line(points = {{-40, 80}, {-34, 80}}, thickness = 0.5), Line(points = {{-40, -80}, {-34, -80}}, thickness = 0.5), Line(points = {{34, 80}, {40, 80}}, thickness = 0.5), Line(points = {{34, -80}, {40, -80}}, thickness = 0.5), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, 60}, {20, 40}}), Ellipse(origin = {-6, 50}, extent = {{-3, 3}, {3, -3}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Ellipse(origin = {6, 50}, rotation = 180, extent = {{-3, 3}, {3, -3}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Line(origin = {0, 50}, points = {{6, 3}, {-6, -3}}), Line(origin = {0, 50}, points = {{6, -3}, {-6, 3}}), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -40}, {20, -60}}), Ellipse(origin = {-6, -50}, extent = {{-3, 3}, {3, -3}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Ellipse(origin = {6, -50}, rotation = 180, extent = {{-3, 3}, {3, -3}}, startAngle = 90, endAngle = 270, closure = EllipseClosure.None), Line(origin = {0, -50}, points = {{6, 3}, {-6, -3}}), Line(origin = {0, -50}, points = {{6, -3}, {-6, 3}}), Line(points = {{-100, 50}, {-20, 50}}, color = {0, 127, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(points = {{20, 50}, {100, 50}}, color = {0, 127, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(points = {{100, -50}, {20, -50}}, color = {0, 127, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(points = {{-20, -50}, {-100, -50}}, color = {0, 127, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(points = {{-8, 40}, {-8, 12}}, color = {255, 0, 0}, thickness = 0.5), Rectangle(fillColor = {192, 192, 192}, fillPattern = FillPattern.Backward, extent = {{-13, 12}, {-3, -12}}), Line(points = {{-8, -12}, {-8, -40}}, color = {255, 0, 0}, thickness = 0.5), Line(points = {{10, 40}, {10, 12}}, color = {0, 0, 255}, thickness = 0.5), Rectangle(lineColor = {0, 0, 255}, fillColor = {170, 213, 255}, fillPattern = FillPattern.Forward, extent = {{5, 12}, {15, -12}}), Line(points = {{10, 8}, {10, -8}}, color = {0, 0, 255}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(points = {{10, -12}, {10, -40}}, color = {0, 0, 255}, thickness = 0.5), Text(extent = {{-25, 75}, {25, 63}}, textString = "V_wet/n"), Text(extent = {{-25, -63}, {25, -75}}, textString = "V_dry/n"), Text(extent = {{-38, 8}, {-14, -8}}, textString = "UA/n", horizontalAlignment = TextAlignment.Right), Text(extent = {{17, 12}, {56, -2}}, textString = "Membrane", horizontalAlignment = TextAlignment.Left), Text(textColor = {0, 0, 255}, extent = {{17, -2}, {62, -16}}, textString = "m_H2O", horizontalAlignment = TextAlignment.Left), Text(textColor = {0, 127, 255}, extent = {{-20, 94}, {20, 82}}, textString = "Wet side"), Text(textColor = {0, 127, 255}, extent = {{-20, -82}, {20, -94}}, textString = "Dry side"), Line(origin = {-18, 0},points = {{10, 8}, {10, -8}}, color = {238, 46, 47}, thickness = 0.75, arrow = {Arrow.Filled, Arrow.Filled})}));
end HumidifierV3;
