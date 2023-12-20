within VirtualFCS.Utilities.ParameterRecords;

record DCPMMCoolingPump
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Inertia Jr = 0.15 "Rotor's moment of inertia";
  parameter Modelica.Units.SI.Inertia Js = 0.15 "Stator's moment of inertia";
  parameter Modelica.Units.SI.Voltage VaNominal = 24 "Nominal armature voltage" annotation(
    Dialog(tab = "Nominal parameters"));
  parameter Modelica.Units.SI.Current IaNominal = 10 "Nominal armature current (>0..Motor, <0..Generator)" annotation(
    Dialog(tab = "Nominal parameters"));
  parameter Modelica.Units.SI.AngularVelocity wNominal(displayUnit = "rev/min") = 1425 * 2 * Modelica.Constants.pi / 60 "Nominal speed" annotation(
    Dialog(tab = "Nominal parameters"));
  parameter Modelica.Units.SI.Temperature TaNominal = 293.15 "Nominal armature temperature" annotation(
    Dialog(tab = "Nominal parameters"));
  parameter Modelica.Units.SI.Resistance Ra = 0.05 "Armature resistance at TRef" annotation(
    Dialog(tab = "Nominal resistances and inductances"));
  parameter Modelica.Units.SI.Temperature TaRef = 293.15 "Reference temperature of armature resistance" annotation(
    Dialog(tab = "Nominal resistances and inductances"));
  parameter Modelica.Electrical.Machines.Thermal.LinearTemperatureCoefficient20 alpha20a = 0 "Temperature coefficient of armature resistance" annotation(
    Dialog(tab = "Nominal resistances and inductances"));
  parameter Modelica.Units.SI.Inductance La = 0.0015 "Armature inductance" annotation(
    Dialog(tab = "Nominal resistances and inductances"));
  parameter Modelica.Electrical.Machines.Losses.FrictionParameters frictionParameters(PRef = 0, wRef = wNominal) "Friction loss parameter record" annotation(
    Dialog(tab = "Losses"));
  parameter Modelica.Units.SI.Voltage ViNominal = VaNominal - Modelica.Electrical.Machines.Thermal.convertResistance(Ra, TaRef, alpha20a, TaNominal) * IaNominal - Modelica.Electrical.Machines.Losses.DCMachines.brushVoltageDrop(brushParameters, IaNominal);
  parameter Modelica.Electrical.Machines.Losses.CoreParameters coreParameters(final m = 1, PRef = 0, VRef = ViNominal, wRef = wNominal) "Armature core loss parameter record" annotation(
    Dialog(tab = "Losses"));
  parameter Modelica.Electrical.Machines.Losses.StrayLoadParameters strayLoadParameters(PRef = 0, IRef = IaNominal, wRef = wNominal) "Stray load losses" annotation(
    Dialog(tab = "Losses"));
  parameter Modelica.Electrical.Machines.Losses.BrushParameters brushParameters(V = 0, ILinear = 0.01 * IaNominal) "Brush loss parameter record" annotation(
    Dialog(tab = "Losses"));
  annotation(
    defaultComponentName = "dcpmData",
    defaultComponentPrefixes = "parameter",
    Documentation(info = "<html>
<p>Basic parameters of DC machines are predefined with default values.</p>
</html>"));
end DCPMMCoolingPump;
