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
    experiment(StartTime = 0, StopTime = 2000, Tolerance = 1e-06, Interval = 1),
    Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Simulation harness for DriveCycle. The instantiated sources, boundaries, and loads define the test conditions; sensors expose the connected component response.</p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><span>No locally declared parameters.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><span>No additional interfaces are declared locally.</span></td><td>-</td><td>-</td><td>-</td><td>-</td></tr>
</tbody></table>

</body></html>"));
end DriveCycleTest;
