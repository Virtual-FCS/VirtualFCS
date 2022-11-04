within VirtualFCS.Utilities.SystemRecords;

record HydrogenDataPlantB
  extends Modelica.Icons.Record;
   parameter Real PumpSpeed_k = 3 "Gain for the pump speed controller"
    annotation(Dialog(group = "Speed controller"));
  parameter Real PumpSpeed_Td = 0.3 "Time constant for the pump speed controller"
    annotation(Dialog(group = "Speed controller"));
  parameter Modelica.Units.NonSI.AngularVelocity_rpm Pump_N_nominal = 400 "Nominal speed of the pump"
    annotation(Dialog(group = "Pump"));
    annotation(
    defaultComponentName="hydrogenData",
    defaultComponentPrefixes="inner",
    missingInnerMessage="
    No 'Hydrogen Data' component is defined. A default component will be used with 
    parameters of a generic hydrogen system");
end HydrogenDataPlantB;