within VirtualFCS;
package SubSystems "Encapsulated support subsystems for modelling fuel cell systems."
  extends Modelica.Icons.Package;
  annotation (
    Documentation(info = "<html><p>The <b>SubSystems</b> package contains replaceable assemblies for the main support functions of a fuel-cell system. Each subsystem hides its internal components behind fluid, electrical, and control interfaces so alternative implementations can be exchanged at system level.</p><h3>Subsystems</h3><ul><li><a href=\"modelica://VirtualFCS.SubSystems.Air\">Air</a>: supplies and regulates cathode air.</li><li><a href=\"modelica://VirtualFCS.SubSystems.Hydrogen\">Hydrogen</a>: supplies, recirculates, regulates, and purges anode hydrogen.</li><li><a href=\"modelica://VirtualFCS.SubSystems.Cooling\">Cooling</a>: circulates coolant and manages stack and reservoir temperatures.</li></ul><p>The integrated <a href=\"modelica://VirtualFCS.SubSystems.FuelCellSubSystems\">FuelCellSubSystems</a> assembly combines these three functions around a fuel-cell stack. Component choices and controller tuning should be checked for the connected stack, operating range, and fluid media.</p></html>"));
end SubSystems;
