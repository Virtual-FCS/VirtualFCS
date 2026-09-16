within VirtualFCS.Fluid;

model RecirculationBlower
  import Modelica.Constants.pi;
  // System
  outer Modelica.Fluid.System system "System properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2;
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {-100, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {-40, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {-60, 100}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}})));
  // Control components
  Modelica.Blocks.Interfaces.RealOutput sen_H2_pump_speed annotation(
    Placement(transformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput controlInterface annotation(
    Placement(transformation(origin = {-114, 40}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gain(k = pump.N_nominal) annotation(
    Placement(transformation(origin = {-88, 40}, extent = {{-6, -6}, {6, 6}})));
  // Machines
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{-62, -26}, {-42, -6}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(visible = true, transformation(origin = {-20, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter VirtualFCS.Utilities.ParameterRecords.DriveDataRBlower driveData annotation(
    Placement(visible = true, transformation(extent = {{-90, -24}, {-70, -4}}, rotation = 0)));
  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow(V_flow_nominal = {0, 0.00365}, head_nominal = {500000, 100000}), N_nominal = 100, T_start = 323.15, V(displayUnit = "l") = 0.006, allowFlowReversal = false, checkValve = true, checkValveHomotopy = Modelica.Fluid.Types.CheckValveHomotopyType.Closed, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, massDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, medium(preferredMediumStates = false), nParallel = 1, use_N_in = true, use_T_start = true) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(visible = true, transformation(origin = {8, -16}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Sensors
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {24, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Other
  VirtualFCS.Control.DCMotorControlRecirculationBlower dCMotorControlRecirculationBlower annotation(
    Placement(transformation(origin = {-50, 40}, extent = {{-20, -20}, {20, 20}})));
  // Power & Efficiencies
  Modelica.Units.SI.Power Power_RecirculationBlower "The power consumed by the RecirculationBlower";
equation
  torque.tau = -9.5488*pump.W_total/pump.N;
  Power_RecirculationBlower = pin_p.i*pin_p.v;
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-40, -16}, {-30, -16}}));
  connect(speedSensor.w, rad_sToRpm.u) annotation(
    Line(points = {{35, 6}, {40, 6}, {40, -19}}, color = {0, 0, 127}));
  connect(rad_sToRpm.y, pump.N_in) annotation(
    Line(points = {{40, -35}, {40, -40}, {0, -40}, {0, -50}}, color = {0, 0, 127}));
  connect(pump.port_b, Output) annotation(
    Line(points = {{10, -60}, {100, -60}}, color = {0, 170, 0}, thickness = 1));
  connect(pump.port_a, Input) annotation(
    Line(points = {{-10, -60}, {-100, -60}}, color = {0, 170, 0}, thickness = 1));
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{-10, -16}, {-2, -16}}));
  connect(speedSensor.flange, inertia.flange_b) annotation(
    Line(points = {{14, 6}, {-10, 6}, {-10, -16}}));
  connect(controlInterface, gain.u) annotation(
    Line(points = {{-114, 40}, {-95, 40}}, color = {0, 0, 127}));
  connect(gain.y, dCMotorControlRecirculationBlower.setSpeedInput) annotation(
    Line(points = {{-81, 40}, {-74, 40}}, color = {0, 0, 127}));
  connect(dcpm.pin_an, dCMotorControlRecirculationBlower.pin_n) annotation(
    Line(points = {{-56, -6}, {-56, 22}}, color = {0, 0, 255}));
  connect(dCMotorControlRecirculationBlower.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-44, 22}, {-44, -6}}, color = {0, 0, 255}));
  connect(pin_n, dCMotorControlRecirculationBlower.pwr_pin_n) annotation(
    Line(points = {{-60, 100}, {-60, 80}, {-56, 80}, {-56, 58}}, color = {0, 0, 255}));
  connect(pin_p, dCMotorControlRecirculationBlower.pwr_pin_p) annotation(
    Line(points = {{-40, 100}, {-40, 80}, {-44, 80}, {-44, 58}}, color = {0, 0, 255}));
  connect(speedSensor.w, dCMotorControlRecirculationBlower.measuredSpeedInput) annotation(
    Line(points = {{35, 6}, {40, 6}, {40, 40}, {-26, 40}}, color = {0, 0, 127}));
  connect(speedSensor.w, sen_H2_pump_speed) annotation(
    Line(points = {{36, 6}, {110, 6}}, color = {0, 0, 127}));
protected
  Modelica.Blocks.Math.Gain rad_sToRpm(k = 60/2/pi) annotation(
    Placement(transformation(origin = {40, -27}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  annotation(
    Icon(graphics = {Polygon(visible = false, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = false, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Polygon(visible = false, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Ellipse(origin = {-26, 26}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-54, 54}, {106, -106}}), Polygon(origin = {70, -5}, rotation = -90, lineThickness = 1, points = {{-6, 9}, {-18, -9}, {6, -9}, {6, -9}, {-6, 9}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>driveData</code></td><td>VirtualFCS.Utilities.ParameterRecords.DriveDataRBlower</td><td>-</td><td><br></td><td></td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>Input</code></td><td>Input-side interface</td><td>FluidPort_a</td><td>-</td><td></td></tr>
<tr><td><code>pin_p</code></td><td>Input-side interface</td><td>PositivePin</td><td>-</td><td></td></tr>
<tr><td><code>controlInterface</code></td><td>Input</td><td>RealInput</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2>The RecirculationBlower model is designed to maintain hydrogen gas circulation within the hydrogen subsystem.&nbsp;<div><br></div><div><b>Description</b></div><div><b><br></b></div><div>The model features 5 interfaces: fluid ports in and out, electrical ports for positive and negative pins, and a control port. The fluid ports provide the upstream and downstream connections for the Recirculation Blower, the electrical ports connect to the low-voltage power supply for the BoP components and the control port sets the rpm of the blower. A <a href=\"&quot;modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet&quot;\">DC motor</a> drives the recirculation blower and is connected to an inertia and torque source, which is linked to the resistance of the pump.</div><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>torque.tau = -9.5488*pump.W_total/pump.N;
Power_RecirculationBlower = pin_p.i*pin_p.v;</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>Output</code></td><td>Output-side interface</td><td>FluidPort_b</td><td>-</td><td></td></tr>
<tr><td><code>pin_n</code></td><td>Output-side interface</td><td>NegativePin</td><td>-</td><td></td></tr>
<tr><td><code>sen_H2_pump_speed</code></td><td>Output</td><td>RealOutput</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end RecirculationBlower;
