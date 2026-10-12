within VirtualFCS.Examples.VehicleExamples;

model RangeExtenderHybridVehicle_ECMS
  extends BatteryElectricVehicle(redeclare Powertrains.RangeExtenderPowertrain_ECMS powertrain(batterySystem(C_bat_pack = 10, V_max_bat_pack=600)));

equation

  annotation(Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<p>Vehicle drive-cycle example using the battery-electric vehicle assembly with the powertrain redeclared as RangeExtenderPowertrain_ECMS. Fuel-cell and battery power sharing is selected by the ECMS controller during the prescribed driving cycle.</p>
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
end RangeExtenderHybridVehicle_ECMS;
