within VirtualFCS.Electrochemical.Hydrogen;

model NernstOCV
  extends Electrochemical.Hydrogen.BaseNernst;
  parameter Modelica.Units.SI.Voltage V_av = 0.9 "Average cell potential";
equation
  v = N_cells*V_av;
  annotation(
    experiment(StartTime = 0, StopTime = 500, Tolerance = 1e-06, Interval = 0.002));
end NernstOCV;
