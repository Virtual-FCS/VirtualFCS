within VirtualFCS.Control;

block PumpSpeedControl
  parameter Real k = 1 "Control Gain";
  parameter Modelica.Units.SI.Time Td = 0.1 "Time Constant of Derivative Block";
  Modelica.Blocks.Continuous.LimPID limPID(Td = Td, initType = Modelica.Blocks.Types.Init.InitialOutput, k = k, yMax = 1, yMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-30, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput setMassFlow annotation(
    Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput getMassFlow annotation(
    Placement(visible = true, transformation(origin = {-100, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput setPumpSpeed annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(setMassFlow, limPID.u_s) annotation(
    Line(points = {{-100, 40}, {-60, 40}, {-60, 30}, {-42, 30}, {-42, 30}}, color = {0, 0, 127}));
  connect(getMassFlow, limPID.u_m) annotation(
    Line(points = {{-100, -20}, {-60, -20}, {-60, 0}, {-30, 0}, {-30, 18}, {-30, 18}}, color = {0, 0, 127}));
  connect(limPID.y, setPumpSpeed) annotation(
    Line(points = {{-18, 30}, {40, 30}, {40, 0}, {110, 0}, {110, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-3, 126}, lineColor = {0, 0, 255}, extent = {{-55, 18}, {55, -18}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><div>Control the speed of a <a href=\"modelica://VirtualFCS.Fluid.PumpElectricDC\">Electric Pump DC</a>&nbsp;or <a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a></div><div><br></div><div><b>Description</b></div><div><br></div>This block uses a simple <a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">PID</a> control to set pump speed as a function of mass flow.&nbsp;<div><br></div><div>The block requires that a sensor be placed to measure the mass flow through the pump in question. The measured value for the mass flow is taken in the getMassFlow interface, while the desired mass flow is set in the setMassFlowInterface. Properties of the&nbsp;<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">PID</a>&nbsp;control can be adjusted in the limPID block, and the resulting control signal is sent to the setPumpSpeed interface.&nbsp;</div></body></html>"));
end PumpSpeedControl;
