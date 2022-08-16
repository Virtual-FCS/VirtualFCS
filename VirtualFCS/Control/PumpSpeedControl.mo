within VirtualFCS.Control;

block PumpSpeedControl 

  parameter Real k = 1 "Control Gain";
  parameter Real Td = 0.1 "Time Constant of Derivative Block";
  
  Modelica.Blocks.Continuous.LimPID limPID( Td = Td,initType = Modelica.Blocks.Types.InitPID.InitialOutput, k = k, limitsAtInit = true, yMax = 1, yMin = 0, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {46, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput getValue annotation(
    Placement(visible = true, transformation(origin = {-120, -84}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput setPumpSpeed annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PumpOff(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-88, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-28, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput setValue annotation(
    Placement(visible = true, transformation(origin = {-128, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-113, 79}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(pre_y_start = true, uHigh = 75, uLow = 0) annotation(
    Placement(visible = true, transformation(origin = {-88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PumpOn1(y = Electrochemical.Hydrogen.FuelCellStack.prescribedHeatFlow.Q_flow / (4.187 * (SubSystems.FuelCellSubSystems.subSystemCooling.pipeReturn.heatPorts.T - SubSystems.FuelCellSubSystems.subSystemCooling.pipeSend.heatPorts.T)))  annotation(
    Placement(visible = true, transformation(origin = {-88, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  
  connect(getValue, limPID.u_m) annotation(
    Line(points = {{-120, -84}, {42, -84}, {42, -12}, {46, -12}}, color = {0, 0, 127}));
  connect(limPID.y, setPumpSpeed) annotation(
    Line(points = {{57, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(PumpOff.y, switch1.u1) annotation(
    Line(points = {{-77, 40}, {-40, 40}, {-40, 8}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch1.u2) annotation(
    Line(points = {{-77, 0}, {-40, 0}}, color = {255, 0, 255}));
  connect(setValue, hysteresis.u) annotation(
    Line(points = {{-128, 0}, {-100, 0}}, color = {0, 0, 127}));
  connect(switch1.y, limPID.u_s) annotation(
    Line(points = {{-16, 0}, {34, 0}, {34, 0}, {34, 0}, {34, 0}}, color = {0, 0, 127}));
  connect(PumpOn1.y, switch1.u3) annotation(
    Line(points = {{-76, -42}, {-52, -42}, {-52, -8}, {-40, -8}, {-40, -8}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-3, 126}, lineColor = {0, 0, 255}, extent = {{-55, 18}, {55, -18}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><div>Control the speed of a <a href=\"modelica://VirtualFCS.Fluid.PumpElectricDC\">Electric Pump DC</a>&nbsp;or <a href=\"modelica://VirtualFCS.Fluid.RecirculationBlower\">Recirculation Blower</a></div><div><br></div><div><b>Description</b></div><div><br></div>This block uses a simple <a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">PID</a> control to set pump speed as a function of mass flow.&nbsp;<div><br></div><div>The block requires that a sensor be placed to measure the mass flow through the pump in question. The measured value for the mass flow is taken in the getMassFlow interface, while the desired mass flow is set in the setMassFlowInterface. Properties of the&nbsp;<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">PID</a>&nbsp;control can be adjusted in the limPID block, and the resulting control signal is sent to the setPumpSpeed interface.&nbsp;</div></body></html>"));
end PumpSpeedControl;
