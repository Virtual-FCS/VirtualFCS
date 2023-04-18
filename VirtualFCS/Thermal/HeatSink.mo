within VirtualFCS.Thermal;

model HeatSink
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  //*** INSTANTIATE COMPONENTS ***//
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Fluid.Pipes.DynamicPipe pipe(use_T_start = true, length = 0.2, diameter = 0.01, nParallel = 5, nNodes = 1, redeclare package Medium = Medium, modelStructure = Modelica.Fluid.Types.ModelStructure.a_v_b, use_HeatTransfer = true)annotation(
    Placement(visible = true, transformation(origin = {10, -70}, extent = {{20, -80}, {0, -60}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {1.33227e-15, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T(displayUnit = "K") = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Continuous.LimPID limPID(Ni = 0.1, Td = 0, Ti = 27, controllerType = Modelica.Blocks.Types.SimpleController.PI, initType = Modelica.Blocks.Types.Init.InitialOutput, k = 40, yMax = 1200, yMin = 0, y_start = 1) annotation(
    Placement(visible = true, transformation(origin = {-28, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Stack_temperature annotation(
    Placement(visible = true, transformation(origin = {-120, 66}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 90}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Set_Point annotation(
    Placement(visible = true, transformation(origin = {-120, 26}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
equation
//*** DEFINE CONNECTIONS ***//
  connect(port_a, pipe.port_a) annotation(
    Line(points = {{-100, 0}, {-10, 0}}, color = {255, 0, 0}, thickness = 1.5));
  connect(pipe.port_b, port_b) annotation(
    Line(points = {{10, 0}, {100, 0}}, color = {0, 0, 255}, thickness = 1.5));
  connect(pipe.heatPorts[1], convection.solid) annotation(
    Line(points = {{0, -4}, {0, -20}}, color = {191, 0, 0}));
  connect(convection.fluid, fixedTemperature.port) annotation(
    Line(points = {{0, -40}, {0, -60}}, color = {191, 0, 0}));
  connect(limPID.y, convection.Gc) annotation(
    Line(points = {{-16, 66}, {24, 66}, {24, -30}, {10, -30}}, color = {0, 0, 127}));
  connect(limPID.u_s, Stack_temperature) annotation(
    Line(points = {{-40, 66}, {-120, 66}}, color = {0, 0, 127}));
  connect(limPID.u_m, Set_Point) annotation(
    Line(points = {{-28, 54}, {-30, 54}, {-30, 26}, {-120, 26}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(origin = {-16, -71}, fillColor = {0, 0, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-84, 11}, {116, -9}}), Ellipse(origin = {40, 76}, fillColor = {166, 166, 166}, fillPattern = FillPattern.Sphere, extent = {{40, 14}, {-40, -6}}), Ellipse(origin = {-40, 76}, fillColor = {166, 166, 166}, fillPattern = FillPattern.Sphere, extent = {{40, 14}, {-40, -6}}), Ellipse(origin = {30, 78}, fillColor = {166, 166, 166}, fillPattern = FillPattern.Sphere, extent = {{-20, 12}, {-40, -6}}), Rectangle(origin = {0, 20}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-100, 7}, {100, -21}}, radius = 2), Ellipse(origin = {0, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}, startAngle = 180, closure = EllipseClosure.Chord), Ellipse(origin = {-57.2, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}, startAngle = 180, closure = EllipseClosure.Chord), Ellipse(origin = {57.2, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}, startAngle = 180, closure = EllipseClosure.Chord), Rectangle(origin = {-85.75, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Rectangle(origin = {-28.6, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Rectangle(origin = {28.6, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Ellipse(origin = {-85.75, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}), Ellipse(origin = {-28.6, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}), Ellipse(origin = {28.6, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}}), Rectangle(origin = {85.75, -13}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -32}}), Ellipse(origin = {85.75, -45}, fillColor = {166, 166, 166}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-14.3, 14.3}, {14.3, -14.3}})}, coordinateSystem(initialScale = 0.1)));
end HeatSink;
