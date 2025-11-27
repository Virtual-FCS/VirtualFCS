within VirtualFCS.Electrochemical.Hydrogen;

model NernstOCV
  extends Electrochemical.Hydrogen.BaseNernst;
  final parameter Modelica.Units.SI.Voltage U0 = 1.23 "standard potential";
equation
  v = N_cells*U0;
  annotation(
    experiment(StartTime = 0, StopTime = 500, Tolerance = 1e-06, Interval = 0.002));
end NernstOCV;
