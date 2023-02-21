within VirtualFCS.Vehicles;

model VehicleProfile "Calculates the driving power for a vehicle that corresponds to a given speed profile."
  import Modelica.Blocks.Tables.Internal;
  type vehicle_name = enumeration(Default "Default", Mirai "Mirai", UserDefined "User Defined") annotation(
    Evaluate = true);
  parameter vehicle_name VN = VirtualFCS.Vehicles.VehicleProfile.vehicle_name.Default "Vehicle name";
  //parameter
  Modelica.Units.SI.Mass m "mass of the vehicle";
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // *** DECLARE PARAMETERS *** //
  // Parameters of the vehicle and the air
  //parameter Real m(unit = "kg") = 1850 "Mass of the vehicle";
  parameter Modelica.Units.SI.Density rho_air = 1.2 "Volumic mass of the air";
  parameter Modelica.Units.SI.Area A_front = 2.7 "Front area of the vehicle";
  parameter Real C_D(unit = "1") = 0.26 "Drag coefficient";
  parameter Modelica.Units.SI.Diameter D_tire = 0.4318 "Tire Diameter";
  parameter Real R_gear(unit = "1") = 3.478 "Reduction Gear Ratio";
  parameter Modelica.Units.SI.Voltage V_load = 343 "Load Voltage";
  parameter Boolean useRegenerativeBreaking = true annotation(
    choices(checkBox = true));
  // Efficiency coefficients
  parameter Modelica.Units.SI.Efficiency eff_drivetrain = 0.9 "Efficiency of the drivetrain";
  parameter Modelica.Units.SI.Efficiency eff_brake = 0.5 "Efficiency of the regenerative breaking";
  // --- Class Outputs --- //
  // Derived Quantities
  Modelica.Units.NonSI.Velocity_kmh V "Vehicle Speed";
  Modelica.Units.SI.Velocity v "Speed of the vehicle in m/s";
  Modelica.Units.SI.Acceleration a "Vehicle acceleration";
  Modelica.Units.SI.Force F_accel "Vehicle acceleration force";
  Modelica.Units.SI.Force F_drag "Vehicle drag force";
  Modelica.Units.SI.Force F_roll "Vehicle rolling force";
  Modelica.Units.SI.Force F_T "Vehicle total force";
  Modelica.Units.SI.AngularVelocity omega_engine "Motor Rotation, rad/s";
  Modelica.Units.NonSI.AngularVelocity_rpm N_engine "Motor Rotation, rpm";
  //  Real tau(unit = "N.m") "Motor Torque";
  Modelica.Units.SI.Position x(fixed = true) "Position";
  Modelica.Units.SI.Power P;
  // *** INSTANTIATE COMPONENTS *** //
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {72, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{80, -60}, {100, -40}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {72, 34}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(extent = {{100, 40}, {80, 60}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vehicleVelocity annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
equation
// *** DEFINE EQUATIONS *** //
  if VN == VirtualFCS.Vehicles.VehicleProfile.vehicle_name.Mirai then
    m = 1850;
  elseif VN == VirtualFCS.Vehicles.VehicleProfile.vehicle_name.Default then
    m = 1980;
  elseif VN == VirtualFCS.Vehicles.VehicleProfile.vehicle_name.UserDefined then
    m = 1100;
  end if;
// Redeclare variables
  V = vehicleVelocity;
// Change of units (from km/h to m/s)
  v = Modelica.Units.Conversions.from_kmh(V);
// Calculate position
  der(x) = v;
  der(v) = a;
  F_drag = 0.5 * C_D * rho_air * v ^ 2 * A_front;
  F_accel = m * a;
  F_roll = 0.02 * m * 9.81;
  F_T = F_drag + F_accel + F_roll;
  P = F_T * v;
  if useRegenerativeBreaking then
    if P >= 0 then
      signalCurrent.i = -(P / eff_drivetrain) / V_load;
    else
      signalCurrent.i = -(P * eff_brake) / V_load;
    end if;
  else
    if P >= 0 then
      signalCurrent.i = -(P / eff_drivetrain) / V_load;
    else
      signalCurrent.i = 0;
    end if;
  end if;
  omega_engine = v * R_gear / (0.5 * D_tire);
  N_engine = 30 * omega_engine / Modelica.Constants.pi;
//der_v = if der(V) > 4.5 then 0 elseif der(V) < (-7) then 0 else der(v);
// Calculate motor rpm
//  omega = 60 * v * R_gear / (Modelica.Constants.pi * D_tire);
// Calculation of the weight and drag powers
//  P_weight = m * der_v * v;
//  P_drag = 0.5 * rho_air * A_front * C_D * v ^ 3;
// Calculation of the driving power
//  P = (P_weight + P_drag) / eff_drivetrain;
// Calculate motor torque
//tau = if omega > 0 then 9.5488 * (P / 1000) / omega else 0;
// Calculation of the driving energy
//  der(E) = P;
//  speedControlledDCMotor.contol_input = N_engine;
//  speedControlledDCMotor.torqueInput = tau;
// Assign current load value
//  if P_weight >= 0 then
//    currentLoad.i = P / V_load;
//  elseif useRegenerativeBreaking == true then
//    currentLoad.i = (P_weight + P_drag) * (eff_drivetrain * eff_regeneration) / V_load;
//  else
//    currentLoad.i = 0;
//  end if;
// *** DEFINE CONNECTIONS *** //
// --- Appearance of the Driving power block --- //
// Coloured rectangle //
// RGB code for the colour + Type of the pattern + Limit points of the rectangle
// Names of the inputs/outputs written on the block //
// In the extent command, write the coordinates of the bottom left corner and the top right corner of the rectangle that should contain the writting
  connect(signalCurrent.p, pin_p) annotation(
    Line(points = {{40, 10}, {40, 10}, {40, 34}, {72, 34}, {72, 34}}, color = {0, 0, 255}));
  connect(signalCurrent.n, pin_n) annotation(
    Line(points = {{40, -10}, {40, -10}, {40, -46}, {72, -46}, {72, -46}}, color = {0, 0, 255}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.05), graphics = {Text(origin = {-4, -12}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle( lineColor = {60, 0, 40}, fillColor = {120, 0, 80}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(origin = {0, 6}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, lineThickness = 1.5, points = {{-66.6, -14}, {-66.6, -10}, {-66.6, -4}, {-66.6, 0}, {-66.6, 2}, {-66, 3.4}, {-64, 5.9}, {-60, 10}, {-56, 14}, {-52, 18}, {-48, 22}, {-46, 24}, {-44, 25.6}, {-42, 26.4}, {-40, 27}, {-38, 27.2}, {-34, 27.2}, {-28, 27.2}, {-18, 27.2}, {-8, 27.2}, {2, 27.2}, {6, 27.2}, {8, 27.2}, {10, 27}, {12, 26.2}, {14, 25.1}, {15, 24.1}, {16, 23.2}, {18, 21.3}, {22, 17.5}, {26, 13.5}, {30, 9.5}, {32, 7.4}, {34, 5.5}, {35, 4.4}, {36, 3.8}, {37, 3.4}, {38, 3.2}, {42, 3.2}, {48, 3.2}, {50, 3.2}, {52, 3.2}, {54, 3}, {56, 2.4}, {58, 1.6}, {60, 0.3}, {62, -1.5}, {63, -2.5}, {64, -4}, {65.2, -6}, {65.9, -8}, {66.5, -12}, {66.5, -18}, {66.5, -22}, {65.8, -24}, {64, -26}, {62, -27}, {58, -27.1}, {42, -27.1}, {20, -27.1}, {4, -27.1}, {-16, -27.1}, {-38, -27.1}, {-50, -27.1}, {-54, -27.1}, {-56, -27.1}, {-58, -26.6}, {-60, -25.9}, {-61, -25.3}, {-62, -24.6}, {-63, -23.7}, {-64, -22.6}, {-65, -21.2}, {-66, -19}, {-66.3, -18}, {-66.6, -16}, {-66.6, -15}, {-66.6, -14}}, smooth = Smooth.Bezier), Ellipse(origin = {-36.4, -21}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-16.5, 16.5}, {16.5, -16.5}}), Ellipse(origin = {-36.4, -21}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12, 12}, {12, -12}}), Rectangle(origin = {-29, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{9.2, -9.9}, {-9.2, 8.1}}), Polygon(origin = {-51, 17}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-7, -7.9}, {9, 8}, {9, -7.9}, {-7, -7.9}}), Polygon(origin = {-40, 23}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-2.5, 1.5}, {-2, 2}, {-1, 2.8}, {0, 3.6}, {1, 4.1}, {3, 4.1}, {3, -3}, {-4, -3}, {-4, -1}, {-2.5, 1.5}}, smooth = Smooth.Bezier), Rectangle(origin = {-40, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, -9.9}, {4, 4}}), Rectangle(origin = {-4.7, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{12, -9.9}, {-9.2, 8.1}}), Ellipse(origin = {36.2, -21}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-16.5, 16.5}, {16.5, -16.5}}), Ellipse(origin = {36.2, -21}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12, 12}, {12, -12}}), Polygon(origin = {5, 17}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{22.5, -7.9}, {6.5, 8}, {6.5, -7.9}, {22.5, -7.9}}), Rectangle(origin = {8, 19}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-4, -9.9}, {4, 4}}), Polygon(origin = {7, 22}, fillColor = {120, 0, 80}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-3, 5}, {0, 5.1}, {1, 5}, {2, 4.8}, {3, 4.4}, {4, 3.6}, {5, 2.6}, {5, -6}, {-5, -6}, {-3, 5}}, smooth = Smooth.Bezier) }),
    Documentation(info = "<html><head></head><body><div>The VehicleProfile block is designed to replicate the power demand of a vehicle considering a pre-determined drive cycle and vehicle parameters such as weight and frontal area. The generated power profile considers the needs to propel the vehicle plus the aerodynamic drag. The block allows the user to select if regenerative breaking is used or not.</div><div><br></div><div><div>The block enables the user to select from standard testing drive cycles including WLTC Class 1-3 and NEDC. The drive cycles are provided as .mat files in the library directory containing the block.</div></div></body></html>"));
end VehicleProfile;
