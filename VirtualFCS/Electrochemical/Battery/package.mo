within VirtualFCS.Electrochemical;

package Battery "Models for battery cells and packs."
  extends Modelica.Icons.VariantsPackage;










  annotation(
    Documentation(info = "<html><head></head><body>This sub-package includes models for simulating the performance of lithium-ion cells and packs.<div><br><table border=\"0.9\"><tbody><tr><th>Name</th>
            <th>Description</th>
            <th>Version</th>
         </tr>
         <tr>
            <td><a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonCell\">LiIonCell</a></td>
            <td>Simulates lithium-ion battery cell</td>
            <td>2022.1.0</td></tr><tr><td><a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Composite\">LiIonBatteryPack_Composite</a></td>
            <td>Simulates individual lithium-ion battery cells in a battery pack by automatically generating multiple instances of LiIonCell.</td><td>2022.1.0</td></tr><tr><td><a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped\">LiIonBatteryPack_Lumped</a></td>
            <td>Simulates lithium-ion battery pack given a number of cells, assuming every cell is identical.</td><td>2022.1.0</td>
         </tr>
      </tbody></table>
   
   
</div></body></html>"));
end Battery;
