within VirtualFCS.Vehicles.Examples;

model DriveCycleTest
  extends Modelica.Icons.Example;
  DriveCycle driveCycle_WLTC1(cycle = "WLTC1")  annotation(
    Placement(transformation(origin = {0, 80}, extent = {{-11, -11}, {11, 11}})));
  VirtualFCS.Vehicles.DriveCycle driveCycle_WLTC2(cycle = "WLTC2")  annotation(
    Placement(transformation(origin = {0, 40}, extent = {{-11, -11}, {11, 11}})));
  VirtualFCS.Vehicles.DriveCycle driveCycle_WLTC3a(cycle = "WLTC3a")  annotation(
    Placement(transformation(extent = {{-11, -11}, {11, 11}})));
  VirtualFCS.Vehicles.DriveCycle driveCycle_WLTC3b(cycle = "WLTC3b")  annotation(
    Placement(transformation(origin = {0, -40}, extent = {{-11, -11}, {11, 11}})));
  VirtualFCS.Vehicles.DriveCycle driveCycle_NEDC(cycle = "NEDC")  annotation(
    Placement(transformation(origin = {0, -80}, extent = {{-11, -11}, {11, 11}})));
equation

annotation(
    experiment(StartTime = 0, StopTime = 2000, Tolerance = 1e-06, Interval = 1));
end DriveCycleTest;
