within VirtualFCS.SubSystems.Air;

model SubSystemAirControl
  import Modelica.Constants.F;
  constant Modelica.Units.SI.MoleFraction xO2 = 0.21 "Standard molar fraction of oxygen in air";
  constant Modelica.Units.SI.MolarMass MM_O2 = Modelica.Media.IdealGases.Common.SingleGasesData.O2.MM "(kg O2 / mol O2) Molar mass molecular oxygen";
  constant Integer n_O2 = 4 "(mol é / mol O2)";
  parameter Integer N_cells = N_cells "Number of cells in the stack";
  parameter Real lambda = lambda "Air excess ratio";
  parameter Modelica.Units.SI.AbsolutePressure p_set = p_set "Target cathodic pressure";
  parameter Real rh_set = rh_set "Relative humidity setpoint inlet stack";
  Modelica.Blocks.Interfaces.RealInput stackCurrent annotation(
    Placement(transformation(origin = {-220, 130}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, 140}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput airFlowCompressorFeedback annotation(
    Placement(transformation(origin = {-220, 50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput rhToStackFeedback annotation(
    Placement(transformation(origin = {-220, -50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput pressureToStackFeedback annotation(
    Placement(transformation(origin = {-220, -130}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, -140}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput setCompressor annotation(
    Placement(transformation(origin = {220, 130}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {212, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput setBypassValveOpening annotation(
    Placement(transformation(origin = {219, 49}, extent = {{-19, -19}, {19, 19}}), iconTransformation(origin = {212, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput setHumInletValveOpening annotation(
    Placement(transformation(origin = {220, -50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {212, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput setOutletValveOpening annotation(
    Placement(transformation(origin = {220, -130}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {212, -140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain current_to_mass_flow(k = N_cells*lambda*MM_O2/n_O2/F/xO2) annotation(
    Placement(transformation(origin = {-140, 130}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Continuous.LimPID PID_outletValve(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = -1e-4, Ti = 10, yMax = 1, yMin = 0)  annotation(
    Placement(transformation(origin = {0, -130}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Continuous.LimPID PID_humidifierValves(controllerType = Modelica.Blocks.Types.SimpleController.PI, yMax = 0.999, yMin = 0.001, Ti = 0.01)  annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant setRH(k = rh_set)  annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant setPressure(k = p_set) annotation(
    Placement(transformation(origin = {-80, -130}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.001)  annotation(
    Placement(transformation(origin = {80, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(transformation(origin = {148, 50}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant const(k = 1)  annotation(
    Placement(transformation(origin = {80, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Add error_flow(k2 = -1) annotation(
    Placement(transformation(origin = {-50, 130}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.PI PI_compressor(T = 2, initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1e6, x_start = 1, y_start = 1) annotation(
    Placement(transformation(origin = {22, 130}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(stackCurrent, current_to_mass_flow.u) annotation(
    Line(points = {{-220, 130}, {-164, 130}}, color = {0, 0, 127}));
  connect(rhToStackFeedback, PID_humidifierValves.u_m) annotation(
    Line(points = {{-220, -50}, {0, -50}, {0, -24}}, color = {0, 0, 127}));
  connect(pressureToStackFeedback, PID_outletValve.u_m) annotation(
    Line(points = {{-220, -130}, {-130, -130}, {-130, -180}, {0, -180}, {0, -154}}, color = {0, 0, 127}));
  connect(setRH.y, PID_humidifierValves.u_s) annotation(
    Line(points = {{-58, 0}, {-24, 0}}, color = {0, 0, 127}));
  connect(setPressure.y, PID_outletValve.u_s) annotation(
    Line(points = {{-58, -130}, {-24, -130}}, color = {0, 0, 127}));
  connect(PID_outletValve.y, setOutletValveOpening) annotation(
    Line(points = {{22, -130}, {220, -130}}, color = {0, 0, 127}));
  connect(PID_humidifierValves.y, firstOrder.u) annotation(
    Line(points = {{22, 0}, {56, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, setHumInletValveOpening) annotation(
    Line(points = {{102, 0}, {120, 0}, {120, -50}, {220, -50}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{102, 0}, {112, 0}, {112, 38}, {124, 38}}, color = {0, 0, 127}, thickness = 0.75));
  connect(const.y, add.u1) annotation(
    Line(points = {{102, 80}, {108, 80}, {108, 62}, {124, 62}}, color = {0, 0, 127}, thickness = 0.75));
  connect(setBypassValveOpening, add.y) annotation(
    Line(points = {{219, 49}, {195, 49}, {195, 50}, {170, 50}}, color = {0, 0, 127}));
  connect(current_to_mass_flow.y, error_flow.u1) annotation(
    Line(points = {{-118, 130}, {-90, 130}, {-90, 136}, {-62, 136}}, color = {0, 0, 127}));
  connect(airFlowCompressorFeedback, error_flow.u2) annotation(
    Line(points = {{-220, 50}, {-80, 50}, {-80, 124}, {-62, 124}}, color = {0, 0, 127}));
  connect(error_flow.y, PI_compressor.u) annotation(
    Line(points = {{-38, 130}, {-2, 130}}, color = {0, 0, 127}));
  connect(PI_compressor.y, setCompressor) annotation(
    Line(points = {{44, 130}, {220, 130}}, color = {0, 0, 127}));
  annotation (
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics={Text(origin = {-9, 240}, textColor = {0, 0, 255}, extent = {{-137, 34}, {137, -34}}, textString = "%name"), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 2, extent = {{-200, 200}, {200, -200}}, radius = 50), Text(  textColor = {255, 0, 0},extent = {{-200, 100}, {200, -100}}, textString = "Air
Control")}),
    Documentation(info = "<html><head></head><body>TO BE UPDATED</body></html>"));

end SubSystemAirControl;
