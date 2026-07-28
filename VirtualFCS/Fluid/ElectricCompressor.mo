within VirtualFCS.Fluid;

model ElectricCompressor
  extends VirtualFCS.Fluid.ElectricCompressorInterface;
  replaceable Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet motor(IaNominal = 30, Jr = 0.15, Js = 0.29, La(displayUnit = "mH") = 0.0015, Ra(displayUnit = "mOhm") = 0.05, TaNominal = 293.15, TaOperational = 293.15, TaRef = 293.15, VaNominal = 100, alpha20a = 0, wMechanical(displayUnit = "rpm"), wNominal(displayUnit = "rpm") = 125.66370614359174) annotation(
    Placement(transformation(origin = {-10, -12}, extent = {{-10, -10}, {10, 10}})));
  replaceable Modelica.Electrical.Machines.Examples.ControlledDCDrives.Utilities.IdealDcDc converter(Td(displayUnit = "ms") = 0.001, Ti(displayUnit = "ms") = 0.001) annotation(
    Placement(transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}})));
  replaceable Compressor compressor(redeclare final package Medium = Medium, useHeatPort=useHeatPort, RPM_nom = motor.wNominal) annotation(
    Placement(transformation(origin = {50, -12}, extent = {{-30, -30}, {30, 30}})));
  Modelica.Blocks.Continuous.LimPID K(Ti = 0.1, controllerType = Modelica.Blocks.Types.SimpleController.PI, k = 2e3, yMax = 300, yMin = 0) annotation(
    Placement(transformation(origin = {-50, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Sensors.MassFlowRate airInflow(redeclare final package Medium = Medium) annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(compressor.port_b, port_b) annotation(
    Line(points = {{80, 0}, {100, 0}}, color = {0, 127, 255}));
  connect(motor.flange, compressor.flange_a) annotation(
    Line(points = {{0, -12}, {20, -12}}));
  connect(airInflow.port_a, port_a) annotation(
    Line(points = {{-60, 0}, {-100, 0}}, color = {0, 127, 255}));
  connect(airInflow.port_b, compressor.port_a) annotation(
    Line(points = {{-40, 0}, {20, 0}}, color = {0, 127, 255}));
  connect(airInflow.m_flow, K.u_m) annotation(
    Line(points = {{-50, 12}, {-50, 48}}, color = {0, 0, 127}));
  connect(K.y, converter.vRef) annotation(
    Line(points = {{-39, 60}, {-23, 60}}, color = {0, 0, 127}));
  connect(motor.pin_an, converter.pin_nMot) annotation(
    Line(points = {{-16, -2}, {-16, 20}, {-20, 20}, {-20, 50}}));
  connect(motor.pin_ap, converter.pin_pMot) annotation(
    Line(points = {{-4, -2}, {-4, 20}, {0, 20}, {0, 50}}, color = {255, 0, 0}));
  connect(pin_n, converter.pin_nBat) annotation(
    Line(points = {{-60, 100}, {-20, 100}, {-20, 70}}));
  connect(pin_p, converter.pin_pBat) annotation(
    Line(points = {{60, 100}, {0, 100}, {0, 70}}, color = {255, 0, 0}));
  connect(K.u_s, massflow) annotation(
    Line(points = {{-62, 60}, {-120, 60}}, color = {0, 0, 127}));
  connect(compressor.heatPort, heatPort) annotation(
    Line(points = {{20, -42}, {20, -100}, {-100, -100}}, color = {191, 0, 0}));
annotation(
    Documentation(info = "<html><head></head><body><div>This is an implementation of an electric compressor assembly. The unit contains a compressor driven by a DC motor, voltage-controlled by a converter, which is in turn manipulated by a PI controller that attempts to match the reference flow to the inlet flow.</div><div><br></div><div>Note that the unit has an internal controller (by default PI) that needs to be properly tuned to the problem.</div><div>Bad tuning will often show up as high-frequency oscillations in the controller output, which will slow down simulation; detune the controller gain in that case.</div></body></html>"));
end ElectricCompressor;
