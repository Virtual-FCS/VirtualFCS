within VirtualFCS.Utilities.ParameterRecords;
record DCPMMCompressor_30kW
  extends Modelica.Icons.Record;
  extends VirtualFCS.Utilities.ParameterRecords.DCPMMCompressor(
    Jr = 0.15,
    Js = 0.29,
    VaNominal = 400,
    IaNominal = 75,
    wNominal = 15000 * 2 * Modelica.Constants.pi / 60,
    TaNominal = 293.15,
    Ra = 0.01,
    TaRef = 293.15,
    alpha20a = 0.004,
    La = 0.002,
    frictionParameters = Modelica.Electrical.Machines.Losses.FrictionParameters(
      PRef = 10,
      wRef = wNominal * 2 * Modelica.Constants.pi / 60),
    brushParameters = Modelica.Electrical.Machines.Losses.BrushParameters(
      V = 0.5,
      ILinear = 0.01 * IaNominal),
    ViNominal = VaNominal - Modelica.Electrical.Machines.Thermal.convertResistance(Ra, TaRef, alpha20a, TaNominal) * IaNominal - Modelica.Electrical.Machines.Losses.DCMachines.brushVoltageDrop(brushParameters, IaNominal),
    coreParameters = Modelica.Electrical.Machines.Losses.CoreParameters(
      m = 1,
      PRef = 10,
      VRef = 75,
      wRef = wNominal * 2 * Modelica.Constants.pi / 60),
    strayLoadParameters = Modelica.Electrical.Machines.Losses.StrayLoadParameters(PRef = 0, IRef = IaNominal, wRef = wNominal));

annotation(Documentation(info = "<html><p>Parameter record containing the nominal data for a 30 kW permanent-magnet compressor motor.</p></html>"));
end DCPMMCompressor_30kW;
