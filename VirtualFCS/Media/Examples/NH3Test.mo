within VirtualFCS.Media.Examples;

model NH3Test
  import Modelica.Units.SI;

  replaceable package Medium = VirtualFCS.Media.NH3_CP;

  Medium.ThermodynamicState state;
  parameter SI.Temperature T = 300;
  parameter SI.Pressure p = 1e5;

equation
  // Set state using pressure and temperature
  state = Medium.setState_pT(p, T);

  Medium.specificEnthalpy(state);
  Medium.density(state);
  Medium.saturationTemperature(p);

end NH3Test;
