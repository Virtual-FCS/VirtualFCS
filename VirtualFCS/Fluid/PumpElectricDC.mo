within VirtualFCS.Fluid;

model PumpElectricDC
  // System
  inner Modelica.Fluid.System system "System wide properties";
  //*** DEFINE REPLACEABLE PACKAGES ***//
  // Medium declaration
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby Modelica.Media.Interfaces.PartialMedium;
  //*** INSTANTIATE COMPONENTS ***//
  // Interfaces and boundaries
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-10, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensors[2] annotation(
    Placement(visible = true, transformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Fluid.Interfaces.FluidPort_b Output(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {99, -60}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a Input(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-99, -60}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Control components
  Modelica.Blocks.Routing.Multiplex2 multiplex2(n1 = 1, n2 = 1) annotation(
    Placement(visible = true, transformation(origin = {82, 90}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput contol_input annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  VirtualFCS.Control.DCMotorControlPumpElectricDC dCMotorControlPumpElectricDC annotation(
    Placement(visible = true, transformation(origin = {-20, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  // Machines
  Modelica.Fluid.Machines.PrescribedPump pump(redeclare package Medium = Medium, redeclare function flowCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow(V_flow_nominal = {0, 0.25, 0.5}, head_nominal = {100, 60, 0}), redeclare function efficiencyCharacteristic = Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.constantEfficiency(eta_nominal = 0.1), N_nominal = 500, V = 0.005, checkValve = true, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, medium(preferredMediumStates = false), nParallel = 1, p_a_start = 102502, use_N_in = true) annotation(
    Placement(visible = true, transformation(origin = {20, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(IaNominal = driveData.motorData.IaNominal, Jr = driveData.motorData.Jr, Js = driveData.motorData.Js, La = driveData.motorData.La, Ra = driveData.motorData.Ra, TaNominal = driveData.motorData.TaNominal, TaOperational = driveData.motorData.TaNominal, TaRef = driveData.motorData.TaRef, VaNominal = driveData.motorData.VaNominal, alpha20a = driveData.motorData.alpha20a, brushParameters = driveData.motorData.brushParameters, coreParameters = driveData.motorData.coreParameters, frictionParameters = driveData.motorData.frictionParameters, ia(fixed = true), phiMechanical(fixed = true), strayLoadParameters = driveData.motorData.strayLoadParameters, wMechanical(fixed = true, start = 0.10472), wNominal = driveData.motorData.wNominal) annotation(
    Placement(visible = true, transformation(origin = {-20, -6}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.15) annotation(
    Placement(visible = true, transformation(origin = {50, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter VirtualFCS.Utilities.ParameterRecords.DriveDataCpump driveData annotation(
    Placement(visible = true, transformation(extent = {{-64, -16}, {-44, 4}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(visible = true, transformation(origin = {80, -6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Sensors
  Modelica.Fluid.Sensors.VolumeFlowRate volumeFlowRate(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-79, -60}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {60, 22}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  // Other
  Modelica.Blocks.Math.Gain gain(k = 9.5493) annotation(
    Placement(visible = true, transformation(origin = {20, -28}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  // Power & Efficiency
  Modelica.Units.SI.Power Power_PumpElectricDC "The power consumed by the PumpElectricDC";
  Modelica.Blocks.Math.Gain gain1(k = pump.N_nominal) annotation(
    Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
equation
  torque.tau = -9.5488*pump.W_total/pump.N;
  Power_PumpElectricDC = pin_p.i*pin_p.v;
//*** DEFINE CONNECTIONS ***//
  connect(multiplex2.y, sensors) annotation(
    Line(points = {{90.8, 90}, {110, 90}}, color = {0, 0, 127}));
  connect(volumeFlowRate.port_a, Input) annotation(
    Line(points = {{-90, -60}, {-99, -60}}, color = {0, 0, 255}, thickness = 1.5));
  connect(volumeFlowRate.V_flow, multiplex2.u1[1]) annotation(
    Line(points = {{-79, -47.9}, {-80, -47.9}, {-80, 94.8}, {72.4, 94.8}}, color = {0, 0, 127}));
  connect(multiplex2.u2[1], speedSensor.w) annotation(
    Line(points = {{72.4, 85.2}, {60, 85.2}, {60, 33}}, color = {0, 0, 127}));
  connect(dcpm.flange, inertia.flange_a) annotation(
    Line(points = {{-6, -6}, {40, -6}}));
  connect(inertia.flange_b, torque.flange) annotation(
    Line(points = {{60, -6}, {70, -6}}));
  connect(inertia.flange_b, speedSensor.flange) annotation(
    Line(points = {{60, -6}, {60, 12}}));
  connect(pin_n, dCMotorControlPumpElectricDC.pwr_pin_n) annotation(
    Line(points = {{-30, 80}, {-30, 68}, {-26, 68}, {-26, 58}}, color = {0, 0, 255}));
  connect(pin_p, dCMotorControlPumpElectricDC.pwr_pin_p) annotation(
    Line(points = {{-10, 80}, {-10, 68}, {-14, 68}, {-14, 58}}, color = {0, 0, 255}));
  connect(dCMotorControlPumpElectricDC.pin_n, dcpm.pin_an) annotation(
    Line(points = {{-26, 22}, {-26, 14}, {-28.4, 14}, {-28.4, 8}}, color = {0, 0, 255}));
  connect(dCMotorControlPumpElectricDC.pin_p, dcpm.pin_ap) annotation(
    Line(points = {{-14, 22}, {-14, 14}, {-11.6, 14}, {-11.6, 8}}, color = {0, 0, 255}));
  connect(volumeFlowRate.port_b, pump.port_a) annotation(
    Line(points = {{-68, -60}, {10, -60}}, color = {0, 0, 255}, thickness = 1.5));
  connect(pump.port_b, Output) annotation(
    Line(points = {{30, -60}, {99, -60}}, color = {0, 0, 255}, thickness = 1.5));
  connect(speedSensor.w, dCMotorControlPumpElectricDC.measuredSpeedInput) annotation(
    Line(points = {{60, 33}, {60, 40}, {4, 40}}, color = {0, 0, 127}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{60, 33}, {60, 40}, {20, 40}, {20, -18.4}}, color = {0, 0, 127}));
  connect(gain.y, pump.N_in) annotation(
    Line(points = {{20, -36.8}, {20, -50}}, color = {0, 0, 127}));
  connect(contol_input, gain1.u) annotation(
    Line(points = {{-110, 40}, {-77.2, 40}}, color = {0, 0, 127}));
  connect(gain1.y, dCMotorControlPumpElectricDC.setSpeedInput) annotation(
    Line(points = {{-63.4, 40}, {-44, 40}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Ellipse(origin = {-2, -15}, fillColor = {208, 208, 208}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-78, 95}, {82, -65}}), Line(origin = {40, 40}, points = {{-40, 40}, {40, -40}, {40, -40}}, thickness = 3), Line(origin = {40, -40}, points = {{-40, -40}, {40, 40}, {40, 40}}, thickness = 3)}),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<div><p class=\"MsoNormal\"><b>References to base model/related packages</b></p><p class=\"MsoNormal\"><a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">Permanent Magnet DC Motor</a>, <a href=\"modelica://Modelica.Fluid.Machines.PrescribedPump\">Prescribed Pump</a>, <a href=\"modelica://VirtualFCS.Control.DCMotorControlPumpElectricDC\">DC Motor Control</a></p><p class=\"MsoNormal\"><o:p></o:p></p>

<p class=\"MsoNormal\"><b>Description</b></p><p class=\"MsoNormal\">The model has three parts input (volume flow rate, control signal motor speed), subcomponents (<a href=\"modelica://Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet\">Permanent Magnet DC Motor</a>,&nbsp;<a href=\"modelica://Modelica.Fluid.Machines.PrescribedPump\">Prescribed Pump</a>,&nbsp;<a href=\"modelica://VirtualFCS.Control.DCMotorControlPumpElectricDC\">DC Motor Control</a>), and output (pump outlet volume flow rate and sensors (inlet&nbsp;volume flow rate and pump speed).</p><p class=\"MsoNormal\"><b><o:p></o:p></b></p>

<p class=\"MsoNormal\">The inlet volume flow rate is measured and depending on the rotational speed estimated by the&nbsp;<a href=\"modelica://VirtualFCS.Control.DCMotorControlPumpElectricDC\">DC Motor Control</a>&nbsp;the&nbsp;<a href=\"modelica://Modelica.Fluid.Machines.PrescribedPump\">Prescribed Pump</a>&nbsp;changes the flow rate accordingly. &nbsp;</p></div>
<h2>Governing Equations</h2>
<pre>torque.tau = -9.5488*pump.W_total/pump.N;
Power_PumpElectricDC = pin_p.i*pin_p.v;</pre><table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Quantity</th><th>Description</th></tr>
<tr><td><code>Power_PumpElectricDC</code></td><td>The power consumed by the PumpElectricDC</td></tr>
</tbody></table>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>driveData</code></td><td>VirtualFCS.Utilities.ParameterRecords.DriveDataCpump</td><td>-</td><td><code>-</code></td><td></td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>pin_p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical terminal</td></tr>
<tr><td><code>Input</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_a</td><td>Pa; kg/s; J/kg</td><td></td></tr>
<tr><td><code>contol_input</code></td><td>Input signal</td><td>Modelica.Blocks.Interfaces.RealInput</td><td>-</td><td></td></tr>
<tr><td><code>pin_n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical terminal</td></tr>
<tr><td><code>Output</code></td><td>Connection</td><td>Modelica.Fluid.Interfaces.FluidPort_b</td><td>Pa; kg/s; J/kg</td><td></td></tr>
<tr><td><code>sensors</code></td><td>Output signal</td><td>Modelica.Blocks.Interfaces.RealOutput[2]</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end PumpElectricDC;
