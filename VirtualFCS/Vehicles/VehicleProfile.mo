within VirtualFCS.Vehicles;

model VehicleProfile "Calculates the driving power for a vehicle that corresponds to a given speed profile."
  import Modelica.Units.Conversions.from_kmh;
  import Modelica.Units.Conversions.to_rpm;
  import Modelica.Constants.g_n;
  
  parameter Boolean useRegenerativeBraking = true annotation(
    choices(checkBox = true));

  parameter Modelica.Units.SI.Mass m = 1920 "Mass of the vehicle";
  parameter Modelica.Units.SI.Density rho_air = 1.2 "Volumic mass of the air";
  parameter Modelica.Units.SI.Area A_front = 2.35 "Frontal area of the vehicle";
  parameter Modelica.Units.SI.CoefficientOfFriction C_D = 0.29 "Drag coefficient";
  parameter Modelica.Units.SI.CoefficientOfFriction C_roll = 0.009 "Rolling resistance coefficient";
  parameter Modelica.Units.SI.Diameter D_tire = 0.729 "Tire Diameter";
  parameter Modelica.Units.SI.DimensionlessRatio R_gear = 11.691 "Reduction Gear Ratio";
  parameter Modelica.Units.SI.Efficiency eff_drivetrain = 0.9 "Efficiency of the drivetrain";
  parameter Modelica.Units.SI.Efficiency eff_brake = 0.65 "Efficiency of the regenerative braking";
  
  Modelica.Units.SI.Position x "Position";
  Modelica.Units.SI.Velocity v = der(x) "Speed of the vehicle in m/s";
  Modelica.Units.SI.Acceleration a = der(v) "Vehicle acceleration";
  Modelica.Units.SI.Force F_accel = m*a "Vehicle acceleration resistance";
  Modelica.Units.SI.Force F_drag = 0.5*C_D*rho_air*v^2*A_front "Air resistance";
  Modelica.Units.SI.Force F_roll = C_roll*m*g_n "Rolling resistance";
  Modelica.Units.SI.Force F_total = F_drag + F_accel + F_roll "Vehicle total resistance";
  Modelica.Units.SI.AngularVelocity omega_engine = v*R_gear/(0.5*D_tire) "Motor Rotation, rad/s";
  Modelica.Units.NonSI.AngularVelocity_rpm N_engine = to_rpm(omega_engine) "Motor Rotation, rpm";
  Modelica.Units.SI.Power P = F_total*v "Total power demand";
  Modelica.Units.SI.Power powerOutput = noEvent(if P >= 0 then P/eff_drivetrain else (if useRegenerativeBraking then P*eff_brake else 0)) "Power drawn from the electrical circuit";
  
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(extent = {{80, -60}, {100, -40}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {100, 40}, extent = {{10, -10}, {-10, 10}}), iconTransformation(extent = {{100, 40}, {80, 60}})));
  Modelica.Blocks.Interfaces.RealInput vehicleVelocity annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression power(y = powerOutput) annotation(
    Placement(transformation(extent = {{-22, -10}, {-2, 10}})));
  Electrical.PowerSource powerSource annotation(
    Placement(transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  v = from_kmh(vehicleVelocity);
  connect(pin_p, powerSource.p) annotation(
    Line(points = {{100, 40}, {40, 40}, {40, 10}}, color = {0, 0, 255}));
  connect(pin_n, powerSource.n) annotation(
    Line(points = {{100, -40}, {40, -40}, {40, -10}}, color = {0, 0, 255}));
  connect(power.y, powerSource.P) annotation(
    Line(points = {{-1, 0}, {34, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.05), graphics = {Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle(lineColor = {60, 0, 40}, fillColor = {120, 0, 80}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(origin = {0, 6}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, lineThickness = 1.5, points = {{-66.6, -14}, {-66.6, -10}, {-66.6, -4}, {-66.6, 0}, {-66.6, 2}, {-66, 3.4}, {-64, 5.9}, {-60, 10}, {-56, 14}, {-52, 18}, {-48, 22}, {-46, 24}, {-44, 25.6}, {-42, 26.4}, {-40, 27}, {-38, 27.2}, {-34, 27.2}, {-28, 27.2}, {-18, 27.2}, {-8, 27.2}, {2, 27.2}, {6, 27.2}, {8, 27.2}, {10, 27}, {12, 26.2}, {14, 25.1}, {15, 24.1}, {16, 23.2}, {18, 21.3}, {22, 17.5}, {26, 13.5}, {30, 9.5}, {32, 7.4}, {34, 5.5}, {35, 4.4}, {36, 3.8}, {37, 3.4}, {38, 3.2}, {42, 3.2}, {48, 3.2}, {50, 3.2}, {52, 3.2}, {54, 3}, {56, 2.4}, {58, 1.6}, {60, 0.3}, {62, -1.5}, {63, -2.5}, {64, -4}, {65.2, -6}, {65.9, -8}, {66.5, -12}, {66.5, -18}, {66.5, -22}, {65.8, -24}, {64, -26}, {62, -27}, {58, -27.1}, {42, -27.1}, {20, -27.1}, {4, -27.1}, {-16, -27.1}, {-38, -27.1}, {-50, -27.1}, {-54, -27.1}, {-56, -27.1}, {-58, -26.6}, {-60, -25.9}, {-61, -25.3}, {-62, -24.6}, {-63, -23.7}, {-64, -22.6}, {-65, -21.2}, {-66, -19}, {-66.3, -18}, {-66.6, -16}, {-66.6, -15}, {-66.6, -14}}, smooth = Smooth.Bezier), Ellipse(origin = {-36.4, -21}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-16.5, 16.5}, {16.5, -16.5}}), Ellipse(origin = {-36.4, -21}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12, 12}, {12, -12}}), Rectangle(origin = {-29, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{9.2, -9.9}, {-9.2, 8.1}}), Polygon(origin = {-51, 17}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-7, -7.9}, {9, 8}, {9, -7.9}, {-7, -7.9}}), Polygon(origin = {-40, 23}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-2.5, 1.5}, {-2, 2}, {-1, 2.8}, {0, 3.6}, {1, 4.1}, {3, 4.1}, {3, -3}, {-4, -3}, {-4, -1}, {-2.5, 1.5}}, smooth = Smooth.Bezier), Rectangle(origin = {-40, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, -9.9}, {4, 4}}), Rectangle(origin = {-4.7, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{12, -9.9}, {-9.2, 8.1}}), Ellipse(origin = {36.2, -21}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-16.5, 16.5}, {16.5, -16.5}}), Ellipse(origin = {36.2, -21}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12, 12}, {12, -12}}), Polygon(origin = {5, 17}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{22.5, -7.9}, {6.5, 8}, {6.5, -7.9}, {22.5, -7.9}}), Rectangle(origin = {8, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, -9.9}, {4, 4}}), Polygon(origin = {7, 22}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-3, 5}, {0, 5.1}, {1, 5}, {2, 4.8}, {3, 4.4}, {4, 3.6}, {5, 2.6}, {5, -6}, {-5, -6}, {-3, 5}}, smooth = Smooth.Bezier)}),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.</p><p>Vehicle-specific parameter defaults are tuned to available data for the 2<sup>nd</sup>-generation Toyota Mirai.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>m</code></td><td>SI.Mass</td><td>kg</td><td>1920</td><td>Vehicle mass (default is a Toyota Mirai)</td></tr>
<tr><td><code>rho_air</code></td><td>SI.Density</td><td>kg/m<sup>3</sup></td><td>1.2</td><td>Air density</td></tr>
<tr><td><code>A_front</code></td><td>SI.Area</td><td>m<sup>2</sup></td><td>2.35</td><td>Front area of the vehicle</td></tr>
<tr><td><code>C_D</code></td><td>SI.CoefficientOfFriction</td><td>-</td><td>0.29</td><td>Drag coefficient</td></tr>
<tr><td><code>C_roll</code></td><td>SI.CoefficientOfFriction</td><td>-</td><td>0.009</td><td>Rolling resistance coefficient</td></tr>
<tr><td><code>D_tire</code></td><td>SI.Diameter</td><td>m</td><td>0.729</td><td>Tire Diameter</td></tr>
<tr><td><code>R_gear</code></td><td>SI.DimensionlessRatio</td><td>1</td><td>11.691</td><td>Reduction Gear Ratio</td></tr>
<tr><td><code>useRegenerativeBraking</code></td><td>Boolean</td><td>1</td><td>true</td><td>If true, allows negative power duriing braking.&nbsp;</td></tr>
<tr><td><code>eff_drivetrain</code></td><td>SI.Efficiency</td><td>1</td><td>0.9</td><td>Efficiency of the drivetrain</td></tr>
<tr><td><code>eff_brake</code></td><td>SI.Efficiency</td><td>1</td><td>0.65</td><td>Efficiency of the regenerative braking</td></tr></tbody></table><h3>Inputs</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>vehicleVelocity</code></td><td>Input</td><td>RealInput</td><td>km/h</td><td>Speed of vehicle along drive cycle</td></tr></tbody></table><h2>2. Model description</h2><div>The VehicleProfile block is designed to replicate the power demand of a vehicle considering a pre-determined drive cycle and vehicle parameters such as weight and frontal area. The generated power profile considers the needs to propel the vehicle plus the aerodynamic drag. The block allows the user to select if regenerative braking is used or not.</div></body></html>"));
end VehicleProfile;
