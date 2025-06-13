within VirtualFCS.Fluid;

model AmmoniaCracker "Ammonia cracker model based on a tube and shell configuration where"
   parameter Integer N = 10 "Number of reactor segments";
  parameter Real L = 1.0 "Reactor length (m)";
  parameter Real A = 0.01 "Cross-sectional area (m^2)";
  parameter Real F = 1e-4 "Volumetric flow rate (m^3/s)";
  parameter Real cA_in = 1.0 "Inlet concentration of A (mol/m^3)";
  parameter Real T_in = 350 "Inlet temperature (K)";
  parameter Real k0 = 3.33/3.6*1e10 "Pre-exponential factor (mol/(kg*s))";
  parameter Real Ea = 1.54e5 "Activation energy (J/mol)";
  parameter Real a = 0.37 "Kinetic parameter";
  parameter Real b = -1.04 "Kinetic parameter";
  parameter Real R = 8.314 "Gas constant (J/mol/K)";
  parameter Real deltaH = -50000 "Reaction enthalpy (J/mol)";
  parameter Real rho = 1000 "Fluid density (kg/m^3)";
  parameter Real Cp = 4184 "Heat capacity (J/kg/K)";
  
  parameter Real dx = L / N "Segment length";
  parameter Real V = A * dx "Volume per segment";
  
  parameter Modelica.Units.SI.Pressure P_tot = 30e5 "Outlet pressure";

 Real T[N](start=fill(T_in, N)) "Temperature in each segment (K)";
 
  parameter Real deltaG_0 = 95517 - 193.67 * T_in - 0.035293 * T_in^2 + (9.22 * 10e-6 * T_in^3);
  
 parameter Real k_eq = exp(-deltaG_0/R/T_in) "Equilibrium constant for the ammonia decomposition reaction";
 
  Modelica.Units.SI.MolarFlowRate F_NH3[N](start=fill(cA_in, N)) "Molar flow NH3(mol/s)";
  Modelica.Units.SI.MolarFlowRate F_N2[N](start=fill(cA_in, N)) "Molar flow N2(mol/s)";
  Modelica.Units.SI.MolarFlowRate F_H2[N](start=fill(cA_in, N)) "Molar flow H2(mol/s)";
  
 
  Modelica.Units.SI.Pressure P_NH3[N](start=fill(P_tot, N)) "Partial Pressure NH3 (Pa)";
  Modelica.Units.SI.Pressure P_N2[N](start=fill(P_tot, N)) "Partial Pressure N2 (Pa)";
  Modelica.Units.SI.Pressure P_H2[N](start=fill(P_tot, N)) "Partial Pressure H2 (Pa)";
  
  
  Real cA[N](start=fill(cA_in, N)) "Concentration of A (mol/m^3)";

  // Reaction rate
  function rate
    input Real a;
    input Real b;
    input Real T;
    input Real k0;
    input Real Ea;
    input Real R;
    input Modelica.Units.SI.Pressure P_NH3;
    input Modelica.Units.SI.Pressure P_N2;
    input Modelica.Units.SI.Pressure P_H2;

    output Real r;
  algorithm
    r := k0 * exp(-Ea / (R*T)) * P_NH3^a * P_H2^b * (1 - 1/k_eq^2 *(P_N2 * P_H2^3 / P_NH3^2));
  end rate;

equation
  for i in 1:N loop
    if i == 1 then
      // Inlet boundary
      cA[i] = cA_in;
      T[i] = T_in;
    else
      // Mass balance
      der(cA[i]) = (F/V) * (cA[i-1] - cA[i]) - rate(cA[i], T[i], k0, Ea, R);

      // Energy balance
      der(T[i]) = (F/V) * (T[i-1] - T[i]) - (deltaH / (rho * Cp)) * rate(cA[i], T[i], k0, Ea, R);
    end if;
  end for;
end AmmoniaCracker;
