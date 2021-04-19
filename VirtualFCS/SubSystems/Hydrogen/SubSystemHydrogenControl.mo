within VirtualFCS.SubSystems.Hydrogen;

class SubSystemHydrogenControl

  parameter Real pressure_H2_set(unit = "Pa") = 200000 "Set H2 Pressure";
  parameter Real massFlow_H2_set(unit = "kg/s") = 1e-2 "Set H2 Recirculation Mass Flow";

  Modelica.Blocks.Routing.Multiplex3 multiplexSignalsH2Subsystem annotation(
    Placement(visible = true, transformation(origin = {124, 40}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getH2MassFlow(y = deMultiplexH2Sensors.y1[1]) annotation(
    Placement(visible = true, transformation(origin = {-81, -62}, extent = {{-23, -16}, {23, 16}}, rotation = 0)));
  VirtualFCS.Control.PurgeValveControl purgeValveControl annotation(
    Placement(visible = true, transformation(origin = {-1, 40}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setH2Pressure(k = pressure_H2_set) annotation(
    Placement(visible = true, transformation(origin = {-1, 113}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  VirtualFCS.Control.PumpSpeedControl pumpSpeedControl annotation(
    Placement(visible = true, transformation(origin = {-3, -44}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setH2MassFlow(k = massFlow_H2_set) annotation(
    Placement(visible = true, transformation(origin = {-86, -14}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface[3] annotation(
    Placement(visible = true, transformation(origin = {210, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput signalInterface_H2[2] annotation(
    Placement(visible = true, transformation(origin = {-218, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-218, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Routing.DeMultiplex2 deMultiplexH2Sensors annotation(
    Placement(visible = true, transformation(origin = {-154, -120}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput signalInterface_FC annotation(
    Placement(visible = true, transformation(origin = {-220, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(pumpSpeedControl.setPumpSpeed, multiplexSignalsH2Subsystem.u3[1]) annotation(
    Line(points = {{31, -44}, {52, -44}, {52, 32}, {66, 32}, {66, 29}, {105, 29}}, color = {0, 0, 127}));
  connect(purgeValveControl.purgeValveControl, multiplexSignalsH2Subsystem.u2[1]) annotation(
    Line(points = {{33, 40}, {105, 40}}, color = {0, 0, 127}));
  connect(getH2MassFlow.y, pumpSpeedControl.getMassFlow) annotation(
    Line(points = {{-56, -62}, {-37, -62}, {-37, -59.5}}, color = {0, 0, 127}));
  connect(setH2Pressure.y, multiplexSignalsH2Subsystem.u1[1]) annotation(
    Line(points = {{15.5, 113}, {52, 113}, {52, 55}, {59.5, 55}, {59.5, 51}, {105, 51}}, color = {0, 0, 127}));
  connect(setH2MassFlow.y, pumpSpeedControl.setMassFlow) annotation(
    Line(points = {{-71, -14}, {-50, -14}, {-50, -28.5}, {-37, -28.5}}, color = {0, 0, 127}));
  connect(multiplexSignalsH2Subsystem.y, controlInterface) annotation(
    Line(points = {{142, 40}, {204, 40}, {204, 40}, {210, 40}}, color = {0, 0, 127}));
  connect(signalInterface_H2, deMultiplexH2Sensors.u) annotation(
    Line(points = {{-218, -120}, {-176, -120}}, color = {0, 0, 127}, thickness = 0.5));
  connect(signalInterface_FC, purgeValveControl.fuelCellCurrent) annotation(
    Line(points = {{-220, 120}, {-102, 120}, {-102, 40}, {-36, 40}, {-36, 40}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-200, 200}, {200, -200}}), Text(origin = {-9, 240}, lineColor = {0, 0, 255}, extent = {{-137, 34}, {137, -34}}, textString = "%name")}));
end SubSystemHydrogenControl;
