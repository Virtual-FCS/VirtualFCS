within VirtualFCS.Media.Examples;

model TestAirState
  import VirtualFCS.Media.Air;
  import Modelica.Media.Air.MoistAir;
  import Modelica.Units.SI.*;

  // Load
  replaceable package Medium = Air;
  replaceable package Medium2 = MoistAir;
  
  // Molar masses
  constant Real MW_air_dry = 28.96e-3 "Molar mass air kg/mol";
  constant Real MW_air_wet = 28.7e-3 "Molar mass air kg/mol";
  constant Real MW_H2O = 18e-3 "Molar mass water kg/mol";

  
  // Parameters
  parameter Real X_H2O = 0.05; 
  parameter Pressure p = 1.013e5;         // Pa
  parameter Temperature T = 50 + 273.15;    // K
  
  // Set ExternalMedia custom air model composition
  parameter MassFraction X[Medium.nX] = {0.7, 0.2, 0.05, X_H2O};

  
  // Modelica MoistAir
  Medium2.ThermodynamicState state2;
  Medium2.MassFraction X2[Medium2.nX];
  
  Medium.ThermodynamicState state;
  MassFraction vap_qual "vapour quality";
  Temperature Tdew "Dew temperature";
  Temperature Tdew2 "Dew temperature";

  // Variables to read from the state
  Temperature T_state;
  SpecificEnthalpy h;
  Density d;
  
  Temperature T_state2;
  SpecificEnthalpy h2;
  Density d2;
  MassFraction X_H2O_calc "Calculated water mass fraction";
  Real phi2 "Relative humidity";
  Real X_liquid, X_vapor "Mass fraction liquid/vapor";
  Real x_liquid, x_vapor "Mol fraction liquid/vapor";
  Pressure p_ws "water saturation pressure";
  Pressure p_w "water partial pressure";
  Real x_H2O = X_H2O/MW_H2O / (X_H2O/MW_H2O + (1-X_H2O)/MW_air_dry) "water molar fraction";
    

equation

  // Define mass fraction: MoistAir has one extra species: Water
  X2[1] = X_H2O;
  X2[2] = 1 - X_H2O;
  
  state2 = Medium2.setState_pTX(p, T, X2);
  Tdew2 = Medium2.saturationTemperature(p);
  phi2 = Medium2.relativeHumidity(state2);
  X_H2O_calc = Medium2.massFraction_pTphi(p, T, phi2);

  // Create thermodynamic state from p, T, and composition
  state = Medium.setState_pTX(p, T, X);
  vap_qual = Medium.vapourQuality(state);

  // Read values from state ExternalMedia
  T_state = Medium.temperature(state);
  h = Medium.specificEnthalpy(state);
  d = Medium.density(state);
  
  Tdew = Medium.saturationTemperature(p);

  // Read values from state Modelica MoistAir
  T_state2 = Medium2.temperature(state2);
  h2 = Medium2.specificEnthalpy(state2);
  d2 = Medium2.density(state2);
  
  
  // Calculate mass liquid and vapour mass fractions
  p_ws = MoistAir.saturationPressure(T);
  p_w = p * x_H2O;

  if p_w > p_ws then
    x_liquid = (p_w-p_ws)/p;
    x_vapor  = 1-x_liquid;
    
    X_liquid = x_liquid*MW_H2O / (x_liquid*MW_H2O + x_vapor*MW_air_wet);
    X_vapor  = 1-X_liquid;
  else
    X_liquid = 0;
    X_vapor  = 1;
    x_liquid = 0;
    x_vapor  = 1;
  end if;
end TestAirState;
