within VirtualFCS.Media.Examples;

model TestAirState
  import VirtualFCS.Media.Air;
  import Modelica.Media.Air.MoistAir;
  import Modelica.Units.SI.*;

  // Load
  replaceable package Medium = Air;
  replaceable package Medium2 = MoistAir;

  parameter Pressure p = 1.013e5;         // Pa
  parameter Temperature T = 50 + 273.15;    // K
  
  // Set ExternalMedia custum air model composition
  
  parameter MassFraction X[Medium.nX] = {0.7, 0.2, 0.05, w_vapor};
  //parameter MassFraction X[Medium.nX] = {1.0};
  
  // Modelica MoistAir
  parameter Real w_vapor = 0.05; 
  Medium2.ThermodynamicState state2;
  Medium2.MassFraction X2[Medium2.nX];
  
  Medium.ThermodynamicState state;
  MassFraction x "vapour quality";
  Temperature Tdew "Dew temperature";
  Temperature Tdew2 "Dew temperature";

  // Variables to read from the state
  Temperature T_state;
  SpecificEnthalpy h;
  Density d;
  
  Temperature T_state2;
  SpecificEnthalpy h2;
  Density d2;
  MassFraction x2 "vapour quality";
  Real phi2 "Relative humidity";
  

equation
  // Define mass fraction: MoistAir has one extra species: Water
  X2[1] = w_vapor;
  X2[2] = 1 - w_vapor;
  
  state2 = Medium2.setState_pTX(p, T, X2);
  Tdew2 = Medium2.saturationTemperature(p);
  phi2 = Medium2.relativeHumidity(state2);
  x2 = Medium2.relativeHumidity_pTX(p, T, X2);

equation
  // Create thermodynamic state from p, T, and composition
  state = Medium.setState_pTX(p, T, X);
  x = Medium.vapourQuality(state);

  // Read values from state ExternalMedia
  T_state = Medium.temperature(state);
  h = Medium.specificEnthalpy(state);
  d = Medium.density(state);
  
  Tdew = Medium.saturationTemperature(p);

  // Read values from state Modelica MoistAir
  T_state2 = Medium2.temperature(state2);
  h2 = Medium2.specificEnthalpy(state2);
  d2 = Medium2.density(state2);
  

end TestAirState;
