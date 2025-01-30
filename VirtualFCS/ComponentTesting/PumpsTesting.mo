within VirtualFCS.ComponentTesting;
model PumpsTesting


  Modelica.Fluid.Sources.Boundary_pT boundary(redeclare package Medium =
        Modelica.Media.Air.MoistAir, nPorts=2)
    annotation (Placement(transformation(extent={{120,-40},{100,-20}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary1(
    redeclare package Medium = Modelica.Media.Air.MoistAir,
    m_flow=1,
    nPorts=2) annotation (Placement(transformation(extent={{-122,-42},{-102,-22}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=1,
    rising=10,
    width=1,
    falling=4,
    period=16,
    nperiod=10,
    offset=0) annotation (Placement(transformation(extent={{-82,10},{-62,30}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{78,80},{98,100}})));
  Modelica.Fluid.Machines.PrescribedPump pump(
    allowFlowReversal=false,
    checkValve=true,
    checkValveHomotopy = Modelica.Fluid.Types.CheckValveHomotopyType.Closed,
    N_nominal=1200,
    redeclare function flowCharacteristic =
    Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow (
    V_flow_nominal={0,0.25,0.5}, head_nominal={100,60,0}),
    use_N_in=true,
    nParallel=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    V(displayUnit="l") = 0.5,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    p_b_start=100000,
    T_start=system.T_start,redeclare package Medium =
    Modelica.Media.Air.MoistAir)
    annotation (Placement(transformation(extent={{-10,-42},{10,-22}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow mov(redeclare package Medium =
        Modelica.Media.Air.MoistAir,
    redeclare Buildings.Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
                                     m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-42,-82},{-22,-62}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid1(
    amplitude=1,
    rising=10,
    width=1,
    falling=4,
    period=16,
    nperiod=10,
    offset=0) annotation (Placement(transformation(extent={{-82,-58},{-62,-38}})));
equation
  connect(pump.port_b, boundary.ports[1]) annotation (Line(points={{10,-32},{12,
          -32},{12,-31},{100,-31}},
                           color={0,127,255}));
  connect(pump.port_a, boundary1.ports[1]) annotation (Line(points={{-10,-32},{-56,
          -32},{-56,-32.25},{-102,-32.25}},
                                  color={0,127,255}));
  connect(trapezoid.y, pump.N_in)
    annotation (Line(points={{-61,20},{0,20},{0,-22}},  color={0,0,127}));
  connect(mov.port_a, boundary1.ports[2]) annotation (Line(points={{-42,-72},{
          -92,-72},{-92,-31.75},{-102,-31.75}},
                                            color={0,127,255}));
  connect(mov.port_b, boundary.ports[2]) annotation (Line(points={{-22,-72},{90,
          -72},{90,-29},{100,-29}},
                               color={0,127,255}));
  connect(trapezoid1.y, mov.m_flow_in)
    annotation (Line(points={{-61,-48},{-32,-48},{-32,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PumpsTesting;
