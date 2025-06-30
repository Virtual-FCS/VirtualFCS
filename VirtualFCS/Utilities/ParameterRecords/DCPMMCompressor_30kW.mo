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
      PRef = 50,
      wRef = wNominal * 2 * Modelica.Constants.pi / 60),
    brushParameters = Modelica.Electrical.Machines.Losses.BrushParameters(
      V = 1.0,
      ILinear = 0.01 * 300),
    ViNominal = VaNominal - Modelica.Electrical.Machines.Thermal.convertResistance(0.01, 293.15, 0.004, 293.15) * 300
                    - Modelica.Electrical.Machines.Losses.DCMachines.brushVoltageDrop(
                          Modelica.Electrical.Machines.Losses.BrushParameters(V = 1.0, ILinear = 3), 300),
    coreParameters = Modelica.Electrical.Machines.Losses.CoreParameters(
      m = 1,
      PRef = 50,
      VRef = 75,
      wRef = wNominal * 2 * Modelica.Constants.pi / 60),
    strayLoadParameters = Modelica.Electrical.Machines.Losses.StrayLoadParameters(
      PRef = 50,
      IRef = 300,
      wRef = wNominal * 2 * Modelica.Constants.pi / 60,
      power_w = 1));
               // rotor inertia (assumed same)
               // stator inertia (assumed same)
                     // scaled up from 30A            // 6000 rpm

    // ViNominal is a derived parameter that uses brushParameters, Ra, etc.

end DCPMMCompressor_30kW;
