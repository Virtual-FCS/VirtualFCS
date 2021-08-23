within VirtualFCS.Electrochemical.Battery;

model LiIonBatteryPack_Composite "A Li-ion battery pack comprised of individual Li-ion cell models."
  // DECLARE PARAMETERS //
  // Physical parameters
  parameter Real mass(unit = "kg") = 0.050 "Mass of the pack";
  //  parameter Real vol(unit = "L") = 0.016 "Volume of the pack";
  parameter Real Cp(unit = "J/(kg.K)") = 1000 "Specific Heat Capacity";
  // Pack design parameters
  parameter Real SOC_init(unit = "1") = 0.5 "Initial State of Charge";
  parameter Integer p = 5 "Number of Cells in Parallel";
  parameter Integer s = 10 "Number of Cells in Series";
  
  parameter Real coolingArea = p * s * liIonCell[1].coolingArea "Cooling Area";
  Real chargeCapacity;
  
  VirtualFCS.Electrochemical.Battery.LiIonCell liIonCell[s * p](each SOC_init = 0.5) annotation(
    Placement(visible = true, transformation(origin = {0, 50.3333}, extent = {{-37, -24.6667}, {37, 24.6667}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-90, 92}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m = s * p)  annotation(
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 7.8 * 10 ^ 0.78 * coolingArea) annotation(
    Placement(visible = true, transformation(origin = {80, -50}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {20, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * coolingArea) annotation(
    Placement(visible = true, transformation(origin = {-20, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatBoundary annotation(
    Placement(visible = true, transformation(origin = {0, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// ***DEFINE EQUATIONS ***//
  chargeCapacity = p * s * liIonCell[1].chargeCapacity;
// coolingArea = p * s * liIonCell[1].coolingArea;
// Calculate the open-circuit voltage at given temperature and state of charge
// Thermal equations
//  prescribedHeatFlow.Q_flow = p * s * abs((OCV.v - pin_p.v) * sensorCurrent.i + Rohm.R_actual * sensorCurrent.i ^ 2);
// ***DEFINE CONNECTIONS ***//
  for i in 1:p loop
    connect(pin_n, liIonCell[s * (i - 1) + 1].pin_n);
    connect(pin_p, liIonCell[i * s].pin_p);
  end for;
  for i in 1:p loop
    for j in 1:s - 1 loop
      connect(liIonCell[s * (i - 1) + j].pin_p, liIonCell[s * (i - 1) + j + 1].pin_n);
    end for;
  end for;
  connect(liIonCell.heatPort, thermalCollector.port_a) annotation(
    Line(points = {{0, 43}, {0, 20}}, color = {191, 0, 0}, thickness = 0.5));
  connect(pin_n, ground.p) annotation(
    Line(points = {{-90, 92}, {-90, 92}, {-90, 60}, {-90, 60}}, color = {0, 0, 255}));
  connect(thermalCollector.port_b, heatPort) annotation(
    Line(points = {{0, 0}, {0, -20}}, color = {191, 0, 0}));
  connect(convection.Gc, setConvectiveCoefficient.y) annotation(
    Line(points = {{30, -50}, {64, -50}, {64, -50}, {64, -50}}, color = {0, 0, 127}));
  connect(heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{0, -20}, {0, -20}, {0, -32}, {-20, -32}, {-20, -40}, {-20, -40}}, color = {191, 0, 0}));
  connect(heatPort, convection.solid) annotation(
    Line(points = {{0, -20}, {0, -20}, {0, -32}, {20, -32}, {20, -40}, {20, -40}}, color = {191, 0, 0}));
  connect(bodyRadiation.port_b, heatBoundary) annotation(
    Line(points = {{-20, -60}, {-20, -60}, {-20, -68}, {0, -68}, {0, -84}, {0, -84}}, color = {191, 0, 0}));
  connect(convection.fluid, heatBoundary) annotation(
    Line(points = {{20, -60}, {20, -60}, {20, -68}, {0, -68}, {0, -84}, {0, -84}}, color = {191, 0, 0}));
protected
  annotation(
    Icon(graphics = {Rectangle(origin = {0, -15}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-130, 85}, {130, -75}}), Rectangle(origin = {0, 85}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-150, 15}, {150, -15}}), Text(origin = {68, 93}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {10, -19}}, textString = "+"), Text(origin = {-74, 105}, lineColor = {255, 255, 255}, extent = {{-22, 15}, {52, -41}}, textString = "-"), Text(origin = {-34, -103}, lineColor = {0, 0, 255}, extent = {{-22, 15}, {86, -41}}, textString = "%name")}, coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(initialScale = 0.05, extent = {{-150, -90}, {150, 100}})),
    version = "",
  Documentation(info = "<html><head></head><body><div>This model describes a lithium-ion battery pack as a composite of <a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonCell\">LiIonCell models</a>. This setup has the advantage of being able to consider the performance of each individual cell, which may be useful for some investiations such as cell-balancing. However, it can also lead to a very large system of equations for complex models with many cells causing high computational cost.&nbsp;</div><div><br></div><div><b><u>Default Parameters</u></b></div><div>mass <span class=\"Apple-tab-span\" style=\"white-space:pre\">		</span>= 2.5&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>kg</div><div>Cp&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">		</span>= 1000&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>J/(kg.K)</div><div>SOC_init&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>= 0.5&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>-</div><div>p<span class=\"Apple-tab-span\" style=\"white-space:pre\">		</span>= 5<span class=\"Apple-tab-span\" style=\"white-space:pre\">		</span>Cells in parallel</div><div>s&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">		</span>= 10&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">		</span>Cells in series</div><div><br></div></body></html>"));
end LiIonBatteryPack_Composite;
