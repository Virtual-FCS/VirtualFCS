within VirtualFCS.Chemical.AmmoniaCracker;

model ElectricHeatingDistr
  parameter Integer N = size(heatWeights, 1) "Number of reactor computational segments";
  parameter Boolean useHeatFilter = false "Enable a gradual heater startup";
  parameter Modelica.Units.SI.Time T_heatFilter = 1e-3 "Time constant limiting the heater power rise";
  parameter Real heatWeights[:] = {1.8, 1.5, 1.2, 1.0, 0.9, 0.8, 0.7, 0.6, 0.3, 0.2} "Relative heat distribution weights from inlet to outlet";
  parameter Modelica.Units.SI.Temperature T_out_target = 550 + 273.15 "Target temperature";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPorts[N] "Segmented heat input ports" annotation(
    Placement(transformation(origin = {0, -100}, extent = {{-40, -10}, {40, 10}}), iconTransformation(origin = {0, -100}, extent = {{-40, -10}, {40, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow[N] annotation(
    Placement(transformation(origin = {30, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PI_heater(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = 1e3, yMax = 1e6, yMin = 0) annotation(
    Placement(transformation(origin = {-8, -8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder heatFilter(T = T_heatFilter, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0) if useHeatFilter annotation(
    Placement(transformation(origin = {8, -8}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Gain heatDistribution[N](k = {heatWeights[i]/sum(heatWeights) for i in 1:N}) if useHeatFilter;
  Modelica.Blocks.Sources.RealExpression temp_cracked_target(y = T_out_target) annotation(
    Placement(transformation(origin = {-46, -8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput T_meas annotation(
    Placement(transformation(origin = {-100, -36}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-94, -30}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(temp_cracked_target.y, PI_heater.u_s) annotation(
    Line(points = {{-35, -8}, {-20, -8}}, color = {0, 0, 127}));
  if useHeatFilter then
    connect(PI_heater.y, heatFilter.u);
    for i in 1:N loop
      connect(heatFilter.y, heatDistribution[i].u);
      connect(heatDistribution[i].y, prescribedHeatFlow[i].Q_flow);
    end for;
  else
    for i in 1:N loop
      connect(PI_heater.y, prescribedHeatFlow[i].Q_flow);
    end for;
  end if;
  connect(prescribedHeatFlow.port, heatPorts) annotation(
    Line(points = {{40, -10}, {60, -10}, {60, -66}, {0, -66}, {0, -100}}, color = {191, 0, 0}));
  connect(T_meas, PI_heater.u_m) annotation(
    Line(points = {{-100, -36}, {-8, -36}, {-8, -20}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Rectangle(fillColor = {215, 230, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Text(extent = {{-100, 100}, {100, 66}}, textString = "%name")}));
end ElectricHeatingDistr;
