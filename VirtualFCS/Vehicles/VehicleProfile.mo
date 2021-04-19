within VirtualFCS.Vehicles;

class VehicleProfile "Calculates the driving power for a vehicle that corresponds to a given speed profile."
  import Modelica.Blocks.Tables.Internal;
 
 
  ////////////////////// Choose speed_profile  //////////////////////////////////////////////////////
  type speed_profile = enumeration(NEDC "NEDC", WLTC "WLTC", personnal "personnal") annotation(
    Evaluate = true);
  parameter speed_profile v = VirtualFCS.Vehicles.VehicleProfile.speed_profile.personnal "Speed profile";
  parameter String fileName = "NoName" "File where matrix is stored" annotation(
    Dialog(loadSelector(filter = "Text files (*.txt);;MATLAB MAT-files (*.mat)", caption = "Open file in which table is present")));
  parameter String tableName = "NoName" "Name of the table";
  
  
  // Choice of file path
  function choose_speed_profile
    input speed_profile v;
    input String path;
    output String file;
  algorithm
    if v == VirtualFCS.Vehicles.VehicleProfile.speed_profile.NEDC then
      file := Modelica.Utilities.Files.loadResource("modelica://VirtualFCS.Vehicles.DriveCycles/NEDC.mat");
    elseif v == VirtualFCS.Vehicles.VehicleProfile.speed_profile.WLTC then
      file := Modelica.Utilities.Files.loadResource("modelica://VirtualFCS.Vehicles.DriveCycles/WLTC.mat");
    elseif v == VirtualFCS.Vehicles.VehicleProfile.speed_profile.personnal then
      file := path;
    end if;
  end choose_speed_profile;

  // Choice of file name

  function speed_profile_name
    input speed_profile v;
    input String table;
    output String name;
  algorithm
    if v == VirtualFCS.Vehicles.VehicleProfile.speed_profile.NEDC then
      name := "NEDC";
    elseif v == VirtualFCS.Vehicles.VehicleProfile.speed_profile.WLTC then
      name := "WLTC";
    elseif v == VirtualFCS.Vehicles.VehicleProfile.speed_profile.personnal then
      name := table;
    end if;
  end speed_profile_name;

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // *** DECLARE PARAMETERS *** //
  // Parameters of the vehicle and the air
  parameter Real m(unit = "kg") = 1850 "Mass of the vehicle";
  parameter Real rho_air(unit = "kg/m3") = 1.2 "Volumic mass of the air";
  parameter Real A_front(unit = "m2") = 2.7 "Front area of the vehicle";
  parameter Real C_D(unit = "1") = 0.26 "Drag coefficient";
  parameter Real D_tire(unit = "m") = 0.4318 "Tire Diameter";
  parameter Real R_gear(unit = "1") = 3.478 "Reduction Gear Ratio";
  parameter Real V_load(unit = "V") = 200 "Load Voltage";
  parameter Boolean useRegenerativeBreaking = false annotation(
    choices(checkBox = true));
  // Efficiency coefficients
  parameter Real eff_drivetrain(unit = "1") = 0.8 "Efficiency of the drivetrain";
  parameter Real eff_regeneration(unit = "1") = 0.8 "Efficiency of the stack";
  // --- Class Outputs --- //
  Modelica.Blocks.Interfaces.RealOutput P(unit = "W") "Output driving power" annotation(
    Placement(visible = true, transformation(extent = {{100, 54}, {140, 94}}, rotation = 0), iconTransformation(extent = {{100, 54}, {140, 94}}, rotation = 0)));
  // Derived Quantities
  Real V(unit = "km/h") "Vehicle Speed";
  Real Vms(unit = "m/s") "Speed of the vehicle in m/s";
  Real der_Vms(unit = "m/s2") "Derivative of the speed of the vehicle in m/s";
  Real P_weight(unit = "W") "Power linked to the weight of the vehicle";
  Real P_drag(unit = "W") "Power linked to the drag of the vehicle";
  Real E(unit = "J") "Driving energy";
  Real omega(unit = "rpm") "Motor Rotation";
  // Real tau(unit = "N.m") "Motor Torque";
  Real x(unit = "m") "Position";
  // *** INSTANTIATE COMPONENTS *** //
  Modelica.Electrical.Analog.Sources.SignalCurrent currentLoad annotation(
    Placement(visible = true, transformation(origin = {35.5, -6.5}, extent = {{-14.5, 14.5}, {14.5, -14.5}}, rotation = -90)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {72, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{80, -40}, {100, -20}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {72, 34}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(extent = {{100, 20}, {80, 40}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(fileName = filepath, table = fill(0.0, 0, 2), tableName = table_Name, tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {-17, -6}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
protected
  parameter String filepath = choose_speed_profile(v, fileName);
  // Filepath
  parameter String table_Name = speed_profile_name(v, tableName);
  // Filename
equation
// *** DEFINE EQUATIONS *** //
// Redeclare variables
  V = combiTimeTable.y[1];
// Change of units (from km/h to m/s)
  Vms = V / 3.6;
// Calculate position
  der(x) = Vms;
  der_Vms = if der(V) > 4.5 then 0 elseif der(V) < (-7) then 0 else der(Vms);
// Calculate motor rpm
  omega = 60 * Vms * R_gear / (Modelica.Constants.pi * D_tire);
// Calculation of the weight and drag powers
  P_weight = m * der_Vms * Vms;
  P_drag = 0.5 * rho_air * A_front * C_D * Vms ^ 3;
// Calculation of the driving power
  P = (P_weight + P_drag) / eff_drivetrain;
// Calculate motor torque
// tau = if omega > 0 then 9.5488 * (P / 1000) / omega else 0;
// Calculation of the driving energy
  der(E) = P;
// Assign current load value
  if P_weight >= 0 then
    currentLoad.i = P / V_load;
  elseif useRegenerativeBreaking == true then
    currentLoad.i = (P_weight + P_drag) * (eff_drivetrain * eff_regeneration) / V_load;
  else
    currentLoad.i = 0;
  end if;
// *** DEFINE CONNECTIONS *** //
  connect(pin_p, currentLoad.p) annotation(
    Line(points = {{72, 34}, {36, 34}, {36, 8}, {35.5, 8}}, color = {0, 0, 255}));
  connect(pin_n, currentLoad.n) annotation(
    Line(points = {{72, -46}, {35.5, -46}, {35.5, -21}}, color = {0, 0, 255}));
// --- Appearance of the Driving power block --- //
// Coloured rectangle //
// RGB code for the colour + Type of the pattern + Limit points of the rectangle
// Names of the inputs/outputs written on the block //
// In the extent command, write the coordinates of the bottom left corner and the top right corner of the rectangle that should contain the writting
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.05), graphics = {Polygon(fillColor = {200, 200, 192}, fillPattern = FillPattern.Solid, points = {{-100, -100}, {-100, 100}, {100, 100}, {100, -100}, {-100, -100}}), Text(extent = {{-150, 120}, {150, 150}}, textString = "VEHICLE PROFILE")}),
    Documentation(info = "<html><head></head><body>The output power is the power needed to make the vehicle speed up and slow down as the driving cycle imposes. It is calculated considering the weight and the drag forces on the vehicle.</body></html>"));
end VehicleProfile;
