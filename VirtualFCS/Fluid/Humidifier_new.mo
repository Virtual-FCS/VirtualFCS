within VirtualFCS.Fluid;
model Humidifier_new
  replaceable package medium = Buildings.Media.Air(reference_X={0.00,1.0});
  Modelica.Fluid.Interfaces.FluidPort_a dry_inlet(redeclare package Medium=medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b dry_outlet(redeclare package Medium=medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a wet_inlet(redeclare package Medium=medium) annotation (Placement(
        transformation(origin={0,42}, extent={{-10,48},{10,68}}),
        iconTransformation(extent={{-10,48},{10,68}})));
  Modelica.Fluid.Interfaces.FluidPort_b wet_outle(redeclare package Medium=medium) annotation (Placement(
        transformation(origin={0,-40}, extent={{-10,-70},{10,-50}}),
        iconTransformation(extent={{-10,-70},{10,-50}})));
  Buildings.Fluid.FixedResistances.PressureDrop pressure_drop(redeclare package
                                                                                Medium=medium,
    m_flow_nominal=0.05,
    dp_nominal=0)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir mixing_volume(redeclare
      package                                                                        Medium=medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow_nominal=0.01,
    V=0.01,                                                                                         nPorts=2)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Fluid.FixedResistances.LosslessPipe lossless_pipe(redeclare package
                                                                                Medium=medium,
      m_flow_nominal=0.05)                                                                     annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-60})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium=medium) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,60})));
  Modelica.Blocks.Math.Gain gain(k=0.001) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={23,45})));
equation
  connect(dry_inlet, pressure_drop.port_a)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
  connect(pressure_drop.port_b, mixing_volume.ports[1])
    annotation (Line(points={{-40,0},{29,0}}, color={0,127,255}));
  connect(mixing_volume.ports[2], dry_outlet) annotation (Line(points={{31,0},{31,
          -2},{84,-2},{84,0},{100,0}}, color={0,127,255}));
  connect(wet_inlet, senMasFlo.port_a) annotation (Line(points={{0,100},{0,85},{
          1.77636e-15,85},{1.77636e-15,70}}, color={0,127,255}));
  connect(senMasFlo.port_b, lossless_pipe.port_a) annotation (Line(points={{-1.83187e-15,
          50},{-1.83187e-15,0},{1.77636e-15,0},{1.77636e-15,-50}}, color={0,127,
          255}));
  connect(lossless_pipe.port_b, wet_outle) annotation (Line(points={{-1.83187e-15,
          -70},{-1.83187e-15,-85},{0,-85},{0,-100}}, color={0,127,255}));
  connect(senMasFlo.m_flow, gain.u) annotation (Line(points={{11,60},{16,60},{16,
          51},{23,51}}, color={0,0,127}));
  connect(gain.y, mixing_volume.mWat_flow) annotation (Line(points={{23,39.5},{23,
          26},{18,26},{18,18}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(fillColor = {189, 189, 189}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}, radius = 30), Rectangle(origin = {-62, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.75, extent = {{-6, 60}, {6, -60}}), Rectangle(origin = {62, 0}, fillPattern = FillPattern.Solid, lineThickness = 0.75, extent = {{-6, 60}, {6, -60}}), Line(origin = {0.205078, 56}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0.205078, 50}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0.205078, 44}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0.205078, 38}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0.205078, 32}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0.205078, 26}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0.205078, 20}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0.205078, 14}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, 8}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, 2}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -4}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -10}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -16}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -22}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -28}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -34}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -40}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -46}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -52}, points = {{-56, 0}, {56, 0}}, thickness = 0.75), Line(origin = {0, -58}, points = {{-56, 0}, {56, 0}}, thickness = 0.75)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(info = "<html><head></head><body>Simple humidifier model development for BeBoP project.&nbsp;<div><br></div></body></html>"));
end Humidifier_new;
