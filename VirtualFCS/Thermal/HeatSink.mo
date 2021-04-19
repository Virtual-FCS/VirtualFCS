within VirtualFCS.Thermal;

model HeatSink

//*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium models
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
//*** INSTANTIATE COMPONENTS ***//
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(
    T = 293.15) 
    annotation(
    Placement(visible = true, transformation(origin = {0, -65}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  
  Modelica.Thermal.HeatTransfer.Components.Convection convection 
    annotation(
    Placement(visible = true, transformation(origin = {0, -27}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  
  Modelica.Fluid.Pipes.DynamicPipe pipe(
    redeclare package Medium = Medium, 
    diameter = 0.01, 
    length = 0.2, 
    modelStructure = Modelica.Fluid.Types.ModelStructure.a_vb, 
    nNodes = 1, 
    nParallel = 5, 
    p_a_start = 102502, 
    use_HeatTransfer = true) 
    annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  
  Modelica.Blocks.Sources.Constant const(
    k = 7200) 
    annotation(
    Placement(visible = true, transformation(origin = {34, -27}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium) 
    annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium) 
    annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
//*** DEFINE CONNECTIONS ***//
  connect(pipe.port_b, port_b) annotation(
    Line(points = {{10, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(pipe.port_a, port_a) annotation(
    Line(points = {{-10, 0}, {-100, 0}}, color = {0, 127, 255}));
  connect(convection.solid, pipe.heatPorts[1]) annotation(
    Line(points = {{0, -20}, {0, -20}, {0, -4}, {0, -4}}, color = {191, 0, 0}));
  connect(convection.fluid, fixedTemperature.port) annotation(
    Line(points = {{0, -34}, {0, -34}, {0, -60}, {0, -60}}, color = {191, 0, 0}));
  connect(const.y, convection.Gc) annotation(
    Line(points = {{28.5, -27}, {18, -27}, {18, -26}, {8, -26}}, color = {0, 0, 127}));
annotation(
    Icon(graphics = {Rectangle(origin = {0, 11}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 11}, {86, -9}}), Line(origin = {-3.52008, -15.3846}, points = {{-99.6124, 15.0996}, {100.388, 15.0996}, {100.388, 15.0996}}, color = {0, 85, 255}, thickness = 3), Rectangle(origin = {0, 31}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 29}, {-74, -9}}), Rectangle(origin = {20, 31}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 29}, {-74, -9}}), Rectangle(origin = {40, 31}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 29}, {-74, -9}}), Rectangle(origin = {100, 31}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 29}, {-74, -9}}), Rectangle(origin = {60, 31}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 29}, {-74, -9}}), Rectangle(origin = {80, 31}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 29}, {-74, -9}}), Rectangle(origin = {160, 31}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 29}, {-74, -9}}), Rectangle(origin = {120, 31}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 29}, {-74, -9}}), Rectangle(origin = {140, 31}, fillColor = {170, 170, 127}, fillPattern = FillPattern.Solid, extent = {{-84, 29}, {-74, -9}}), Ellipse(origin = {-40, 80}, fillPattern = FillPattern.Solid, extent = {{40, 6}, {-20, -6}}, endAngle = 360), Ellipse(origin = {40, 80}, fillPattern = FillPattern.Solid, extent = {{20, 6}, {-40, -6}}, endAngle = 360), Ellipse(origin = {36, 82}, fillPattern = FillPattern.Solid, extent = {{-32, 2}, {-40, -6}}, endAngle = 360)}));
end HeatSink;
